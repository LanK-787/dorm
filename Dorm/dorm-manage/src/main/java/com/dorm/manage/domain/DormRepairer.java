package com.dorm.manage.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 维修人员管理对象 dorm_repairer
 * 
 * @author 王新瑜
 * @date 2025-06-17
 */
public class DormRepairer extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 维修人员ID */
    private Long repairerId;

    /** 用户ID */
    private Long userId;

    /** 工号 */
    @Excel(name = "工号")
    private Long repairerNo;

    /** 姓名 */
    @Excel(name = "姓名")
    private String name;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private String phone;

    /** 专长领域（0电工，1水工，2木工，3水泥工） */
    @Excel(name = "专长领域", readConverterExp = "0=电工，1水工，2木工，3水泥工")
    private String specialty;

    /** 状态(0出工,1空闲) */
    @Excel(name = "状态(0出工,1空闲)")
    private String status;

    /** 已接单数量 */
    @Excel(name = "已接单数量")
    private Integer orderCount;

    public void setRepairerId(Long repairerId) 
    {
        this.repairerId = repairerId;
    }

    public Long getRepairerId() 
    {
        return repairerId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setRepairerNo(Long repairerNo) 
    {
        this.repairerNo = repairerNo;
    }

    public Long getRepairerNo() 
    {
        return repairerNo;
    }

    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
    }

    public void setPhone(String phone) 
    {
        this.phone = phone;
    }

    public String getPhone() 
    {
        return phone;
    }

    public void setSpecialty(String specialty) 
    {
        this.specialty = specialty;
    }

    public String getSpecialty() 
    {
        return specialty;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus()
    {
        return status;
    }

    public void setOrderCount(Integer orderCount)
    {
        this.orderCount = orderCount;
    }

    public Integer getOrderCount()
    {
        return orderCount;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("repairerId", getRepairerId())
            .append("userId", getUserId())
            .append("repairerNo", getRepairerNo())
            .append("name", getName())
            .append("phone", getPhone())
            .append("specialty", getSpecialty())
            .append("status", getStatus())
            .append("orderCount", getOrderCount())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
