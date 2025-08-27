package com.dorm.manage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.enums.BusinessType;
import com.dorm.manage.domain.DormStudentLeave;
import com.dorm.manage.service.IDormStudentLeaveService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.utils.TypeConvertUtils;
import com.dorm.common.core.page.TableDataInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 学生离校登记Controller
 * 
 * @author 王新瑜
 * @date 2025-06-19
 */
@RestController
@RequestMapping("/dorm/leave")
public class DormStudentLeaveController extends BaseController
{
    private static final Logger logger = LoggerFactory.getLogger(DormStudentLeaveController.class);

    @Autowired
    private IDormStudentLeaveService dormStudentLeaveService;

    /**
     * 查询学生离校登记列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:leave:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormStudentLeave dormStudentLeave)
    {
        startPage();
        List<DormStudentLeave> list = dormStudentLeaveService.selectDormStudentLeaveList(dormStudentLeave);
        return getDataTable(list);
    }

    /**
     * 导出学生离校登记列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:leave:export')")
    @Log(title = "学生离校登记", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormStudentLeave dormStudentLeave)
    {
        List<DormStudentLeave> list = dormStudentLeaveService.selectDormStudentLeaveList(dormStudentLeave);
        ExcelUtil<DormStudentLeave> util = new ExcelUtil<DormStudentLeave>(DormStudentLeave.class);
        util.exportExcel(response, list, "学生离校登记数据");
    }

    /**
     * 获取学生离校登记详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:leave:query')")
    @GetMapping(value = "/{leaveId}")
    public AjaxResult getInfo(@PathVariable("leaveId") Long leaveId)
    {
        return success(dormStudentLeaveService.selectDormStudentLeaveByLeaveId(leaveId));
    }

    /**
     * 新增学生离校登记
     */
    @PreAuthorize("@ss.hasPermi('dorm:leave:add')")
    @Log(title = "学生离校登记", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormStudentLeave dormStudentLeave)
    {
        return toAjax(dormStudentLeaveService.insertDormStudentLeave(dormStudentLeave));
    }

    /**
     * 修改学生离校登记
     */
    @PreAuthorize("@ss.hasPermi('dorm:leave:edit')")
    @Log(title = "学生离校登记", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormStudentLeave dormStudentLeave)
    {
        return toAjax(dormStudentLeaveService.updateDormStudentLeave(dormStudentLeave));
    }

    /**
     * 删除学生离校登记
     */
    @PreAuthorize("@ss.hasPermi('dorm:leave:remove')")
    @Log(title = "学生离校登记", businessType = BusinessType.DELETE)
	@DeleteMapping("/{leaveIds}")
    public AjaxResult remove(@PathVariable Long[] leaveIds)
    {
        return toAjax(dormStudentLeaveService.deleteDormStudentLeaveByLeaveIds(leaveIds));
    }

    /**
     * 取消离校申请
     */
    @Log(title = "取消离校申请", businessType = BusinessType.UPDATE)
    @PutMapping("/cancel/{leaveId}")
    public AjaxResult cancelLeaveApplication(@PathVariable Long leaveId)
    {
        try {
            DormStudentLeave leave = dormStudentLeaveService.selectDormStudentLeaveByLeaveId(leaveId);
            if (leave == null) {
                return error("离校申请不存在");
            }

            // 只有待审批状态才能取消
            if (!"0".equals(leave.getApproveStatus())) {
                return error("只有待审批状态的申请才能取消");
            }

            // 更新状态为已取消
            leave.setApproveStatus("3");
            leave.setApproveTime(new java.util.Date());
            leave.setApproveRemark("用户主动取消申请");

            return toAjax(dormStudentLeaveService.updateDormStudentLeave(leave));
        } catch (Exception e) {
            logger.error("取消离校申请失败", e);
            return error("取消申请失败：" + e.getMessage());
        }
    }

    /**
     * 确认返校
     */
    @Log(title = "确认返校", businessType = BusinessType.UPDATE)
    @PutMapping("/return/{leaveId}")
    public AjaxResult confirmReturn(@PathVariable Long leaveId)
    {
        try {
            DormStudentLeave leave = dormStudentLeaveService.selectDormStudentLeaveByLeaveId(leaveId);
            if (leave == null) {
                return error("离校申请不存在");
            }

            // 只有已批准且离校中的状态才能确认返校
            if (!"1".equals(leave.getApproveStatus()) || !"0".equals(leave.getStatus())) {
                return error("只有已批准且离校中的申请才能确认返校");
            }

            // 更新状态为已返校
            leave.setStatus("1");
            leave.setActualReturnTime(new java.util.Date());

            return toAjax(dormStudentLeaveService.updateDormStudentLeave(leave));
        } catch (Exception e) {
            logger.error("确认返校失败", e);
            return error("确认返校失败：" + e.getMessage());
        }
    }

    /**
     * 批准离校申请
     */
    @Log(title = "批准离校申请", businessType = BusinessType.UPDATE)
    @PutMapping("/approve")
    public AjaxResult approveLeaveApplication(@RequestBody DormStudentLeave leave)
    {
        try {
            DormStudentLeave existingLeave = dormStudentLeaveService.selectDormStudentLeaveByLeaveId(leave.getLeaveId());
            if (existingLeave == null) {
                return error("离校申请不存在");
            }

            // 只有待审批状态才能批准
            if (!"0".equals(existingLeave.getApproveStatus())) {
                return error("只有待审批状态的申请才能批准");
            }

            // 更新审批信息
            existingLeave.setApproveStatus("1"); // 已批准
            existingLeave.setApprover(leave.getApprover());
            existingLeave.setApproveTime(new java.util.Date());
            existingLeave.setApproveRemark(leave.getApproveRemark());

            return toAjax(dormStudentLeaveService.updateDormStudentLeave(existingLeave));
        } catch (Exception e) {
            logger.error("批准离校申请失败", e);
            return error("批准申请失败：" + e.getMessage());
        }
    }

