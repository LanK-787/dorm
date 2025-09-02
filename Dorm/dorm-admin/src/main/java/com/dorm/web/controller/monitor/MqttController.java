package com.dorm.web.controller.monitor;

import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.framework.web.service.MqttSmokeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * MQTT监控控制器
 * 
 * @author dorm
 * @since 2025-09-01
 */
@RestController
@RequestMapping("/monitor/mqtt")
public class MqttController extends BaseController {
    
    @Autowired
    private MqttSmokeService mqttSmokeService;
    
    /**
     * 获取MQTT连接状态
     */
    @PreAuthorize("@ss.hasPermi('monitor:mqtt:view')")
    @GetMapping("/status")
    public AjaxResult getStatus() {
        Map<String, Object> status = mqttSmokeService.getStatus();
        return success(status);
    }
    
    /**
     * 检查MQTT连接状态
     */
    @PreAuthorize("@ss.hasPermi('monitor:mqtt:view')")
    @GetMapping("/health")
    public AjaxResult health() {
        boolean connected = mqttSmokeService.isConnected();
        Map<String, Object> status = mqttSmokeService.getStatus();
        status.put("health", connected ? "UP" : "DOWN");
        return success(status);
    }
    
    /**
     * 手动重连 MQTT
     */
    @PreAuthorize("@ss.hasPermi('monitor:mqtt:edit')")
    @PostMapping("/reconnect")
    public AjaxResult reconnect() {
        try {
            mqttSmokeService.reconnect();
            return success("重连命令已发送");
        } catch (Exception e) {
            return error("重连失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取MQTT配置信息（脱敏）
     */
    @PreAuthorize("@ss.hasPermi('monitor:mqtt:view')")
    @GetMapping("/config")
    public AjaxResult getConfig() {
        Map<String, Object> status = mqttSmokeService.getStatus();
        // 移除敏感信息
        status.remove("password");
        return success(status);
    }
}