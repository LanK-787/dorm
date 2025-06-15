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
import com.dorm.manage.domain.DormNoticeLike;
import com.dorm.manage.service.IDormNoticeLikeService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;
import com.dorm.common.utils.SecurityUtils;

/**
 * 公告点赞记录Controller
 * 
 * @author 王新瑜
 * @date 2025-06-14
 */
@RestController
@RequestMapping("/dorm/noticeLike")
public class DormNoticeLikeController extends BaseController
{
    @Autowired
    private IDormNoticeLikeService dormNoticeLikeService;

    /**
     * 查询公告点赞记录列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:noticeLike:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormNoticeLike dormNoticeLike)
    {
        startPage();
        List<DormNoticeLike> list = dormNoticeLikeService.selectDormNoticeLikeList(dormNoticeLike);
        return getDataTable(list);
    }

    /**
     * 导出公告点赞记录列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:noticeLike:export')")
    @Log(title = "公告点赞记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormNoticeLike dormNoticeLike)
    {
        List<DormNoticeLike> list = dormNoticeLikeService.selectDormNoticeLikeList(dormNoticeLike);
        ExcelUtil<DormNoticeLike> util = new ExcelUtil<DormNoticeLike>(DormNoticeLike.class);
        util.exportExcel(response, list, "公告点赞记录数据");
    }

    /**
     * 获取公告点赞记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:noticeLike:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(dormNoticeLikeService.selectDormNoticeLikeById(id));
    }

    /**
     * 新增公告点赞记录
     */
    @PreAuthorize("@ss.hasPermi('dorm:noticeLike:add')")
    @Log(title = "公告点赞记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormNoticeLike dormNoticeLike)
    {
        return toAjax(dormNoticeLikeService.insertDormNoticeLike(dormNoticeLike));
    }

    /**
     * 修改公告点赞记录
     */
    @PreAuthorize("@ss.hasPermi('dorm:noticeLike:edit')")
    @Log(title = "公告点赞记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormNoticeLike dormNoticeLike)
    {
        return toAjax(dormNoticeLikeService.updateDormNoticeLike(dormNoticeLike));
    }

    /**
     * 删除公告点赞记录
     */
    @PreAuthorize("@ss.hasPermi('dorm:noticeLike:remove')")
    @Log(title = "公告点赞记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(dormNoticeLikeService.deleteDormNoticeLikeByIds(ids));
    }

    /**
     * 点赞/取消点赞公告
     */
    @Log(title = "公告点赞", businessType = BusinessType.UPDATE)
    @PostMapping("/toggle/{noticeId}")
    public AjaxResult toggleLike(@PathVariable Long noticeId)
    {
        try {
            Long userId = SecurityUtils.getUserId();
            boolean isLiked = dormNoticeLikeService.toggleLike(noticeId, userId);
            
            if (isLiked) {
                return success("点赞成功");
            } else {
                return success("取消点赞成功");
            }
        } catch (Exception e) {
            logger.error("点赞操作失败", e);
            return error("操作失败：" + e.getMessage());
        }
    }

    /**
     * 查询用户是否已点赞
     */
    @GetMapping("/isLiked/{noticeId}")
    public AjaxResult isUserLiked(@PathVariable Long noticeId)
    {
        try {
            Long userId = SecurityUtils.getUserId();
            boolean isLiked = dormNoticeLikeService.isUserLiked(noticeId, userId);
            return success(isLiked);
        } catch (Exception e) {
            logger.error("查询点赞状态失败", e);
            return error("查询失败：" + e.getMessage());
        }
    }

    /**
     * 获取公告点赞数量
     */
    @GetMapping("/count/{noticeId}")
    public AjaxResult getLikeCount(@PathVariable Long noticeId)
    {
        try {
            int likeCount = dormNoticeLikeService.getLikeCount(noticeId);
            return success(likeCount);
        } catch (Exception e) {
            logger.error("获取点赞数量失败", e);
            return error("获取失败：" + e.getMessage());
        }
    }
}
