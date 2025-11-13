package com.dorm.manage.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 派单历史记录对象 dorm_repair_dispatch_history
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public class DormRepairDispatchHistory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 历史记录ID */
    private Long historyId;

    /** 工单ID */
    @Excel(name = "工单ID")
    private Long requestId;

    /** 工单编号 */
    @Excel(name = "工单编号")
    private String requestNo;

    /** 维修项目 */
    @Excel(name = "维修项目", readConverterExp = "0=电工，1=水工，2=木工，3=水泥工")
    private String specialty;

    /** 派单类型 */
    @Excel(name = "派单类型", readConverterExp = "AUTO=自动派单,MANUAL=人工派单,RETRY=重新派单")
    private String dispatchType;

    /** 选中的维修人员ID */
    @Excel(name = "选中的维修人员ID")
    private Long selectedRepairerId;

    /** 选中的维修人员姓名 */
    @Excel(name = "选中的维修人员姓名")
    private String selectedRepairerName;

    /** 候选维修人员数量 */
    @Excel(name = "候选维修人员数量")
    private Integer candidateCount;

    /** 派单结果 */
    @Excel(name = "派单结果", readConverterExp = "SUCCESS=成功,FAILED=失败")
    private String dispatchResult;

    /** 失败原因 */
    @Excel(name = "失败原因")
    private String failureReason;

    /** 派单时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "派单时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date dispatchTime;

    public void setHistoryId(Long historyId) 
    {
        this.historyId = historyId;
    }

    public Long getHistoryId() 
    {
        return historyId;
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

    public void setSpecialty(String specialty) 
    {
        this.specialty = specialty;
    }

    public String getSpecialty() 
    {
        return specialty;
    }

    public void setDispatchType(String dispatchType) 
    {
        this.dispatchType = dispatchType;
    }

    public String getDispatchType() 
    {
        return dispatchType;
    }

    public void setSelectedRepairerId(Long selectedRepairerId) 
    {
        this.selectedRepairerId = selectedRepairerId;
    }

    public Long getSelectedRepairerId() 
    {
        return selectedRepairerId;
    }

    public void setSelectedRepairerName(String selectedRepairerName) 
    {
        this.selectedRepairerName = selectedRepairerName;
    }

    public String getSelectedRepairerName() 
    {
        return selectedRepairerName;
    }

    public void setCandidateCount(Integer candidateCount) 
    {
        this.candidateCount = candidateCount;
    }

    public Integer getCandidateCount() 
    {
        return candidateCount;
    }

    public void setDispatchResult(String dispatchResult) 
    {
        this.dispatchResult = dispatchResult;
    }

    public String getDispatchResult() 
    {
        return dispatchResult;
    }

    public void setFailureReason(String failureReason) 
    {
        this.failureReason = failureReason;
    }

    public String getFailureReason() 
    {
        return failureReason;
    }

    public void setDispatchTime(Date dispatchTime) 
    {
        this.dispatchTime = dispatchTime;
    }

    public Date getDispatchTime() 
    {
        return dispatchTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("historyId", getHistoryId())
            .append("requestId", getRequestId())
            .append("requestNo", getRequestNo())
            .append("specialty", getSpecialty())
            .append("dispatchType", getDispatchType())
            .append("selectedRepairerId", getSelectedRepairerId())
            .append("selectedRepairerName", getSelectedRepairerName())
            .append("candidateCount", getCandidateCount())
            .append("dispatchResult", getDispatchResult())
            .append("failureReason", getFailureReason())
            .append("dispatchTime", getDispatchTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .toString();
    }
}
