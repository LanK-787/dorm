package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormAlarmLog;

/**
 * 报警记录Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-09-02
 */
public interface DormAlarmLogMapper 
{
    /**
     * 查询报警记录
     * 
     * @param alarmId 报警记录主键
     * @return 报警记录
     */
    public DormAlarmLog selectDormAlarmLogByAlarmId(Long alarmId);

    /**
     * 查询报警记录列表
     * 
     * @param dormAlarmLog 报警记录
     * @return 报警记录集合
     */
    public List<DormAlarmLog> selectDormAlarmLogList(DormAlarmLog dormAlarmLog);

    /**
     * 新增报警记录
     * 
     * @param dormAlarmLog 报警记录
     * @return 结果
     */
    public int insertDormAlarmLog(DormAlarmLog dormAlarmLog);

    /**
     * 修改报警记录
     * 
     * @param dormAlarmLog 报警记录
     * @return 结果
     */
    public int updateDormAlarmLog(DormAlarmLog dormAlarmLog);

    /**
     * 删除报警记录
     * 
     * @param alarmId 报警记录主键
     * @return 结果
     */
    public int deleteDormAlarmLogByAlarmId(Long alarmId);

    /**
     * 批量删除报警记录
     * 
     * @param alarmIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormAlarmLogByAlarmIds(Long[] alarmIds);
}
