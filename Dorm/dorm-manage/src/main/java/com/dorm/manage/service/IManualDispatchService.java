package com.dorm.manage.service;

import com.dorm.manage.domain.DormRepairer;

import java.util.List;

/**
 * 人工派单服务接口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public interface IManualDispatchService 
{
    /**
     * 获取等待人工派单的工单列表
     * 
     * @return 工单列表
     */
    List<ManualDispatchRequest> getPendingManualDispatchRequests();

    /**
     * 人工派单
     * 
     * @param requestId 工单ID
     * @param repairerId 维修人员ID
     * @param operatorId 操作员ID
     * @param remark 备注
     * @return 派单结果
     */
    ManualDispatchResult manualDispatch(Long requestId, Long repairerId, Long operatorId, String remark);

    /**
     * 获取可用的维修人员列表（用于人工派单）
     * 
     * @param specialty 专长领域
     * @param includeWorking 是否包含正在工作的维修人员
     * @return 维修人员列表
     */
    List<DormRepairer> getAvailableRepairersForManual(String specialty, boolean includeWorking);

    /**
     * 批量人工派单
     * 
     * @param dispatchRequests 派单请求列表
     * @param operatorId 操作员ID
     * @return 批量派单结果
     */
    BatchManualDispatchResult batchManualDispatch(List<ManualDispatchRequest> dispatchRequests, Long operatorId);

    /**
     * 取消人工派单
     * 
     * @param requestId 工单ID
     * @param operatorId 操作员ID
     * @param reason 取消原因
     * @return 取消结果
     */
    boolean cancelManualDispatch(Long requestId, Long operatorId, String reason);

    /**
     * 获取人工派单历史
     * 
     * @param requestId 工单ID
     * @return 派单历史
     */
    List<ManualDispatchHistory> getManualDispatchHistory(Long requestId);

    /**
     * 获取人工派单统计
     * 
     * @param operatorId 操作员ID（可选）
     * @param days 统计天数
     * @return 统计数据
     */
    ManualDispatchStatistics getManualDispatchStatistics(Long operatorId, int days);

    /**
     * 人工派单请求类
     */
    class ManualDispatchRequest {
        /** 工单ID */
        private Long requestId;
        
        /** 工单编号 */
        private String requestNo;
        
        /** 维修项目 */
        private String specialty;
        
        /** 问题描述 */
        private String description;
        
        /** 宿舍信息 */
        private String dormInfo;
        
        /** 报修人 */
        private String reporterName;
        
        /** 联系方式 */
        private String contactPhone;
        
        /** 创建时间 */
        private java.util.Date createTime;
        
        /** 尝试次数 */
        private Integer attemptCount;
        
        /** 最后失败原因 */
        private String lastFailureReason;
        
        /** 指定维修人员ID（用于批量派单） */
        private Long assignedRepairerId;

        // Getters and Setters
        public Long getRequestId() {
            return requestId;
        }

        public void setRequestId(Long requestId) {
            this.requestId = requestId;
        }

        public String getRequestNo() {
            return requestNo;
        }

        public void setRequestNo(String requestNo) {
            this.requestNo = requestNo;
        }

        public String getSpecialty() {
            return specialty;
        }

        public void setSpecialty(String specialty) {
            this.specialty = specialty;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getDormInfo() {
            return dormInfo;
        }

        public void setDormInfo(String dormInfo) {
            this.dormInfo = dormInfo;
        }

        public String getReporterName() {
            return reporterName;
        }

        public void setReporterName(String reporterName) {
            this.reporterName = reporterName;
        }

        public String getContactPhone() {
            return contactPhone;
        }

        public void setContactPhone(String contactPhone) {
            this.contactPhone = contactPhone;
        }

        public java.util.Date getCreateTime() {
            return createTime;
        }

        public void setCreateTime(java.util.Date createTime) {
            this.createTime = createTime;
        }

        public Integer getAttemptCount() {
            return attemptCount;
        }

        public void setAttemptCount(Integer attemptCount) {
            this.attemptCount = attemptCount;
        }

        public String getLastFailureReason() {
            return lastFailureReason;
        }

        public void setLastFailureReason(String lastFailureReason) {
            this.lastFailureReason = lastFailureReason;
        }

        public Long getAssignedRepairerId() {
            return assignedRepairerId;
        }

        public void setAssignedRepairerId(Long assignedRepairerId) {
            this.assignedRepairerId = assignedRepairerId;
        }
    }

    /**
     * 人工派单结果类
     */
    class ManualDispatchResult {
        /** 是否成功 */
        private boolean success;
        
        /** 派单ID */
        private Long assignmentId;
        
        /** 维修人员信息 */
        private DormRepairer repairer;
        
        /** 失败原因 */
        private String failureReason;
        
        /** 操作时间 */
        private java.util.Date operationTime;

        public ManualDispatchResult() {}

        public ManualDispatchResult(boolean success, String failureReason) {
            this.success = success;
            this.failureReason = failureReason;
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public Long getAssignmentId() {
            return assignmentId;
        }

        public void setAssignmentId(Long assignmentId) {
            this.assignmentId = assignmentId;
        }

        public DormRepairer getRepairer() {
            return repairer;
        }

        public void setRepairer(DormRepairer repairer) {
            this.repairer = repairer;
        }

        public String getFailureReason() {
            return failureReason;
        }

        public void setFailureReason(String failureReason) {
            this.failureReason = failureReason;
        }

        public java.util.Date getOperationTime() {
            return operationTime;
        }

        public void setOperationTime(java.util.Date operationTime) {
            this.operationTime = operationTime;
        }
    }

    /**
     * 批量人工派单结果类
     */
    class BatchManualDispatchResult {
        /** 总数 */
        private int totalCount;
        
        /** 成功数 */
        private int successCount;
        
        /** 失败数 */
        private int failureCount;
        
        /** 详细结果 */
        private List<ManualDispatchResult> details;

        // Getters and Setters
        public int getTotalCount() {
            return totalCount;
        }

        public void setTotalCount(int totalCount) {
            this.totalCount = totalCount;
        }

        public int getSuccessCount() {
            return successCount;
        }

        public void setSuccessCount(int successCount) {
            this.successCount = successCount;
        }

        public int getFailureCount() {
            return failureCount;
        }

        public void setFailureCount(int failureCount) {
            this.failureCount = failureCount;
        }

        public List<ManualDispatchResult> getDetails() {
            return details;
        }

        public void setDetails(List<ManualDispatchResult> details) {
            this.details = details;
        }
    }

    /**
     * 人工派单历史类
     */
    class ManualDispatchHistory {
        /** 操作时间 */
        private java.util.Date operationTime;
        
        /** 操作员 */
        private String operatorName;
        
        /** 操作类型 */
        private String operationType;
        
        /** 维修人员 */
        private String repairerName;
        
        /** 备注 */
        private String remark;

        // Getters and Setters
        public java.util.Date getOperationTime() {
            return operationTime;
        }

        public void setOperationTime(java.util.Date operationTime) {
            this.operationTime = operationTime;
        }

        public String getOperatorName() {
            return operatorName;
        }

        public void setOperatorName(String operatorName) {
            this.operatorName = operatorName;
        }

        public String getOperationType() {
            return operationType;
        }

        public void setOperationType(String operationType) {
            this.operationType = operationType;
        }

        public String getRepairerName() {
            return repairerName;
        }

        public void setRepairerName(String repairerName) {
            this.repairerName = repairerName;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }
    }

    /**
     * 人工派单统计类
     */
    class ManualDispatchStatistics {
        /** 总派单数 */
        private int totalDispatches;
        
        /** 成功派单数 */
        private int successfulDispatches;
        
        /** 平均处理时间（分钟） */
        private double averageProcessingTime;
        
        /** 成功率 */
        private double successRate;

        // Getters and Setters
        public int getTotalDispatches() {
            return totalDispatches;
        }

        public void setTotalDispatches(int totalDispatches) {
            this.totalDispatches = totalDispatches;
        }

        public int getSuccessfulDispatches() {
            return successfulDispatches;
        }

        public void setSuccessfulDispatches(int successfulDispatches) {
            this.successfulDispatches = successfulDispatches;
        }

        public double getAverageProcessingTime() {
            return averageProcessingTime;
        }

        public void setAverageProcessingTime(double averageProcessingTime) {
            this.averageProcessingTime = averageProcessingTime;
        }

        public double getSuccessRate() {
            return successRate;
        }

        public void setSuccessRate(double successRate) {
            this.successRate = successRate;
        }
    }
}
