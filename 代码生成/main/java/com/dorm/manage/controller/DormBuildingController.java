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
import com.dorm.manage.domain.DormBuilding;
import com.dorm.manage.service.IDormBuildingService;
import com.dorm.common.utils.poi.ExcelUtil;

/**
 * 宿舍管理Controller
 * 
 * @author 王新瑜
 * @date 2025-06-03
 */
@RestController
@RequestMapping("/dorm/building")
public class DormBuildingController extends BaseController
{
    @Autowired
    private IDormBuildingService dormBuildingService;

    /**
     * 查询宿舍管理列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:list')")
    @GetMapping("/list")
    public AjaxResult list(DormBuilding dormBuilding)
    {
        List<DormBuilding> list = dormBuildingService.selectDormBuildingList(dormBuilding);
        return success(list);
    }

    /**
     * 导出宿舍管理列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:export')")
    @Log(title = "宿舍管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormBuilding dormBuilding)
    {
        List<DormBuilding> list = dormBuildingService.selectDormBuildingList(dormBuilding);
        ExcelUtil<DormBuilding> util = new ExcelUtil<DormBuilding>(DormBuilding.class);
        util.exportExcel(response, list, "宿舍管理数据");
    }

    /**
     * 获取宿舍管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:query')")
    @GetMapping(value = "/{dormId}")
    public AjaxResult getInfo(@PathVariable("dormId") Long dormId)
    {
        return success(dormBuildingService.selectDormBuildingByDormId(dormId));
    }

    /**
     * 新增宿舍管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:add')")
    @Log(title = "宿舍管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormBuilding dormBuilding)
    {
        return toAjax(dormBuildingService.insertDormBuilding(dormBuilding));
    }

    /**
     * 修改宿舍管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:edit')")
    @Log(title = "宿舍管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormBuilding dormBuilding)
    {
        return toAjax(dormBuildingService.updateDormBuilding(dormBuilding));
    }

    /**
     * 删除宿舍管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:remove')")
    @Log(title = "宿舍管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{dormIds}")
    public AjaxResult remove(@PathVariable Long[] dormIds)
    {
        return toAjax(dormBuildingService.deleteDormBuildingByDormIds(dormIds));
    }
}
