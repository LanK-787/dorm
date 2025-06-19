package com.dorm.manage.controller;

import java.util.List;
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
}
