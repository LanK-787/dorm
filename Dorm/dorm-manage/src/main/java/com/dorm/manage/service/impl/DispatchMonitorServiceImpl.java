package com.dorm.manage.service.impl;

import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.domain.DormRepairer;
import com.dorm.manage.mapper.DormRepairAssignmentMapper;
import com.dorm.manage.mapper.DormRepairRequestMapper;
import com.dorm.manage.mapper.DormRepairerMapper;
import com.dorm.manage.service.IDispatchMonitorService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 派单监控服务实现类
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@Service
public class DispatchMonitorServiceImpl implements IDispatchMonitorService {

    private static final Logger logger = LoggerFactory.getLogger(DispatchMonitorServiceImpl.class);

    @Autowired
    private DormRepairRequestMapper repairRequestMapper;

    @Autowired
    private DormRepairAssignmentMapper assignmentMapper;

    @Autowired
    private DormRepairerMapper repairerMapper;

    @Autowired
    private RedisTemplate<Object, Object> redisTemplate;

    /**
     * 获取派单统计数据
     */
    @Override
    public DispatchStatistics getDispatchStatistics(Date startDate, Date endDate) {
        try {
            DispatchStatistics statistics = new DispatchStatistics();

            // 查询指定时间范围内的所有派单
            DormRepairAssignment queryAssignment = new DormRepairAssignment();
            List<DormRepairAssignment> assignments = assignmentMapper.selectDormRepairAssignmentList(queryAssignment);

            // 过滤时间范围
            List<DormRepairAssignment> filteredAssignments = assignments.stream()
                    .filter(assignment -> assignment.getAssignTime() != null &&
                            !assignment.getAssignTime().before(startDate) &&
                            !assignment.getAssignTime().after(endDate))
                    .collect(Collectors.toList());

            // 计算统计数据
            statistics.setTotalDispatches(filteredAssignments.size());

            long successfulCount = filteredAssignments.stream()
                    .filter(assignment -> "2".equals(assignment.getProcessStatus()))
                    .count();
            statistics.setSuccessfulDispatches((int) successfulCount);

            long failedCount = filteredAssignments.stream()
                    .filter(assignment -> "3".equals(assignment.getProcessStatus()))
                    .count();
            statistics.setFailedDispatches((int) failedCount);

            // 计算成功率
            if (statistics.getTotalDispatches() > 0) {
                statistics.setSuccessRate((double) successfulCount / statistics.getTotalDispatches() * 100);
            }

            // 计算平均响应时间
            double avgResponseTime = filteredAssignments.stream()
                    .filter(assignment -> assignment.getAcceptTime() != null && assignment.getAssignTime() != null)
                    .mapToLong(assignment -> assignment.getAcceptTime().getTime() - assignment.getAssignTime().getTime())
                    .average()
                    .orElse(0.0);
            statistics.setAverageResponseTime(avgResponseTime / (1000 * 60)); // 转换为分钟

            // 计算平均完成时间
            double avgCompletionTime = filteredAssignments.stream()
                    .filter(assignment -> assignment.getCompleteTime() != null && assignment.getAcceptTime() != null)
                    .mapToLong(assignment -> assignment.getCompleteTime().getTime() - assignment.getAcceptTime().getTime())
                    .average()
                    .orElse(0.0);
            statistics.setAverageCompletionTime(avgCompletionTime / (1000 * 60 * 60)); // 转换为小时

            return statistics;

        } catch (Exception e) {
            logger.error("获取派单统计数据失败", e);
            return new DispatchStatistics();
        }
    }

