package com.dorm.manage.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import com.dorm.common.constant.UserConstants;
import com.dorm.common.core.text.Convert;
import com.dorm.common.exception.ServiceException;
import com.dorm.common.utils.DateUtils;
import com.dorm.common.utils.StringUtils;
import com.dorm.common.utils.spring.SpringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormBuildingMapper;
import com.dorm.common.core.domain.entity.DormBuilding;
import com.dorm.manage.service.IDormBuildingService;
import com.dorm.common.core.domain.TreeSelect;

/**
 * 宿舍管理Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-03
 */
@Service
public class DormBuildingServiceImpl implements IDormBuildingService 
{
    @Autowired
    private DormBuildingMapper dormBuildingMapper;

    /**
     * 查询宿舍管理
     * 
     * @param dormId 宿舍管理主键
     * @return 宿舍管理
     */
    @Override
    public DormBuilding selectDormBuildingByDormId(Long dormId)
    {
        return dormBuildingMapper.selectDormBuildingByDormId(dormId);
    }

    /**
     * 查询宿舍管理列表
     * 
     * @param dormBuilding 宿舍管理
     * @return 宿舍管理
     */
    @Override
    public List<DormBuilding> selectDormBuildingList(DormBuilding dormBuilding)
    {
        return dormBuildingMapper.selectDormBuildingList(dormBuilding);
    }

    /**
     * 查询宿舍树结构信息
     * 
     * @param dormBuilding 宿舍信息
     * @return 宿舍树信息集合
     */
    @Override
    public List<TreeSelect> selectDormTreeList(DormBuilding dormBuilding)
    {
        List<DormBuilding> dorms = SpringUtils.getAopProxy(this).selectDormBuildingList(dormBuilding);
        return buildDormTreeSelect(dorms);
    }

    /**
     * 构建前端所需要树结构
     * 
     * @param dorms 宿舍列表
     * @return 树结构列表
     */
    @Override
    public List<DormBuilding> buildDormTree(List<DormBuilding> dorms)
    {
        List<DormBuilding> returnList = new ArrayList<DormBuilding>();
        List<Long> tempList = dorms.stream().map(DormBuilding::getDormId).collect(Collectors.toList());
        for (DormBuilding dorm : dorms)
        {
            // 如果是顶级节点, 遍历该父节点的所有子节点
            if (!tempList.contains(dorm.getParentId()))
            {
                recursionFn(dorms, dorm);
                returnList.add(dorm);
            }
        }
        if (returnList.isEmpty())
        {
            returnList = dorms;
        }
        return returnList;
    }

    /**
     * 构建前端所需要下拉树结构
     * 
     * @param dorms 宿舍列表
     * @return 下拉树结构列表
     */
    @Override
    public List<TreeSelect> buildDormTreeSelect(List<DormBuilding> dorms)
    {
        List<DormBuilding> dormTrees = buildDormTree(dorms);
        return dormTrees.stream().map(TreeSelect::new).collect(Collectors.toList());
    }

    /**
     * 根据ID查询所有子宿舍（正常状态）
     * 
     * @param dormId 宿舍ID
     * @return 子宿舍数
     */
    @Override
    public int selectNormalChildrenDormById(Long dormId)
    {
        return dormBuildingMapper.selectNormalChildrenDormById(dormId);
    }

    /**
     * 是否存在子节点
     * 
     * @param dormId 宿舍ID
     * @return 结果
     */
    @Override
    public boolean hasChildByDormId(Long dormId)
    {
        int result = dormBuildingMapper.hasChildByDormId(dormId);
        return result > 0;
    }

    /**
     * 查询宿舍是否存在用户
     * 
     * @param dormId 宿舍ID
     * @return 结果 true 存在 false 不存在
     */
    @Override
    public boolean checkDormExistUser(Long dormId)
    {
        int result = dormBuildingMapper.checkDormExistUser(dormId);
        return result > 0;
    }

