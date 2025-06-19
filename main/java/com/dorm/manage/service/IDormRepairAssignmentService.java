package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormRepairAssignment;

/**
 * 工单分配Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public interface IDormRepairAssignmentService 
{
    /**
     * 查询工单分配
     * 
     * @param assignmentId 工单分配主键
     * @return 工单分配
     */
    public DormRepairAssignment selectDormRepairAssignmentByAssignmentId(Long assignmentId);

    /**
     * 查询工单分配列表
     * 
     * @param dormRepairAssignment 工单分配
     * @return 工单分配集合
     */
    public List<DormRepairAssignment> selectDormRepairAssignmentList(DormRepairAssignment dormRepairAssignment);

    /**
     * 新增工单分配
     * 
     * @param dormRepairAssignment 工单分配
     * @return 结果
     */
    public int insertDormRepairAssignment(DormRepairAssignment dormRepairAssignment);

    /**
     * 修改工单分配
     * 
     * @param dormRepairAssignment 工单分配
     * @return 结果
     */
    public int updateDormRepairAssignment(DormRepairAssignment dormRepairAssignment);

    /**
     * 批量删除工单分配
     * 
     * @param assignmentIds 需要删除的工单分配主键集合
     * @return 结果
     */
    public int deleteDormRepairAssignmentByAssignmentIds(Long[] assignmentIds);

    /**
     * 删除工单分配信息
     * 
     * @param assignmentId 工单分配主键
     * @return 结果
     */
    public int deleteDormRepairAssignmentByAssignmentId(Long assignmentId);
}
