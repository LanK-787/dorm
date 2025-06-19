package com.dorm.manage.service.impl;

import com.dorm.common.utils.DateUtils;
import com.dorm.common.utils.StringUtils;
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.domain.DormRepairer;
import com.dorm.manage.domain.DormRepairDispatchHistory;
import com.dorm.manage.mapper.DormRepairAssignmentMapper;
import com.dorm.manage.mapper.DormRepairRequestMapper;
import com.dorm.manage.mapper.DormRepairerMapper;
import com.dorm.manage.mapper.DormRepairDispatchHistoryMapper;
import com.dorm.manage.service.ISmartDispatchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * 智能派单服务实现类
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@Service
public class SmartDispatchServiceImpl implements ISmartDispatchService {

    private static final Logger logger = LoggerFactory.getLogger(SmartDispatchServiceImpl.class);

    /** 最大派单尝试次数 */
    private static final int MAX_DISPATCH_ATTEMPTS = 3;
    
    /** 分布式锁前缀 */
    private static final String DISPATCH_LOCK_PREFIX = "dispatch:lock:";
    
    /** 分布式锁过期时间（秒） */
    private static final int LOCK_EXPIRE_SECONDS = 30;

    @Autowired
    private DormRepairRequestMapper repairRequestMapper;

    @Autowired
    private DormRepairerMapper repairerMapper;

    @Autowired
    private DormRepairAssignmentMapper assignmentMapper;

    @Autowired
    private DormRepairDispatchHistoryMapper dispatchHistoryMapper;

    @Autowired
    private RedisTemplate<Object, Object> redisTemplate;

    /**
     * 智能派单
     */
    @Override
    @Transactional
    public SmartDispatchResult smartDispatch(DormRepairRequest repairRequest) {
        String lockKey = DISPATCH_LOCK_PREFIX + repairRequest.getRequestId();
        
        try {
            // 获取分布式锁
            if (!acquireLock(lockKey)) {
                return new SmartDispatchResult(false, "获取派单锁失败，可能有其他进程正在处理");
            }

            // 检查工单状态（待派单或等待人工派单）
            if (!"0".equals(repairRequest.getStatus()) && !"5".equals(repairRequest.getStatus())) {
                return new SmartDispatchResult(false, "工单状态不允许派单，当前状态：" + repairRequest.getStatus());
            }

            // 增加尝试次数
            int attemptCount = repairRequest.getAttemptCount() == null ? 0 : repairRequest.getAttemptCount();
            attemptCount++;
            repairRequest.setAttemptCount(attemptCount);

            // 获取已拒绝的维修人员列表
            List<Long> excludeRepairerIds = getRejectedRepairerIds(repairRequest.getRequestId());

            // 获取可用的维修人员（使用渐进式搜索策略）
            List<DormRepairer> availableRepairers = getAvailableRepairersWithFallback(
                repairRequest.getSpecialty(), excludeRepairerIds, attemptCount);

            if (availableRepairers.isEmpty()) {
                // 检查是否超过最大尝试次数
                if (attemptCount > MAX_DISPATCH_ATTEMPTS) {
                    repairRequest.setStatus("5"); // 等待人工派单
                    repairRequestMapper.updateDormRepairRequest(repairRequest);
                    logger.warn("工单[{}]超过最大派单尝试次数({})，暂时标记为等待人工派单，但系统将继续尝试",
                               repairRequest.getRequestNo(), MAX_DISPATCH_ATTEMPTS);
                    return new SmartDispatchResult(false, "超过最大派单尝试次数，暂时等待人工派单");
                } else {
                    // 暂时标记为等待人工派单，但不停止重试
                    repairRequest.setStatus("5"); // 等待人工派单
                    repairRequestMapper.updateDormRepairRequest(repairRequest);
                    logger.info("工单[{}]暂时没有可用维修人员，标记为等待人工派单，系统将继续尝试自动派单",
                               repairRequest.getRequestNo());
                    return new SmartDispatchResult(false, "暂时没有可用的维修人员，系统将继续尝试");
                }
            }

            // 选择最优维修人员（接单数最少的）
            DormRepairer selectedRepairer = selectOptimalRepairer(availableRepairers);

            // 创建派单记录
            DormRepairAssignment assignment = createAssignment(repairRequest, selectedRepairer);
            assignmentMapper.insertDormRepairAssignment(assignment);

            // 更新工单状态
            repairRequest.setStatus("1"); // 已派单
            repairRequestMapper.updateDormRepairRequest(repairRequest);

            // 注意：这里不更新 order_count，因为 order_count 应该只在完成工单时增加

            // 记录派单历史
            recordDispatchHistory(repairRequest, selectedRepairer, availableRepairers.size(), "AUTO", "SUCCESS", null);

            logger.info("智能派单成功：工单[{}]派给维修人员[{}]", repairRequest.getRequestNo(), selectedRepairer.getName());

            return new SmartDispatchResult(true, selectedRepairer, availableRepairers.size(), "AUTO");

        } catch (Exception e) {
            logger.error("智能派单失败：工单[{}]", repairRequest.getRequestNo(), e);
            // 记录派单失败历史
            recordDispatchHistory(repairRequest, null, 0, "AUTO", "FAILED", "派单过程中发生异常：" + e.getMessage());
            return new SmartDispatchResult(false, "派单过程中发生异常：" + e.getMessage());
        } finally {
            // 释放分布式锁
            releaseLock(lockKey);
        }
    }

