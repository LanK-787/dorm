package com.dorm.manage.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.common.utils.SecurityUtils;
import com.dorm.manage.mapper.DormAlarmLogMapper;
import com.dorm.manage.domain.DormAlarmLog;
import com.dorm.manage.service.IDormAlarmLogService;

/**
 * 报警记录Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
@Service
public class DormAlarmLogServiceImpl implements IDormAlarmLogService 
{
    @Autowired
    private DormAlarmLogMapper dormAlarmLogMapper;

    /**
     * 查询报警记录
     * 
     * @param alarmId 报警记录主键
     * @return 报警记录
     */
    @Override
    public DormAlarmLog selectDormAlarmLogByAlarmId(Long alarmId)
    {
        return dormAlarmLogMapper.selectDormAlarmLogByAlarmId(alarmId);
    }

    /**
     * 查询报警记录列表
     * 
     * @param dormAlarmLog 报警记录
     * @return 报警记录
     */
    @Override
    public List<DormAlarmLog> selectDormAlarmLogList(DormAlarmLog dormAlarmLog)
    {
        return dormAlarmLogMapper.selectDormAlarmLogList(dormAlarmLog);
    }

    /**
     * 新增报警记录
     * 
     * @param dormAlarmLog 报警记录
     * @return 结果
     */
    @Override
    public int insertDormAlarmLog(DormAlarmLog dormAlarmLog)
    {
        return dormAlarmLogMapper.insertDormAlarmLog(dormAlarmLog);
    }

    /**
     * 修改报警记录
     * 
     * @param dormAlarmLog 报警记录
     * @return 结果
     */
    @Override
    public int updateDormAlarmLog(DormAlarmLog dormAlarmLog)
    {
        return dormAlarmLogMapper.updateDormAlarmLog(dormAlarmLog);
    }

    /**
     * 批量删除报警记录
     * 
     * @param alarmIds 需要删除的报警记录主键
     * @return 结果
     */
    @Override
    public int deleteDormAlarmLogByAlarmIds(Long[] alarmIds)
    {
        return dormAlarmLogMapper.deleteDormAlarmLogByAlarmIds(alarmIds);
    }

    /**
     * 删除报警记录信息
     * 
     * @param alarmId 报警记录主键
     * @return 结果
     */
    @Override
    public int deleteDormAlarmLogByAlarmId(Long alarmId)
    {
        return dormAlarmLogMapper.deleteDormAlarmLogByAlarmId(alarmId);
    }

    /**
     * 标记报警为已处理
     * 
     * @param alarmId 报警记录主键
     * @return 结果
     */
    @Override
    public int handleDormAlarmLog(Long alarmId)
    {
        DormAlarmLog alarmLog = new DormAlarmLog();
        alarmLog.setAlarmId(alarmId);
        alarmLog.setHandled(1);
        alarmLog.setHandledTime(new Date());
        alarmLog.setHandler(SecurityUtils.getLoginUser().getUser().getNickName());
        return dormAlarmLogMapper.updateDormAlarmLog(alarmLog);
    }
}
