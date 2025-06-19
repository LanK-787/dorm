package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormRepairAssignment;
import org.apache.ibatis.annotations.Param;

/**
 * 工单分配Mapper接口
 *
 * @author 王新瑜
 * @date 2025-06-18
 */
public interface DormRepairAssignmentMapper
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
     * 查询工单分配列表（包含工单详细信息）
     *
     * @param dormRepairAssignment 工单分配
     * @return 工单分配集合
     */
    public List<DormRepairAssignment> selectDormRepairAssignmentListWithDetails(DormRepairAssignment dormRepairAssignment);

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
     * 条件更新工单分配状态（防止并发问题）
     *
     * @param assignmentId 工单分配ID
     * @param newStatus 新状态
     * @param expectedStatus 期望的当前状态
     * @return 结果
     */
    public int updateAssignmentStatusConditional(@Param("assignmentId") Long assignmentId,
                                                @Param("newStatus") String newStatus,
                                                @Param("expectedStatus") String expectedStatus);

    /**
     * 删除工单分配
     *
     * @param assignmentId 工单分配主键
     * @return 结果
     */
    public int deleteDormRepairAssignmentByAssignmentId(Long assignmentId);

    /**
     * 批量删除工单分配
     *
     * @param assignmentIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormRepairAssignmentByAssignmentIds(Long[] assignmentIds);
}
