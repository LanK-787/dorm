package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormRepairRequest;

/**
 * 报修工单Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public interface DormRepairRequestMapper 
{
    /**
     * 查询报修工单
     * 
     * @param requestId 报修工单主键
     * @return 报修工单
     */
    public DormRepairRequest selectDormRepairRequestByRequestId(Long requestId);

    /**
     * 查询报修工单列表
     * 
     * @param dormRepairRequest 报修工单
     * @return 报修工单集合
     */
    public List<DormRepairRequest> selectDormRepairRequestList(DormRepairRequest dormRepairRequest);

    /**
     * 新增报修工单
     * 
     * @param dormRepairRequest 报修工单
     * @return 结果
     */
    public int insertDormRepairRequest(DormRepairRequest dormRepairRequest);

    /**
     * 修改报修工单
     * 
     * @param dormRepairRequest 报修工单
     * @return 结果
     */
    public int updateDormRepairRequest(DormRepairRequest dormRepairRequest);

    /**
     * 删除报修工单
     * 
     * @param requestId 报修工单主键
     * @return 结果
     */
    public int deleteDormRepairRequestByRequestId(Long requestId);

    /**
     * 批量删除报修工单
     *
     * @param requestIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormRepairRequestByRequestIds(Long[] requestIds);

    /**
     * 查询指定日期的最大工单编号
     *
     * @param dateKey 日期键（YYYYMMDD格式）
     * @return 最大工单编号
     */
    public String selectMaxRequestNoByDate(String dateKey);
}
