package com.dorm.manage.controller;

import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.manage.service.IDispatchMonitorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

/**
 * 派单监控Controller
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/dorm/monitor")
public class DispatchMonitorController extends BaseController
{
    @Autowired
    private IDispatchMonitorService dispatchMonitorService;

    /**
     * 获取派单统计数据
     */
    @PreAuthorize("@ss.hasPermi('dorm:monitor:statistics')")
    @GetMapping("/statistics")
    public AjaxResult getDispatchStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate)
    {
        IDispatchMonitorService.DispatchStatistics statistics = 
            dispatchMonitorService.getDispatchStatistics(startDate, endDate);
        return AjaxResult.success(statistics);
    }

    /**
     * 获取维修人员工作量统计
     */
    @PreAuthorize("@ss.hasPermi('dorm:monitor:workload')")
    @GetMapping("/workload")
    public AjaxResult getRepairerWorkloadStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate)
    {
        List<IDispatchMonitorService.RepairerWorkload> workloadList = 
            dispatchMonitorService.getRepairerWorkloadStatistics(startDate, endDate);
        return AjaxResult.success(workloadList);
    }

    /**
     * 获取派单失败分析
     */
    @PreAuthorize("@ss.hasPermi('dorm:monitor:failure')")
    @GetMapping("/failure-analysis")
    public AjaxResult getDispatchFailureAnalysis(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate)
    {
        List<IDispatchMonitorService.DispatchFailureAnalysis> analysisList = 
            dispatchMonitorService.getDispatchFailureAnalysis(startDate, endDate);
        return AjaxResult.success(analysisList);
    }

    /**
     * 获取实时派单状态
     */
    @PreAuthorize("@ss.hasPermi('dorm:monitor:realtime')")
    @GetMapping("/realtime-status")
    public AjaxResult getRealTimeDispatchStatus()
    {
        IDispatchMonitorService.RealTimeDispatchStatus status = 
            dispatchMonitorService.getRealTimeDispatchStatus();
        return AjaxResult.success(status);
    }

    /**
     * 检查系统健康状态
     */
    @PreAuthorize("@ss.hasPermi('dorm:monitor:health')")
    @GetMapping("/health")
    public AjaxResult checkSystemHealth()
    {
        IDispatchMonitorService.SystemHealthStatus healthStatus = 
            dispatchMonitorService.checkSystemHealth();
        return AjaxResult.success(healthStatus);
    }

    /**
     * 获取派单效率趋势
     */
    @PreAuthorize("@ss.hasPermi('dorm:monitor:trend')")
    @GetMapping("/efficiency-trend")
    public AjaxResult getDispatchEfficiencyTrend(@RequestParam(defaultValue = "7") int days)
    {
        if (days < 1 || days > 30) {
            return AjaxResult.error("天数范围应在1-30之间");
        }
        
        List<IDispatchMonitorService.DispatchEfficiencyTrend> trendList = 
            dispatchMonitorService.getDispatchEfficiencyTrend(days);
        return AjaxResult.success(trendList);
    }

    /**
     * 获取监控仪表板数据
     */
    @PreAuthorize("@ss.hasPermi('dorm:monitor:dashboard')")
    @GetMapping("/dashboard")
    public AjaxResult getDashboardData()
    {
        // 获取实时状态
        IDispatchMonitorService.RealTimeDispatchStatus realtimeStatus = 
            dispatchMonitorService.getRealTimeDispatchStatus();

        // 获取系统健康状态
        IDispatchMonitorService.SystemHealthStatus healthStatus = 
            dispatchMonitorService.checkSystemHealth();

        // 获取最近7天的效率趋势
        List<IDispatchMonitorService.DispatchEfficiencyTrend> trendList = 
            dispatchMonitorService.getDispatchEfficiencyTrend(7);

        // 获取今日统计数据
        Date today = new Date();
        Date startOfDay = new Date(today.getTime() - today.getTime() % (24 * 60 * 60 * 1000));
        IDispatchMonitorService.DispatchStatistics todayStats = 
            dispatchMonitorService.getDispatchStatistics(startOfDay, today);

        // 组装仪表板数据
        DashboardData dashboardData = new DashboardData();
        dashboardData.setRealtimeStatus(realtimeStatus);
        dashboardData.setHealthStatus(healthStatus);
        dashboardData.setEfficiencyTrend(trendList);
        dashboardData.setTodayStatistics(todayStats);

        return AjaxResult.success(dashboardData);
    }

    /**
     * 仪表板数据类
     */
    public static class DashboardData {
        /** 实时状态 */
        private IDispatchMonitorService.RealTimeDispatchStatus realtimeStatus;
        
        /** 健康状态 */
        private IDispatchMonitorService.SystemHealthStatus healthStatus;
        
        /** 效率趋势 */
        private List<IDispatchMonitorService.DispatchEfficiencyTrend> efficiencyTrend;
        
        /** 今日统计 */
        private IDispatchMonitorService.DispatchStatistics todayStatistics;

        public IDispatchMonitorService.RealTimeDispatchStatus getRealtimeStatus() {
            return realtimeStatus;
        }

        public void setRealtimeStatus(IDispatchMonitorService.RealTimeDispatchStatus realtimeStatus) {
            this.realtimeStatus = realtimeStatus;
        }

        public IDispatchMonitorService.SystemHealthStatus getHealthStatus() {
            return healthStatus;
        }

        public void setHealthStatus(IDispatchMonitorService.SystemHealthStatus healthStatus) {
            this.healthStatus = healthStatus;
        }

        public List<IDispatchMonitorService.DispatchEfficiencyTrend> getEfficiencyTrend() {
            return efficiencyTrend;
        }

        public void setEfficiencyTrend(List<IDispatchMonitorService.DispatchEfficiencyTrend> efficiencyTrend) {
            this.efficiencyTrend = efficiencyTrend;
        }

        public IDispatchMonitorService.DispatchStatistics getTodayStatistics() {
            return todayStatistics;
        }

        public void setTodayStatistics(IDispatchMonitorService.DispatchStatistics todayStatistics) {
            this.todayStatistics = todayStatistics;
        }
    }
}
