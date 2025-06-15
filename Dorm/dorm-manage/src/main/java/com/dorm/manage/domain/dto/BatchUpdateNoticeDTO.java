package com.dorm.manage.domain.dto;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 批量更新公告DTO
 *
 * @author 王新瑜
 * @date 2025-06-14
 */
public class BatchUpdateNoticeDTO {

    /** 公告ID列表 */
    @NotEmpty(message = "公告ID列表不能为空")
    private List<Long> noticeIds;

    /** 状态（用于批量修改状态） */
    private String status;

    /** 轮播图显示（用于批量设置轮播图） */
    private String isCarousel;

    public List<Long> getNoticeIds() {
        return noticeIds;
    }

    public void setNoticeIds(List<Long> noticeIds) {
        this.noticeIds = noticeIds;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getIsCarousel() {
        return isCarousel;
    }

    public void setIsCarousel(String isCarousel) {
        this.isCarousel = isCarousel;
    }

    @Override
    public String toString() {
        return "BatchUpdateNoticeDTO{" +
                "noticeIds=" + noticeIds +
                ", status='" + status + '\'' +
                ", isCarousel='" + isCarousel + '\'' +
                '}';
    }
}
