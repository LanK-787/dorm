-- ===================================================================
-- 修复离校申请表时间字段数据类型脚本
-- 作者: AI助手
-- 日期: 2025-06-19
-- 描述: 确保 dorm_student_leave 表的所有时间字段都是 DATETIME 类型
-- ===================================================================

-- 1. 检查当前 dorm_student_leave 表的时间字段类型
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'dorm_student_leave'
  AND COLUMN_NAME IN ('leave_time', 'expected_return_time', 'actual_return_time', 'approve_time', 'create_time', 'update_time')
ORDER BY ORDINAL_POSITION;

-- 2. 如果字段是 DATE 类型，修改为 DATETIME 类型
-- 注意：在执行前请先备份数据！

-- 修改离校时间字段
ALTER TABLE `dorm_student_leave` 
MODIFY COLUMN `leave_time` datetime DEFAULT NULL COMMENT '离校时间';

-- 修改预计返校时间字段
ALTER TABLE `dorm_student_leave` 
MODIFY COLUMN `expected_return_time` datetime DEFAULT NULL COMMENT '预计返校时间';

-- 修改实际返校时间字段
ALTER TABLE `dorm_student_leave` 
MODIFY COLUMN `actual_return_time` datetime DEFAULT NULL COMMENT '实际返校时间';

-- 修改审批时间字段
ALTER TABLE `dorm_student_leave` 
MODIFY COLUMN `approve_time` datetime DEFAULT NULL COMMENT '审批时间';

-- 修改创建时间字段（如果需要）
ALTER TABLE `dorm_student_leave` 
MODIFY COLUMN `create_time` datetime DEFAULT NULL COMMENT '创建时间';

-- 修改更新时间字段（如果需要）
ALTER TABLE `dorm_student_leave` 
MODIFY COLUMN `update_time` datetime DEFAULT NULL COMMENT '更新时间';

-- 3. 验证修改结果
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'dorm_student_leave'
  AND COLUMN_NAME LIKE '%time%'
  AND DATA_TYPE IN ('date', 'datetime', 'timestamp')
ORDER BY ORDINAL_POSITION;

-- 4. 测试数据插入（可选）
-- INSERT INTO dorm_student_leave (student_no, leave_time, expected_return_time, approve_time, create_time) 
-- VALUES (20250001, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), NOW(), NOW());

-- 5. 查看测试数据的时间格式
-- SELECT 
--     student_no,
--     leave_time,
--     expected_return_time, 
--     approve_time,
--     create_time
-- FROM dorm_student_leave 
-- WHERE student_no = 20250001;
