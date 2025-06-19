-- ===================================================================
-- 修复时间字段数据类型脚本
-- 作者: AI助手
-- 日期: 2025-06-19
-- 描述: 确保所有时间字段都是 DATETIME 类型而不是 DATE 类型
-- ===================================================================

-- 1. 检查当前 dorm_repair_assignment 表的字段类型
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'dorm_repair_assignment'
  AND COLUMN_NAME IN ('assign_time', 'accept_time', 'complete_time', 'reject_time', 'create_time', 'update_time')
ORDER BY ORDINAL_POSITION;

-- 2. 如果字段是 DATE 类型，修改为 DATETIME 类型
-- 注意：在执行前请先备份数据！

-- 修改分配时间字段
ALTER TABLE `dorm_repair_assignment` 
MODIFY COLUMN `assign_time` datetime DEFAULT NULL COMMENT '分配时间';

-- 修改接单时间字段
ALTER TABLE `dorm_repair_assignment` 
MODIFY COLUMN `accept_time` datetime DEFAULT NULL COMMENT '接单时间';

-- 修改完成时间字段
ALTER TABLE `dorm_repair_assignment` 
MODIFY COLUMN `complete_time` datetime DEFAULT NULL COMMENT '完成时间';

-- 修改拒绝时间字段
ALTER TABLE `dorm_repair_assignment` 
MODIFY COLUMN `reject_time` datetime DEFAULT NULL COMMENT '拒绝时间';

-- 3. 同样检查和修复 dorm_repair_request 表的时间字段
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'dorm_repair_request'
  AND COLUMN_NAME IN ('create_time', 'update_time')
ORDER BY ORDINAL_POSITION;

-- 4. 验证修改结果
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME IN ('dorm_repair_assignment', 'dorm_repair_request')
  AND COLUMN_NAME LIKE '%time%'
  AND DATA_TYPE IN ('date', 'datetime', 'timestamp')
ORDER BY TABLE_NAME, ORDINAL_POSITION;



-- ===================================================================
-- 修复完成
-- 说明：
-- 1. 执行此脚本前请备份数据库
-- 2. 如果字段已经是 DATETIME 类型，ALTER 语句不会产生错误
-- 3. 修改后重启应用服务器以确保更改生效
-- ===================================================================