    /**
     * 校验宿舍名称是否唯一
     * 
     * @param dormBuilding 宿舍信息
     * @return 结果
     */
    @Override
    public boolean checkDormNameUnique(DormBuilding dormBuilding)
    {
        Long dormId = StringUtils.isNull(dormBuilding.getDormId()) ? -1L : dormBuilding.getDormId();
        DormBuilding info = dormBuildingMapper.checkDormNameUnique(dormBuilding.getBuildingName(), dormBuilding.getParentId());
        if (StringUtils.isNotNull(info) && info.getDormId().longValue() != dormId.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * 新增宿舍管理
     *
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    @Override
    public int insertDormBuilding(DormBuilding dormBuilding)
    {
        DormBuilding info = dormBuildingMapper.selectDormBuildingByDormId(dormBuilding.getParentId());
        // 如果父节点不为正常状态,则不允许新增子节点
        if (!UserConstants.DEPT_NORMAL.equals(info.getStatus()))
        {
            throw new ServiceException("宿舍停用，不允许新增");
        }
        dormBuilding.setAncestors(info.getAncestors() + "," + dormBuilding.getParentId());
        dormBuilding.setCreateTime(DateUtils.getNowDate());

        int result = dormBuildingMapper.insertDormBuilding(dormBuilding);

        // 新增成功后，递归更新父节点容量数据
        if (result > 0) {
            recursiveUpdateParentCapacity(dormBuilding.getDormId());
        }

        return result;
    }

    /**
     * 修改宿舍管理
     * 
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    @Override
    public int updateDormBuilding(DormBuilding dormBuilding)
    {
        // 保存修改前的容量信息，用于判断是否需要更新父节点
        DormBuilding oldDorm = dormBuildingMapper.selectDormBuildingByDormId(dormBuilding.getDormId());
        boolean capacityChanged = false;

        if (oldDorm != null) {
            // 检查容量是否发生变化
            Integer oldMaxCapacity = oldDorm.getMaxCapacity();
            Integer oldCurrentCount = oldDorm.getCurrentCount();
            Integer newMaxCapacity = dormBuilding.getMaxCapacity();
            Integer newCurrentCount = dormBuilding.getCurrentCount();

            capacityChanged = !Objects.equals(oldMaxCapacity, newMaxCapacity) ||
                             !Objects.equals(oldCurrentCount, newCurrentCount);
        }

        DormBuilding newParentDorm = dormBuildingMapper.selectDormBuildingByDormId(dormBuilding.getParentId());
        if (StringUtils.isNotNull(newParentDorm) && StringUtils.isNotNull(oldDorm))
        {
            String newAncestors = newParentDorm.getAncestors() + "," + newParentDorm.getDormId();
            String oldAncestors = oldDorm.getAncestors();
            dormBuilding.setAncestors(newAncestors);
            updateDormChildren(dormBuilding.getDormId(), newAncestors, oldAncestors);
        }
        dormBuilding.setUpdateTime(DateUtils.getNowDate());
        int result = dormBuildingMapper.updateDormBuilding(dormBuilding);

        // 修改成功后，如果容量发生变化，递归更新父节点容量数据
        if (result > 0 && capacityChanged) {
            recursiveUpdateParentCapacity(dormBuilding.getDormId());
        }

        if (UserConstants.DEPT_NORMAL.equals(dormBuilding.getStatus()) && StringUtils.isNotEmpty(dormBuilding.getAncestors())
                && !StringUtils.equals("0", dormBuilding.getAncestors()))
        {
            // 如果该宿舍是启用状态，则启用该宿舍的所有上级宿舍
            updateParentDormStatusNormal(dormBuilding);
        }
        return result;
    }

    /**
     * 修改该宿舍的父级宿舍状态
     * 
     * @param dormBuilding 当前宿舍
     */
    private void updateParentDormStatusNormal(DormBuilding dormBuilding)
    {
        String ancestors = dormBuilding.getAncestors();
        Long[] dormIds = Convert.toLongArray(ancestors);
        dormBuildingMapper.updateDormStatusNormal(dormIds);
    }

    /**
     * 修改子元素关系
     * 
     * @param dormId 被修改的宿舍ID
     * @param newAncestors 新的父ID集合
     * @param oldAncestors 旧的父ID集合
     */
    public void updateDormChildren(Long dormId, String newAncestors, String oldAncestors)
    {
        List<DormBuilding> children = dormBuildingMapper.selectChildrenDormById(dormId);
        for (DormBuilding child : children)
        {
            child.setAncestors(child.getAncestors().replaceFirst(oldAncestors, newAncestors));
        }
        if (children.size() > 0)
        {
            dormBuildingMapper.updateDormChildren(children);
        }
    }

    /**
     * 删除宿舍管理信息
     *
     * @param dormId 宿舍管理主键
     * @return 结果
     */
    @Override
    public int deleteDormBuildingByDormId(Long dormId)
    {
        // 获取要删除的节点信息，用于后续更新父节点容量
        DormBuilding dormToDelete = dormBuildingMapper.selectDormBuildingByDormId(dormId);

        int result = dormBuildingMapper.deleteDormBuildingByDormId(dormId);

        // 删除成功后，递归更新父节点容量数据
        if (result > 0 && dormToDelete != null) {
            recursiveUpdateParentCapacity(dormId);
        }

        return result;
    }

    /**
     * 批量删除宿舍管理
     *
     * @param dormIds 需要删除的宿舍管理主键
     * @return 结果
     */
    @Override
    public int deleteDormBuildingByDormIds(Long[] dormIds)
    {
        // 获取要删除的节点信息，用于后续更新父节点容量
        Set<Long> parentIdsToUpdate = new HashSet<>();
        for (Long dormId : dormIds) {
            DormBuilding dormToDelete = dormBuildingMapper.selectDormBuildingByDormId(dormId);
            if (dormToDelete != null && dormToDelete.getParentId() != null && dormToDelete.getParentId() > 0) {
                parentIdsToUpdate.add(dormToDelete.getParentId());
            }
        }

        int result = dormBuildingMapper.deleteDormBuildingByDormIds(dormIds);

        // 删除成功后，批量更新所有相关父节点的容量数据
        if (result > 0 && !parentIdsToUpdate.isEmpty()) {
            for (Long parentId : parentIdsToUpdate) {
                recursiveUpdateParentCapacity(parentId);
            }
        }

        return result;
    }

    /**
     * 递归列表
     */
    private void recursionFn(List<DormBuilding> list, DormBuilding t)
    {
        // 得到子节点列表
        List<DormBuilding> childList = getChildList(list, t);
        t.setChildren(childList);
        for (DormBuilding tChild : childList)
        {
            if (hasChild(list, tChild))
            {
                recursionFn(list, tChild);
            }
        }
    }

    /**
     * 得到子节点列表
     */
    private List<DormBuilding> getChildList(List<DormBuilding> list, DormBuilding t)
    {
        List<DormBuilding> tlist = new ArrayList<DormBuilding>();
        Iterator<DormBuilding> it = list.iterator();
        while (it.hasNext())
        {
            DormBuilding n = (DormBuilding) it.next();
            if (StringUtils.isNotNull(n.getParentId()) && n.getParentId().longValue() == t.getDormId().longValue())
            {
                tlist.add(n);
            }
        }
        return tlist;
    }

    /**
     * 判断是否有子节点
     */
    private boolean hasChild(List<DormBuilding> list, DormBuilding t)
    {
        return getChildList(list, t).size() > 0;
    }

    /**
     * 检查宿舍容量是否允许分配新学生
     *
     * @param dormId 宿舍ID
     * @return 是否允许分配
     */
    @Override
    public boolean checkDormCapacityAvailable(Long dormId)
    {
        if (dormId == null) {
            return false;
        }
        int isFull = dormBuildingMapper.checkDormCapacityFull(dormId);
        return isFull == 0;
    }

    /**
     * 增加宿舍当前入住人数
     *
     * @param dormId 宿舍ID
     * @return 结果
     */
    @Override
    public int incrementDormCurrentCount(Long dormId)
    {
        if (dormId == null) {
            return 0;
        }
        int result = dormBuildingMapper.incrementCurrentCount(dormId);
        // 更新后重新计算状态，确保状态正确
        if (result > 0) {
            dormBuildingMapper.updateDormStatusByCapacity(dormId);
            // 递归更新父节点状态和容量
            recursiveUpdateParentStatus(dormId);
            recursiveUpdateParentCapacity(dormId);
        }
        return result;
    }

    /**
     * 减少宿舍当前入住人数
     *
     * @param dormId 宿舍ID
     * @return 结果
     */
    @Override
    public int decrementDormCurrentCount(Long dormId)
    {
        if (dormId == null) {
            return 0;
        }
        int result = dormBuildingMapper.decrementCurrentCount(dormId);
        // 更新后重新计算状态，确保状态正确
        if (result > 0) {
            dormBuildingMapper.updateDormStatusByCapacity(dormId);
            // 递归更新父节点状态和容量
            recursiveUpdateParentStatus(dormId);
            recursiveUpdateParentCapacity(dormId);
        }
        return result;
    }

    /**
     * 获取宿舍容量信息
     *
     * @param dormId 宿舍ID
     * @return 宿舍容量信息
     */
    @Override
    public DormBuilding getDormCapacityInfo(Long dormId)
    {
        if (dormId == null) {
            return null;
        }
        return dormBuildingMapper.selectDormCapacityInfo(dormId);
    }

    /**
     * 自动更新宿舍状态（基于当前容量）
     *
     * @param dormId 宿舍ID
     * @return 结果
     */
    @Override
    public int updateDormStatusByCapacity(Long dormId)
    {
        if (dormId == null) {
            return 0;
        }
        int result = dormBuildingMapper.updateDormStatusByCapacity(dormId);
        if (result > 0) {
            // 递归更新父节点状态
            recursiveUpdateParentStatus(dormId);
        }
        return result;
    }

    /**
     * 批量修复所有宿舍状态（基于当前容量）
     *
     * @return 修复的宿舍数量
     */
    @Override
    public int batchFixDormStatus()
    {
        // 1. 获取所有状态不一致的宿舍
        List<DormBuilding> inconsistentDorms = getInconsistentStatusDorms();
        if (inconsistentDorms.isEmpty()) {
            return 0;
        }

        // 2. 更新所有不一致宿舍的状态
        int fixedCount = dormBuildingMapper.batchUpdateDormStatusByCapacity();

        // 3. 收集所有需要检查的父节点ID
        Set<Long> parentIds = new HashSet<>();
        for (DormBuilding dorm : inconsistentDorms) {
            Long parentId = dormBuildingMapper.getParentId(dorm.getDormId());
            while (parentId != null && parentId > 0) {
                parentIds.add(parentId);
                parentId = dormBuildingMapper.getParentId(parentId);
            }
        }

        // 4. 从下到上更新父节点状态
        List<Long> sortedParentIds = new ArrayList<>(parentIds);
        Collections.sort(sortedParentIds); // 按ID升序排序，确保从低层级到高层级更新
        for (Long parentId : sortedParentIds) {
            updateParentDormStatus(parentId);
        }

        return fixedCount;
    }

    /**
     * 检查并获取状态与容量不一致的宿舍
     *
     * @return 不一致的宿舍列表
     */
    @Override
    public List<DormBuilding> getInconsistentStatusDorms()
    {
        return dormBuildingMapper.selectInconsistentStatusDorms();
    }

    /**
     * 验证宿舍状态数据一致性
     *
     * @return 是否一致
     */
    @Override
    public boolean validateDormStatusConsistency()
    {
        int inconsistentCount = dormBuildingMapper.checkStatusCapacityConsistency();
        return inconsistentCount == 0;
    }

    /**
     * 更新父节点状态
     *
     * @param dormId 宿舍ID
     * @return 结果
     */
    @Override
    public int updateParentDormStatus(Long dormId) {
        if (dormId == null) {
            return 0;
        }
        
        // 检查子宿舍状态
        int allFull = dormBuildingMapper.checkChildrenDormStatus(dormId);
        
        // 更新当前节点状态
        String newStatus = allFull == 1 ? "1" : "0";
        return dormBuildingMapper.updateParentStatus(dormId, newStatus);
    }

    /**
     * 递归更新父节点状态
     *
     * @param dormId 宿舍ID
     */
    @Override
    public void recursiveUpdateParentStatus(Long dormId) {
        if (dormId == null) {
            return;
        }

        // 获取父节点ID
        Long parentId = dormBuildingMapper.getParentId(dormId);
        if (parentId != null && parentId > 0) {
            // 更新父节点状态
            int updated = updateParentDormStatus(parentId);
            if (updated > 0) {
                // 继续递归更新上级父节点
                recursiveUpdateParentStatus(parentId);
            }
        }
    }

    /**
     * 更新父节点容量数据
     *
     * @param dormId 父节点ID
     * @return 结果
     */
    @Override
    public int updateParentCapacity(Long dormId) {
        if (dormId == null) {
            return 0;
        }
        return dormBuildingMapper.updateParentCapacity(dormId);
    }

    /**
     * 递归更新父节点容量数据
     *
     * @param dormId 宿舍ID
     */
    @Override
    public void recursiveUpdateParentCapacity(Long dormId) {
        if (dormId == null) {
            return;
        }

        // 获取父节点ID
        Long parentId = dormBuildingMapper.getParentId(dormId);
        if (parentId != null && parentId > 0) {
            // 更新父节点容量数据
            int updated = updateParentCapacity(parentId);
            if (updated > 0) {
                // 继续递归更新上级父节点
                recursiveUpdateParentCapacity(parentId);
            }
        }
    }

    /**
     * 批量更新父节点容量数据
     *
     * @param dormIds 需要更新的父节点ID列表
     * @return 结果
     */
    @Override
    public int batchUpdateParentCapacity(List<Long> dormIds) {
        if (dormIds == null || dormIds.isEmpty()) {
            return 0;
        }
        return dormBuildingMapper.batchUpdateParentCapacity(dormIds);
    }
}
