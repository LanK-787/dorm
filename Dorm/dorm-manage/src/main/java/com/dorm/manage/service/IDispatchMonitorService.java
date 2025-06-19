package com.dorm.manage.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 派单监控服务接口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public interface IDispatchMonitorService 
{
    /**
     * 获取派单统计数据
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 统计数据
     */
    DispatchStatistics getDispatchStatistics(Date startDate, Date endDate);

    /**
     * 获取维修人员工作量统计
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 工作量统计
     */
    List<RepairerWorkload> getRepairerWorkloadStatistics(Date startDate, Date endDate);

    /**
     * 获取派单失败分析
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 失败分析
     */
    List<DispatchFailureAnalysis> getDispatchFailureAnalysis(Date startDate, Date endDate);

    /**
     * 获取实时派单状态
     * 
     * @return 实时状态
     */
    RealTimeDispatchStatus getRealTimeDispatchStatus();

    /**
     * 检查系统健康状态
     * 
     * @return 健康状态
     */
    SystemHealthStatus checkSystemHealth();

    /**
     * 获取派单效率趋势
     * 
     * @param days 天数
     * @return 效率趋势
     */
    List<DispatchEfficiencyTrend> getDispatchEfficiencyTrend(int days);

    /**
     * 派单统计数据类
     */
    class DispatchStatistics {
        /** 总派单数 */
        private int totalDispatches;
        
        /** 成功派单数 */
        private int successfulDispatches;
        
        /** 失败派单数 */
        private int failedDispatches;
        
        /** 人工派单数 */
        private int manualDispatches;
        
        /** 平均响应时间（分钟） */
        private double averageResponseTime;
        
        /** 平均完成时间（小时） */
        private double averageCompletionTime;
        
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

        public int getFailedDispatches() {
            return failedDispatches;
        }

        public void setFailedDispatches(int failedDispatches) {
            this.failedDispatches = failedDispatches;
        }

        public int getManualDispatches() {
            return manualDispatches;
        }

        public void setManualDispatches(int manualDispatches) {
            this.manualDispatches = manualDispatches;
        }

        public double getAverageResponseTime() {
            return averageResponseTime;
        }

        public void setAverageResponseTime(double averageResponseTime) {
            this.averageResponseTime = averageResponseTime;
        }

        public double getAverageCompletionTime() {
            return averageCompletionTime;
        }

        public void setAverageCompletionTime(double averageCompletionTime) {
            this.averageCompletionTime = averageCompletionTime;
        }

        public double getSuccessRate() {
            return successRate;
        }

        public void setSuccessRate(double successRate) {
            this.successRate = successRate;
        }
    }

    /**
     * 维修人员工作量统计类
     */
    class RepairerWorkload {
        /** 维修人员ID */
        private Long repairerId;
        
        /** 维修人员姓名 */
        private String repairerName;
        
        /** 接单数量 */
        private int assignedCount;
        
        /** 完成数量 */
        private int completedCount;
        
        /** 拒绝数量 */
        private int rejectedCount;
        
        /** 平均响应时间（分钟） */
        private double averageResponseTime;
        
        /** 完成率 */
        private double completionRate;

        // Getters and Setters
        public Long getRepairerId() {
            return repairerId;
        }

        public void setRepairerId(Long repairerId) {
            this.repairerId = repairerId;
        }

        public String getRepairerName() {
            return repairerName;
        }

        public void setRepairerName(String repairerName) {
            this.repairerName = repairerName;
        }

        public int getAssignedCount() {
            return assignedCount;
        }

        public void setAssignedCount(int assignedCount) {
            this.assignedCount = assignedCount;
        }

        public int getCompletedCount() {
            return completedCount;
        }

        public void setCompletedCount(int completedCount) {
            this.completedCount = completedCount;
        }

        public int getRejectedCount() {
            return rejectedCount;
        }

        public void setRejectedCount(int rejectedCount) {
            this.rejectedCount = rejectedCount;
        }

        public double getAverageResponseTime() {
            return averageResponseTime;
        }

        public void setAverageResponseTime(double averageResponseTime) {
            this.averageResponseTime = averageResponseTime;
        }

        public double getCompletionRate() {
            return completionRate;
        }

        public void setCompletionRate(double completionRate) {
            this.completionRate = completionRate;
        }
    }

    /**
     * 派单失败分析类
     */
    class DispatchFailureAnalysis {
        /** 失败原因 */
        private String failureReason;
        
        /** 失败次数 */
        private int failureCount;
        
        /** 失败率 */
        private double failureRate;

        // Getters and Setters
        public String getFailureReason() {
            return failureReason;
        }

        public void setFailureReason(String failureReason) {
            this.failureReason = failureReason;
        }

        public int getFailureCount() {
            return failureCount;
        }

        public void setFailureCount(int failureCount) {
            this.failureCount = failureCount;
        }

        public double getFailureRate() {
            return failureRate;
        }

        public void setFailureRate(double failureRate) {
            this.failureRate = failureRate;
        }
    }

    /**
     * 实时派单状态类
     */
    class RealTimeDispatchStatus {
        /** 待派单数量 */
        private int pendingDispatchCount;
        
        /** 处理中数量 */
        private int processingCount;
        
        /** 等待人工派单数量 */
        private int manualDispatchCount;
        
        /** 空闲维修人员数量 */
        private int availableRepairerCount;
        
        /** 出工维修人员数量 */
        private int workingRepairerCount;

        // Getters and Setters
        public int getPendingDispatchCount() {
            return pendingDispatchCount;
        }

        public void setPendingDispatchCount(int pendingDispatchCount) {
            this.pendingDispatchCount = pendingDispatchCount;
        }

        public int getProcessingCount() {
            return processingCount;
        }

        public void setProcessingCount(int processingCount) {
            this.processingCount = processingCount;
        }

        public int getManualDispatchCount() {
            return manualDispatchCount;
        }

        public void setManualDispatchCount(int manualDispatchCount) {
            this.manualDispatchCount = manualDispatchCount;
        }

        public int getAvailableRepairerCount() {
            return availableRepairerCount;
        }

        public void setAvailableRepairerCount(int availableRepairerCount) {
            this.availableRepairerCount = availableRepairerCount;
        }

        public int getWorkingRepairerCount() {
            return workingRepairerCount;
        }

        public void setWorkingRepairerCount(int workingRepairerCount) {
            this.workingRepairerCount = workingRepairerCount;
        }
    }

    /**
     * 系统健康状态类
     */
    class SystemHealthStatus {
        /** 系统状态（HEALTHY, WARNING, ERROR） */
        private String status;
        
        /** 健康检查项目 */
        private Map<String, Object> healthChecks;
        
        /** 警告信息 */
        private List<String> warnings;
        
        /** 错误信息 */
        private List<String> errors;

        // Getters and Setters
        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Map<String, Object> getHealthChecks() {
            return healthChecks;
        }

        public void setHealthChecks(Map<String, Object> healthChecks) {
            this.healthChecks = healthChecks;
        }

        public List<String> getWarnings() {
            return warnings;
        }

        public void setWarnings(List<String> warnings) {
            this.warnings = warnings;
        }

        public List<String> getErrors() {
            return errors;
        }

        public void setErrors(List<String> errors) {
            this.errors = errors;
        }
    }

    /**
     * 派单效率趋势类
     */
    class DispatchEfficiencyTrend {
        /** 日期 */
        private Date date;
        
        /** 派单数量 */
        private int dispatchCount;
        
        /** 成功率 */
        private double successRate;
        
        /** 平均响应时间 */
        private double averageResponseTime;

        // Getters and Setters
        public Date getDate() {
            return date;
        }

        public void setDate(Date date) {
            this.date = date;
        }

        public int getDispatchCount() {
            return dispatchCount;
        }

        public void setDispatchCount(int dispatchCount) {
            this.dispatchCount = dispatchCount;
        }

        public double getSuccessRate() {
            return successRate;
        }

        public void setSuccessRate(double successRate) {
            this.successRate = successRate;
        }

        public double getAverageResponseTime() {
            return averageResponseTime;
        }

        public void setAverageResponseTime(double averageResponseTime) {
            this.averageResponseTime = averageResponseTime;
        }
    }
}
