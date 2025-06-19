package com.dorm.manage.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dorm.manage.mapper.DormRepairRequestMapper;
import com.dorm.manage.service.IRepairRequestNoService;

/**
 * 报修工单编号生成服务实现
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@Service
public class RepairRequestNoServiceImpl implements IRepairRequestNoService 
{
    @Autowired
    private DormRepairRequestMapper dormRepairRequestMapper;
    
    // 用于存储每日计数器的线程安全Map
    private static final ConcurrentHashMap<String, AtomicInteger> dailyCounters = new ConcurrentHashMap<>();
    
    // 工单编号格式验证正则表达式
    private static final Pattern REQUEST_NO_PATTERN = Pattern.compile("^REQ\\d{8}\\d{4}$");
    
    /**
     * 生成下一个报修工单编号
     * 
     * @return 工单编号
     */
    @Override
    @Transactional
    public synchronized String generateNextRequestNo() {
        LocalDateTime now = LocalDateTime.now();
        String dateKey = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        
        // 获取或创建当日计数器
        AtomicInteger counter = dailyCounters.computeIfAbsent(dateKey, k -> {
            // 查询数据库中当日最大序列号，确保重启后序列号连续
            int maxSequence = getMaxSequenceForDate(dateKey);
            return new AtomicInteger(maxSequence);
        });
        
        // 获取下一个序列号
        int sequence = counter.incrementAndGet();
        
        // 生成工单编号：REQ + 日期 + 4位序列号
        String requestNo = String.format("REQ%s%04d", dateKey, sequence);
        
        // 清理过期的计数器（保留最近3天的数据）
        cleanupOldCounters();
        
        return requestNo;
    }
    
    /**
     * 验证工单编号格式是否正确
     * 
     * @param requestNo 工单编号
     * @return 是否有效
     */
    @Override
    public boolean isValidRequestNo(String requestNo) {
        if (requestNo == null || requestNo.trim().isEmpty()) {
            return false;
        }
        return REQUEST_NO_PATTERN.matcher(requestNo.trim()).matches();
    }
    
    /**
     * 获取指定日期的最大序列号
     * 
     * @param dateKey 日期键（YYYYMMDD）
     * @return 最大序列号
     */
    private int getMaxSequenceForDate(String dateKey) {
        try {
            // 查询当日最大工单编号
            String maxRequestNo = dormRepairRequestMapper.selectMaxRequestNoByDate(dateKey);
            if (maxRequestNo != null && maxRequestNo.startsWith("REQ" + dateKey)) {
                // 提取序列号部分
                String sequencePart = maxRequestNo.substring(11); // REQ + 8位日期 = 11位
                return Integer.parseInt(sequencePart);
            }
        } catch (Exception e) {
            // 如果查询失败，从0开始
            System.err.println("查询最大序列号失败，从0开始: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * 清理过期的计数器
     */
    private void cleanupOldCounters() {
        LocalDateTime threeDaysAgo = LocalDateTime.now().minusDays(3);
        String cutoffDate = threeDaysAgo.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        
        // 移除3天前的计数器
        dailyCounters.entrySet().removeIf(entry -> entry.getKey().compareTo(cutoffDate) < 0);
    }
}
