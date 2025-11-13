package com.dorm.framework.rabbitmq.message;

/**
 * 派单状态更新消息
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public class DispatchStatusUpdateMessage extends BaseMessage {

    /** 派单记录ID */
    private Long assignmentId;
    
    /** 工单ID */
    private Long requestId;
    
    /** 工单编号 */
    private String requestNo;
    
    /** 维修人员ID */
    private Long repairerId;
    
    /** 维修人员姓名 */
    private String repairerName;
    
    /** 操作类型（ACCEPT-接受，REJECT-拒绝，COMPLETE-完成） */
    private String operationType;
    
    /** 拒绝原因（拒绝时使用） */
    private String rejectReason;
    
    /** 完成图片（完成时使用） */
    private String completionImages;
    
    /** 处理备注 */
    private String processRemark;

    public DispatchStatusUpdateMessage() {
        super();
    }

    public DispatchStatusUpdateMessage(Long assignmentId, Long requestId, String requestNo, 
                                     Long repairerId, String repairerName, String operationType) {
        super();
        this.assignmentId = assignmentId;
        this.requestId = requestId;
        this.requestNo = requestNo;
        this.repairerId = repairerId;
        this.repairerName = repairerName;
        this.operationType = operationType;
    }

    public Long getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Long assignmentId) {
        this.assignmentId = assignmentId;
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

    public Long getRepairerId() {
        return repairerId;
    }

    public void setRepairerId(Long repairerId) {
        this.repairerId = repairerId;
    }

    public String getRepairerName() {
        return repairerName;
    }

    public void setRepairerName(String repairerName) {
        this.repairerName = repairerName;
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public String getCompletionImages() {
        return completionImages;
    }

    public void setCompletionImages(String completionImages) {
        this.completionImages = completionImages;
    }

    public String getProcessRemark() {
        return processRemark;
    }

    public void setProcessRemark(String processRemark) {
        this.processRemark = processRemark;
    }

    @Override
    public String toString() {
        return "DispatchStatusUpdateMessage{" +
                "assignmentId=" + assignmentId +
                ", requestId=" + requestId +
                ", requestNo='" + requestNo + '\'' +
                ", repairerId=" + repairerId +
                ", repairerName='" + repairerName + '\'' +
                ", operationType='" + operationType + '\'' +
                ", rejectReason='" + rejectReason + '\'' +
                ", completionImages='" + completionImages + '\'' +
                ", processRemark='" + processRemark + '\'' +
                ", messageId='" + getMessageId() + '\'' +
                ", createTime=" + getCreateTime() +
                '}';
    }
}
