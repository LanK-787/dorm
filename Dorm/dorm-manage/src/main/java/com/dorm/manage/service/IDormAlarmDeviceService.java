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
}
