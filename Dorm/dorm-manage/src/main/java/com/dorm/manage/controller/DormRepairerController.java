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
import com.dorm.manage.domain.DormRepairer;
import com.dorm.manage.service.IDormRepairerService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;

/**
 * 维修人员管理Controller
 * 
 * @author 王新瑜
 * @date 2025-06-17
 */
@RestController
@RequestMapping("/manage/repairer")
public class DormRepairerController extends BaseController
{
    @Autowired
    private IDormRepairerService dormRepairerService;

    /**
     * 查询维修人员管理列表
     */
    @PreAuthorize("@ss.hasPermi('manage:repairer:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormRepairer dormRepairer)
    {
        startPage();
        List<DormRepairer> list = dormRepairerService.selectDormRepairerList(dormRepairer);
        return getDataTable(list);
    }

    /**
     * 导出维修人员管理列表
     */
    @PreAuthorize("@ss.hasPermi('manage:repairer:export')")
    @Log(title = "维修人员管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormRepairer dormRepairer)
    {
        List<DormRepairer> list = dormRepairerService.selectDormRepairerList(dormRepairer);
        ExcelUtil<DormRepairer> util = new ExcelUtil<DormRepairer>(DormRepairer.class);
        util.exportExcel(response, list, "维修人员管理数据");
    }

    /**
     * 获取维修人员管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('manage:repairer:query')")
    @GetMapping(value = "/{repairerId}")
    public AjaxResult getInfo(@PathVariable("repairerId") Long repairerId)
    {
        return success(dormRepairerService.selectDormRepairerByRepairerId(repairerId));
    }

    /**
     * 根据用户ID获取维修人员信息
     */
    @GetMapping(value = "/user/{userId}")
    public AjaxResult getInfoByUserId(@PathVariable("userId") Long userId)
    {
        return success(dormRepairerService.selectDormRepairerByUserId(userId));
    }

    /**
     * 新增维修人员管理
     */
    @PreAuthorize("@ss.hasPermi('manage:repairer:add')")
    @Log(title = "维修人员管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormRepairer dormRepairer)
    {
        return toAjax(dormRepairerService.insertDormRepairer(dormRepairer));
    }

    /**
     * 修改维修人员管理
     */
    @PreAuthorize("@ss.hasPermi('manage:repairer:edit')")
    @Log(title = "维修人员管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormRepairer dormRepairer)
    {
        return toAjax(dormRepairerService.updateDormRepairer(dormRepairer));
    }

    /**
     * 删除维修人员管理
     */
    @PreAuthorize("@ss.hasPermi('manage:repairer:remove')")
    @Log(title = "维修人员管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{repairerIds}")
    public AjaxResult remove(@PathVariable Long[] repairerIds)
    {
        return toAjax(dormRepairerService.deleteDormRepairerByRepairerIds(repairerIds));
    }
}
