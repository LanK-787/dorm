package com.dorm.manage.service.impl;

import com.dorm.common.utils.DateUtils;
import com.dorm.framework.rabbitmq.message.SmartDispatchMessage;
import com.dorm.framework.rabbitmq.producer.MessageProducer;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.ISmartDispatchService;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 智能派单集成服务实现类
 * 整合所有派单相关功能，提供统一的派单入口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@Service
public class SmartDispatchIntegrationServiceImpl {

    private static final Logger logger = LoggerFactory.getLogger(SmartDispatchIntegrationServiceImpl.class);

    @Autowired
    private IDormRepairRequestService repairRequestService;

    @Autowired
    private ISmartDispatchService smartDispatchService;

    @Autowired
    private MessageProducer messageProducer;

    /**
     * 提交报修申请并触发智能派单
     * 这是整个智能派单系统的入口方法
     * 
     * @param repairRequest 报修申请
     * @return 提交结果
     */
    @Transactional
    public SubmitResult submitRepairRequestAndDispatch(DormRepairRequest repairRequest) {
        try {
            logger.info("收到报修申请：{}", repairRequest.getDescription());

            // 1. 保存报修工单
            int result = repairRequestService.insertDormRepairRequest(repairRequest);
            if (result <= 0) {
                return new SubmitResult(false, "保存报修工单失败");
            }

            logger.info("报修工单保存成功：工单编号[{}]", repairRequest.getRequestNo());

            // 2. 发送智能派单消息（异步处理）
            SmartDispatchMessage dispatchMessage = new SmartDispatchMessage(
                repairRequest.getRequestId(),
                repairRequest.getRequestNo(),
                repairRequest.getSpecialty(),
                "AUTO"
            );
            messageProducer.sendSmartDispatchMessage(dispatchMessage);

            logger.info("智能派单消息已发送：工单[{}]", repairRequest.getRequestNo());

            return new SubmitResult(true, "报修申请提交成功，系统正在自动派单", repairRequest.getRequestNo());

        } catch (Exception e) {
            logger.error("提交报修申请失败：{}", repairRequest, e);
            return new SubmitResult(false, "提交报修申请失败：" + e.getMessage());
        }
    }

    /**
     * 立即执行智能派单（同步处理）
     * 用于紧急情况或手动触发派单
     * 
     * @param requestId 工单ID
     * @return 派单结果
     */
    public ImmediateDispatchResult immediateDispatch(Long requestId) {
        try {
            logger.info("开始立即派单：工单ID[{}]", requestId);

            // 获取工单信息
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(requestId);
            if (repairRequest == null) {
                return new ImmediateDispatchResult(false, "工单不存在");
            }

            // 执行智能派单
            ISmartDispatchService.SmartDispatchResult result = smartDispatchService.smartDispatch(repairRequest);

            if (result.isSuccess()) {
                logger.info("立即派单成功：工单[{}]派给维修人员[{}]", 
                           repairRequest.getRequestNo(), result.getSelectedRepairer().getName());
                
                return new ImmediateDispatchResult(true, "派单成功", 
                                                 result.getSelectedRepairer().getName(),
                                                 result.getCandidateCount());
            } else {
                logger.warn("立即派单失败：工单[{}]，原因：{}", 
                           repairRequest.getRequestNo(), result.getFailureReason());
                
                return new ImmediateDispatchResult(false, result.getFailureReason());
            }

        } catch (Exception e) {
            logger.error("立即派单失败：工单ID[{}]", requestId, e);
            return new ImmediateDispatchResult(false, "派单过程中发生异常：" + e.getMessage());
        }
    }

    /**
     * 检查并处理待派单的工单
     * 定时任务调用，确保没有遗漏的工单
     */
    public void checkAndProcessPendingRequests() {
        try {
            logger.info("开始检查待派单工单");

            // 查询所有待派单的工单
            DormRepairRequest queryRequest = new DormRepairRequest();
            queryRequest.setStatus("0"); // 待派单
            
            List<DormRepairRequest> pendingRequests = repairRequestService.selectDormRepairRequestList(queryRequest);

            int processedCount = 0;
            for (DormRepairRequest request : pendingRequests) {
                // 检查工单创建时间，如果超过5分钟还未派单，则重新触发派单
                long createTime = request.getCreateTime().getTime();
                long currentTime = System.currentTimeMillis();
                long diffMinutes = (currentTime - createTime) / (1000 * 60);

                if (diffMinutes >= 5) {
                    logger.info("发现超时未派单的工单：[{}]，创建时间：{}，准备重新派单", 
                               request.getRequestNo(), request.getCreateTime());

                    // 发送重新派单消息
                    SmartDispatchMessage redispatchMessage = new SmartDispatchMessage(
                        request.getRequestId(),
                        request.getRequestNo(),
                        request.getSpecialty(),
                        "RETRY"
                    );
                    messageProducer.sendSmartDispatchMessage(redispatchMessage);
                    
                    processedCount++;
                }
            }

            if (processedCount > 0) {
                logger.info("检查待派单工单完成，重新派单{}个工单", processedCount);
            }

        } catch (Exception e) {
            logger.error("检查待派单工单失败", e);
        }
    }

    /**
     * 提交结果类
     */
    public static class SubmitResult {
        private boolean success;
        private String message;
        private String requestNo;

        public SubmitResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public SubmitResult(boolean success, String message, String requestNo) {
            this.success = success;
            this.message = message;
            this.requestNo = requestNo;
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public String getRequestNo() {
            return requestNo;
        }

        public void setRequestNo(String requestNo) {
            this.requestNo = requestNo;
        }
    }

    /**
     * 立即派单结果类
     */
    public static class ImmediateDispatchResult {
        private boolean success;
        private String message;
        private String repairerName;
        private int candidateCount;

        public ImmediateDispatchResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public ImmediateDispatchResult(boolean success, String message, String repairerName, int candidateCount) {
            this.success = success;
            this.message = message;
            this.repairerName = repairerName;
            this.candidateCount = candidateCount;
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public String getRepairerName() {
            return repairerName;
        }

        public void setRepairerName(String repairerName) {
            this.repairerName = repairerName;
        }

        public int getCandidateCount() {
            return candidateCount;
        }

        public void setCandidateCount(int candidateCount) {
            this.candidateCount = candidateCount;
        }
    }
}
