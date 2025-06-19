package com.dorm.manage.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 学生离校登记对象 dorm_student_leave
 * 
 * @author 王新瑜
 * @date 2025-06-19
 */
public class DormStudentLeave extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 离校记录ID */
    private Long leaveId;

    /** 学号 */
    @Excel(name = "学号")
    private Long studentNo;

    /** 离校时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "离校时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date leaveTime;

    /** 预计返校时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "预计返校时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date expectedReturnTime;

    /** 实际返校时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "实际返校时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date actualReturnTime;

    /** 离校原因 */
    @Excel(name = "离校原因")
    private String leaveReason;

    /** 目的地 */
    @Excel(name = "目的地")
    private String destination;

    /** 离校期间联系电话 */
    @Excel(name = "离校期间联系电话")
    private String contactDuringLeave;

    /** 紧急联系人 */
    @Excel(name = "紧急联系人")
    private String emergencyContact;

    /** 紧急联系人电话 */
    @Excel(name = "紧急联系人电话")
    private String emergencyPhone;

    /** 状态（0-离校中，1-已返校，2-逾期未返） */
    @Excel(name = "状态", readConverterExp = "0=-离校中，1-已返校，2-逾期未返")
    private String status;

    /** 审批人 */
    @Excel(name = "审批人")
    private String approver;

    /** 审批时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "审批时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date approveTime;

    /** 审批状态（0-待审批，1-已批准，2-已拒绝） */
    @Excel(name = "审批状态", readConverterExp = "0=-待审批，1-已批准，2-已拒绝，3-已取消")
    private String approveStatus;

    /** 审批备注 */
    @Excel(name = "审批备注")
    private String approveRemark;

    public void setLeaveId(Long leaveId) 
    {
        this.leaveId = leaveId;
    }

    public Long getLeaveId() 
    {
        return leaveId;
    }

    public void setStudentNo(Long studentNo) 
    {
        this.studentNo = studentNo;
    }

    public Long getStudentNo() 
    {
        return studentNo;
    }

    public void setLeaveTime(Date leaveTime) 
    {
        this.leaveTime = leaveTime;
    }

    public Date getLeaveTime() 
    {
        return leaveTime;
    }

    public void setExpectedReturnTime(Date expectedReturnTime) 
    {
        this.expectedReturnTime = expectedReturnTime;
    }

    public Date getExpectedReturnTime() 
    {
        return expectedReturnTime;
    }

    public void setActualReturnTime(Date actualReturnTime) 
    {
        this.actualReturnTime = actualReturnTime;
    }

    public Date getActualReturnTime() 
    {
        return actualReturnTime;
    }

    public void setLeaveReason(String leaveReason) 
    {
        this.leaveReason = leaveReason;
    }

    public String getLeaveReason() 
    {
        return leaveReason;
    }

    public void setDestination(String destination) 
    {
        this.destination = destination;
    }

    public String getDestination() 
    {
        return destination;
    }

    public void setContactDuringLeave(String contactDuringLeave) 
    {
        this.contactDuringLeave = contactDuringLeave;
    }

    public String getContactDuringLeave()
    {
        return contactDuringLeave;
    }

    public void setEmergencyContact(String emergencyContact)
    {
        this.emergencyContact = emergencyContact;
    }

    public String getEmergencyContact()
    {
        return emergencyContact;
    }

    public void setEmergencyPhone(String emergencyPhone)
    {
        this.emergencyPhone = emergencyPhone;
    }

    public String getEmergencyPhone()
    {
        return emergencyPhone;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setApprover(String approver) 
    {
        this.approver = approver;
    }

    public String getApprover() 
    {
        return approver;
    }

    public void setApproveTime(Date approveTime) 
    {
        this.approveTime = approveTime;
    }

    public Date getApproveTime() 
    {
        return approveTime;
    }

    public void setApproveStatus(String approveStatus) 
    {
        this.approveStatus = approveStatus;
    }

    public String getApproveStatus() 
    {
        return approveStatus;
    }

    public void setApproveRemark(String approveRemark) 
    {
        this.approveRemark = approveRemark;
    }

    public String getApproveRemark() 
    {
        return approveRemark;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("leaveId", getLeaveId())
            .append("studentNo", getStudentNo())
            .append("leaveTime", getLeaveTime())
            .append("expectedReturnTime", getExpectedReturnTime())
            .append("actualReturnTime", getActualReturnTime())
            .append("leaveReason", getLeaveReason())
            .append("destination", getDestination())
            .append("contactDuringLeave", getContactDuringLeave())
            .append("emergencyContact", getEmergencyContact())
            .append("emergencyPhone", getEmergencyPhone())
            .append("status", getStatus())
            .append("approver", getApprover())
            .append("approveTime", getApproveTime())
            .append("approveStatus", getApproveStatus())
            .append("approveRemark", getApproveRemark())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
