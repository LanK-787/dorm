package com.dorm.manage.domain;

import java.util.Date;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 设备管理对象 dorm_alarm_device
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
public class DormAlarmDevice extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，设备ID */
    private Long deviceId;

    /** 所属宿舍/房间ID */
    @Excel(name = "所属宿舍/房间ID")
    private Long dormId;

    /** 宿舍全称 */
    private String dormFullName;

    /** 多个宿舍ID（用于查询父节点下的所有设备） */
    private List<Long> dormIds;

    /** 设备名称 */
    @Excel(name = "设备名称")
    private String deviceName;

    /** 设备类型，'0'为烟雾报警器 */
    @Excel(name = "设备类型，'0'为烟雾报警器")
    private Integer deviceType;

    /** 安装位置 */
    private String location;

    /** 设备状态（0离线，1在线） */
    @Excel(name = "设备状态", readConverterExp = "0=离线，1在线")
    private Integer status;

    /** 最后一次在线时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "最后一次在线时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date lastOnlineTime;

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

    public void setDormFullName(String dormFullName) 
    {
        this.dormFullName = dormFullName;
    }

    public String getDormFullName() 
    {
        return dormFullName;
    }

    public void setDormIds(List<Long> dormIds) 
    {
        this.dormIds = dormIds;
    }

    public List<Long> getDormIds() 
    {
        return dormIds;
    }

    public void setDeviceName(String deviceName) 
    {
        this.deviceName = deviceName;
    }

    public String getDeviceName() 
    {
        return deviceName;
    }

    public void setDeviceType(Integer deviceType) 
    {
        this.deviceType = deviceType;
    }

    public Integer getDeviceType() 
    {
        return deviceType;
    }

    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }

    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    public Integer getStatus() 
    {
        return status;
    }

    public void setLastOnlineTime(Date lastOnlineTime) 
    {
        this.lastOnlineTime = lastOnlineTime;
    }

    public Date getLastOnlineTime() 
    {
        return lastOnlineTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("deviceId", getDeviceId())
            .append("dormId", getDormId())
            .append("dormFullName", getDormFullName())
            .append("dormIds", getDormIds())
            .append("deviceName", getDeviceName())
            .append("deviceType", getDeviceType())
            .append("location", getLocation())
            .append("status", getStatus())
            .append("lastOnlineTime", getLastOnlineTime())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
