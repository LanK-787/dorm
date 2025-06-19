package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormRepairAssignmentMapper;
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.service.IDormRepairAssignmentService;

/**
 * 工单分配Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@Service
public class DormRepairAssignmentServiceImpl implements IDormRepairAssignmentService 
{
    @Autowired
    private DormRepairAssignmentMapper dormRepairAssignmentMapper;

    /**
     * 查询工单分配
     * 
     * @param assignmentId 工单分配主键
     * @return 工单分配
     */
    @Override
    public DormRepairAssignment selectDormRepairAssignmentByAssignmentId(Long assignmentId)
    {
        return dormRepairAssignmentMapper.selectDormRepairAssignmentByAssignmentId(assignmentId);
    }

    /**
     * 查询工单分配列表
     * 
     * @param dormRepairAssignment 工单分配
     * @return 工单分配
     */
    @Override
    public List<DormRepairAssignment> selectDormRepairAssignmentList(DormRepairAssignment dormRepairAssignment)
    {
        return dormRepairAssignmentMapper.selectDormRepairAssignmentList(dormRepairAssignment);
    }

    /**
     * 新增工单分配
     * 
     * @param dormRepairAssignment 工单分配
     * @return 结果
     */
    @Override
    public int insertDormRepairAssignment(DormRepairAssignment dormRepairAssignment)
    {
        dormRepairAssignment.setCreateTime(DateUtils.getNowDate());
        return dormRepairAssignmentMapper.insertDormRepairAssignment(dormRepairAssignment);
    }

    /**
     * 修改工单分配
     * 
     * @param dormRepairAssignment 工单分配
     * @return 结果
     */
    @Override
    public int updateDormRepairAssignment(DormRepairAssignment dormRepairAssignment)
    {
        dormRepairAssignment.setUpdateTime(DateUtils.getNowDate());
        return dormRepairAssignmentMapper.updateDormRepairAssignment(dormRepairAssignment);
    }

    /**
     * 批量删除工单分配
     * 
     * @param assignmentIds 需要删除的工单分配主键
     * @return 结果
     */
    @Override
    public int deleteDormRepairAssignmentByAssignmentIds(Long[] assignmentIds)
    {
        return dormRepairAssignmentMapper.deleteDormRepairAssignmentByAssignmentIds(assignmentIds);
    }

    /**
     * 删除工单分配信息
     * 
     * @param assignmentId 工单分配主键
     * @return 结果
     */
    @Override
    public int deleteDormRepairAssignmentByAssignmentId(Long assignmentId)
    {
        return dormRepairAssignmentMapper.deleteDormRepairAssignmentByAssignmentId(assignmentId);
    }
}
