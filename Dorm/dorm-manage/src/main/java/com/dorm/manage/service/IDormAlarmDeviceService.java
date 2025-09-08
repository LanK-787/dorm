package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormAlarmDevice;

/**
 * 设备管理Service接口
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
public interface IDormAlarmDeviceService 
{
    /**
     * 查询设备管理
     * 
     * @param deviceId 设备管理主键
     * @return 设备管理
     */
    public DormAlarmDevice selectDormAlarmDeviceByDeviceId(Long deviceId);

    /**
     * 查询设备管理列表
     * 
     * @param dormAlarmDevice 设备管理
     * @return 设备管理集合
     */
    public List<DormAlarmDevice> selectDormAlarmDeviceList(DormAlarmDevice dormAlarmDevice);

    /**
     * 新增设备管理
     * 
     * @param dormAlarmDevice 设备管理
     * @return 结果
     */
    public int insertDormAlarmDevice(DormAlarmDevice dormAlarmDevice);

    /**
     * 修改设备管理
     * 
     * @param dormAlarmDevice 设备管理
     * @return 结果
     */
    public int updateDormAlarmDevice(DormAlarmDevice dormAlarmDevice);

    /**
     * 批量删除设备管理
     * 
     * @param deviceIds 需要删除的设备管理主键集合
     * @return 结果
     */
    public int deleteDormAlarmDeviceByDeviceIds(Long[] deviceIds);

    /**
     * 删除设备管理信息
     * 
     * @param deviceId 设备管理主键
     * @return 结果
     */
    public int deleteDormAlarmDeviceByDeviceId(Long deviceId);

    /**
     * 更新设备在线状态
     * 
     * @param deviceId 设备ID
     * @param status 设备状态（0离线，1在线）
     * @return 结果
     */
    public int updateDeviceStatus(Long deviceId, Integer status);

    /**
     * 批量更新设备离线状态（将超过指定时间未更新的设备设为离线）
     * 
     * @param offlineMinutes 离线时间阈值（分钟）
     * @return 更新的设备数量
     */
    public int updateOfflineDevices(int offlineMinutes);
}
