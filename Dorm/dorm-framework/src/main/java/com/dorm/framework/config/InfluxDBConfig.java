package com.dorm.framework.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * InfluxDB配置类
 * 
 * @author dorm
 * @since 2025-09-01
 */
@Configuration
@ConfigurationProperties(prefix = "influxdb")
public class InfluxDBConfig {
    
    private static final Logger log = LoggerFactory.getLogger(InfluxDBConfig.class);
    
    /**
     * 是否启用InfluxDB服务
     */
    private boolean enabled = false;
    
    /**
     * InfluxDB服务器地址
     */
    private String url = "http://localhost:8086";
    
    /**
     * 访问令牌
     */
    private String token;
    
    /**
     * 组织名称
     */
    private String org = "dorm";
    
    /**
     * 数据桶名称
     */
    private String bucket = "dorm_data";
    
    /**
     * 连接超时时间(毫秒)
     */
    private long connectTimeout = 10000L;
    
    /**
     * 读取超时时间(毫秒)
     */
    private long readTimeout = 30000L;
    
    /**
     * 写入超时时间(毫秒)
     */
    private long writeTimeout = 10000L;
    
    // Getters and Setters
    
    public boolean isEnabled() {
        return enabled;
    }
    
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
        if (enabled) {
            log.info("InfluxDB服务已启用");
        } else {
            log.info("InfluxDB服务未启用");
        }
    }
    
    public String getUrl() {
        return url;
    }
    
    public void setUrl(String url) {
        this.url = url;
    }
    
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getOrg() {
        return org;
    }
    
    public void setOrg(String org) {
        this.org = org;
    }
    
    public String getBucket() {
        return bucket;
    }
    
    public void setBucket(String bucket) {
        this.bucket = bucket;
    }
    
    public long getConnectTimeout() {
        return connectTimeout;
    }
    
    public void setConnectTimeout(long connectTimeout) {
        this.connectTimeout = connectTimeout;
    }
    
    public long getReadTimeout() {
        return readTimeout;
    }
    
    public void setReadTimeout(long readTimeout) {
        this.readTimeout = readTimeout;
    }
    
    public long getWriteTimeout() {
        return writeTimeout;
    }
    
    public void setWriteTimeout(long writeTimeout) {
        this.writeTimeout = writeTimeout;
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
        
        if (url == null || url.trim().isEmpty()) {
            log.error("InfluxDB URL不能为空");
            return false;
        }
        
        if (token == null || token.trim().isEmpty()) {
            log.error("InfluxDB Token不能为空");
            return false;
        }
        
        if (org == null || org.trim().isEmpty()) {
            log.error("InfluxDB Organization不能为空");
            return false;
        }
        
        if (bucket == null || bucket.trim().isEmpty()) {
            log.error("InfluxDB Bucket不能为空");
            return false;
        }
        
        return true;
    }
    
    @Override
    public String toString() {
        return "InfluxDBConfig{" +
                "enabled=" + enabled +
                ", url='" + url + '\'' +
                ", org='" + org + '\'' +
                ", bucket='" + bucket + '\'' +
                ", connectTimeout=" + connectTimeout +
                ", readTimeout=" + readTimeout +
                ", writeTimeout=" + writeTimeout +
                '}';
    }
}