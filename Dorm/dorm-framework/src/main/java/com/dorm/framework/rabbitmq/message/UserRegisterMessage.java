package com.dorm.framework.rabbitmq.message;

/**
 * 用户注册消息
 * 
 * @author dorm
 */
public class UserRegisterMessage extends BaseMessage {

    private static final long serialVersionUID = 1L;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 用户名
     */
    private String userName;

    /**
     * 昵称
     */
    private String nickName;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 手机号
     */
    private String phoneNumber;

    /**
     * 用户类型：student-学生, repairer-维修人员, admin-管理员
     */
    private String userType;

    /**
     * 操作类型：REGISTER-注册, UPDATE-更新, DELETE-删除
     */
    private String operationType;

    /**
     * 注册IP
     */
    private String registerIp;

    /**
     * 用户状态：0-正常, 1-停用
     */
    private String status;

    public UserRegisterMessage() {
        super();
    }

    public UserRegisterMessage(String source) {
        super(source);
    }

    // ==================== Getter and Setter ====================

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType;
    }

    public String getRegisterIp() {
        return registerIp;
    }

    public void setRegisterIp(String registerIp) {
        this.registerIp = registerIp;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "UserRegisterMessage{" +
                "userId=" + userId +
                ", userName='" + userName + '\'' +
                ", nickName='" + nickName + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", userType='" + userType + '\'' +
                ", operationType='" + operationType + '\'' +
                ", registerIp='" + registerIp + '\'' +
                ", status='" + status + '\'' +
                "} " + super.toString();
    }
}
