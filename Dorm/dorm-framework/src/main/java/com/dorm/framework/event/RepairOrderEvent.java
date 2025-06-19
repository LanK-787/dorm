package com.dorm.framework.event;

import com.dorm.framework.rabbitmq.message.RepairOrderMessage;
import org.springframework.context.ApplicationEvent;

/**
 * 维修工单事件
 * 
 * @author dorm
 */
public class RepairOrderEvent extends ApplicationEvent {

    private static final long serialVersionUID = 1L;

    /**
     * 事件类型
     */
    public enum EventType {
        ASSIGNED,    // 工单分配
        UNASSIGNED,  // 工单取消分配
        COMPLETED    // 工单完成
    }

    /**
     * 事件类型
     */
    private EventType eventType;

    /**
     * 维修工单消息
     */
    private RepairOrderMessage repairOrderMessage;

    /**
     * 是否减少计数（仅对COMPLETED事件有效）
     */
    private boolean shouldDecrementCount;

    public RepairOrderEvent(Object source, EventType eventType, RepairOrderMessage repairOrderMessage) {
        super(source);
        this.eventType = eventType;
        this.repairOrderMessage = repairOrderMessage;
        this.shouldDecrementCount = false;
    }

    public RepairOrderEvent(Object source, EventType eventType, RepairOrderMessage repairOrderMessage, boolean shouldDecrementCount) {
        super(source);
        this.eventType = eventType;
        this.repairOrderMessage = repairOrderMessage;
        this.shouldDecrementCount = shouldDecrementCount;
    }

    public EventType getEventType() {
        return eventType;
    }

    public void setEventType(EventType eventType) {
        this.eventType = eventType;
    }

    public RepairOrderMessage getRepairOrderMessage() {
        return repairOrderMessage;
    }

    public void setRepairOrderMessage(RepairOrderMessage repairOrderMessage) {
        this.repairOrderMessage = repairOrderMessage;
    }

    public boolean isShouldDecrementCount() {
        return shouldDecrementCount;
    }

    public void setShouldDecrementCount(boolean shouldDecrementCount) {
        this.shouldDecrementCount = shouldDecrementCount;
    }

    @Override
    public String toString() {
        return "RepairOrderEvent{" +
                "eventType=" + eventType +
                ", repairOrderMessage=" + repairOrderMessage +
                ", shouldDecrementCount=" + shouldDecrementCount +
                '}';
    }
}