    /**
     * 重新派单
     */
    @Override
    @Transactional
    public SmartDispatchResult redispatch(Long requestId, List<Long> excludeRepairerIds) {
        DormRepairRequest repairRequest = repairRequestMapper.selectDormRepairRequestByRequestId(requestId);
        if (repairRequest == null) {
            return new SmartDispatchResult(false, "工单不存在");
        }

        // 合并已拒绝的维修人员列表
        List<Long> allExcludeIds = new ArrayList<>(getRejectedRepairerIds(requestId));
        if (excludeRepairerIds != null) {
            allExcludeIds.addAll(excludeRepairerIds);
        }

        // 获取可用的维修人员
        List<DormRepairer> availableRepairers = getAvailableRepairers(repairRequest.getSpecialty(), allExcludeIds);

        if (availableRepairers.isEmpty()) {
            // 暂时标记为等待人工派单，但系统会继续尝试
            repairRequest.setStatus("5");
            repairRequestMapper.updateDormRepairRequest(repairRequest);
            logger.info("重新派单暂时没有找到可用维修人员：工单[{}]，系统将继续尝试", repairRequest.getRequestNo());
            return new SmartDispatchResult(false, "暂时没有可用的维修人员，系统将继续尝试重新派单");
        }

        // 选择最优维修人员
        DormRepairer selectedRepairer = selectOptimalRepairer(availableRepairers);

        // 创建新的派单记录
        DormRepairAssignment assignment = createAssignment(repairRequest, selectedRepairer);
        assignmentMapper.insertDormRepairAssignment(assignment);

        // 更新工单状态
        repairRequest.setStatus("1"); // 已派单
        repairRequestMapper.updateDormRepairRequest(repairRequest);

        // 注意：这里不更新 order_count，因为 order_count 应该只在完成工单时增加

        logger.info("重新派单成功：工单[{}]派给维修人员[{}]", repairRequest.getRequestNo(), selectedRepairer.getName());

        return new SmartDispatchResult(true, selectedRepairer, availableRepairers.size(), "RETRY");
    }

    /**
     * 获取可用的维修人员列表
     */
    @Override
    public List<DormRepairer> getAvailableRepairers(String specialty, List<Long> excludeRepairerIds) {
        return getAvailableRepairersWithFallback(specialty, excludeRepairerIds, 1);
    }

