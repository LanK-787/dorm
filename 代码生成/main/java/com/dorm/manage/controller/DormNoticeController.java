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
import com.dorm.manage.domain.DormNotice;
import com.dorm.manage.service.IDormNoticeService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;

/**
 * 宿舍公告Controller
 * 
 * @author 王新瑜
 * @date 2025-06-06
 */
@RestController
@RequestMapping("/dorm/notices")
public class DormNoticeController extends BaseController
{
    @Autowired
    private IDormNoticeService dormNoticeService;

    /**
     * 查询宿舍公告列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:notices:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormNotice dormNotice)
    {
        startPage();
        List<DormNotice> list = dormNoticeService.selectDormNoticeList(dormNotice);
        return getDataTable(list);
    }

    /**
     * 导出宿舍公告列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:notices:export')")
    @Log(title = "宿舍公告", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormNotice dormNotice)
    {
        List<DormNotice> list = dormNoticeService.selectDormNoticeList(dormNotice);
        ExcelUtil<DormNotice> util = new ExcelUtil<DormNotice>(DormNotice.class);
        util.exportExcel(response, list, "宿舍公告数据");
    }

    /**
     * 获取宿舍公告详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:notices:query')")
    @GetMapping(value = "/{noticeId}")
    public AjaxResult getInfo(@PathVariable("noticeId") Long noticeId)
    {
        return success(dormNoticeService.selectDormNoticeByNoticeId(noticeId));
    }

    /**
     * 新增宿舍公告
     */
    @PreAuthorize("@ss.hasPermi('dorm:notices:add')")
    @Log(title = "宿舍公告", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormNotice dormNotice)
    {
        return toAjax(dormNoticeService.insertDormNotice(dormNotice));
    }

    /**
     * 修改宿舍公告
     */
    @PreAuthorize("@ss.hasPermi('dorm:notices:edit')")
    @Log(title = "宿舍公告", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormNotice dormNotice)
    {
        return toAjax(dormNoticeService.updateDormNotice(dormNotice));
    }

    /**
     * 删除宿舍公告
     */
    @PreAuthorize("@ss.hasPermi('dorm:notices:remove')")
    @Log(title = "宿舍公告", businessType = BusinessType.DELETE)
	@DeleteMapping("/{noticeIds}")
    public AjaxResult remove(@PathVariable Long[] noticeIds)
    {
        return toAjax(dormNoticeService.deleteDormNoticeByNoticeIds(noticeIds));
    }
}
