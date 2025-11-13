package com.dorm.framework.rabbitmq.message;

/**
 * 系统日志消息
 * 
 * @author 王新瑜
 */
public class SystemLogMessage extends BaseMessage {

    private static final long serialVersionUID = 1L;

    /**
     * 操作模块
     */
    private String module;

    /**
     * 业务类型
     */
    private String businessType;

    /**
     * 操作类型：0-其它, 1-新增, 2-修改, 3-删除, 4-授权, 5-导出, 6-导入, 7-强退, 8-生成代码, 9-清空数据
     */
    private Integer operType;

    /**
     * 操作人员
     */
    private String operName;

    /**
     * 部门名称
     */
    private String deptName;

    /**
     * 请求URL
     */
    private String operUrl;

    /**
     * 主机地址
     */
    private String operIp;

    /**
     * 操作地点
     */
    private String operLocation;

    /**
     * 请求参数
     */
    private String operParam;

    /**
     * 返回参数
     */
    private String jsonResult;

    /**
     * 操作状态：0-正常, 1-异常
     */
    private Integer status;

    /**
     * 错误消息
     */
    private String errorMsg;

    /**
     * 操作时间
     */
    private String operTime;

    /**
     * 消耗时间
     */
    private Long costTime;

    public SystemLogMessage() {
        super();
    }

    public SystemLogMessage(String source) {
        super(source);
    }

    // ==================== Getter and Setter ====================

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public Integer getOperType() {
        return operType;
    }

    public void setOperType(Integer operType) {
        this.operType = operType;
    }

    public String getOperName() {
        return operName;
    }

    public void setOperName(String operName) {
        this.operName = operName;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getOperUrl() {
        return operUrl;
    }

    public void setOperUrl(String operUrl) {
        this.operUrl = operUrl;
    }

    public String getOperIp() {
        return operIp;
    }

    public void setOperIp(String operIp) {
        this.operIp = operIp;
    }

    public String getOperLocation() {
        return operLocation;
    }

    public void setOperLocation(String operLocation) {
        this.operLocation = operLocation;
    }

    public String getOperParam() {
        return operParam;
    }

    public void setOperParam(String operParam) {
        this.operParam = operParam;
    }

    public String getJsonResult() {
        return jsonResult;
    }

    public void setJsonResult(String jsonResult) {
        this.jsonResult = jsonResult;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public String getOperTime() {
        return operTime;
    }

    public void setOperTime(String operTime) {
        this.operTime = operTime;
    }

    public Long getCostTime() {
        return costTime;
    }

    public void setCostTime(Long costTime) {
        this.costTime = costTime;
    }

    @Override
    public String toString() {
        return "SystemLogMessage{" +
                "module='" + module + '\'' +
                ", businessType='" + businessType + '\'' +
                ", operType=" + operType +
                ", operName='" + operName + '\'' +
                ", deptName='" + deptName + '\'' +
                ", operUrl='" + operUrl + '\'' +
                ", operIp='" + operIp + '\'' +
                ", operLocation='" + operLocation + '\'' +
                ", operParam='" + operParam + '\'' +
                ", jsonResult='" + jsonResult + '\'' +
                ", status=" + status +
                ", errorMsg='" + errorMsg + '\'' +
                ", operTime='" + operTime + '\'' +
                ", costTime=" + costTime +
                "} " + super.toString();
    }
}
