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
}