    /**
     * 获取维修人员工作量统计
     */
    @Override
    public List<RepairerWorkload> getRepairerWorkloadStatistics(Date startDate, Date endDate) {
        try {
            List<RepairerWorkload> workloadList = new ArrayList<>();

            // 获取所有维修人员
            List<DormRepairer> repairers = repairerMapper.selectDormRepairerList(new DormRepairer());

            for (DormRepairer repairer : repairers) {
                RepairerWorkload workload = new RepairerWorkload();
                workload.setRepairerId(repairer.getRepairerId());
                workload.setRepairerName(repairer.getName());

                // 查询该维修人员的派单记录
                DormRepairAssignment queryAssignment = new DormRepairAssignment();
                queryAssignment.setRepairerId(repairer.getRepairerId());
                List<DormRepairAssignment> assignments = assignmentMapper.selectDormRepairAssignmentList(queryAssignment);

                // 过滤时间范围
                List<DormRepairAssignment> filteredAssignments = assignments.stream()
                        .filter(assignment -> assignment.getAssignTime() != null &&
                                !assignment.getAssignTime().before(startDate) &&
                                !assignment.getAssignTime().after(endDate))
                        .collect(Collectors.toList());

                workload.setAssignedCount(filteredAssignments.size());

                long completedCount = filteredAssignments.stream()
                        .filter(assignment -> "2".equals(assignment.getProcessStatus()))
                        .count();
                workload.setCompletedCount((int) completedCount);

                long rejectedCount = filteredAssignments.stream()
                        .filter(assignment -> "3".equals(assignment.getProcessStatus()))
                        .count();
                workload.setRejectedCount((int) rejectedCount);

                // 计算完成率
                if (workload.getAssignedCount() > 0) {
                    workload.setCompletionRate((double) completedCount / workload.getAssignedCount() * 100);
                }

                // 计算平均响应时间
                double avgResponseTime = filteredAssignments.stream()
                        .filter(assignment -> assignment.getAcceptTime() != null && assignment.getAssignTime() != null)
                        .mapToLong(assignment -> assignment.getAcceptTime().getTime() - assignment.getAssignTime().getTime())
                        .average()
                        .orElse(0.0);
                workload.setAverageResponseTime(avgResponseTime / (1000 * 60)); // 转换为分钟

                workloadList.add(workload);
            }

            return workloadList;

        } catch (Exception e) {
            logger.error("获取维修人员工作量统计失败", e);
            return new ArrayList<>();
        }
    }

    /**
     * 获取派单失败分析
     */
    @Override
    public List<DispatchFailureAnalysis> getDispatchFailureAnalysis(Date startDate, Date endDate) {
        try {
            // 查询失败的派单记录
            DormRepairAssignment queryAssignment = new DormRepairAssignment();
            queryAssignment.setProcessStatus("3"); // 已拒绝
            List<DormRepairAssignment> failedAssignments = assignmentMapper.selectDormRepairAssignmentList(queryAssignment);

            // 过滤时间范围
            List<DormRepairAssignment> filteredAssignments = failedAssignments.stream()
                    .filter(assignment -> assignment.getRejectTime() != null &&
                            !assignment.getRejectTime().before(startDate) &&
                            !assignment.getRejectTime().after(endDate))
                    .collect(Collectors.toList());

            // 按拒绝原因分组统计
            Map<String, Long> reasonCountMap = filteredAssignments.stream()
                    .collect(Collectors.groupingBy(
                            assignment -> assignment.getRejectReason() != null ? assignment.getRejectReason() : "未知原因",
                            Collectors.counting()
                    ));

            List<DispatchFailureAnalysis> analysisList = new ArrayList<>();
            int totalFailures = filteredAssignments.size();

            for (Map.Entry<String, Long> entry : reasonCountMap.entrySet()) {
                DispatchFailureAnalysis analysis = new DispatchFailureAnalysis();
                analysis.setFailureReason(entry.getKey());
                analysis.setFailureCount(entry.getValue().intValue());
                
                if (totalFailures > 0) {
                    analysis.setFailureRate((double) entry.getValue() / totalFailures * 100);
                }
                
                analysisList.add(analysis);
            }

            // 按失败次数降序排列
            analysisList.sort((a, b) -> Integer.compare(b.getFailureCount(), a.getFailureCount()));

            return analysisList;

        } catch (Exception e) {
            logger.error("获取派单失败分析失败", e);
            return new ArrayList<>();
        }
    }

    /**
     * 获取实时派单状态
     */
    @Override
    public RealTimeDispatchStatus getRealTimeDispatchStatus() {
        try {
            RealTimeDispatchStatus status = new RealTimeDispatchStatus();

            // 统计待派单数量
            DormRepairRequest pendingQuery = new DormRepairRequest();
            pendingQuery.setStatus("0"); // 待派单
            List<DormRepairRequest> pendingRequests = repairRequestMapper.selectDormRepairRequestList(pendingQuery);
            status.setPendingDispatchCount(pendingRequests.size());

            // 统计处理中数量
            DormRepairAssignment processingQuery = new DormRepairAssignment();
            processingQuery.setProcessStatus("1"); // 处理中
            List<DormRepairAssignment> processingAssignments = assignmentMapper.selectDormRepairAssignmentList(processingQuery);
            status.setProcessingCount(processingAssignments.size());

            // 统计等待人工派单数量
            DormRepairRequest manualQuery = new DormRepairRequest();
            manualQuery.setStatus("5"); // 等待人工派单
            List<DormRepairRequest> manualRequests = repairRequestMapper.selectDormRepairRequestList(manualQuery);
            status.setManualDispatchCount(manualRequests.size());

            // 统计维修人员状态
            DormRepairer availableQuery = new DormRepairer();
            availableQuery.setStatus("1"); // 空闲
            List<DormRepairer> availableRepairers = repairerMapper.selectDormRepairerList(availableQuery);
            status.setAvailableRepairerCount(availableRepairers.size());

            DormRepairer workingQuery = new DormRepairer();
            workingQuery.setStatus("0"); // 出工
            List<DormRepairer> workingRepairers = repairerMapper.selectDormRepairerList(workingQuery);
            status.setWorkingRepairerCount(workingRepairers.size());

            return status;

        } catch (Exception e) {
            logger.error("获取实时派单状态失败", e);
            return new RealTimeDispatchStatus();
        }
    }

