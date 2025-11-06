package com.dorm.framework.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * MQTT配置类
 * 
 * @author 王新瑜
 * @since 2025-09-01
 */
@Configuration
@ConfigurationProperties(prefix = "mqtt")
public class MqttConfig {
    
    private static final Logger log = LoggerFactory.getLogger(MqttConfig.class);
    
    /**
     * 是否启用MQTT服务
     */
    private boolean enabled = false;
    
    /**
     * MQTT Broker地址
     */
    private String brokerUrl = "tcp://localhost:1883";
    
    /**
     * 客户端ID
     */
    private String clientId = "dorm-smoke-client";
    
    /**
     * 要订阅的主题
     */
    private String topic = "/dorm/smoke/{dorm_id}";
    
    /**
     * 服务质量等级
     */
    private int qos = 1;
    
    /**
     * MQTT用户名
     */
    private String username;
    
    /**
     * MQTT密码
     */
    private String password;
    
    /**
     * 连接超时时间(秒)
     */
    private int connectionTimeout = 30;
    
    /**
     * 保活间隔(秒)
     */
    private int keepAliveInterval = 60;
    
    /**
     * 是否自动重连
     */
    private boolean automaticReconnect = true;
    
    /**
     * 是否清除会话
     */
    private boolean cleanSession = true;
    
    // Getters and Setters
    
    public boolean isEnabled() {
        return enabled;
    }
    
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
        if (enabled) {
            log.info("MQTT服务已启用");
        } else {
            log.info("MQTT服务未启用");
        }
    }
    
    public String getBrokerUrl() {
        return brokerUrl;
    }
    
    public void setBrokerUrl(String brokerUrl) {
        this.brokerUrl = brokerUrl;
    }
    
    public String getClientId() {
        return clientId;
    }
    
    public void setClientId(String clientId) {
        this.clientId = clientId;
    }
    
    public String getTopic() {
        return topic;
    }
    
    public void setTopic(String topic) {
        this.topic = topic;
    }
    
    public int getQos() {
        return qos;
    }
    
    public void setQos(int qos) {
        this.qos = qos;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public int getConnectionTimeout() {
        return connectionTimeout;
    }
    
    public void setConnectionTimeout(int connectionTimeout) {
        this.connectionTimeout = connectionTimeout;
    }
    
    public int getKeepAliveInterval() {
        return keepAliveInterval;
    }
    
    public void setKeepAliveInterval(int keepAliveInterval) {
        this.keepAliveInterval = keepAliveInterval;
    }
    
    public boolean isAutomaticReconnect() {
        return automaticReconnect;
    }
    
    public void setAutomaticReconnect(boolean automaticReconnect) {
        this.automaticReconnect = automaticReconnect;
    }
    
    public boolean isCleanSession() {
        return cleanSession;
    }
    
    public void setCleanSession(boolean cleanSession) {
        this.cleanSession = cleanSession;
    }
    
    /**
     * 验证配置是否有效
     * 
     * @return 配置是否有效
     */
    public boolean isValid() {
        if (!enabled) {
            return true; // 未启用时不需要验证
        }
        
        if (brokerUrl == null || brokerUrl.trim().isEmpty()) {
            log.error("MQTT Broker URL不能为空");
            return false;
        }
        
        if (clientId == null || clientId.trim().isEmpty()) {
            log.error("MQTT Client ID不能为空");
            return false;
        }
        
        if (topic == null || topic.trim().isEmpty()) {
            log.error("MQTT Topic不能为空");
            return false;
        }
        
        if (qos < 0 || qos > 2) {
            log.error("MQTT QoS必须在0-2之间");
            return false;
        }
        
        return true;
    }
    
    @Override
    public String toString() {
        return "MqttConfig{" +
                "enabled=" + enabled +
                ", brokerUrl='" + brokerUrl + '\'' +
                ", clientId='" + clientId + '\'' +
                ", topic='" + topic + '\'' +
                ", qos=" + qos +
                ", connectionTimeout=" + connectionTimeout +
                ", keepAliveInterval=" + keepAliveInterval +
                ", automaticReconnect=" + automaticReconnect +
                ", cleanSession=" + cleanSession +
                '}';
    }
}