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
import com.dorm.manage.domain.DormAlarmDevice;
import com.dorm.manage.service.IDormAlarmDeviceService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;

/**
 * 设备管理Controller
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
@RestController
@RequestMapping("/dorm/device")
public class DormAlarmDeviceController extends BaseController
{
    @Autowired
    private IDormAlarmDeviceService dormAlarmDeviceService;

    /**
     * 查询设备管理列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:device:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormAlarmDevice dormAlarmDevice)
    {
        startPage();
        List<DormAlarmDevice> list = dormAlarmDeviceService.selectDormAlarmDeviceList(dormAlarmDevice);
        return getDataTable(list);
    }

    /**
     * 导出设备管理列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:device:export')")
    @Log(title = "设备管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormAlarmDevice dormAlarmDevice)
    {
        List<DormAlarmDevice> list = dormAlarmDeviceService.selectDormAlarmDeviceList(dormAlarmDevice);
        ExcelUtil<DormAlarmDevice> util = new ExcelUtil<DormAlarmDevice>(DormAlarmDevice.class);
        util.exportExcel(response, list, "设备管理数据");
    }

    /**
     * 获取设备管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:device:query')")
    @GetMapping(value = "/{deviceId}")
    public AjaxResult getInfo(@PathVariable("deviceId") Long deviceId)
    {
        return success(dormAlarmDeviceService.selectDormAlarmDeviceByDeviceId(deviceId));
    }

    /**
     * 新增设备管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:device:add')")
    @Log(title = "设备管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormAlarmDevice dormAlarmDevice)
    {
        return toAjax(dormAlarmDeviceService.insertDormAlarmDevice(dormAlarmDevice));
    }

    /**
     * 修改设备管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:device:edit')")
    @Log(title = "设备管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormAlarmDevice dormAlarmDevice)
    {
        return toAjax(dormAlarmDeviceService.updateDormAlarmDevice(dormAlarmDevice));
    }

    /**
     * 删除设备管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:device:remove')")
    @Log(title = "设备管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{deviceIds}")
    public AjaxResult remove(@PathVariable Long[] deviceIds)
    {
        return toAjax(dormAlarmDeviceService.deleteDormAlarmDeviceByDeviceIds(deviceIds));
    }
}
