package com.dorm.manage.constants;

/**
 * 报修工单状态常量
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
public class RepairRequestStatus {
    
    /** 待派单 */
    public static final String PENDING = "0";
    
    /** 已派单 */
    public static final String ASSIGNED = "1";
    
    /** 维修中 */
    public static final String IN_PROGRESS = "2";
    
    /** 已完成 */
    public static final String COMPLETED = "3";
    
    /** 已取消 */
    public static final String CANCELLED = "4";
    
    /**
     * 获取状态描述
     * 
     * @param status 状态值
     * @return 状态描述
     */
    public static String getStatusDesc(String status) {
        switch (status) {
            case PENDING:
                return "待派单";
            case ASSIGNED:
                return "已派单";
            case IN_PROGRESS:
                return "维修中";
            case COMPLETED:
                return "已完成";
            case CANCELLED:
                return "已取消";
            default:
                return "未知状态";
        }
    }
    
    /**
     * 验证状态值是否有效
     * 
     * @param status 状态值
     * @return 是否有效
     */
    public static boolean isValidStatus(String status) {
        return PENDING.equals(status) || 
               ASSIGNED.equals(status) || 
               IN_PROGRESS.equals(status) || 
               COMPLETED.equals(status) || 
               CANCELLED.equals(status);
    }
    
    /**
     * 检查状态是否可以取消
     * 只有待派单和已派单状态可以取消
     * 
     * @param status 当前状态
     * @return 是否可以取消
     */
    public static boolean canCancel(String status) {
        return PENDING.equals(status) || ASSIGNED.equals(status);
    }
    
    /**
     * 检查状态是否可以编辑
     * 只有待派单状态可以编辑
     * 
     * @param status 当前状态
     * @return 是否可以编辑
     */
    public static boolean canEdit(String status) {
        return PENDING.equals(status);
    }
}
