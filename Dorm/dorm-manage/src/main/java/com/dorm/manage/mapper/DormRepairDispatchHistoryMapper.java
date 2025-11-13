package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormRepairDispatchHistory;

/**
 * 派单历史记录Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public interface DormRepairDispatchHistoryMapper 
{
    /**
     * 查询派单历史记录
     * 
     * @param historyId 派单历史记录主键
     * @return 派单历史记录
     */
    public DormRepairDispatchHistory selectDormRepairDispatchHistoryByHistoryId(Long historyId);

    /**
     * 查询派单历史记录列表
     * 
     * @param dormRepairDispatchHistory 派单历史记录
     * @return 派单历史记录集合
     */
    public List<DormRepairDispatchHistory> selectDormRepairDispatchHistoryList(DormRepairDispatchHistory dormRepairDispatchHistory);

    /**
     * 新增派单历史记录
     * 
     * @param dormRepairDispatchHistory 派单历史记录
     * @return 结果
     */
    public int insertDormRepairDispatchHistory(DormRepairDispatchHistory dormRepairDispatchHistory);

    /**
     * 修改派单历史记录
     * 
     * @param dormRepairDispatchHistory 派单历史记录
     * @return 结果
     */
    public int updateDormRepairDispatchHistory(DormRepairDispatchHistory dormRepairDispatchHistory);

    /**
     * 删除派单历史记录
     * 
     * @param historyId 派单历史记录主键
     * @return 结果
     */
    public int deleteDormRepairDispatchHistoryByHistoryId(Long historyId);

    /**
     * 批量删除派单历史记录
     * 
     * @param historyIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormRepairDispatchHistoryByHistoryIds(Long[] historyIds);

    /**
     * 根据工单ID查询派单历史
     * 
     * @param requestId 工单ID
     * @return 派单历史记录集合
     */
    public List<DormRepairDispatchHistory> selectDispatchHistoryByRequestId(Long requestId);
}