    /**
     * 拒绝离校申请
     */
    @Log(title = "拒绝离校申请", businessType = BusinessType.UPDATE)
    @PutMapping("/reject")
    public AjaxResult rejectLeaveApplication(@RequestBody DormStudentLeave leave)
    {
        try {
            DormStudentLeave existingLeave = dormStudentLeaveService.selectDormStudentLeaveByLeaveId(leave.getLeaveId());
            if (existingLeave == null) {
                return error("离校申请不存在");
            }

            // 只有待审批状态才能拒绝
            if (!"0".equals(existingLeave.getApproveStatus())) {
                return error("只有待审批状态的申请才能拒绝");
            }

            // 更新审批信息
            existingLeave.setApproveStatus("2"); // 已拒绝
            existingLeave.setApprover(leave.getApprover());
            existingLeave.setApproveTime(new java.util.Date());
            existingLeave.setApproveRemark(leave.getApproveRemark());

            return toAjax(dormStudentLeaveService.updateDormStudentLeave(existingLeave));
        } catch (Exception e) {
            logger.error("拒绝离校申请失败", e);
            return error("拒绝申请失败：" + e.getMessage());
        }
    }

    /**
     * 批量审批离校申请
     */
    @Log(title = "批量审批离校申请", businessType = BusinessType.UPDATE)
    @PutMapping("/batch-approve")
    public AjaxResult batchApproveLeaveApplication(@RequestBody Map<String, Object> params)
    {
        try {
            // 安全地处理leaveIds类型转换，支持Integer和Long类型
            @SuppressWarnings("unchecked")
            List<Object> rawLeaveIds = (List<Object>) params.get("leaveIds");
            List<Long> leaveIds = TypeConvertUtils.convertToLongList(rawLeaveIds);

            String approveStatus = (String) params.get("approveStatus");
            String approver = (String) params.get("approver");
            String approveRemark = (String) params.get("approveRemark");

            if (leaveIds == null || leaveIds.isEmpty()) {
                return error("请选择要审批的记录");
            }

            if (!"1".equals(approveStatus) && !"2".equals(approveStatus)) {
                return error("审批状态参数错误");
            }

            int successCount = 0;
            int failCount = 0;
            StringBuilder errorMsg = new StringBuilder();

            for (Long leaveId : leaveIds) {
                try {
                    DormStudentLeave leave = dormStudentLeaveService.selectDormStudentLeaveByLeaveId(leaveId);
                    if (leave == null) {
                        failCount++;
                        errorMsg.append("记录[").append(leaveId).append("]不存在；");
                        continue;
                    }

                    // 只有待审批状态才能审批
                    if (!"0".equals(leave.getApproveStatus())) {
                        failCount++;
                        errorMsg.append("记录[").append(leaveId).append("]状态不正确；");
                        continue;
                    }

                    // 更新审批信息
                    leave.setApproveStatus(approveStatus);
                    leave.setApprover(approver);
                    leave.setApproveTime(new java.util.Date());
                    leave.setApproveRemark(approveRemark);

                    int result = dormStudentLeaveService.updateDormStudentLeave(leave);
                    if (result > 0) {
                        successCount++;
                    } else {
                        failCount++;
                        errorMsg.append("记录[").append(leaveId).append("]更新失败；");
                    }
                } catch (Exception e) {
                    failCount++;
                    errorMsg.append("记录[").append(leaveId).append("]处理异常；");
                    logger.error("批量审批记录[{}]失败", leaveId, e);
                }
            }

            String resultMsg = String.format("批量审批完成：成功%d条，失败%d条", successCount, failCount);
            if (failCount > 0) {
                resultMsg += "。失败原因：" + errorMsg.toString();
            }

            if (successCount > 0) {
                return success(resultMsg);
            } else {
                return error(resultMsg);
            }
        } catch (Exception e) {
            logger.error("批量审批离校申请失败", e);
            return error("批量审批失败：" + e.getMessage());
        }
    }

    /**
     * 获取请假申请统计数据
     */
    @GetMapping("/statistics")
    public AjaxResult getLeaveStatistics()
    {
        try {
            Map<String, Object> statistics = new HashMap<>();

            // 获取所有请假申请数据
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

            long rejectedLeaves = allLeaves.stream()
                .filter(leave -> "2".equals(leave.getApproveStatus()))
                .count();

            long cancelledLeaves = allLeaves.stream()
                .filter(leave -> "3".equals(leave.getApproveStatus()))
                .count();

            // 按离校状态统计
            long awayStudents = allLeaves.stream()
                .filter(leave -> "0".equals(leave.getStatus()))
                .count();

            long returnedStudents = allLeaves.stream()
                .filter(leave -> "1".equals(leave.getStatus()))
                .count();

            long overdueStudents = allLeaves.stream()
                .filter(leave -> "2".equals(leave.getStatus()))
                .count();

            statistics.put("totalLeaves", totalLeaves);
            statistics.put("pendingApproval", pendingApproval);
            statistics.put("approvedLeaves", approvedLeaves);
            statistics.put("rejectedLeaves", rejectedLeaves);
            statistics.put("cancelledLeaves", cancelledLeaves);
            statistics.put("awayStudents", awayStudents);
            statistics.put("returnedStudents", returnedStudents);
            statistics.put("overdueStudents", overdueStudents);

            return success(statistics);
        } catch (Exception e) {
            logger.error("获取请假申请统计数据失败", e);
            return error("获取请假申请统计数据失败：" + e.getMessage());
        }
    }
}
