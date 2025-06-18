package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormRepairRequest;

/**
 * 报修工单Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public interface IDormRepairRequestService 
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
     * 批量删除报修工单
     * 
     * @param requestIds 需要删除的报修工单主键集合
     * @return 结果
     */
    public int deleteDormRepairRequestByRequestIds(Long[] requestIds);

    /**
     * 删除报修工单信息
     * 
     * @param requestId 报修工单主键
     * @return 结果
     */
    public int deleteDormRepairRequestByRequestId(Long requestId);
}
