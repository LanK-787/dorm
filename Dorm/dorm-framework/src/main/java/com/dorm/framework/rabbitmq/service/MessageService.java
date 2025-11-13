package com.dorm.framework.rabbitmq.service;

import com.dorm.framework.rabbitmq.message.RepairOrderMessage;
import com.dorm.framework.rabbitmq.message.SystemLogMessage;
import com.dorm.framework.rabbitmq.message.UserRegisterMessage;

/**
 * 消息服务接口
 * 
 * @author 王新瑜
 */
public interface MessageService {

    /**
     * 发送维修工单创建消息
     * 
     * @param orderId           工单ID
     * @param orderNo           工单编号
     * @param applicantId       申请人ID
     * @param applicantName     申请人姓名
     * @param dormId            宿舍ID
     * @param dormNo            宿舍号
     * @param faultDescription  故障描述
     * @param urgencyLevel      紧急程度
     */
    void sendRepairOrderCreateMessage(Long orderId, String orderNo, Long applicantId, String applicantName,
                                    Long dormId, String dormNo, String faultDescription, Integer urgencyLevel);

    /**
     * 发送维修工单分配消息
     * 
     * @param orderId       工单ID
     * @param orderNo       工单编号
     * @param repairerId    维修人员ID
     * @param repairerName  维修人员姓名
     */
    void sendRepairOrderAssignMessage(Long orderId, String orderNo, Long repairerId, String repairerName);

    /**
     * 发送维修工单完成消息
     * 
     * @param orderId       工单ID
     * @param orderNo       工单编号
     * @param repairerId    维修人员ID
     * @param repairerName  维修人员姓名
     * @param remark        完成备注
     */
    void sendRepairOrderCompleteMessage(Long orderId, String orderNo, Long repairerId, String repairerName, String remark);

    /**
     * 发送用户注册消息
     * 
     * @param userId        用户ID
     * @param userName      用户名
     * @param nickName      昵称
     * @param email         邮箱
     * @param phoneNumber   手机号
     * @param userType      用户类型
     * @param registerIp    注册IP
     */
    void sendUserRegisterMessage(Long userId, String userName, String nickName, String email, 
                               String phoneNumber, String userType, String registerIp);

    /**
     * 发送用户信息更新消息
     * 
     * @param userId        用户ID
     * @param userName      用户名
     * @param nickName      昵称
     * @param email         邮箱
     * @param phoneNumber   手机号
     * @param userType      用户类型
     */
    void sendUserUpdateMessage(Long userId, String userName, String nickName, String email, 
                             String phoneNumber, String userType);

    /**
     * 发送系统日志消息
     * 
     * @param module        操作模块
     * @param businessType  业务类型
     * @param operType      操作类型
     * @param operName      操作人员
     * @param operUrl       请求URL
     * @param operIp        主机地址
     * @param operParam     请求参数
     * @param jsonResult    返回参数
     * @param status        操作状态
     * @param errorMsg      错误消息
     * @param costTime      消耗时间
     */
    void sendSystemLogMessage(String module, String businessType, Integer operType, String operName,
                            String operUrl, String operIp, String operParam, String jsonResult,
                            Integer status, String errorMsg, Long costTime);

    /**
     * 发送通知消息
     * 
     * @param title     通知标题
     * @param content   通知内容
     * @param type      通知类型
     * @param targetId  目标用户ID
     */
    void sendNotificationMessage(String title, String content, String type, Long targetId);
}
