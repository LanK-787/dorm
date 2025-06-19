-- ===================================================================
-- 智能维修派单系统数据库表结构优化脚本
-- 作者: AI助手
-- 日期: 2025-06-18
-- 描述: 为支持智能派单功能，对现有数据库表进行结构优化
-- ===================================================================

-- 1. 为 dorm_repair_request 表添加派单尝试次数字段
ALTER TABLE `dorm_repair_request` 
ADD COLUMN `attempt_count` int(11) DEFAULT 0 COMMENT '派单尝试次数' AFTER `status`;

-- 2. 更新 dorm_repair_request 表状态字段注释，添加新状态
ALTER TABLE `dorm_repair_request` 
MODIFY COLUMN `status` varchar(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '0' COMMENT '状态（0-待派单，1-已派单，2-维修中，3-已完成，4-已取消，5-等待人工派单）';

-- 3. 为 dorm_repair_assignment 表添加必要索引以优化查询性能
-- 为工单ID添加索引
CREATE INDEX `idx_request_id` ON `dorm_repair_assignment` (`request_id`);

-- 为维修人员ID添加索引
CREATE INDEX `idx_repairer_id` ON `dorm_repair_assignment` (`repairer_id`);

-- 为处理状态添加索引
CREATE INDEX `idx_process_status` ON `dorm_repair_assignment` (`process_status`);

-- 为分配时间添加索引
CREATE INDEX `idx_assign_time` ON `dorm_repair_assignment` (`assign_time`);

-- 复合索引：维修人员ID + 处理状态（用于查询维修人员的待处理派单）
CREATE INDEX `idx_repairer_status` ON `dorm_repair_assignment` (`repairer_id`, `process_status`);

-- 复合索引：工单ID + 处理状态（用于查询工单的派单历史）
CREATE INDEX `idx_request_status` ON `dorm_repair_assignment` (`request_id`, `process_status`);

-- 4. 为 dorm_repairer 表添加必要索引
-- 为用户ID添加索引
CREATE INDEX `idx_user_id` ON `dorm_repairer` (`user_id`);

-- 为状态添加索引
CREATE INDEX `idx_status` ON `dorm_repairer` (`status`);

-- 为专长领域添加索引
CREATE INDEX `idx_specialty` ON `dorm_repairer` (`specialty`);

-- 复合索引：状态 + 专长领域 + 接单数量（用于智能派单算法）
CREATE INDEX `idx_status_specialty_order` ON `dorm_repairer` (`status`, `specialty`, `order_count`);

-- 5. 为 dorm_repair_request 表添加必要索引
-- 为状态添加索引
CREATE INDEX `idx_status` ON `dorm_repair_request` (`status`);

-- 为专长领域添加索引
CREATE INDEX `idx_specialty` ON `dorm_repair_request` (`specialty`);

-- 为创建时间添加索引
CREATE INDEX `idx_create_time` ON `dorm_repair_request` (`create_time`);

-- 复合索引：状态 + 专长领域（用于智能派单查询）
CREATE INDEX `idx_status_specialty` ON `dorm_repair_request` (`status`, `specialty`);

-- 6. 创建智能派单锁表（用于分布式锁）
CREATE TABLE IF NOT EXISTS `dorm_repair_dispatch_lock` (
  `lock_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '锁ID',
  `request_id` bigint(20) NOT NULL COMMENT '工单ID',
  `lock_key` varchar(100) NOT NULL COMMENT '锁键值',
  `lock_value` varchar(100) NOT NULL COMMENT '锁值',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`lock_id`),
  UNIQUE KEY `uk_lock_key` (`lock_key`),
  KEY `idx_request_id` (`request_id`),
  KEY `idx_expire_time` (`expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='智能派单分布式锁表';

-- 7. 创建派单历史记录表（用于统计和分析）
CREATE TABLE IF NOT EXISTS `dorm_repair_dispatch_history` (
  `history_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '历史记录ID',
  `request_id` bigint(20) NOT NULL COMMENT '工单ID',
  `request_no` varchar(50) NOT NULL COMMENT '工单编号',
  `specialty` varchar(10) NOT NULL COMMENT '维修项目',
  `dispatch_type` varchar(10) NOT NULL COMMENT '派单类型（AUTO-自动派单，MANUAL-人工派单，RETRY-重新派单）',
  `selected_repairer_id` bigint(20) DEFAULT NULL COMMENT '选中的维修人员ID',
  `selected_repairer_name` varchar(50) DEFAULT NULL COMMENT '选中的维修人员姓名',
  `candidate_count` int(11) DEFAULT 0 COMMENT '候选维修人员数量',
  `dispatch_result` varchar(10) NOT NULL COMMENT '派单结果（SUCCESS-成功，FAILED-失败）',
  `failure_reason` varchar(200) DEFAULT NULL COMMENT '失败原因',
  `dispatch_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '派单时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`history_id`),
  KEY `idx_request_id` (`request_id`),
  KEY `idx_request_no` (`request_no`),
  KEY `idx_dispatch_time` (`dispatch_time`),
  KEY `idx_dispatch_type` (`dispatch_type`),
  KEY `idx_dispatch_result` (`dispatch_result`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='派单历史记录表';

-- 8. 初始化数据：将现有工单的派单尝试次数设置为默认值
UPDATE `dorm_repair_request` SET `attempt_count` = 0 WHERE `attempt_count` IS NULL;

-- 9. 创建存储过程：清理过期的分布式锁
DELIMITER $$
CREATE PROCEDURE `CleanExpiredDispatchLocks`()
BEGIN
    DELETE FROM `dorm_repair_dispatch_lock` 
    WHERE `expire_time` < NOW();
END$$
DELIMITER ;

-- 10. 创建定时任务清理过期锁（需要开启事件调度器）
-- SET GLOBAL event_scheduler = ON;
-- CREATE EVENT IF NOT EXISTS `evt_clean_expired_locks`
-- ON SCHEDULE EVERY 5 MINUTE
-- DO
--   CALL CleanExpiredDispatchLocks();

-- ===================================================================
-- 表结构优化完成
-- ===================================================================
