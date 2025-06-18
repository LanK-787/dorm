package com.dorm.framework.rabbitmq.service.impl;

import com.dorm.framework.rabbitmq.message.RepairOrderMessage;
import com.dorm.framework.rabbitmq.message.SystemLogMessage;
import com.dorm.framework.rabbitmq.message.UserRegisterMessage;
import com.dorm.framework.rabbitmq.producer.MessageProducer;
import com.dorm.framework.rabbitmq.service.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 消息服务实现类
 * 
 * @author dorm
 */
@Service
public class MessageServiceImpl implements MessageService {

    private static final Logger logger = LoggerFactory.getLogger(MessageServiceImpl.class);

    @Autowired
    private MessageProducer messageProducer;

    @Override
    public void sendRepairOrderCreateMessage(Long orderId, String orderNo, Long applicantId, String applicantName,
                                           Long dormId, String dormNo, String faultDescription, Integer urgencyLevel) {
        try {
            RepairOrderMessage message = new RepairOrderMessage("REPAIR_ORDER_SERVICE");
            message.setOrderId(orderId);
            message.setOrderNo(orderNo);
            message.setOperationType("CREATE");
            message.setOrderStatus("PENDING");
            message.setApplicantId(applicantId);
            message.setApplicantName(applicantName);
            message.setDormId(dormId);
            message.setDormNo(dormNo);
            message.setFaultDescription(faultDescription);
            message.setUrgencyLevel(urgencyLevel);

            messageProducer.sendRepairOrderMessage(message);
            logger.info("发送维修工单创建消息成功: {}", orderNo);
            
        } catch (Exception e) {
            logger.error("发送维修工单创建消息失败: {}, 错误信息: {}", orderNo, e.getMessage(), e);
        }
    }

    @Override
    public void sendRepairOrderAssignMessage(Long orderId, String orderNo, Long repairerId, String repairerName) {
        try {
            RepairOrderMessage message = new RepairOrderMessage("REPAIR_ORDER_SERVICE");
            message.setOrderId(orderId);
            message.setOrderNo(orderNo);
            message.setOperationType("ASSIGN");
            message.setOrderStatus("ASSIGNED");
            message.setRepairerId(repairerId);
            message.setRepairerName(repairerName);

            messageProducer.sendRepairOrderMessage(message);
            logger.info("发送维修工单分配消息成功: {} -> {}", orderNo, repairerName);
            
        } catch (Exception e) {
            logger.error("发送维修工单分配消息失败: {}, 错误信息: {}", orderNo, e.getMessage(), e);
        }
    }

    @Override
    public void sendRepairOrderCompleteMessage(Long orderId, String orderNo, Long repairerId, String repairerName, String remark) {
        try {
            RepairOrderMessage message = new RepairOrderMessage("REPAIR_ORDER_SERVICE");
            message.setOrderId(orderId);
            message.setOrderNo(orderNo);
            message.setOperationType("COMPLETE");
            message.setOrderStatus("COMPLETED");
            message.setRepairerId(repairerId);
            message.setRepairerName(repairerName);
            message.setRemark(remark);

            messageProducer.sendRepairOrderMessage(message);
            logger.info("发送维修工单完成消息成功: {} by {}", orderNo, repairerName);
            
        } catch (Exception e) {
            logger.error("发送维修工单完成消息失败: {}, 错误信息: {}", orderNo, e.getMessage(), e);
        }
    }

    @Override
    public void sendUserRegisterMessage(Long userId, String userName, String nickName, String email, 
                                      String phoneNumber, String userType, String registerIp) {
        try {
            UserRegisterMessage message = new UserRegisterMessage("USER_SERVICE");
            message.setUserId(userId);
            message.setUserName(userName);
            message.setNickName(nickName);
            message.setEmail(email);
            message.setPhoneNumber(phoneNumber);
            message.setUserType(userType);
            message.setOperationType("REGISTER");
            message.setRegisterIp(registerIp);
            message.setStatus("0");

            messageProducer.sendUserRegisterMessage(message);
            logger.info("发送用户注册消息成功: {} ({})", userName, userType);
            
        } catch (Exception e) {
            logger.error("发送用户注册消息失败: {}, 错误信息: {}", userName, e.getMessage(), e);
        }
    }

    @Override
    public void sendUserUpdateMessage(Long userId, String userName, String nickName, String email, 
                                    String phoneNumber, String userType) {
        try {
            UserRegisterMessage message = new UserRegisterMessage("USER_SERVICE");
            message.setUserId(userId);
            message.setUserName(userName);
            message.setNickName(nickName);
            message.setEmail(email);
            message.setPhoneNumber(phoneNumber);
            message.setUserType(userType);
            message.setOperationType("UPDATE");
            message.setStatus("0");

            messageProducer.sendUserRegisterMessage(message);
            logger.info("发送用户更新消息成功: {}", userName);
            
        } catch (Exception e) {
            logger.error("发送用户更新消息失败: {}, 错误信息: {}", userName, e.getMessage(), e);
        }
    }

    @Override
    public void sendSystemLogMessage(String module, String businessType, Integer operType, String operName,
                                   String operUrl, String operIp, String operParam, String jsonResult,
                                   Integer status, String errorMsg, Long costTime) {
        try {
            SystemLogMessage message = new SystemLogMessage("SYSTEM_LOG_SERVICE");
            message.setModule(module);
            message.setBusinessType(businessType);
            message.setOperType(operType);
            message.setOperName(operName);
            message.setOperUrl(operUrl);
            message.setOperIp(operIp);
            message.setOperParam(operParam);
            message.setJsonResult(jsonResult);
            message.setStatus(status);
            message.setErrorMsg(errorMsg);
            message.setCostTime(costTime);
            message.setOperTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

            messageProducer.sendSystemLogMessage(message);
            logger.debug("发送系统日志消息成功: {} - {}", module, operName);
            
        } catch (Exception e) {
            logger.error("发送系统日志消息失败: {} - {}, 错误信息: {}", module, operName, e.getMessage(), e);
        }
    }

    @Override
    public void sendNotificationMessage(String title, String content, String type, Long targetId) {
        try {
            // 创建通知消息（这里简化处理，实际可以创建专门的NotificationMessage类）
            UserRegisterMessage message = new UserRegisterMessage("NOTIFICATION_SERVICE");
            message.setUserId(targetId);
            message.setOperationType("NOTIFICATION");
            message.setUserType(type);
            // 可以利用现有字段存储通知信息
            message.setNickName(title);
            message.setEmail(content);

            messageProducer.sendNotificationMessage(message);
            logger.info("发送通知消息成功: {} -> 用户{}", title, targetId);
            
        } catch (Exception e) {
            logger.error("发送通知消息失败: {}, 错误信息: {}", title, e.getMessage(), e);
        }
    }
}
