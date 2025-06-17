package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormRepairer;

/**
 * 维修人员管理Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-17
 */
public interface IDormRepairerService 
{
    /**
     * 查询维修人员管理
     * 
     * @param repairerId 维修人员管理主键
     * @return 维修人员管理
     */
    public DormRepairer selectDormRepairerByRepairerId(Long repairerId);

    /**
     * 查询维修人员管理列表
     * 
     * @param dormRepairer 维修人员管理
     * @return 维修人员管理集合
     */
    public List<DormRepairer> selectDormRepairerList(DormRepairer dormRepairer);

    /**
     * 新增维修人员管理
     * 
     * @param dormRepairer 维修人员管理
     * @return 结果
     */
    public int insertDormRepairer(DormRepairer dormRepairer);

    /**
     * 修改维修人员管理
     * 
     * @param dormRepairer 维修人员管理
     * @return 结果
     */
    public int updateDormRepairer(DormRepairer dormRepairer);

    /**
     * 批量删除维修人员管理
     * 
     * @param repairerIds 需要删除的维修人员管理主键集合
     * @return 结果
     */
    public int deleteDormRepairerByRepairerIds(Long[] repairerIds);

    /**
     * 删除维修人员管理信息
     * 
     * @param repairerId 维修人员管理主键
     * @return 结果
     */
    public int deleteDormRepairerByRepairerId(Long repairerId);
}
