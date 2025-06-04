package com.dorm.manage.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.dorm.common.annotation.Log;
import com.dorm.common.constant.UserConstants;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.core.domain.TreeSelect;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.StringUtils;
import com.dorm.common.core.domain.entity.DormBuilding;
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
     * 查询宿舍树结构信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:list')")
    @GetMapping("/treeselect")
    public AjaxResult treeselect(DormBuilding dormBuilding)
    {
        List<TreeSelect> dorms = dormBuildingService.selectDormTreeList(dormBuilding);
        return success(dorms);
    }

    /**
     * 查询宿舍列表（排除节点）
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:list')")
    @GetMapping("/list/exclude/{dormId}")
    public AjaxResult excludeChild(@PathVariable(value = "dormId", required = false) Long dormId)
    {
        List<DormBuilding> dorms = dormBuildingService.selectDormBuildingList(new DormBuilding());
        dorms.removeIf(d -> d.getDormId().intValue() == dormId || ArrayUtils.contains(StringUtils.split(d.getAncestors(), ","), dormId + ""));
        return success(dorms);
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
    public AjaxResult add(@Validated @RequestBody DormBuilding dormBuilding)
    {
        if (!dormBuildingService.checkDormNameUnique(dormBuilding))
        {
            return error("新增宿舍'" + dormBuilding.getBuildingName() + "'失败，宿舍名称已存在");
        }
        dormBuilding.setCreateBy(getUsername());
        return toAjax(dormBuildingService.insertDormBuilding(dormBuilding));
    }

    /**
     * 修改宿舍管理
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:edit')")
    @Log(title = "宿舍管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody DormBuilding dormBuilding)
    {
        Long dormId = dormBuilding.getDormId();
        if (!dormBuildingService.checkDormNameUnique(dormBuilding))
        {
            return error("修改宿舍'" + dormBuilding.getBuildingName() + "'失败，宿舍名称已存在");
        }
        else if (dormBuilding.getParentId().equals(dormId))
        {
            return error("修改宿舍'" + dormBuilding.getBuildingName() + "'失败，上级宿舍不能是自己");
        }
        else if (StringUtils.equals(UserConstants.DEPT_DISABLE, dormBuilding.getStatus()) && dormBuildingService.selectNormalChildrenDormById(dormId) > 0)
        {
            return error("该宿舍包含未停用的子宿舍！");
        }
        dormBuilding.setUpdateBy(getUsername());
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
        for (Long dormId : dormIds)
        {
            if (dormBuildingService.hasChildByDormId(dormId))
            {
                return warn("存在下级宿舍,不允许删除");
            }
            if (dormBuildingService.checkDormExistUser(dormId))
            {
                return warn("宿舍存在用户,不允许删除");
            }
        }
        return toAjax(dormBuildingService.deleteDormBuildingByDormIds(dormIds));
    }
}
