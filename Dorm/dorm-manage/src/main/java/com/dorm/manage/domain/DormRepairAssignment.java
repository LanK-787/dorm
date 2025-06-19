package com.dorm.manage.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 工单分配对象 dorm_repair_assignment
 *
 * @author 王新瑜
 * @date 2025-06-18
 */
public class DormRepairAssignment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 分配ID */
    private Long assignmentId;

    /** 工单ID */
    @Excel(name = "工单ID")
    private Long requestId;

    /** 工单编号 */
    @Excel(name = "工单编号")
    private String requestNo;

    /** 维修人员ID */
    @Excel(name = "维修人员ID")
    private Long repairerId;

    /** 维修人员姓名 */
    @Excel(name = "维修人员姓名")
    private String repairerName;

    /** 维修项目（0电工，1水工，2木工，3水泥工） */
    @Excel(name = "维修项目", readConverterExp = "0=电工，1水工，2木工，3水泥工")
    private String specialty;

    /** 分配时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "分配时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date assignTime;

    /** 处理状态（0-待接单，1-处理中，2-已完成，3-已拒绝） */
    @Excel(name = "处理状态", readConverterExp = "0=-待接单，1-处理中，2-已完成，3-已拒绝")
    private String processStatus;

    /** 接单时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "接单时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date acceptTime;

    /** 完成时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "完成时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date completeTime;

    /** 拒绝时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "拒绝时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date rejectTime;

    /** 拒绝原因 */
    @Excel(name = "拒绝原因")
    private String rejectReason;

    /** 图片URL，多个以逗号分隔，用于完成维修后图片上传 */
    @Excel(name = "图片URL，多个以逗号分隔，用于完成维修后图片上传")
    private String images;

    /** 处理备注 */
    @Excel(name = "处理备注")
    private String processRemark;

    /** 工单描述（关联查询字段，不存储在数据库） */
    private String description;

    /** 报修人（关联查询字段，不存储在数据库） */
    private String reporterName;

    /** 联系方式（关联查询字段，不存储在数据库） */
    private String contactPhone;

    /** 工单状态（关联查询字段，不存储在数据库） */
    private String requestStatus;

    /** 宿舍完整名称（关联查询字段，不存储在数据库） */
    private String dormName;

    public void setAssignmentId(Long assignmentId)
    {
        this.assignmentId = assignmentId;
    }

    public Long getAssignmentId()
    {
        return assignmentId;
    }

    public void setRequestId(Long requestId)
    {
        this.requestId = requestId;
    }

    public Long getRequestId()
    {
        return requestId;
    }

    public void setRequestNo(String requestNo)
    {
        this.requestNo = requestNo;
    }

    public String getRequestNo()
    {
        return requestNo;
    }

    public void setRepairerId(Long repairerId)
    {
        this.repairerId = repairerId;
    }

    public Long getRepairerId()
    {
        return repairerId;
    }

    public void setRepairerName(String repairerName)
    {
        this.repairerName = repairerName;
    }

    public String getRepairerName()
    {
        return repairerName;
    }

    public void setSpecialty(String specialty)
    {
        this.specialty = specialty;
    }

    public String getSpecialty()
    {
        return specialty;
    }

    public void setAssignTime(Date assignTime)
    {
        this.assignTime = assignTime;
    }

    public Date getAssignTime()
    {
        return assignTime;
    }

    public void setProcessStatus(String processStatus)
    {
        this.processStatus = processStatus;
    }

    public String getProcessStatus()
    {
        return processStatus;
    }

    public void setAcceptTime(Date acceptTime)
    {
        this.acceptTime = acceptTime;
    }

    public Date getAcceptTime()
    {
        return acceptTime;
    }

    public void setCompleteTime(Date completeTime)
    {
        this.completeTime = completeTime;
    }

    public Date getCompleteTime()
    {
        return completeTime;
    }

    public void setRejectTime(Date rejectTime)
    {
        this.rejectTime = rejectTime;
    }

    public Date getRejectTime()
    {
        return rejectTime;
    }

    public void setRejectReason(String rejectReason)
    {
        this.rejectReason = rejectReason;
    }

    public String getRejectReason()
    {
        return rejectReason;
    }

    public void setImages(String images)
    {
        this.images = images;
    }

    public String getImages()
    {
        return images;
    }

    public void setProcessRemark(String processRemark)
    {
        this.processRemark = processRemark;
    }

    public String getProcessRemark()
    {
        return processRemark;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getDescription()
    {
        return description;
    }

    public void setReporterName(String reporterName)
    {
        this.reporterName = reporterName;
    }

    public String getReporterName()
    {
        return reporterName;
    }

    public void setContactPhone(String contactPhone)
    {
        this.contactPhone = contactPhone;
    }

    public String getContactPhone()
    {
        return contactPhone;
    }

    public void setRequestStatus(String requestStatus)
    {
        this.requestStatus = requestStatus;
    }

    public String getRequestStatus()
    {
        return requestStatus;
    }

    public void setDormName(String dormName)
    {
        this.dormName = dormName;
    }

    public String getDormName()
    {
        return dormName;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
                .append("assignmentId", getAssignmentId())
                .append("requestId", getRequestId())
                .append("requestNo", getRequestNo())
                .append("repairerId", getRepairerId())
                .append("repairerName", getRepairerName())
                .append("specialty", getSpecialty())
                .append("assignTime", getAssignTime())
                .append("processStatus", getProcessStatus())
                .append("acceptTime", getAcceptTime())
                .append("completeTime", getCompleteTime())
                .append("rejectTime", getRejectTime())
                .append("rejectReason", getRejectReason())
                .append("images", getImages())
                .append("processRemark", getProcessRemark())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .toString();
    }
}
