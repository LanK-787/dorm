package com.dorm.manage.service;

/**
 * 报修工单编号生成服务接口
 * 
 * @author AI助手
 * @date 2025-06-18
 */
public interface IRepairRequestNoService 
{
    /**
     * 生成下一个报修工单编号
     * 格式：REQ + YYYYMMDD + 4位序列号
     * 例如：REQ202506180001
     * 
     * @return 工单编号
     */
    String generateNextRequestNo();
    
    /**
     * 验证工单编号格式是否正确
     * 
     * @param requestNo 工单编号
     * @return 是否有效
     */
    boolean isValidRequestNo(String requestNo);
}
