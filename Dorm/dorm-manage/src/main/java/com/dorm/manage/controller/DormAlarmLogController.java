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
import com.dorm.manage.domain.DormAlarmLog;
import com.dorm.manage.service.IDormAlarmLogService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;

/**
 * 报警记录Controller
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
@RestController
@RequestMapping("/dorm/alarms")
public class DormAlarmLogController extends BaseController
{
    @Autowired
    private IDormAlarmLogService dormAlarmLogService;

    /**
     * 查询报警记录列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:alarms:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormAlarmLog dormAlarmLog)
    {
        startPage();
        List<DormAlarmLog> list = dormAlarmLogService.selectDormAlarmLogList(dormAlarmLog);
        return getDataTable(list);
    }

    /**
     * 导出报警记录列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:alarms:export')")
    @Log(title = "报警记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormAlarmLog dormAlarmLog)
    {
        List<DormAlarmLog> list = dormAlarmLogService.selectDormAlarmLogList(dormAlarmLog);
        ExcelUtil<DormAlarmLog> util = new ExcelUtil<DormAlarmLog>(DormAlarmLog.class);
        util.exportExcel(response, list, "报警记录数据");
    }

    /**
     * 获取报警记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:alarms:query')")
    @GetMapping(value = "/{alarmId}")
    public AjaxResult getInfo(@PathVariable("alarmId") Long alarmId)
    {
        return success(dormAlarmLogService.selectDormAlarmLogByAlarmId(alarmId));
    }

    /**
     * 新增报警记录
     */
    @PreAuthorize("@ss.hasPermi('dorm:alarms:add')")
    @Log(title = "报警记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormAlarmLog dormAlarmLog)
    {
        return toAjax(dormAlarmLogService.insertDormAlarmLog(dormAlarmLog));
    }

    /**
     * 修改报警记录
     */
    @PreAuthorize("@ss.hasPermi('dorm:alarms:edit')")
    @Log(title = "报警记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormAlarmLog dormAlarmLog)
    {
        return toAjax(dormAlarmLogService.updateDormAlarmLog(dormAlarmLog));
    }

    /**
     * 删除报警记录
     */
    @PreAuthorize("@ss.hasPermi('dorm:alarms:remove')")
    @Log(title = "报警记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{alarmIds}")
    public AjaxResult remove(@PathVariable Long[] alarmIds)
    {
        return toAjax(dormAlarmLogService.deleteDormAlarmLogByAlarmIds(alarmIds));
    }
}