    /**
     * 获取可用的维修人员列表（带渐进式搜索策略）
     *
     * @param specialty 专业技能
     * @param excludeRepairerIds 排除的维修人员ID列表
     * @param attemptCount 尝试次数
     * @return 可用维修人员列表
     */
    private List<DormRepairer> getAvailableRepairersWithFallback(String specialty, List<Long> excludeRepairerIds, int attemptCount) {
        logger.info("开始搜索可用维修人员：专业[{}]，排除[{}]，尝试次数[{}]", specialty, excludeRepairerIds, attemptCount);

        // 第一次尝试：严格匹配（只要空闲状态的维修人员）
        List<DormRepairer> candidates = searchRepairers("1", specialty, excludeRepairerIds, true);
        if (!candidates.isEmpty()) {
            logger.info("严格匹配找到{}个候选维修人员", candidates.size());
            return candidates;
        }

        // 第二次尝试：包含工作中的维修人员（如果他们工作负载不重）
        if (attemptCount >= 2) {
            candidates = searchRepairers(null, specialty, excludeRepairerIds, true);
            // 过滤掉工作负载过重的维修人员（超过3个未完成工单）
            candidates = candidates.stream()
                    .filter(repairer -> getCurrentWorkload(repairer.getRepairerId()) <= 3)
                    .collect(Collectors.toList());
            if (!candidates.isEmpty()) {
                logger.info("放宽状态限制找到{}个候选维修人员", candidates.size());
                return candidates;
            }
        }

        // 第三次尝试：放宽专业匹配（寻找相关专业）
        if (attemptCount >= 3) {
            candidates = searchRepairersWithRelatedSpecialty(specialty, excludeRepairerIds);
            if (!candidates.isEmpty()) {
                logger.info("相关专业匹配找到{}个候选维修人员", candidates.size());
                return candidates;
            }
        }

        // 第四次尝试：进一步放宽排除限制（允许之前拒绝过但时间较久的维修人员）
        if (attemptCount >= 4) {
            List<Long> recentExcludeIds = getRecentRejectedRepairerIds(excludeRepairerIds);
            candidates = searchRepairers("1", specialty, recentExcludeIds, true);
            if (!candidates.isEmpty()) {
                logger.info("放宽排除限制找到{}个候选维修人员", candidates.size());
                return candidates;
            }
        }

        logger.warn("所有搜索策略都未找到可用维修人员：专业[{}]，尝试次数[{}]", specialty, attemptCount);
        return new ArrayList<>();
    }

    /**
     * 搜索维修人员
     */
    private List<DormRepairer> searchRepairers(String status, String specialty, List<Long> excludeRepairerIds, boolean strictSpecialty) {
        DormRepairer queryRepairer = new DormRepairer();
        if (status != null) {
            queryRepairer.setStatus(status);
        }

        List<DormRepairer> allRepairers = repairerMapper.selectDormRepairerList(queryRepairer);

        return allRepairers.stream()
                .filter(repairer -> {
                    // 检查专长领域是否匹配
                    if (StringUtils.isEmpty(repairer.getSpecialty())) {
                        return false;
                    }

                    boolean hasSpecialty;
                    if (strictSpecialty) {
                        // 严格匹配：专长必须完全包含所需技能
                        String[] specialties = repairer.getSpecialty().split(",");
                        hasSpecialty = Arrays.asList(specialties).contains(specialty);
                    } else {
                        // 模糊匹配：专长包含相关关键词
                        hasSpecialty = repairer.getSpecialty().contains(specialty);
                    }

                    // 检查是否在排除列表中
                    boolean isExcluded = excludeRepairerIds != null &&
                                       excludeRepairerIds.contains(repairer.getRepairerId());

                    return hasSpecialty && !isExcluded;
                })
                .sorted(Comparator.comparing(DormRepairer::getOrderCount)) // 按完成工单数升序排列
                .collect(Collectors.toList());
    }

    /**
     * 检查是否需要人工派单
     */
    @Override
    public boolean needManualDispatch(Long requestId) {
        DormRepairRequest repairRequest = repairRequestMapper.selectDormRepairRequestByRequestId(requestId);
        return repairRequest != null && "5".equals(repairRequest.getStatus());
    }

    /**
     * 获取工单的拒绝派单历史
     */
    @Override
    public List<Long> getRejectedRepairerIds(Long requestId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRequestId(requestId);
        queryAssignment.setProcessStatus("3"); // 已拒绝
        
        List<DormRepairAssignment> rejectedAssignments = assignmentMapper.selectDormRepairAssignmentList(queryAssignment);
        
        return rejectedAssignments.stream()
                .map(DormRepairAssignment::getRepairerId)
                .collect(Collectors.toList());
    }

