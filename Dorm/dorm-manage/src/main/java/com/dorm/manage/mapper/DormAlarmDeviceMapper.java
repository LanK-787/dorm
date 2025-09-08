package com.dorm.manage.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.dorm.manage.domain.DormAlarmDevice;

/**
 * 设备管理Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
public interface DormAlarmDeviceMapper 
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
     * 删除设备管理
     * 
     * @param deviceId 设备管理主键
     * @return 结果
     */
    public int deleteDormAlarmDeviceByDeviceId(Long deviceId);

    /**
     * 批量删除设备管理
     * 
     * @param deviceIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormAlarmDeviceByDeviceIds(Long[] deviceIds);

    /**
     * 批量更新设备离线状态（将超过指定时间未更新的设备设为离线）
     * 
     * @param offlineMinutes 离线时间阈值（分钟）
     * @return 更新的设备数量
     */
    public int updateOfflineDevices(@Param("offlineMinutes") int offlineMinutes);
}
