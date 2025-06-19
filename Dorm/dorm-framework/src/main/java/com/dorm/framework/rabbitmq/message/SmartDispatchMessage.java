package com.dorm.framework.rabbitmq.message;

import java.util.List;

/**
 * 智能派单消息
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public class SmartDispatchMessage extends BaseMessage {

    /** 工单ID */
    private Long requestId;
    
    /** 工单编号 */
    private String requestNo;
    
    /** 维修项目 */
    private String specialty;
    
    /** 派单类型（AUTO-自动派单，RETRY-重新派单） */
    private String dispatchType;
    
    /** 排除的维修人员ID列表（重新派单时使用） */
    private List<Long> excludeRepairerIds;
    
    /** 延时时间（毫秒，用于延时派单） */
    private Long delayTime;

    public SmartDispatchMessage() {
        super();
    }

    public SmartDispatchMessage(Long requestId, String requestNo, String specialty, String dispatchType) {
        super();
        this.requestId = requestId;
        this.requestNo = requestNo;
        this.specialty = specialty;
        this.dispatchType = dispatchType;
    }

    public Long getRequestId() {
        return requestId;
    }

    public void setRequestId(Long requestId) {
        this.requestId = requestId;
    }

    public String getRequestNo() {
        return requestNo;
    }

    public void setRequestNo(String requestNo) {
        this.requestNo = requestNo;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getDispatchType() {
        return dispatchType;
    }

    public void setDispatchType(String dispatchType) {
        this.dispatchType = dispatchType;
    }

    public List<Long> getExcludeRepairerIds() {
        return excludeRepairerIds;
    }

    public void setExcludeRepairerIds(List<Long> excludeRepairerIds) {
        this.excludeRepairerIds = excludeRepairerIds;
    }

    public Long getDelayTime() {
        return delayTime;
    }

    public void setDelayTime(Long delayTime) {
        this.delayTime = delayTime;
    }

    @Override
    public String toString() {
        return "SmartDispatchMessage{" +
                "requestId=" + requestId +
                ", requestNo='" + requestNo + '\'' +
                ", specialty='" + specialty + '\'' +
                ", dispatchType='" + dispatchType + '\'' +
                ", excludeRepairerIds=" + excludeRepairerIds +
                ", delayTime=" + delayTime +
                ", messageId='" + getMessageId() + '\'' +
                ", createTime=" + getCreateTime() +
                '}';
    }
}
