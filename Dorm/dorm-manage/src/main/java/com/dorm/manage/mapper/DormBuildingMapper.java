package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.common.core.domain.entity.DormBuilding;
import org.apache.ibatis.annotations.Param;

/**
 * 宿舍管理Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-03
 */
public interface DormBuildingMapper 
{
    /**
     * 查询宿舍管理
     * 
     * @param dormId 宿舍管理主键
     * @return 宿舍管理
     */
    public DormBuilding selectDormBuildingByDormId(Long dormId);

    /**
     * 查询宿舍管理列表
     * 
     * @param dormBuilding 宿舍管理
     * @return 宿舍管理集合
     */
    public List<DormBuilding> selectDormBuildingList(DormBuilding dormBuilding);

    /**
     * 根据ID查询所有子宿舍
     * 
     * @param dormId 宿舍ID
     * @return 宿舍列表
     */
    public List<DormBuilding> selectChildrenDormById(Long dormId);

    /**
     * 根据ID查询所有子宿舍（正常状态）
     * 
     * @param dormId 宿舍ID
     * @return 子宿舍数
     */
    public int selectNormalChildrenDormById(Long dormId);

    /**
     * 是否存在子节点
     * 
     * @param dormId 宿舍ID
     * @return 结果
     */
    public int hasChildByDormId(Long dormId);

    /**
     * 查询宿舍是否存在用户
     * 
     * @param dormId 宿舍ID
     * @return 结果
     */
    public int checkDormExistUser(Long dormId);

    /**
     * 校验宿舍名称是否唯一
     * 
     * @param buildingName 宿舍名称
     * @param parentId 父宿舍ID
     * @return 结果
     */
    public DormBuilding checkDormNameUnique(@Param("buildingName") String buildingName, @Param("parentId") Long parentId);

    /**
     * 新增宿舍管理
     * 
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    public int insertDormBuilding(DormBuilding dormBuilding);

    /**
     * 修改宿舍管理
     * 
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    public int updateDormBuilding(DormBuilding dormBuilding);

    /**
     * 修改所在宿舍正常状态
     * 
     * @param dormIds 宿舍ID组
     */
    public void updateDormStatusNormal(Long[] dormIds);

    /**
     * 修改子元素关系
     * 
     * @param dorms 子元素
     * @return 结果
     */
    public int updateDormChildren(@Param("dorms") List<DormBuilding> dorms);

    /**
     * 删除宿舍管理
     * 
     * @param dormId 宿舍管理主键
     * @return 结果
     */
    public int deleteDormBuildingByDormId(Long dormId);

    /**
     * 批量删除宿舍管理
     *
     * @param dormIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormBuildingByDormIds(Long[] dormIds);

    /**
     * 增加宿舍当前入住人数
     *
     * @param dormId 宿舍ID
     * @return 结果
     */
    public int incrementCurrentCount(Long dormId);

    /**
     * 减少宿舍当前入住人数
     *
     * @param dormId 宿舍ID
     * @return 结果
     */
    public int decrementCurrentCount(Long dormId);

    /**
     * 检查宿舍容量是否已满
     *
     * @param dormId 宿舍ID
     * @return 是否已满 (1:已满, 0:未满)
     */
    public int checkDormCapacityFull(Long dormId);

    /**
     * 获取宿舍容量信息
     *
     * @param dormId 宿舍ID
     * @return 宿舍容量信息
     */
    public DormBuilding selectDormCapacityInfo(Long dormId);

    /**
     * 自动更新宿舍状态（基于当前容量）
     *
     * @param dormId 宿舍ID
     * @return 结果
     */
    public int updateDormStatusByCapacity(Long dormId);

    /**
     * 批量自动更新所有宿舍状态（基于当前容量）
     *
     * @return 结果
     */
    public int batchUpdateDormStatusByCapacity();

    /**
     * 检查状态与容量是否一致
     *
     * @return 不一致的宿舍数量
     */
    public int checkStatusCapacityConsistency();

    /**
     * 获取状态与容量不一致的宿舍列表
     *
     * @return 宿舍列表
     */
    public List<DormBuilding> selectInconsistentStatusDorms();
}
