package com.dorm.common.service.impl;

import com.dorm.common.service.MailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.internet.MimeMessage;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * 邮件服务实现类
 * 
 * @author dorm
 * @date 2025-09-08
 */
@Service
@ConditionalOnProperty(prefix = "spring.mail", name = "host")
public class MailServiceImpl implements MailService {
    
    private static final Logger log = LoggerFactory.getLogger(MailServiceImpl.class);
    
    @Autowired(required = false)
    private JavaMailSender mailSender;
    
    @Value("${spring.mail.username}")
    private String from;
    
    @Override
    public void sendSimpleMail(String to, String subject, String content) {
        if (mailSender == null) {
            log.warn("邮件服务未配置，无法发送邮件: {} -> {}", from, to);
            return;
        }
        
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(from);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(content);
            message.setSentDate(new Date());
            
            mailSender.send(message);
            log.info("简单邮件发送成功: {} -> {}", from, to);
        } catch (Exception e) {
            log.error("简单邮件发送失败: {} -> {}, 错误信息: {}", from, to, e.getMessage(), e);
            throw new RuntimeException("邮件发送失败: " + e.getMessage());
        }
    }
    
    @Override
    public void sendHtmlMail(String to, String subject, String content) {
        if (mailSender == null) {
            log.warn("邮件服务未配置，无法发送HTML邮件: {} -> {}", from, to);
            return;
        }
        
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(from);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content, true);
            helper.setSentDate(new Date());
            
            mailSender.send(message);
            log.info("HTML邮件发送成功: {} -> {}", from, to);
        } catch (Exception e) {
            log.error("HTML邮件发送失败: {} -> {}, 错误信息: {}", from, to, e.getMessage(), e);
            throw new RuntimeException("邮件发送失败: " + e.getMessage());
        }
    }
    
    @Override
    public void sendAlertMail(String to, Map<String, Object> alertInfo) {
        if (mailSender == null) {
            log.warn("邮件服务未配置，无法发送报警邮件: {} -> {}", alertInfo.get("dormId"), to);
            return;
        }
        
        try {
            String subject = "【宿舍管理系统】烟雾报警通知";
            String content = buildAlertMailContent(alertInfo);
            
            sendHtmlMail(to, subject, content);
            log.info("报警邮件发送成功: 宿舍{}, 烟雾值{}ppm -> {}", 
                    alertInfo.get("dormId"), alertInfo.get("smokeValue"), to);
        } catch (Exception e) {
            log.error("报警邮件发送失败: {} -> {}, 错误信息: {}", alertInfo, to, e.getMessage(), e);
            throw new RuntimeException("报警邮件发送失败: " + e.getMessage());
        }
    }
    
    /**
     * 构建报警邮件内容
     */
    private String buildAlertMailContent(Map<String, Object> alertInfo) {
        StringBuilder content = new StringBuilder();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        // 提取报警信息
        String alertLevel = (String) alertInfo.get("alertLevel");
        String dormId = (String) alertInfo.get("dormId");
        Double smokeValue = (Double) alertInfo.get("smokeValue");
        @SuppressWarnings("unchecked")
        Map<String, Object> dormInfo = (Map<String, Object>) alertInfo.get("dormInfo");
        
        String dormFullName = dormInfo != null ? 
            (String) dormInfo.get("fullName") : "宿舍 " + dormId;
        String dormManager = dormInfo != null ? 
            (String) dormInfo.get("dormManager") : "";
        String phone = dormInfo != null ? 
            (String) dormInfo.get("phone") : "";
        
        content.append("<!DOCTYPE html>");
        content.append("<html>");
        content.append("<head>");
        content.append("<meta charset='UTF-8'>");
        content.append("<style>");
        content.append("body { font-family: Arial, sans-serif; margin: 20px; }");
        content.append(".alert-header { background-color: #ff4757; color: white; padding: 15px; text-align: center; }");
        content.append(".alert-content { padding: 20px; border: 1px solid #ddd; }");
        content.append(".info-item { margin: 10px 0; }");
        content.append(".label { font-weight: bold; color: #333; }");
        content.append(".value { color: #666; }");
        content.append(".critical { color: #ff4757; font-weight: bold; }");
        content.append(".footer { margin-top: 20px; padding-top: 10px; border-top: 1px solid #ddd; color: #999; }");
        content.append("</style>");
        content.append("</head>");
        content.append("<body>");
        
        content.append("<div class='alert-header'>");
        content.append("<h2>🚨 烟雾报警通知</h2>");
        content.append("</div>");
        
        content.append("<div class='alert-content'>");
        content.append("<div class='info-item'>");
        content.append("<span class='label'>报警级别:</span> ");
        content.append("<span class='critical'>").append(getAlertLevelText(alertLevel)).append("</span>");
        content.append("</div>");
        
        content.append("<div class='info-item'>");
        content.append("<span class='label'>报警时间:</span> ");
        content.append("<span class='value'>").append(sdf.format(new Date())).append("</span>");
        content.append("</div>");
        
        content.append("<div class='info-item'>");
        content.append("<span class='label'>宿舍位置:</span> ");
        content.append("<span class='value'>").append(dormFullName).append("</span>");
        content.append("</div>");
        
        content.append("<div class='info-item'>");
        content.append("<span class='label'>烟雾浓度:</span> ");
        content.append("<span class='critical'>").append(smokeValue).append(" ppm</span>");
        content.append("</div>");
        
        if (dormManager != null && !dormManager.trim().isEmpty()) {
            content.append("<div class='info-item'>");
            content.append("<span class='label'>宿舍管理员:</span> ");
            content.append("<span class='value'>").append(dormManager).append("</span>");
            content.append("</div>");
        }
        
        if (phone != null && !phone.trim().isEmpty()) {
            content.append("<div class='info-item'>");
            content.append("<span class='label'>联系电话:</span> ");
            content.append("<span class='value'>").append(phone).append("</span>");
            content.append("</div>");
        }
        
        content.append("<div class='info-item'>");
        content.append("<span class='label'>处理建议:</span> ");
        content.append("<span class='value'>");
        if ("CRIT".equalsIgnoreCase(alertLevel) || "CRITICAL".equalsIgnoreCase(alertLevel)) {
            content.append("请立即前往现场查看，必要时联系消防部门!");
        } else {
            content.append("请及时前往现场查看情况，并采取相应措施。");
        }
        content.append("</span>");
        content.append("</div>");
        
        content.append("</div>");
        
        content.append("<div class='footer'>");
        content.append("<p>此邮件由宿舍管理系统自动发送，请勿回复。</p>");
        content.append("<p>发送时间: ").append(sdf.format(new Date())).append("</p>");
        content.append("</div>");
        
        content.append("</body>");
        content.append("</html>");
        
        return content.toString();
    }
    
    /**
     * 获取报警级别文本
     */
    private String getAlertLevelText(String alertLevel) {
        if ("CRIT".equalsIgnoreCase(alertLevel) || "CRITICAL".equalsIgnoreCase(alertLevel)) {
            return "严重报警";
        } else if ("WARN".equalsIgnoreCase(alertLevel) || "WARNING".equalsIgnoreCase(alertLevel)) {
            return "警告级报警";
        } else {
            return "信息级报警";
        }
    }
}