package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormBuilding;

/**
 * 宿舍管理Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-03
 */
public interface IDormBuildingService 
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
     * 批量删除宿舍管理
     * 
     * @param dormIds 需要删除的宿舍管理主键集合
     * @return 结果
     */
    public int deleteDormBuildingByDormIds(Long[] dormIds);

    /**
     * 删除宿舍管理信息
     * 
     * @param dormId 宿舍管理主键
     * @return 结果
     */
    public int deleteDormBuildingByDormId(Long dormId);
}
