package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormRepairer;

/**
 * 维修人员管理Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-17
 */
public interface DormRepairerMapper 
{
    /**
     * 查询维修人员管理
     *
     * @param repairerId 维修人员管理主键
     * @return 维修人员管理
     */
    public DormRepairer selectDormRepairerByRepairerId(Long repairerId);

    /**
     * 根据用户ID查询维修人员管理
     *
     * @param userId 用户ID
     * @return 维修人员管理
     */
    public DormRepairer selectDormRepairerByUserId(Long userId);

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
     * 删除维修人员管理
     * 
     * @param repairerId 维修人员管理主键
     * @return 结果
     */
    public int deleteDormRepairerByRepairerId(Long repairerId);

    /**
     * 批量删除维修人员管理
     * 
     * @param repairerIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormRepairerByRepairerIds(Long[] repairerIds);
}