    /**
     * 检查系统健康状态
     */
    @Override
    public SystemHealthStatus checkSystemHealth() {
        try {
            SystemHealthStatus healthStatus = new SystemHealthStatus();
            Map<String, Object> healthChecks = new HashMap<>();
            List<String> warnings = new ArrayList<>();
            List<String> errors = new ArrayList<>();

            // 检查数据库连接
            try {
                repairRequestMapper.selectDormRepairRequestList(new DormRepairRequest());
                healthChecks.put("database", "HEALTHY");
            } catch (Exception e) {
                healthChecks.put("database", "ERROR");
                errors.add("数据库连接异常：" + e.getMessage());
            }

            // 检查Redis连接
            try {
                redisTemplate.opsForValue().get("health_check");
                healthChecks.put("redis", "HEALTHY");
            } catch (Exception e) {
                healthChecks.put("redis", "ERROR");
                errors.add("Redis连接异常：" + e.getMessage());
            }

            // 检查待派单积压情况
            RealTimeDispatchStatus dispatchStatus = getRealTimeDispatchStatus();
            if (dispatchStatus.getPendingDispatchCount() > 10) {
                warnings.add("待派单数量过多：" + dispatchStatus.getPendingDispatchCount());
            }

            if (dispatchStatus.getManualDispatchCount() > 5) {
                warnings.add("等待人工派单数量过多：" + dispatchStatus.getManualDispatchCount());
            }

            if (dispatchStatus.getAvailableRepairerCount() == 0) {
                errors.add("没有可用的维修人员");
            }

            // 确定整体健康状态
            if (!errors.isEmpty()) {
                healthStatus.setStatus("ERROR");
            } else if (!warnings.isEmpty()) {
                healthStatus.setStatus("WARNING");
            } else {
                healthStatus.setStatus("HEALTHY");
            }

            healthStatus.setHealthChecks(healthChecks);
            healthStatus.setWarnings(warnings);
            healthStatus.setErrors(errors);

            return healthStatus;

        } catch (Exception e) {
            logger.error("检查系统健康状态失败", e);
            SystemHealthStatus errorStatus = new SystemHealthStatus();
            errorStatus.setStatus("ERROR");
            errorStatus.setErrors(Arrays.asList("系统健康检查失败：" + e.getMessage()));
            return errorStatus;
        }
    }

    /**
     * 获取派单效率趋势
     */
    @Override
    public List<DispatchEfficiencyTrend> getDispatchEfficiencyTrend(int days) {
        try {
            List<DispatchEfficiencyTrend> trendList = new ArrayList<>();

            Calendar calendar = Calendar.getInstance();
            for (int i = days - 1; i >= 0; i--) {
                calendar.setTime(new Date());
                calendar.add(Calendar.DAY_OF_MONTH, -i);
                calendar.set(Calendar.HOUR_OF_DAY, 0);
                calendar.set(Calendar.MINUTE, 0);
                calendar.set(Calendar.SECOND, 0);
                calendar.set(Calendar.MILLISECOND, 0);
                Date startDate = calendar.getTime();

                calendar.add(Calendar.DAY_OF_MONTH, 1);
                Date endDate = calendar.getTime();

                DispatchStatistics dayStats = getDispatchStatistics(startDate, endDate);

                DispatchEfficiencyTrend trend = new DispatchEfficiencyTrend();
                trend.setDate(startDate);
                trend.setDispatchCount(dayStats.getTotalDispatches());
                trend.setSuccessRate(dayStats.getSuccessRate());
                trend.setAverageResponseTime(dayStats.getAverageResponseTime());

                trendList.add(trend);
            }

            return trendList;

        } catch (Exception e) {
            logger.error("获取派单效率趋势失败", e);
            return new ArrayList<>();
        }
    }
}
