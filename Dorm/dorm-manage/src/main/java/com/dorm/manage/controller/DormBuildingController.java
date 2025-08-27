package com.dorm.manage.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
            return error("该宿舍包含未空闲的子宿舍！");
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

    /**
     * 批量修复宿舍状态
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:edit')")
    @Log(title = "宿舍管理", businessType = BusinessType.UPDATE)
    @PostMapping("/batchFixStatus")
    public AjaxResult batchFixStatus()
    {
        try {
            int fixedCount = dormBuildingService.batchFixDormStatus();
            if (fixedCount > 0) {
                return success("成功修复 " + fixedCount + " 个宿舍的状态");
            } else {
                return success("所有宿舍状态与容量一致，无需修复");
            }
        } catch (Exception e) {
            return error("批量修复状态失败：" + e.getMessage());
        }
    }

    /**
     * 检查宿舍状态一致性
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:list')")
    @GetMapping("/checkStatusConsistency")
    public AjaxResult checkStatusConsistency()
    {
        try {
            List<DormBuilding> inconsistentDorms = dormBuildingService.getInconsistentStatusDorms();
            if (inconsistentDorms.isEmpty()) {
                return success("所有宿舍状态与容量一致");
            } else {
                // 创建包含消息和数据的结果对象
                Map<String, Object> result = new HashMap<>();
                result.put("message", "发现 " + inconsistentDorms.size() + " 个宿舍状态与容量不一致");
                result.put("inconsistentDorms", inconsistentDorms);
                result.put("count", inconsistentDorms.size());
                return success(result);
            }
        } catch (Exception e) {
            return error("检查状态一致性失败：" + e.getMessage());
        }
    }

    /**
     * 获取宿舍统计数据
     */
    @GetMapping("/statistics")
    public AjaxResult getDormStatistics()
    {
        try {
            Map<String, Object> statistics = new HashMap<>();

            // 获取所有宿舍数据
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

            // 统计空闲宿舍数
            long emptyRooms = allDorms.stream()
                .filter(dorm -> dorm.getCurrentCount() != null && dorm.getCurrentCount() == 0)
                .count();

            statistics.put("totalRooms", totalRooms);
            statistics.put("totalBeds", totalBeds);
            statistics.put("occupiedBeds", occupiedBeds);
            statistics.put("availableBeds", availableBeds);
            statistics.put("occupancyRate", Math.round(occupancyRate * 100.0) / 100.0);
            statistics.put("fullRooms", fullRooms);
            statistics.put("emptyRooms", emptyRooms);

            return success(statistics);
        } catch (Exception e) {
            return error("获取宿舍统计数据失败：" + e.getMessage());
        }
    }

    /**
     * 验证宿舍状态数据一致性
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:list')")
    @GetMapping("/validateStatus")
    public AjaxResult validateStatus()
    {
        try {
            boolean isConsistent = dormBuildingService.validateDormStatusConsistency();
            if (isConsistent) {
                return success("宿舍状态数据一致性验证通过");
            } else {
                return warn("宿舍状态数据存在不一致，建议执行批量修复");
            }
        } catch (Exception e) {
            return error("验证状态一致性失败：" + e.getMessage());
        }
    }

    /**
     * 同步父子节点容量数据
     */
    @PreAuthorize("@ss.hasPermi('dorm:building:edit')")
    @Log(title = "宿舍管理", businessType = BusinessType.UPDATE)
    @PostMapping("/syncCapacity")
    public AjaxResult syncCapacity()
    {
        try {
            // 获取所有有子节点的父节点
            List<DormBuilding> allDorms = dormBuildingService.selectDormBuildingList(new DormBuilding());
            Set<Long> parentIds = new HashSet<>();

            for (DormBuilding dorm : allDorms) {
                if (dorm.getParentId() != null && dorm.getParentId() > 0) {
                    parentIds.add(dorm.getParentId());
                }
            }

            if (parentIds.isEmpty()) {
                return success("没有需要同步的父节点");
            }

            // 批量更新父节点容量
            int updatedCount = dormBuildingService.batchUpdateParentCapacity(new ArrayList<>(parentIds));

            return success("成功同步 " + updatedCount + " 个父节点的容量数据");
        } catch (Exception e) {
            return error("同步容量数据失败：" + e.getMessage());
        }
    }
}
