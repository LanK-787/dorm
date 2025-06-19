-- 修复报修工单编号自动生成问题
-- 作者：AI助手
-- 日期：2025-06-18

-- 方案1：修改字段为可空，允许后端自动生成
ALTER TABLE `dorm_repair_request` 
MODIFY COLUMN `request_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工单编号（自动生成）';

-- 方案2：创建序列表用于生成唯一编号（推荐）
CREATE TABLE IF NOT EXISTS `dorm_repair_sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序列ID',
  `date_key` varchar(8) NOT NULL COMMENT '日期键（YYYYMMDD）',
  `sequence_no` int(11) NOT NULL DEFAULT 1 COMMENT '当日序列号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_key` (`date_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报修工单序列号表';

-- 插入今日初始序列
INSERT INTO `dorm_repair_sequence` (`date_key`, `sequence_no`) 
VALUES (DATE_FORMAT(NOW(), '%Y%m%d'), 1)
ON DUPLICATE KEY UPDATE `sequence_no` = `sequence_no`;

-- 创建获取下一个序列号的存储过程
DELIMITER $$

CREATE PROCEDURE `GetNextRepairRequestNo`(OUT next_request_no VARCHAR(30))
BEGIN
    DECLARE current_date_key VARCHAR(8);
    DECLARE current_sequence INT;
    
    -- 获取当前日期键
    SET current_date_key = DATE_FORMAT(NOW(), '%Y%m%d');
    
    -- 获取并更新序列号（原子操作）
    INSERT INTO `dorm_repair_sequence` (`date_key`, `sequence_no`) 
    VALUES (current_date_key, 1)
    ON DUPLICATE KEY UPDATE `sequence_no` = `sequence_no` + 1;
    
    -- 获取当前序列号
    SELECT `sequence_no` INTO current_sequence 
    FROM `dorm_repair_sequence` 
    WHERE `date_key` = current_date_key;
    
    -- 生成工单编号：REQ + 日期 + 4位序列号
    SET next_request_no = CONCAT('REQ', current_date_key, LPAD(current_sequence, 4, '0'));
    
END$$

DELIMITER ;

-- 测试存储过程（可选）
-- CALL GetNextRepairRequestNo(@test_no);
-- SELECT @test_no AS test_request_no;
