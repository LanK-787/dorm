package com.dorm.manage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dorm.common.core.domain.entity.DormBuilding;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.manage.domain.DormStudent;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.domain.DormStudentLeave;
import com.dorm.manage.domain.DormNotice;
import com.dorm.manage.service.IDormBuildingService;
import com.dorm.manage.service.IDormStudentService;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.IDormStudentLeaveService;
import com.dorm.manage.service.IDormNoticeService;

/**
 * 首页数据大屏Controller
 * 
 * @author 王新瑜
 * @date 2025-06-20
 */
@RestController
@RequestMapping("/dashboard")
public class DashboardController extends BaseController
{
    @Autowired
    private IDormBuildingService dormBuildingService;

    @Autowired
    private IDormStudentService dormStudentService;

    @Autowired
    private IDormRepairRequestService dormRepairRequestService;

    @Autowired
    private IDormStudentLeaveService dormStudentLeaveService;

    @Autowired
    private IDormNoticeService dormNoticeService;

    /**
     * 获取首页统计数据
     */
    @GetMapping("/statistics")
    public AjaxResult getDashboardStatistics()
    {
        try {
            Map<String, Object> result = new HashMap<>();
            
            // 宿舍统计数据
            Map<String, Object> dormStats = getDormStatistics();
            result.put("dormStatistics", dormStats);
            
            // 学生统计数据
            Map<String, Object> studentStats = getStudentStatistics();
            result.put("studentStatistics", studentStats);
            
            // 维修工单统计数据
            Map<String, Object> repairStats = getRepairStatistics();
            result.put("repairStatistics", repairStats);
            
            // 请假申请统计数据
            Map<String, Object> leaveStats = getLeaveStatistics();
            result.put("leaveStatistics", leaveStats);
            
            // 公告统计数据
            Map<String, Object> noticeStats = getNoticeStatistics();
            result.put("noticeStatistics", noticeStats);
            
            return success(result);
        } catch (Exception e) {
            return error("获取首页统计数据失败：" + e.getMessage());
        }
    }

    /**
     * 获取宿舍统计数据
     */
    private Map<String, Object> getDormStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        List<DormBuilding> allDorms = dormBuildingService.selectDormBuildingList(new DormBuilding());
        
        // 统计总宿舍数（只统计房间级别的宿舍）
        long totalRooms = allDorms.stream()
            .filter(dorm -> dorm.getMaxCapacity() != null && dorm.getMaxCapacity() > 0)
            .count();
        
        // 统计总床位数
        int totalBeds = allDorms.stream()
            .filter(dorm -> dorm.getMaxCapacity() != null)
            .mapToInt(dorm -> dorm.getMaxCapacity())
            .sum();
        
        // 统计已入住床位数
        int occupiedBeds = allDorms.stream()
            .filter(dorm -> dorm.getCurrentCount() != null)
            .mapToInt(dorm -> dorm.getCurrentCount())
            .sum();
        
        // 统计空闲床位数
        int availableBeds = totalBeds - occupiedBeds;
        
        // 计算入住率
        double occupancyRate = totalBeds > 0 ? (double) occupiedBeds / totalBeds * 100 : 0;
        
        // 统计满员宿舍数
        long fullRooms = allDorms.stream()
            .filter(dorm -> "1".equals(dorm.getStatus()))
            .count();
        
        statistics.put("totalRooms", totalRooms);
        statistics.put("totalBeds", totalBeds);
        statistics.put("occupiedBeds", occupiedBeds);
        statistics.put("availableBeds", availableBeds);
        statistics.put("occupancyRate", Math.round(occupancyRate * 100.0) / 100.0);
        statistics.put("fullRooms", fullRooms);
        
