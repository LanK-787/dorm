package com.dorm.manage.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 宿舍公告对象 dorm_notice
 * 
 * @author 王新瑜
 * @date 2025-06-06
 */
public class DormNotice extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 公告ID（主键） */
    private Long noticeId;

    /** 公告标题 */
    @Excel(name = "公告标题")
    private String noticeTitle;

    /** 公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动） */
    @Excel(name = "公告类型", readConverterExp = "0=全校公告,1=楼栋公告,2=全校通知,3=楼栋通知,4=全校活动,5=楼栋活动")
    private String noticeType;

    /** 公告内容（支持HTML/富文本） */
    @Excel(name = "公告内容", readConverterExp = "支=持HTML/富文本")
    private String noticeContent;

    /** 状态（0草稿 1已发布 2撤回） */
    @Excel(name = "状态", readConverterExp = "0=草稿,1=已发布,2=撤回")
    private String status;

    public void setNoticeId(Long noticeId) 
    {
        this.noticeId = noticeId;
    }

    public Long getNoticeId() 
    {
        return noticeId;
    }

    public void setNoticeTitle(String noticeTitle) 
    {
        this.noticeTitle = noticeTitle;
    }

    public String getNoticeTitle() 
    {
        return noticeTitle;
    }

    public void setNoticeType(String noticeType) 
    {
        this.noticeType = noticeType;
    }

    public String getNoticeType() 
    {
        return noticeType;
    }

    public void setNoticeContent(String noticeContent) 
    {
        this.noticeContent = noticeContent;
    }

    public String getNoticeContent() 
    {
        return noticeContent;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("noticeId", getNoticeId())
            .append("noticeTitle", getNoticeTitle())
            .append("noticeType", getNoticeType())
            .append("noticeContent", getNoticeContent())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
