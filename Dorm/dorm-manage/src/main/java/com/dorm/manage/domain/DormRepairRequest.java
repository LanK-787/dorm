package com.dorm.manage.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 报修工单对象 dorm_repair_request
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public class DormRepairRequest extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 工单ID */
    private Long requestId;

    /** 工单编号 */
    @Excel(name = "工单编号")
    private String requestNo;

    /** 报修学生ID */
    @Excel(name = "报修学生ID")
    private Long studentId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 宿舍ID */
    @Excel(name = "宿舍ID")
    private Long dormId;

    /** 报修项目（0电工，1水工，2木工，3水泥工） */
    @Excel(name = "报修项目", readConverterExp = "0=电工，1水工，2木工，3水泥工")
    private String specialty;

    /** 问题描述 */
    @Excel(name = "问题描述")
    private String description;

    /** 报修人 */
    @Excel(name = "报修人")
    private String reporterName;

    /** 联系方式 */
    @Excel(name = "联系方式")
    private String contactPhone;

    /** 图片URL，多个以逗号分隔 */
    @Excel(name = "图片URL，多个以逗号分隔")
    private String images;

    /** 状态（0-待派单，1-已派单，2-维修中，3-已完成，4-已取消，5-等待人工派单） */
    @Excel(name = "状态", readConverterExp = "0=待派单,1=已派单,2=维修中,3=已完成,4=已取消,5=等待人工派单")
    private String status;

    /** 派单尝试次数 */
    @Excel(name = "派单尝试次数")
    private Integer attemptCount;

    /** 宿舍完整名称（关联查询字段，不存储在数据库） */
    private String dormName;

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

    public void setStudentId(Long studentId) 
    {
        this.studentId = studentId;
    }

    public Long getStudentId()
    {
        return studentId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setDormId(Long dormId)
    {
        this.dormId = dormId;
    }

    public Long getDormId() 
    {
        return dormId;
    }

    public void setSpecialty(String specialty) 
    {
        this.specialty = specialty;
    }

    public String getSpecialty() 
    {
        return specialty;
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

    public void setImages(String images) 
    {
        this.images = images;
    }

    public String getImages() 
    {
        return images;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus()
    {
        return status;
    }

    public void setDormName(String dormName)
    {
        this.dormName = dormName;
    }

    public String getDormName()
    {
        return dormName;
    }

    public void setAttemptCount(Integer attemptCount)
    {
        this.attemptCount = attemptCount;
    }

    public Integer getAttemptCount()
    {
        return attemptCount;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("requestId", getRequestId())
            .append("requestNo", getRequestNo())
            .append("studentId", getStudentId())
            .append("userId", getUserId())
            .append("dormId", getDormId())
            .append("specialty", getSpecialty())
            .append("description", getDescription())
            .append("reporterName", getReporterName())
            .append("contactPhone", getContactPhone())
            .append("images", getImages())
            .append("status", getStatus())
            .append("attemptCount", getAttemptCount())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