        return statistics;
    }

    /**
     * 获取学生统计数据
     */
    private Map<String, Object> getStudentStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        List<DormStudent> allStudents = dormStudentService.selectDormStudentList(new DormStudent());
        
        // 统计总学生数
        int totalStudents = allStudents.size();
        
        // 统计在校学生数
        long inSchoolStudents = allStudents.stream()
            .filter(student -> "0".equals(student.getStatus()))
            .count();
        
        // 统计男女学生数
        long maleStudents = allStudents.stream()
            .filter(student -> "0".equals(student.getGender()))
            .count();
        
        long femaleStudents = allStudents.stream()
            .filter(student -> "1".equals(student.getGender()))
            .count();
        
        // 统计已分配宿舍的学生数
        long assignedStudents = allStudents.stream()
            .filter(student -> student.getDormId() != null)
            .count();
        
        statistics.put("totalStudents", totalStudents);
        statistics.put("inSchoolStudents", inSchoolStudents);
        statistics.put("maleStudents", maleStudents);
        statistics.put("femaleStudents", femaleStudents);
        statistics.put("assignedStudents", assignedStudents);
        
        return statistics;
    }

    /**
     * 获取维修工单统计数据
     */
    private Map<String, Object> getRepairStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        List<DormRepairRequest> allRequests = dormRepairRequestService.selectDormRepairRequestList(new DormRepairRequest());
        
        // 统计总工单数
        int totalRequests = allRequests.size();
        
        // 按状态统计工单数量
        long pendingRequests = allRequests.stream()
            .filter(request -> "0".equals(request.getStatus()))
            .count();
        
        long inProgressRequests = allRequests.stream()
            .filter(request -> "2".equals(request.getStatus()))
            .count();
        
        long completedRequests = allRequests.stream()
            .filter(request -> "3".equals(request.getStatus()))
            .count();
        
        statistics.put("totalRequests", totalRequests);
        statistics.put("pendingRequests", pendingRequests);
        statistics.put("inProgressRequests", inProgressRequests);
        statistics.put("completedRequests", completedRequests);
        
        return statistics;
    }

    /**
     * 获取请假申请统计数据
     */
    private Map<String, Object> getLeaveStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        List<DormStudentLeave> allLeaves = dormStudentLeaveService.selectDormStudentLeaveList(new DormStudentLeave());
        
        // 统计总申请数
        int totalLeaves = allLeaves.size();
        
        // 按审批状态统计
        long pendingApproval = allLeaves.stream()
            .filter(leave -> "0".equals(leave.getApproveStatus()))
            .count();
        
        long approvedLeaves = allLeaves.stream()
            .filter(leave -> "1".equals(leave.getApproveStatus()))
            .count();
        
        // 按离校状态统计
        long awayStudents = allLeaves.stream()
            .filter(leave -> "0".equals(leave.getStatus()))
            .count();
        
        statistics.put("totalLeaves", totalLeaves);
        statistics.put("pendingApproval", pendingApproval);
        statistics.put("approvedLeaves", approvedLeaves);
        statistics.put("awayStudents", awayStudents);
        
        return statistics;
    }

    /**
     * 获取公告统计数据
     */
    private Map<String, Object> getNoticeStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        List<DormNotice> allNotices = dormNoticeService.selectDormNoticeList(new DormNotice());
        
        // 统计总公告数
        int totalNotices = allNotices.size();
        
        // 统计轮播图公告数
        long carouselNotices = allNotices.stream()
            .filter(notice -> "1".equals(notice.getIsCarousel()))
            .count();
        
        // 按类型统计
        long announcements = allNotices.stream()
            .filter(notice -> "0".equals(notice.getNoticeType()))
            .count();
        
        long notifications = allNotices.stream()
            .filter(notice -> "1".equals(notice.getNoticeType()))
            .count();
        
        long activities = allNotices.stream()
            .filter(notice -> "2".equals(notice.getNoticeType()))
            .count();
        
        statistics.put("totalNotices", totalNotices);
        statistics.put("carouselNotices", carouselNotices);
        statistics.put("announcements", announcements);
        statistics.put("notifications", notifications);
        statistics.put("activities", activities);
        
        return statistics;
    }
}
