package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormAlarmDeviceMapper;
import com.dorm.manage.domain.DormAlarmDevice;
import com.dorm.manage.service.IDormAlarmDeviceService;

/**
 * 设备管理Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
@Service
public class DormAlarmDeviceServiceImpl implements IDormAlarmDeviceService 
{
    @Autowired
    private DormAlarmDeviceMapper dormAlarmDeviceMapper;

    /**
     * 查询设备管理
     * 
     * @param deviceId 设备管理主键
     * @return 设备管理
     */
    @Override
    public DormAlarmDevice selectDormAlarmDeviceByDeviceId(Long deviceId)
    {
        return dormAlarmDeviceMapper.selectDormAlarmDeviceByDeviceId(deviceId);
    }

    /**
     * 查询设备管理列表
     * 
     * @param dormAlarmDevice 设备管理
     * @return 设备管理
     */
    @Override
    public List<DormAlarmDevice> selectDormAlarmDeviceList(DormAlarmDevice dormAlarmDevice)
    {
        return dormAlarmDeviceMapper.selectDormAlarmDeviceList(dormAlarmDevice);
    }

    /**
     * 新增设备管理
     * 
     * @param dormAlarmDevice 设备管理
     * @return 结果
     */
    @Override
    public int insertDormAlarmDevice(DormAlarmDevice dormAlarmDevice)
    {
        dormAlarmDevice.setCreateTime(DateUtils.getNowDate());
        return dormAlarmDeviceMapper.insertDormAlarmDevice(dormAlarmDevice);
    }

    /**
     * 修改设备管理
     * 
     * @param dormAlarmDevice 设备管理
     * @return 结果
     */
    @Override
    public int updateDormAlarmDevice(DormAlarmDevice dormAlarmDevice)
    {
        dormAlarmDevice.setUpdateTime(DateUtils.getNowDate());
        return dormAlarmDeviceMapper.updateDormAlarmDevice(dormAlarmDevice);
    }

    /**
     * 批量删除设备管理
     * 
     * @param deviceIds 需要删除的设备管理主键
     * @return 结果
     */
    @Override
    public int deleteDormAlarmDeviceByDeviceIds(Long[] deviceIds)
    {
        return dormAlarmDeviceMapper.deleteDormAlarmDeviceByDeviceIds(deviceIds);
    }

    /**
     * 删除设备管理信息
     * 
     * @param deviceId 设备管理主键
     * @return 结果
     */
    @Override
    public int deleteDormAlarmDeviceByDeviceId(Long deviceId)
    {
        return dormAlarmDeviceMapper.deleteDormAlarmDeviceByDeviceId(deviceId);
    }
}
