package com.dorm.web.controller.test;

import com.dorm.common.annotation.Anonymous;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.service.MailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 邮件测试控制器
 * 
 * @author dorm
 * @date 2025-09-08
 */
@RestController
@RequestMapping("/test/mail")
public class MailTestController extends BaseController {
    
    @Autowired
    private MailService mailService;
    
    /**
     * 测试发送简单邮件
     */
    @Anonymous
    @PostMapping("/simple")
    public AjaxResult testSimpleMail(@RequestParam String to,
                                   @RequestParam String subject,
                                   @RequestParam String content) {
        try {
            mailService.sendSimpleMail(to, subject, content);
            return success("简单邮件发送成功");
        } catch (Exception e) {
            return error("简单邮件发送失败: " + e.getMessage());
        }
    }
    
    /**
     * 测试发送HTML邮件
     */
    @Anonymous
    @PostMapping("/html")
    public AjaxResult testHtmlMail(@RequestParam String to,
                                 @RequestParam String subject,
                                 @RequestParam String content) {
        try {
            mailService.sendHtmlMail(to, subject, content);
            return success("HTML邮件发送成功");
        } catch (Exception e) {
            return error("HTML邮件发送失败: " + e.getMessage());
        }
    }
    
    /**
     * 测试发送报警邮件
     */
    @Anonymous
    @PostMapping("/alert")
    public AjaxResult testAlertMail(@RequestParam String to,
                                  @RequestParam(defaultValue = "262") String dormId,
                                  @RequestParam(defaultValue = "500.0") Double smokeValue,
                                  @RequestParam(defaultValue = "CRIT") String alertLevel) {
        try {
            // 构建测试报警信息
            Map<String, Object> alertInfo = new HashMap<>();
            alertInfo.put("alertLevel", alertLevel);
            alertInfo.put("dormId", dormId);
            alertInfo.put("smokeValue", smokeValue);
            
            // 构建宿舍信息
            Map<String, Object> dormInfo = new HashMap<>();
            dormInfo.put("fullName", "瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - " + dormId);
            dormInfo.put("buildingName", dormId);
            dormInfo.put("dormManager", "朱阿姨");
            dormInfo.put("phone", "13256489846");
            dormInfo.put("maxCapacity", 6);
            dormInfo.put("currentCount", 6);
            
            alertInfo.put("dormInfo", dormInfo);
            
            mailService.sendAlertMail(to, alertInfo);
            return success("报警邮件发送成功");
        } catch (Exception e) {
            return error("报警邮件发送失败: " + e.getMessage());
        }
    }
}