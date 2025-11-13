package com.dorm.framework.rabbitmq.message;

/**
 * 维修工单消息
 * 
 * @author 王新瑜
 */
public class RepairOrderMessage extends BaseMessage {

    private static final long serialVersionUID = 1L;

    /**
     * 工单ID
     */
    private Long orderId;

    /**
     * 工单编号
     */
    private String orderNo;

    /**
     * 操作类型：CREATE-创建, UPDATE-更新, ASSIGN-分配, COMPLETE-完成, CANCEL-取消
     */
    private String operationType;

    /**
     * 工单状态
     */
    private String orderStatus;

    /**
     * 维修人员ID
     */
    private Long repairerId;

    /**
     * 维修人员姓名
     */
    private String repairerName;

    /**
     * 申请人ID
     */
    private Long applicantId;

    /**
     * 申请人姓名
     */
    private String applicantName;

    /**
     * 宿舍ID
     */
    private Long dormId;

    /**
     * 宿舍号
     */
    private String dormNo;

    /**
     * 故障描述
     */
    private String faultDescription;

    /**
     * 紧急程度：1-低, 2-中, 3-高, 4-紧急
     */
    private Integer urgencyLevel;

    /**
     * 备注信息
     */
    private String remark;

    public RepairOrderMessage() {
        super();
    }

    public RepairOrderMessage(String source) {
        super(source);
    }

    // ==================== Getter and Setter ====================

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
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

    public Long getApplicantId() {
        return applicantId;
    }

    public void setApplicantId(Long applicantId) {
        this.applicantId = applicantId;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public Long getDormId() {
        return dormId;
    }

    public void setDormId(Long dormId) {
        this.dormId = dormId;
    }

    public String getDormNo() {
        return dormNo;
    }

    public void setDormNo(String dormNo) {
        this.dormNo = dormNo;
    }

    public String getFaultDescription() {
        return faultDescription;
    }

    public void setFaultDescription(String faultDescription) {
        this.faultDescription = faultDescription;
    }

    public Integer getUrgencyLevel() {
        return urgencyLevel;
    }

    public void setUrgencyLevel(Integer urgencyLevel) {
        this.urgencyLevel = urgencyLevel;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    @Override
    public String toString() {
        return "RepairOrderMessage{" +
                "orderId=" + orderId +
                ", orderNo='" + orderNo + '\'' +
                ", operationType='" + operationType + '\'' +
                ", orderStatus='" + orderStatus + '\'' +
                ", repairerId=" + repairerId +
                ", repairerName='" + repairerName + '\'' +
                ", applicantId=" + applicantId +
                ", applicantName='" + applicantName + '\'' +
                ", dormId=" + dormId +
                ", dormNo='" + dormNo + '\'' +
                ", faultDescription='" + faultDescription + '\'' +
                ", urgencyLevel=" + urgencyLevel +
                ", remark='" + remark + '\'' +
                "} " + super.toString();
    }
}
