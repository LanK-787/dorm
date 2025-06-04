package com.dorm.manage.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.dorm.common.core.domain.entity.DormBuilding;
import com.dorm.common.core.domain.entity.SysDept;
import com.dorm.manage.service.IDormBuildingService;
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
import com.dorm.manage.domain.DormStudent;
import com.dorm.manage.service.IDormStudentService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;

/**
 * 学生管理Controller
 * 
 * @author 王新瑜
 * @date 2025-06-04
 */
@RestController
@RequestMapping("/dorm/student")
public class DormStudentController extends BaseController
{
    @Autowired
    private IDormStudentService dormStudentService;

    @Autowired
    private IDormBuildingService dormBuildingService;

    /**
     * 查询学生管理列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:student:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormStudent dormStudent)
    {
        startPage();
        List<DormStudent> list = dormStudentService.selectDormStudentList(dormStudent);
        return getDataTable(list);
    }

    /**
     * 导出学生管理列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:student:export')")
    @Log(title = "学生管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormStudent dormStudent)
    {
        List<DormStudent> list = dormStudentService.selectDormStudentList(dormStudent);
        ExcelUtil<DormStudent> util = new ExcelUtil<DormStudent>(DormStudent.class);
        util.exportExcel(response, list, "学生管理数据");
    }

    /**
     * 获取学生管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:student:query')")
    @GetMapping(value = "/{studentId}")
    public AjaxResult getInfo(@PathVariable("studentId") Long studentId)
    {
        return success(dormStudentService.selectDormStudentByStudentId(studentId));
    }

    /**
     * 新增学生管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:student:add')")
    @Log(title = "学生管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormStudent dormStudent)
    {
        return toAjax(dormStudentService.insertDormStudent(dormStudent));
    }

    /**
     * 修改学生管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:student:edit')")
    @Log(title = "学生管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormStudent dormStudent)
    {
        return toAjax(dormStudentService.updateDormStudent(dormStudent));
    }

    /**
     * 删除学生管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:student:remove')")
    @Log(title = "学生管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{studentIds}")
    public AjaxResult remove(@PathVariable Long[] studentIds)
    {
        return toAjax(dormStudentService.deleteDormStudentByStudentIds(studentIds));
    }

    /**
     * 获取宿舍树列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:student:list')")
    @GetMapping("/dormTree")
    public AjaxResult deptTree(DormBuilding dormBuilding)
    {
        return success(dormBuildingService.selectDormTreeList(dormBuilding));
    }

}
