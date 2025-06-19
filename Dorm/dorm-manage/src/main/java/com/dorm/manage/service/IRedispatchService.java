package com.dorm.manage.service;

import com.dorm.manage.domain.DormRepairRequest;

/**
 * 重新派单服务接口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public interface IRedispatchService 
{
    /**
     * 异步重新派单
     * 
     * @param requestId 工单ID
     * @param delaySeconds 延时秒数
     * @return 是否成功发送重新派单消息
     */
    boolean asyncRedispatch(Long requestId, int delaySeconds);

    /**
     * 立即重新派单
     * 
     * @param requestId 工单ID
     * @return 重新派单结果
     */
    RedispatchResult immediateRedispatch(Long requestId);

    /**
     * 检查工单是否需要重新派单
     * 
     * @param requestId 工单ID
     * @return 是否需要重新派单
     */
    boolean needRedispatch(Long requestId);

    /**
     * 获取工单的重新派单次数
     * 
     * @param requestId 工单ID
     * @return 重新派单次数
     */
    int getRedispatchCount(Long requestId);

    /**
     * 标记工单为人工派单
     * 
     * @param requestId 工单ID
     * @param reason 原因
     * @return 操作结果
     */
    boolean markAsManualDispatch(Long requestId, String reason);

    /**
     * 重新派单结果类
     */
    class RedispatchResult {
        /** 是否成功 */
        private boolean success;
        
        /** 选中的维修人员ID */
        private Long selectedRepairerId;
        
        /** 选中的维修人员姓名 */
        private String selectedRepairerName;
        
        /** 候选维修人员数量 */
        private int candidateCount;
        
        /** 失败原因 */
        private String failureReason;
        
        /** 是否转为人工派单 */
        private boolean manualDispatch;

        public RedispatchResult() {}

        public RedispatchResult(boolean success, String failureReason) {
            this.success = success;
            this.failureReason = failureReason;
        }

        public RedispatchResult(boolean success, Long selectedRepairerId, String selectedRepairerName, 
                              int candidateCount) {
            this.success = success;
            this.selectedRepairerId = selectedRepairerId;
            this.selectedRepairerName = selectedRepairerName;
            this.candidateCount = candidateCount;
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public Long getSelectedRepairerId() {
            return selectedRepairerId;
        }

        public void setSelectedRepairerId(Long selectedRepairerId) {
            this.selectedRepairerId = selectedRepairerId;
        }

        public String getSelectedRepairerName() {
            return selectedRepairerName;
        }

        public void setSelectedRepairerName(String selectedRepairerName) {
            this.selectedRepairerName = selectedRepairerName;
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

        public boolean isManualDispatch() {
            return manualDispatch;
        }

        public void setManualDispatch(boolean manualDispatch) {
            this.manualDispatch = manualDispatch;
        }
    }
}