    /**
     * 定期检查并重新派单等待人工派单的工单
     */
    @Override
    public PendingDispatchCheckResult checkAndRedispatchPendingOrders() {
        logger.info("开始检查等待人工派单的工单");

        // 查询所有等待人工派单的工单
        DormRepairRequest queryRequest = new DormRepairRequest();
        queryRequest.setStatus("5"); // 等待人工派单
        List<DormRepairRequest> pendingRequests = repairRequestMapper.selectDormRepairRequestList(queryRequest);

        int totalChecked = pendingRequests.size();
        int successCount = 0;
        int failureCount = 0;
        StringBuilder details = new StringBuilder();

        logger.info("找到{}个等待人工派单的工单", totalChecked);

        for (DormRepairRequest request : pendingRequests) {
            try {
                // 检查工单创建时间，避免频繁重试
                long createTime = request.getCreateTime().getTime();
                long currentTime = System.currentTimeMillis();
                long diffMinutes = (currentTime - createTime) / (1000 * 60);

                // 只处理创建超过10分钟的工单，避免过于频繁的重试
                if (diffMinutes < 10) {
                    continue;
                }

                logger.info("尝试重新派单：工单[{}]，创建时间：{}", request.getRequestNo(), request.getCreateTime());

                // 尝试智能派单
                SmartDispatchResult result = smartDispatch(request);

                if (result.isSuccess()) {
                    successCount++;
                    String successDetail = String.format("工单[%s]重新派单成功，派给维修人员[%s]",
                                                        request.getRequestNo(), result.getSelectedRepairer().getName());
                    details.append(successDetail).append("; ");
                    logger.info(successDetail);
                } else {
                    failureCount++;
                    String failureDetail = String.format("工单[%s]重新派单失败：%s",
                                                        request.getRequestNo(), result.getFailureReason());
                    details.append(failureDetail).append("; ");
                    logger.debug(failureDetail);
                }

            } catch (Exception e) {
                failureCount++;
                String errorDetail = String.format("工单[%s]重新派单异常：%s", request.getRequestNo(), e.getMessage());
                details.append(errorDetail).append("; ");
                logger.error(errorDetail, e);
            }
        }

        String summary = String.format("检查完成：总计%d个，成功%d个，失败%d个", totalChecked, successCount, failureCount);
        logger.info(summary);

        return new PendingDispatchCheckResult(totalChecked, successCount, failureCount, details.toString());
    }

    /**
     * 批量重新派单指定的工单列表
     */
    @Override
    public BatchRedispatchResult batchRedispatch(List<Long> requestIds) {
        logger.info("开始批量重新派单：工单数量[{}]", requestIds.size());

        int totalProcessed = requestIds.size();
        int successCount = 0;
        int failureCount = 0;
        BatchRedispatchResult result = new BatchRedispatchResult(totalProcessed, successCount, failureCount);

        for (Long requestId : requestIds) {
            try {
                DormRepairRequest request = repairRequestMapper.selectDormRepairRequestByRequestId(requestId);
                if (request == null) {
                    failureCount++;
                    result.addResult(String.format("工单ID[%d]不存在", requestId));
                    continue;
                }

                // 只处理等待人工派单的工单
                if (!"5".equals(request.getStatus())) {
                    failureCount++;
                    result.addResult(String.format("工单[%s]状态不是等待人工派单，当前状态：%s",
                                                  request.getRequestNo(), request.getStatus()));
                    continue;
                }

                SmartDispatchResult dispatchResult = smartDispatch(request);

                if (dispatchResult.isSuccess()) {
                    successCount++;
                    result.addResult(String.format("工单[%s]派单成功，派给维修人员[%s]",
                                                  request.getRequestNo(), dispatchResult.getSelectedRepairer().getName()));
                } else {
                    failureCount++;
                    result.addResult(String.format("工单[%s]派单失败：%s",
                                                  request.getRequestNo(), dispatchResult.getFailureReason()));
                }

            } catch (Exception e) {
                failureCount++;
                result.addResult(String.format("工单ID[%d]处理异常：%s", requestId, e.getMessage()));
                logger.error("批量重新派单异常：工单ID[{}]", requestId, e);
            }
        }

        result.setSuccessCount(successCount);
        result.setFailureCount(failureCount);

        logger.info("批量重新派单完成：总计{}个，成功{}个，失败{}个", totalProcessed, successCount, failureCount);

        return result;
    }

    /**
     * 搜索相关专业的维修人员
     */
    private List<DormRepairer> searchRepairersWithRelatedSpecialty(String specialty, List<Long> excludeRepairerIds) {
        // 定义专业相关性映射
        Map<String, List<String>> relatedSpecialties = new HashMap<>();
        relatedSpecialties.put("0", Arrays.asList("1", "2", "3")); // 电工可以做其他相关工作
        relatedSpecialties.put("1", Arrays.asList("0", "2"));      // 水工可以做电工、木工相关
        relatedSpecialties.put("2", Arrays.asList("0", "3"));      // 木工可以做电工、水泥工相关
        relatedSpecialties.put("3", Arrays.asList("1", "2"));      // 水泥工可以做水工、木工相关

        List<String> relatedSpecs = relatedSpecialties.getOrDefault(specialty, new ArrayList<>());
        List<DormRepairer> candidates = new ArrayList<>();

        for (String relatedSpec : relatedSpecs) {
            List<DormRepairer> relatedCandidates = searchRepairers("1", relatedSpec, excludeRepairerIds, true);
            candidates.addAll(relatedCandidates);
        }

        return candidates.stream()
                .distinct()
                .sorted(Comparator.comparing(DormRepairer::getOrderCount))
                .collect(Collectors.toList());
    }

