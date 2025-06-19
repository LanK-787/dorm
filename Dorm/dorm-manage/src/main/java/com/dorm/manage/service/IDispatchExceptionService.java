package com.dorm.manage.service;

import java.util.List;

/**
 * 派单异常处理服务接口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public interface IDispatchExceptionService 
{
    /**
     * 处理派单异常
     * 
     * @param requestId 工单ID
     * @param exceptionType 异常类型
     * @param exceptionMessage 异常信息
     * @param stackTrace 异常堆栈
     * @return 处理结果
     */
    ExceptionHandleResult handleDispatchException(Long requestId, String exceptionType, 
                                                 String exceptionMessage, String stackTrace);

    /**
     * 记录派单异常
     * 
     * @param requestId 工单ID
     * @param exceptionType 异常类型
     * @param exceptionMessage 异常信息
     * @param stackTrace 异常堆栈
     */
    void recordDispatchException(Long requestId, String exceptionType, 
                               String exceptionMessage, String stackTrace);

    /**
     * 获取异常统计
     * 
     * @param days 统计天数
     * @return 异常统计列表
     */
    List<ExceptionStatistics> getExceptionStatistics(int days);

    /**
     * 获取频繁异常列表
     * 
     * @param limit 返回数量限制
     * @return 频繁异常列表
     */
    List<FrequentException> getFrequentExceptions(int limit);

    /**
     * 处理超时派单
     * 
     * @param assignmentId 派单ID
     * @return 处理结果
     */
    boolean handleTimeoutAssignment(Long assignmentId);

    /**
     * 处理死信消息
     * 
     * @param messageId 消息ID
     * @param messageContent 消息内容
     * @param failureReason 失败原因
     * @return 处理结果
     */
    boolean handleDeadLetterMessage(String messageId, String messageContent, String failureReason);

    /**
     * 自动恢复派单
     * 
     * @param requestId 工单ID
     * @return 恢复结果
     */
    RecoveryResult autoRecoverDispatch(Long requestId);

    /**
     * 异常处理结果类
     */
    class ExceptionHandleResult {
        /** 是否处理成功 */
        private boolean success;
        
        /** 处理动作 */
        private String action;
        
        /** 处理结果描述 */
        private String description;
        
        /** 是否需要人工干预 */
        private boolean needManualIntervention;

        public ExceptionHandleResult() {}

        public ExceptionHandleResult(boolean success, String action, String description) {
            this.success = success;
            this.action = action;
            this.description = description;
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getAction() {
            return action;
        }

        public void setAction(String action) {
            this.action = action;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public boolean isNeedManualIntervention() {
            return needManualIntervention;
        }

        public void setNeedManualIntervention(boolean needManualIntervention) {
            this.needManualIntervention = needManualIntervention;
        }
    }

    /**
     * 异常统计类
     */
    class ExceptionStatistics {
        /** 异常类型 */
        private String exceptionType;
        
        /** 异常数量 */
        private int count;
        
        /** 异常率 */
        private double rate;
        
        /** 最近发生时间 */
        private java.util.Date lastOccurrence;

        // Getters and Setters
        public String getExceptionType() {
            return exceptionType;
        }

        public void setExceptionType(String exceptionType) {
            this.exceptionType = exceptionType;
        }

        public int getCount() {
            return count;
        }

        public void setCount(int count) {
            this.count = count;
        }

        public double getRate() {
            return rate;
        }

        public void setRate(double rate) {
            this.rate = rate;
        }

        public java.util.Date getLastOccurrence() {
            return lastOccurrence;
        }

        public void setLastOccurrence(java.util.Date lastOccurrence) {
            this.lastOccurrence = lastOccurrence;
        }
    }

    /**
     * 频繁异常类
     */
    class FrequentException {
        /** 异常类型 */
        private String exceptionType;
        
        /** 异常信息 */
        private String exceptionMessage;
        
        /** 发生次数 */
        private int occurrenceCount;
        
        /** 影响的工单数量 */
        private int affectedRequestCount;
        
        /** 建议处理方案 */
        private String suggestedSolution;

        // Getters and Setters
        public String getExceptionType() {
            return exceptionType;
        }

        public void setExceptionType(String exceptionType) {
            this.exceptionType = exceptionType;
        }

        public String getExceptionMessage() {
            return exceptionMessage;
        }

        public void setExceptionMessage(String exceptionMessage) {
            this.exceptionMessage = exceptionMessage;
        }

        public int getOccurrenceCount() {
            return occurrenceCount;
        }

        public void setOccurrenceCount(int occurrenceCount) {
            this.occurrenceCount = occurrenceCount;
        }

        public int getAffectedRequestCount() {
            return affectedRequestCount;
        }

        public void setAffectedRequestCount(int affectedRequestCount) {
            this.affectedRequestCount = affectedRequestCount;
        }

        public String getSuggestedSolution() {
            return suggestedSolution;
        }

        public void setSuggestedSolution(String suggestedSolution) {
            this.suggestedSolution = suggestedSolution;
        }
    }

    /**
     * 恢复结果类
     */
    class RecoveryResult {
        /** 是否恢复成功 */
        private boolean success;
        
        /** 恢复动作 */
        private String recoveryAction;
        
        /** 恢复描述 */
        private String description;
        
        /** 新的派单ID */
        private Long newAssignmentId;

        public RecoveryResult() {}

        public RecoveryResult(boolean success, String recoveryAction, String description) {
            this.success = success;
            this.recoveryAction = recoveryAction;
            this.description = description;
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getRecoveryAction() {
            return recoveryAction;
        }

        public void setRecoveryAction(String recoveryAction) {
            this.recoveryAction = recoveryAction;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public Long getNewAssignmentId() {
            return newAssignmentId;
        }

        public void setNewAssignmentId(Long newAssignmentId) {
            this.newAssignmentId = newAssignmentId;
        }
    }
}
