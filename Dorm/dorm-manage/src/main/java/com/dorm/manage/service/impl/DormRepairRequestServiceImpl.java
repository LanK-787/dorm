package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import com.dorm.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import com.dorm.manage.mapper.DormRepairRequestMapper;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.IRepairRequestNoService;
import com.dorm.manage.service.ISmartDispatchService;
import com.dorm.framework.rabbitmq.message.SmartDispatchMessage;
import com.dorm.framework.rabbitmq.producer.MessageProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 报修工单Service业务层处理
 *
 * @author 王新瑜
 * @date 2025-06-18
 */
@Service
public class DormRepairRequestServiceImpl implements IDormRepairRequestService
{
    private static final Logger logger = LoggerFactory.getLogger(DormRepairRequestServiceImpl.class);
    @Autowired
    private DormRepairRequestMapper dormRepairRequestMapper;

    @Autowired
    private IRepairRequestNoService repairRequestNoService;

    @Autowired
    private MessageProducer messageProducer;

    @Autowired
    private ISmartDispatchService smartDispatchService;

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
    @Transactional
    public int insertDormRepairRequest(DormRepairRequest dormRepairRequest)
    {
        // 自动生成工单编号
        if (StringUtils.isEmpty(dormRepairRequest.getRequestNo())) {
            dormRepairRequest.setRequestNo(repairRequestNoService.generateNextRequestNo());
        }

        // 设置默认状态为待派单
        if (StringUtils.isEmpty(dormRepairRequest.getStatus())) {
            dormRepairRequest.setStatus("0");
        }

        dormRepairRequest.setCreateTime(DateUtils.getNowDate());
        int result = dormRepairRequestMapper.insertDormRepairRequest(dormRepairRequest);

        // 如果保存成功，触发智能派单
        if (result > 0) {
            logger.info("工单保存成功，开始触发智能派单：工单ID[{}]，编号[{}]，专长[{}]",
                       dormRepairRequest.getRequestId(), dormRepairRequest.getRequestNo(), dormRepairRequest.getSpecialty());
            // 构造要发送的消息
            SmartDispatchMessage dispatchMessage = new SmartDispatchMessage(
                dormRepairRequest.getRequestId(),
                dormRepairRequest.getRequestNo(),
                dormRepairRequest.getSpecialty(),
                "AUTO"
            );
            logger.debug("准备发送智能派单消息：{}", dispatchMessage);

            // 在事务提交后发送消息；若当前无事务同步，则立即发送
            if (TransactionSynchronizationManager.isSynchronizationActive()) {
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        try {
                            messageProducer.sendSmartDispatchMessage(dispatchMessage);
                            logger.info("智能派单消息发送成功（事务提交后）：工单[{}]，消息ID[{}]",
                                       dormRepairRequest.getRequestNo(), dispatchMessage.getMessageId());
                        } catch (Exception e) {
                            logger.warn("事务提交后异步派单消息发送失败，启用同步派单兜底：工单[{}]，错误：{}",
                                       dormRepairRequest.getRequestNo(), e.getMessage());
                            try {
                                ISmartDispatchService.SmartDispatchResult dispatchResult =
                                    smartDispatchService.smartDispatch(dormRepairRequest);
                                if (dispatchResult.isSuccess()) {
                                    logger.info("同步智能派单成功：工单[{}]派给维修人员[{}]",
                                               dormRepairRequest.getRequestNo(), dispatchResult.getSelectedRepairer().getName());
                                } else {
                                    logger.error("同步智能派单失败：工单[{}]，原因：{}",
                                                dormRepairRequest.getRequestNo(), dispatchResult.getFailureReason());
                                }
                            } catch (Exception syncException) {
                                logger.error("同步智能派单也失败：工单[{}]，错误：{}",
                                            dormRepairRequest.getRequestNo(), syncException.getMessage(), syncException);
                            }
                        }
                    }
                });
            } else {
                try {
                    messageProducer.sendSmartDispatchMessage(dispatchMessage);
                    logger.info("智能派单消息发送成功（无事务）：工单[{}]，消息ID[{}]",
                               dormRepairRequest.getRequestNo(), dispatchMessage.getMessageId());
                } catch (Exception e) {
                    // 异步派单失败，使用同步派单作为备用方案
                    logger.warn("异步派单消息发送失败（无事务），启用同步派单：工单[{}]，错误：{}",
                               dormRepairRequest.getRequestNo(), e.getMessage());
                    try {
                        ISmartDispatchService.SmartDispatchResult dispatchResult =
                            smartDispatchService.smartDispatch(dormRepairRequest);
                        if (dispatchResult.isSuccess()) {
                            logger.info("同步智能派单成功：工单[{}]派给维修人员[{}]",
                                       dormRepairRequest.getRequestNo(), dispatchResult.getSelectedRepairer().getName());
                        } else {
                            logger.error("同步智能派单失败：工单[{}]，原因：{}",
                                        dormRepairRequest.getRequestNo(), dispatchResult.getFailureReason());
                        }
                    } catch (Exception syncException) {
                        logger.error("同步智能派单也失败：工单[{}]，错误：{}",
                                    dormRepairRequest.getRequestNo(), syncException.getMessage(), syncException);
                    }
                }
            }
        }

        return result;
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
