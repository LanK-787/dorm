package com.dorm.framework.rabbitmq.message;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * 消息基类
 * 
 * @author dorm
 */
public abstract class BaseMessage implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 消息ID
     */
    private String messageId;

    /**
     * 消息类型
     */
    private String messageType;

    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /**
     * 重试次数
     */
    private Integer retryCount = 0;

    /**
     * 最大重试次数
     */
    private Integer maxRetryCount = 3;

    /**
     * 消息来源
     */
    private String source;

    public BaseMessage() {
        this.messageId = UUID.randomUUID().toString();
        this.createTime = LocalDateTime.now();
        this.messageType = this.getClass().getSimpleName();
    }

    public BaseMessage(String source) {
        this();
        this.source = source;
    }

    // ==================== Getter and Setter ====================

    public String getMessageId() {
        return messageId;
    }

    public void setMessageId(String messageId) {
        this.messageId = messageId;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public Integer getRetryCount() {
        return retryCount;
    }

    public void setRetryCount(Integer retryCount) {
        this.retryCount = retryCount;
    }

    public Integer getMaxRetryCount() {
        return maxRetryCount;
    }

    public void setMaxRetryCount(Integer maxRetryCount) {
        this.maxRetryCount = maxRetryCount;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    /**
     * 增加重试次数
     */
    public void incrementRetryCount() {
        this.retryCount++;
    }

    /**
     * 是否超过最大重试次数
     */
    public boolean isMaxRetryExceeded() {
        return this.retryCount >= this.maxRetryCount;
    }

    @Override
    public String toString() {
        return "BaseMessage{" +
                "messageId='" + messageId + '\'' +
                ", messageType='" + messageType + '\'' +
                ", createTime=" + createTime +
                ", retryCount=" + retryCount +
                ", maxRetryCount=" + maxRetryCount +
                ", source='" + source + '\'' +
                '}';
    }
}
