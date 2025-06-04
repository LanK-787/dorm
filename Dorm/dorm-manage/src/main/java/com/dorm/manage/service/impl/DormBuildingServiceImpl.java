package com.dorm.manage.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
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
        return dormBuildingMapper.insertDormBuilding(dormBuilding);
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
        DormBuilding newParentDorm = dormBuildingMapper.selectDormBuildingByDormId(dormBuilding.getParentId());
        DormBuilding oldDorm = dormBuildingMapper.selectDormBuildingByDormId(dormBuilding.getDormId());
        if (StringUtils.isNotNull(newParentDorm) && StringUtils.isNotNull(oldDorm))
        {
            String newAncestors = newParentDorm.getAncestors() + "," + newParentDorm.getDormId();
            String oldAncestors = oldDorm.getAncestors();
            dormBuilding.setAncestors(newAncestors);
            updateDormChildren(dormBuilding.getDormId(), newAncestors, oldAncestors);
        }
        dormBuilding.setUpdateTime(DateUtils.getNowDate());
        int result = dormBuildingMapper.updateDormBuilding(dormBuilding);
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
        return dormBuildingMapper.deleteDormBuildingByDormId(dormId);
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
        return dormBuildingMapper.deleteDormBuildingByDormIds(dormIds);
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
}