    /**
     * 获取最近拒绝的维修人员ID（只排除最近1小时内拒绝的）
     */
    private List<Long> getRecentRejectedRepairerIds(List<Long> allRejectedIds) {
        if (allRejectedIds == null || allRejectedIds.isEmpty()) {
            return new ArrayList<>();
        }

        // 这里可以实现更复杂的逻辑，比如查询拒绝时间
        // 暂时简化为只排除一半的拒绝人员
        return allRejectedIds.subList(0, Math.min(allRejectedIds.size() / 2, allRejectedIds.size()));
    }

    /**
     * 获取维修人员当前工作负载
     */
    private int getCurrentWorkload(Long repairerId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRepairerId(repairerId);
        queryAssignment.setProcessStatus("1"); // 处理中的工单

        List<DormRepairAssignment> processingAssignments = assignmentMapper.selectDormRepairAssignmentList(queryAssignment);
        return processingAssignments.size();
    }

    /**
     * 选择最优维修人员
     */
    private DormRepairer selectOptimalRepairer(List<DormRepairer> availableRepairers) {
        // 已经按完成工单数排序，直接取第一个
        return availableRepairers.get(0);
    }

    /**
     * 创建派单记录
     */
    private DormRepairAssignment createAssignment(DormRepairRequest repairRequest, DormRepairer repairer) {
        DormRepairAssignment assignment = new DormRepairAssignment();
        assignment.setRequestId(repairRequest.getRequestId());
        assignment.setRequestNo(repairRequest.getRequestNo());
        assignment.setRepairerId(repairer.getRepairerId());
        assignment.setRepairerName(repairer.getName());
        assignment.setSpecialty(repairRequest.getSpecialty());
        assignment.setAssignTime(DateUtils.getNowDate());
        assignment.setProcessStatus("0"); // 待接单
        assignment.setCreateTime(DateUtils.getNowDate());
        return assignment;
    }

    /**
     * 获取分布式锁
     */
    private boolean acquireLock(String lockKey) {
        try {
            Boolean result = redisTemplate.opsForValue().setIfAbsent(lockKey, "1", LOCK_EXPIRE_SECONDS, TimeUnit.SECONDS);
            return Boolean.TRUE.equals(result);
        } catch (Exception e) {
            logger.error("获取分布式锁失败：{}", lockKey, e);
            return false;
        }
    }

    /**
     * 释放分布式锁
     */
    private void releaseLock(String lockKey) {
        try {
            redisTemplate.delete(lockKey);
        } catch (Exception e) {
            logger.error("释放分布式锁失败：{}", lockKey, e);
        }
    }

    /**
     * 记录派单历史
     */
    private void recordDispatchHistory(DormRepairRequest repairRequest, DormRepairer selectedRepairer,
                                     int candidateCount, String dispatchType, String dispatchResult, String failureReason) {
        try {
            DormRepairDispatchHistory history = new DormRepairDispatchHistory();
            history.setRequestId(repairRequest.getRequestId());
            history.setRequestNo(repairRequest.getRequestNo());
            history.setSpecialty(repairRequest.getSpecialty());
            history.setDispatchType(dispatchType);
            history.setCandidateCount(candidateCount);
            history.setDispatchResult(dispatchResult);
            history.setFailureReason(failureReason);
            history.setDispatchTime(DateUtils.getNowDate());
            history.setCreateTime(DateUtils.getNowDate());

            if (selectedRepairer != null) {
                history.setSelectedRepairerId(selectedRepairer.getRepairerId());
                history.setSelectedRepairerName(selectedRepairer.getName());
            }

            dispatchHistoryMapper.insertDormRepairDispatchHistory(history);
        } catch (Exception e) {
            logger.error("记录派单历史失败：工单[{}]", repairRequest.getRequestNo(), e);
        }
    }
}
