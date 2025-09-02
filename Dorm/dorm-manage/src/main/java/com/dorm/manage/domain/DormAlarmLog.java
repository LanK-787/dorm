package com.dorm.manage.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 报警记录对象 dorm_alarm_log
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
public class DormAlarmLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，告警ID */
    private Long alarmId;

    /** 对应报警设备ID */
    @Excel(name = "对应报警设备ID")
    private Long deviceId;

    /** 房间ID */
    @Excel(name = "房间ID")
    private Long dormId;

    /** 告警时烟雾值 */
    @Excel(name = "告警时烟雾值")
    private Long smokeValue;

    /** 告警等级（1一般，2严重等） */
    @Excel(name = "告警等级", readConverterExp = "1=一般，2严重等")
    private Integer alarmLevel;

    /** 告警时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "告警时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date alarmTime;

    /** 是否处理（0未处理，1已处理） */
    @Excel(name = "是否处理", readConverterExp = "0=未处理，1已处理")
    private Integer handled;

    /** 处理时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "处理时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date handledTime;

    /** 处理人 */
    @Excel(name = "处理人")
    private String handler;

    /** 备注 */
    @Excel(name = "备注")
    private String remarks;

    public void setAlarmId(Long alarmId) 
    {
        this.alarmId = alarmId;
    }

    public Long getAlarmId() 
    {
        return alarmId;
    }

    public void setDeviceId(Long deviceId) 
    {
        this.deviceId = deviceId;
    }

    public Long getDeviceId() 
    {
        return deviceId;
    }

    public void setDormId(Long dormId) 
    {
        this.dormId = dormId;
    }

    public Long getDormId() 
    {
        return dormId;
    }

    public void setSmokeValue(Long smokeValue) 
    {
        this.smokeValue = smokeValue;
    }

    public Long getSmokeValue() 
    {
        return smokeValue;
    }

    public void setAlarmLevel(Integer alarmLevel) 
    {
        this.alarmLevel = alarmLevel;
    }

    public Integer getAlarmLevel() 
    {
        return alarmLevel;
    }

    public void setAlarmTime(Date alarmTime) 
    {
        this.alarmTime = alarmTime;
    }

    public Date getAlarmTime() 
    {
        return alarmTime;
    }

    public void setHandled(Integer handled) 
    {
        this.handled = handled;
    }

    public Integer getHandled() 
    {
        return handled;
    }

    public void setHandledTime(Date handledTime) 
    {
        this.handledTime = handledTime;
    }

    public Date getHandledTime() 
    {
        return handledTime;
    }

    public void setHandler(String handler) 
    {
        this.handler = handler;
    }

    public String getHandler() 
    {
        return handler;
    }

    public void setRemarks(String remarks) 
    {
        this.remarks = remarks;
    }

    public String getRemarks() 
    {
        return remarks;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("alarmId", getAlarmId())
            .append("deviceId", getDeviceId())
            .append("dormId", getDormId())
            .append("smokeValue", getSmokeValue())
            .append("alarmLevel", getAlarmLevel())
            .append("alarmTime", getAlarmTime())
            .append("handled", getHandled())
            .append("handledTime", getHandledTime())
            .append("handler", getHandler())
            .append("remarks", getRemarks())
            .toString();
    }
}
