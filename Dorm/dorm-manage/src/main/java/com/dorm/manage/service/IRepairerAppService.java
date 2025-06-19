package com.dorm.manage.service;

import com.dorm.common.core.domain.AjaxResult;
import com.dorm.manage.domain.DormRepairAssignment;

import java.util.List;

/**
 * 维修人员App端服务接口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public interface IRepairerAppService 
{
    /**
     * 获取待处理派单列表
     * 
     * @param repairerId 维修人员ID
     * @return 派单列表
     */
    List<DormRepairAssignment> getPendingAssignments(Long repairerId);

    /**
     * 获取处理中的派单列表
     * 
     * @param repairerId 维修人员ID
     * @return 派单列表
     */
    List<DormRepairAssignment> getProcessingAssignments(Long repairerId);

    /**
     * 获取已完成的派单列表
     *
     * @param repairerId 维修人员ID
     * @return 派单列表
     */
    List<DormRepairAssignment> getCompletedAssignments(Long repairerId);

    /**
     * 获取已拒绝的派单列表
     *
     * @param repairerId 维修人员ID
     * @return 派单列表
     */
    List<DormRepairAssignment> getRejectedAssignments(Long repairerId);

    /**
     * 获取所有派单列表
     *
     * @param repairerId 维修人员ID
     * @return 派单列表
     */
    List<DormRepairAssignment> getAllAssignments(Long repairerId);

    /**
     * 获取派单详情
     *
     * @param assignmentId 派单ID
     * @param repairerId 维修人员ID
     * @return 派单详情
     */
    DormRepairAssignment getAssignmentDetail(Long assignmentId, Long repairerId);

    /**
     * 接受派单
     * 
     * @param assignmentId 派单ID
     * @param repairerId 维修人员ID
     * @return 操作结果
     */
    AjaxResult acceptAssignment(Long assignmentId, Long repairerId);

    /**
     * 拒绝派单
     * 
     * @param assignmentId 派单ID
     * @param repairerId 维修人员ID
     * @param rejectReason 拒绝原因
     * @return 操作结果
     */
    AjaxResult rejectAssignment(Long assignmentId, Long repairerId, String rejectReason);

    /**
     * 完成维修
     * 
     * @param assignmentId 派单ID
     * @param repairerId 维修人员ID
     * @param images 完成图片
     * @param processRemark 处理备注
     * @return 操作结果
     */
    AjaxResult completeAssignment(Long assignmentId, Long repairerId, String images, String processRemark);

    /**
     * 获取未读派单数量
     * 
     * @param repairerId 维修人员ID
     * @return 未读数量
     */
    int getUnreadAssignmentCount(Long repairerId);

    /**
     * 派单详情VO类
     */
    class AssignmentDetailVO {
        /** 派单信息 */
        private DormRepairAssignment assignment;
        
        /** 工单信息 */
        private Object repairRequest;
        
        /** 宿舍信息 */
        private Object dormInfo;

        public DormRepairAssignment getAssignment() {
            return assignment;
        }

        public void setAssignment(DormRepairAssignment assignment) {
            this.assignment = assignment;
        }

        public Object getRepairRequest() {
            return repairRequest;
        }

        public void setRepairRequest(Object repairRequest) {
            this.repairRequest = repairRequest;
        }

        public Object getDormInfo() {
            return dormInfo;
        }

        public void setDormInfo(Object dormInfo) {
            this.dormInfo = dormInfo;
        }
    }
}
