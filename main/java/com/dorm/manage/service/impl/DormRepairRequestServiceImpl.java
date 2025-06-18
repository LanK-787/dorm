package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormRepairRequestMapper;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.service.IDormRepairRequestService;

/**
 * 报修工单Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@Service
public class DormRepairRequestServiceImpl implements IDormRepairRequestService 
{
    @Autowired
    private DormRepairRequestMapper dormRepairRequestMapper;

    /**
     * 查询报修工单
     * 
     * @param requestId 报修工单主键
     * @return 报修工单
     */
    @Override
    public DormRepairRequest selectDormRepairRequestByRequestId(Long requestId)
    {
        return dormRepairRequestMapper.selectDormRepairRequestByRequestId(requestId);
    }

    /**
     * 查询报修工单列表
     * 
     * @param dormRepairRequest 报修工单
     * @return 报修工单
     */
    @Override
    public List<DormRepairRequest> selectDormRepairRequestList(DormRepairRequest dormRepairRequest)
    {
        return dormRepairRequestMapper.selectDormRepairRequestList(dormRepairRequest);
    }

    /**
     * 新增报修工单
     * 
     * @param dormRepairRequest 报修工单
     * @return 结果
     */
    @Override
    public int insertDormRepairRequest(DormRepairRequest dormRepairRequest)
    {
        dormRepairRequest.setCreateTime(DateUtils.getNowDate());
        return dormRepairRequestMapper.insertDormRepairRequest(dormRepairRequest);
    }

    /**
     * 修改报修工单
     * 
     * @param dormRepairRequest 报修工单
     * @return 结果
     */
    @Override
    public int updateDormRepairRequest(DormRepairRequest dormRepairRequest)
    {
        dormRepairRequest.setUpdateTime(DateUtils.getNowDate());
        return dormRepairRequestMapper.updateDormRepairRequest(dormRepairRequest);
    }

    /**
     * 批量删除报修工单
     * 
     * @param requestIds 需要删除的报修工单主键
     * @return 结果
     */
    @Override
    public int deleteDormRepairRequestByRequestIds(Long[] requestIds)
    {
        return dormRepairRequestMapper.deleteDormRepairRequestByRequestIds(requestIds);
    }

    /**
     * 删除报修工单信息
     * 
     * @param requestId 报修工单主键
     * @return 结果
     */
    @Override
    public int deleteDormRepairRequestByRequestId(Long requestId)
    {
        return dormRepairRequestMapper.deleteDormRepairRequestByRequestId(requestId);
    }
}
