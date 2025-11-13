package com.dorm.common.service;

/**
 * 邮件服务接口
 * 
 * @author 王新瑜
 * @date 2025-09-08
 */
public interface MailService {
    
    /**
     * 发送简单文本邮件
     * 
     * @param to 收件人邮箱
     * @param subject 邮件主题
     * @param content 邮件内容
     */
    void sendSimpleMail(String to, String subject, String content);
    
    /**
     * 发送HTML邮件
     * 
     * @param to 收件人邮箱
     * @param subject 邮件主题
     * @param content HTML内容
     */
    void sendHtmlMail(String to, String subject, String content);
    
    /**
     * 发送报警邮件
     * 
     * @param to 收件人邮箱
     * @param alertInfo 报警信息
     */
    void sendAlertMail(String to, java.util.Map<String, Object> alertInfo);
}