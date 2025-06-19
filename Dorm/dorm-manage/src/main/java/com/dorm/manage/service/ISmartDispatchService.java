package com.dorm.manage.service;

import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.domain.DormRepairer;

import java.util.ArrayList;
import java.util.List;

/**
 * 智能派单服务接口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public interface ISmartDispatchService 
{
    /**
     * 智能派单
     * 
     * @param repairRequest 报修工单
     * @return 派单结果
     */
    SmartDispatchResult smartDispatch(DormRepairRequest repairRequest);

    /**
     * 重新派单
     * 
     * @param requestId 工单ID
     * @param excludeRepairerIds 排除的维修人员ID列表
     * @return 派单结果
     */
    SmartDispatchResult redispatch(Long requestId, List<Long> excludeRepairerIds);

    /**
     * 获取可用的维修人员列表
     * 
     * @param specialty 专长领域
     * @param excludeRepairerIds 排除的维修人员ID列表
     * @return 维修人员列表
     */
    List<DormRepairer> getAvailableRepairers(String specialty, List<Long> excludeRepairerIds);

    /**
     * 检查是否需要人工派单
     * 
     * @param requestId 工单ID
     * @return 是否需要人工派单
     */
    boolean needManualDispatch(Long requestId);

    /**
     * 获取工单的拒绝派单历史
     *
     * @param requestId 工单ID
     * @return 拒绝派单的维修人员ID列表
     */
    List<Long> getRejectedRepairerIds(Long requestId);

    /**
     * 定期检查并重新派单等待人工派单的工单
     *
     * @return 处理结果统计
     */
    PendingDispatchCheckResult checkAndRedispatchPendingOrders();

    /**
     * 批量重新派单指定的工单列表
     *
     * @param requestIds 工单ID列表
     * @return 批量处理结果
     */
    BatchRedispatchResult batchRedispatch(List<Long> requestIds);

    /**
     * 智能派单结果类
     */
    class SmartDispatchResult {
        /** 派单是否成功 */
        private boolean success;
        
        /** 选中的维修人员 */
        private DormRepairer selectedRepairer;
        
        /** 候选维修人员数量 */
        private int candidateCount;
        
        /** 失败原因 */
        private String failureReason;
        
        /** 派单类型 */
        private String dispatchType;

        public SmartDispatchResult() {}

        public SmartDispatchResult(boolean success, String failureReason) {
            this.success = success;
            this.failureReason = failureReason;
        }

        public SmartDispatchResult(boolean success, DormRepairer selectedRepairer, int candidateCount, String dispatchType) {
            this.success = success;
            this.selectedRepairer = selectedRepairer;
            this.candidateCount = candidateCount;
            this.dispatchType = dispatchType;
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public DormRepairer getSelectedRepairer() {
            return selectedRepairer;
        }

        public void setSelectedRepairer(DormRepairer selectedRepairer) {
            this.selectedRepairer = selectedRepairer;
        }

        public int getCandidateCount() {
            return candidateCount;
        }

        public void setCandidateCount(int candidateCount) {
            this.candidateCount = candidateCount;
        }

        public String getFailureReason() {
            return failureReason;
        }

        public void setFailureReason(String failureReason) {
            this.failureReason = failureReason;
        }

        public String getDispatchType() {
            return dispatchType;
        }

        public void setDispatchType(String dispatchType) {
            this.dispatchType = dispatchType;
        }
    }

    /**
     * 等待派单检查结果类
     */
    class PendingDispatchCheckResult {
        /** 检查的工单总数 */
        private int totalChecked;

        /** 成功重新派单的数量 */
        private int successCount;

        /** 失败的数量 */
        private int failureCount;

        /** 详细结果信息 */
        private String details;

        public PendingDispatchCheckResult() {}

        public PendingDispatchCheckResult(int totalChecked, int successCount, int failureCount, String details) {
            this.totalChecked = totalChecked;
            this.successCount = successCount;
            this.failureCount = failureCount;
            this.details = details;
        }

        // Getters and Setters
        public int getTotalChecked() { return totalChecked; }
        public void setTotalChecked(int totalChecked) { this.totalChecked = totalChecked; }
        public int getSuccessCount() { return successCount; }
        public void setSuccessCount(int successCount) { this.successCount = successCount; }
        public int getFailureCount() { return failureCount; }
        public void setFailureCount(int failureCount) { this.failureCount = failureCount; }
        public String getDetails() { return details; }
        public void setDetails(String details) { this.details = details; }
    }

    /**
     * 批量重新派单结果类
     */
    class BatchRedispatchResult {
        /** 处理的工单总数 */
        private int totalProcessed;

        /** 成功派单的数量 */
        private int successCount;

        /** 失败的数量 */
        private int failureCount;

        /** 详细结果列表 */
        private List<String> resultDetails;

        public BatchRedispatchResult() {
            this.resultDetails = new ArrayList<>();
        }

        public BatchRedispatchResult(int totalProcessed, int successCount, int failureCount) {
            this.totalProcessed = totalProcessed;
            this.successCount = successCount;
            this.failureCount = failureCount;
            this.resultDetails = new ArrayList<>();
        }

        // Getters and Setters
        public int getTotalProcessed() { return totalProcessed; }
        public void setTotalProcessed(int totalProcessed) { this.totalProcessed = totalProcessed; }
        public int getSuccessCount() { return successCount; }
        public void setSuccessCount(int successCount) { this.successCount = successCount; }
        public int getFailureCount() { return failureCount; }
        public void setFailureCount(int failureCount) { this.failureCount = failureCount; }
        public List<String> getResultDetails() { return resultDetails; }
        public void setResultDetails(List<String> resultDetails) { this.resultDetails = resultDetails; }

        public void addResult(String detail) {
            this.resultDetails.add(detail);
        }
    }
}
