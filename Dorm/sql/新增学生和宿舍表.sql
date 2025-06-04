/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80012 (8.0.12)
 Source Host           : localhost:3306
 Source Schema         : ry-vue

 Target Server Type    : MySQL
 Target Server Version : 80012 (8.0.12)
 File Encoding         : 65001

 Date: 04/06/2025 13:43:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dorm_building
-- ----------------------------
DROP TABLE IF EXISTS `dorm_building`;
CREATE TABLE `dorm_building`  (
  `dorm_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '宿舍ID（主键）',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父宿舍ID',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '祖级列表',
  `building_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '宿舍名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `dorm_manager` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '宿管',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '宿舍状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dorm_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 229 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '宿舍表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_building
-- ----------------------------
INSERT INTO `dorm_building` VALUES (100, 0, '0', '瓯江口', 0, '', '', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', '2025-06-04 11:13:25');
INSERT INTO `dorm_building` VALUES (101, 100, '0,100', '人工智能学院', 1, '', '', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', '2025-06-04 11:13:41');
INSERT INTO `dorm_building` VALUES (102, 100, '0,100', '光电制造学院', 2, '', '', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', '2025-06-04 11:13:54');
INSERT INTO `dorm_building` VALUES (103, 101, '0,100,101', '观潮公寓', 1, '', '', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', '2025-06-04 11:16:57');
INSERT INTO `dorm_building` VALUES (204, 103, '0,100,101,103', 'A栋', 0, '李阿姨', '18888645465', NULL, '0', '0', '', NULL, '', '2025-06-04 11:17:20');
INSERT INTO `dorm_building` VALUES (205, 103, '0,100,101,103', 'B栋', 1, '张阿姨', '165151', NULL, '0', '0', '', NULL, '', NULL);
INSERT INTO `dorm_building` VALUES (206, 102, '0,100,102', '听涛公寓', 0, NULL, NULL, NULL, '0', '0', '', NULL, '', NULL);
INSERT INTO `dorm_building` VALUES (207, 206, '0,100,102,206', 'A栋', 0, NULL, NULL, NULL, '0', '0', '', NULL, '', NULL);
INSERT INTO `dorm_building` VALUES (210, 207, '0,100,102,206,207', '1', 1, NULL, NULL, NULL, '0', '2', 'admin', '2025-06-04 12:08:44', '', NULL);
INSERT INTO `dorm_building` VALUES (211, 210, '0,100,102,206,207,210', '1', 1, NULL, NULL, NULL, '0', '2', 'admin', '2025-06-04 12:09:18', 'admin', '2025-06-04 12:09:57');
INSERT INTO `dorm_building` VALUES (212, 204, '0,100,101,103,204', '一楼', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-04 13:29:16', '', NULL);
INSERT INTO `dorm_building` VALUES (213, 212, '0,100,101,103,204,212', '101', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-04 13:29:25', '', NULL);
INSERT INTO `dorm_building` VALUES (214, 103, '0,100,101,103', 'C栋', 2, '刘阿姨', '13888876543', NULL, '0', '0', 'admin', '2025-06-05 08:15:22', '', NULL);
INSERT INTO `dorm_building` VALUES (215, 103, '0,100,101,103', 'D栋', 3, '陈阿姨', '13999912345', NULL, '0', '0', 'admin', '2025-06-05 08:16:10', '', NULL);
INSERT INTO `dorm_building` VALUES (216, 204, '0,100,101,103,204', '二楼', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 09:20:33', '', NULL);
INSERT INTO `dorm_building` VALUES (217, 204, '0,100,101,103,204', '三楼', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 09:21:15', '', NULL);
INSERT INTO `dorm_building` VALUES (218, 205, '0,100,101,103,205', '一楼', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 10:05:18', '', NULL);
INSERT INTO `dorm_building` VALUES (219, 205, '0,100,101,103,205', '二楼', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 10:06:22', '', NULL);
INSERT INTO `dorm_building` VALUES (220, 206, '0,100,102,206', 'B栋', 1, '吴老师', '13555567890', NULL, '0', '0', 'admin', '2025-06-05 11:10:45', '', NULL);
INSERT INTO `dorm_building` VALUES (221, 207, '0,100,102,206,207', '一楼', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 11:30:15', '', NULL);
INSERT INTO `dorm_building` VALUES (222, 207, '0,100,102,206,207', '二楼', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 11:31:20', '', NULL);
INSERT INTO `dorm_building` VALUES (223, 212, '0,100,101,103,204,212', '102', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 13:45:10', '', NULL);
INSERT INTO `dorm_building` VALUES (224, 212, '0,100,101,103,204,212', '103', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 13:45:30', '', NULL);
INSERT INTO `dorm_building` VALUES (225, 216, '0,100,101,103,204,216', '201', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 14:10:15', '', NULL);
INSERT INTO `dorm_building` VALUES (226, 216, '0,100,101,103,204,216', '202', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 14:10:45', '', NULL);
INSERT INTO `dorm_building` VALUES (227, 221, '0,100,102,206,207,221', '101', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 14:30:22', '', NULL);
INSERT INTO `dorm_building` VALUES (228, 221, '0,100,102,206,207,221', '102', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-05 14:31:05', '', NULL);

-- ----------------------------
-- Table structure for dorm_student
-- ----------------------------
DROP TABLE IF EXISTS `dorm_student`;
CREATE TABLE `dorm_student`  (
  `student_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '学生ID，主键',
  `user_id` bigint(20) NOT NULL COMMENT '系统用户ID → sys_user.user_id',
  `student_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生姓名',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '性别（0男 1女）',
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班级名称',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '学生状态（0在校 1离校）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱地址',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '删除标志（0代表存在 2代表删除）',
  `dorm_id` bigint(20) NULL DEFAULT NULL COMMENT '当前宿舍ID → dorm_room.room_id',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`student_id`) USING BTREE,
  UNIQUE INDEX `uk_dorm_student_student_no`(`student_no` ASC) USING BTREE,
  INDEX `idx_dorm_student_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_dorm_student_room`(`dorm_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_student
-- ----------------------------
INSERT INTO `dorm_student` VALUES (1, 101, '20230001', '张三', '0', '计算机科学与技术1班', '13800138001', '0', 'zhangsan@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (2, 102, '20230002', '李四', '0', '计算机科学与技术1班', '13800138002', '0', 'lisi@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (3, 103, '20230003', '王五', '0', '计算机科学与技术1班', '13800138003', '0', 'wangwu@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (4, 104, '20230004', '赵六', '0', '计算机科学与技术1班', '13800138004', '0', 'zhaoliu@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (5, 105, '20230005', '钱七', '0', '计算机科学与技术2班', '13800138005', '0', 'qianqi@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (6, 106, '20230006', '孙八', '0', '计算机科学与技术2班', '13800138006', '0', 'sunba@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (7, 107, '20230007', '周九', '0', '计算机科学与技术2班', '13800138007', '0', 'zhoujiu@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (8, 108, '20230008', '吴十', '0', '计算机科学与技术2班', '13800138008', '0', 'wushi@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (9, 109, '20230009', '郑十一', '0', '软件工程1班', '13800138009', '0', 'zhengshiyi@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (10, 110, '20230010', '王小红', '1', '软件工程1班', '13800138010', '0', 'wangxiaohong@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (11, 111, '20230011', '李小花', '1', '软件工程1班', '13800138011', '0', 'lixiaohua@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (12, 112, '20230012', '张美丽', '1', '软件工程1班', '13800138012', '0', 'zhangmeili@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (13, 113, '20230013', '刘芳', '1', '软件工程1班', '13800138013', '0', 'liufang@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (14, 114, '20230014', '陈静', '1', '软件工程2班', '13800138014', '0', 'chenjing@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (15, 115, '20230015', '杨雪', '1', '软件工程2班', '13800138015', '0', 'yangxue@school.edu', NULL, 213, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (2, 'dorm_building', '宿舍楼表', '', '', 'DormBuilding', 'tree', 'element-plus', 'com.dorm.manage', 'dorm', 'building', '宿舍管理', '王新瑜', '0', '/', '{\"treeCode\":\"dorm_id\",\"treeName\":\"building_name\",\"treeParentCode\":\"parent_id\",\"parentMenuId\":2000}', 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (15, 2, 'dorm_id', '宿舍ID（主键）', 'bigint(20)', 'Long', 'dormId', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (16, 2, 'parent_id', '上级节点', 'bigint(20)', 'Long', 'parentId', '0', '0', '1', '1', '0', '0', '0', 'EQ', 'input', '', 2, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (17, 2, 'ancestors', '祖级列表', 'varchar(50)', 'String', 'ancestors', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'input', '', 3, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (18, 2, 'building_name', '宿舍名称', 'varchar(30)', 'String', 'buildingName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (19, 2, 'order_num', '显示顺序', 'int(4)', 'Integer', 'orderNum', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (20, 2, 'dorm_manager', '宿管', 'varchar(20)', 'String', 'dormManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (21, 2, 'phone', '联系电话', 'varchar(11)', 'String', 'phone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (22, 2, 'email', '邮箱', 'varchar(50)', 'String', 'email', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 8, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (23, 2, 'status', '宿舍状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'dorm_status', 9, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (24, 2, 'del_flag', '删除标志（0存在 2删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (25, 2, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (26, 2, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (27, 2, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 13, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');
INSERT INTO `gen_table_column` VALUES (28, 2, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '0', NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2025-06-03 21:32:07', '', '2025-06-03 23:02:27');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '2', 'admin', '2025-06-03 20:44:14', '', NULL);
INSERT INTO `sys_dept` VALUES (200, 100, '0,100', '飞', 0, NULL, NULL, NULL, '0', '2', 'admin', '2025-06-03 21:19:38', '', NULL);
INSERT INTO `sys_dept` VALUES (201, 108, '0,100,102,108', '1', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-03 22:53:00', '', NULL);
INSERT INTO `sys_dept` VALUES (202, 102, '0,100,102', '1', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-03 22:58:02', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 0, '正常', '0', 'dorm_status', NULL, 'success', 'N', '0', 'admin', '2025-06-03 22:36:12', 'admin', '2025-06-03 22:36:50', NULL);
INSERT INTO `sys_dict_data` VALUES (101, 1, '停用', '1', 'dorm_status', NULL, 'warning', 'N', '0', 'admin', '2025-06-03 22:36:42', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '宿舍状态', 'dorm_status', '0', 'admin', '2025-06-03 22:34:50', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-06-03 20:44:14', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-03 21:16:08');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 11:13:01');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 12:54:47');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 13:28:23');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2007 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-06-03 20:44:14', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-06-03 20:44:14', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2025-06-03 20:44:14', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2025-06-03 20:44:14', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-06-03 20:44:14', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-06-03 20:44:14', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-06-03 20:44:14', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-06-03 20:44:14', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-06-03 20:44:14', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-06-03 20:44:14', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-06-03 20:44:14', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-06-03 20:44:14', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-06-03 20:44:14', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-06-03 20:44:14', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-06-03 20:44:14', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-06-03 20:44:14', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-06-03 20:44:14', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-06-03 20:44:14', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-06-03 20:44:14', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-06-03 20:44:14', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-06-03 20:44:14', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-06-03 20:44:14', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-06-03 20:44:14', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-06-03 20:44:14', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '宿舍管理', 0, 0, 'dorm', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'list', 'admin', '2025-06-03 20:52:49', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2001, '宿舍管理', 2000, 1, 'building', 'dorm/building/index', NULL, '', 1, 0, 'C', '0', '0', 'dorm:building:list', '#', 'admin', '2025-06-03 21:59:16', '', NULL, '宿舍管理菜单');
INSERT INTO `sys_menu` VALUES (2002, '宿舍管理查询', 2001, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:building:query', '#', 'admin', '2025-06-03 21:59:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '宿舍管理新增', 2001, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:building:add', '#', 'admin', '2025-06-03 21:59:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '宿舍管理修改', 2001, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:building:edit', '#', 'admin', '2025-06-03 21:59:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '宿舍管理删除', 2001, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:building:remove', '#', 'admin', '2025-06-03 21:59:16', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '宿舍管理导出', 2001, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:building:export', '#', 'admin', '2025-06-03 21:59:16', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-06-03 20:44:14', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-06-03 20:44:14', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 208 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 1, 'com.dorm.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"宿舍管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"dorm\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 20:52:49', 188);
INSERT INTO `sys_oper_log` VALUES (101, '部门管理', 1, 'com.dorm.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"飞\",\"orderNum\":0,\"params\":{},\"parentId\":100,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 21:19:38', 133);
INSERT INTO `sys_oper_log` VALUES (102, '部门管理', 3, 'com.dorm.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/200', '127.0.0.1', '内网IP', '200', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 21:19:46', 33);
INSERT INTO `sys_oper_log` VALUES (103, '代码生成', 6, 'com.dorm.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"dorm-building\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 21:31:26', 129);
INSERT INTO `sys_oper_log` VALUES (104, '代码生成', 3, 'com.dorm.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 21:32:03', 46);
INSERT INTO `sys_oper_log` VALUES (105, '代码生成', 6, 'com.dorm.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_building\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 21:32:07', 64);
INSERT INTO `sys_oper_log` VALUES (106, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuer', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 21:34:09', 67);
INSERT INTO `sys_oper_log` VALUES (107, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_building\"}', NULL, 0, NULL, '2025-06-03 21:34:13', 191);
INSERT INTO `sys_oper_log` VALUES (108, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 21:34:09\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 21:34:09\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 21:34:09\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"inc', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 21:38:06', 56);
INSERT INTO `sys_oper_log` VALUES (109, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_building\"}', NULL, 0, NULL, '2025-06-03 21:38:11', 42);
INSERT INTO `sys_oper_log` VALUES (110, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_building\"}', NULL, 0, NULL, '2025-06-03 21:54:22', 131);
INSERT INTO `sys_oper_log` VALUES (111, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\",3\",\"buildingName\":\"B\",\"children\":[],\"dormId\":5,\"params\":{},\"parentId\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:11:16', 192);
INSERT INTO `sys_oper_log` VALUES (112, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:11:23', 39);
INSERT INTO `sys_oper_log` VALUES (113, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/3', '127.0.0.1', '内网IP', '[3]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:11:25', 13);
INSERT INTO `sys_oper_log` VALUES (114, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:11:28', 18);
INSERT INTO `sys_oper_log` VALUES (115, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/4', '127.0.0.1', '内网IP', '[4]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:11:30', 16);
INSERT INTO `sys_oper_log` VALUES (116, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/5', '127.0.0.1', '内网IP', '[5]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:11:31', 12);
INSERT INTO `sys_oper_log` VALUES (117, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"瓯江口\",\"children\":[],\"orderNum\":0,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:11:55', 10);
INSERT INTO `sys_oper_log` VALUES (118, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"瓯江口\",\"children\":[],\"delFlag\":\"0\",\"orderNum\":0,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:12:18', 5);
INSERT INTO `sys_oper_log` VALUES (119, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"瓯江口\",\"children\":[],\"delFlag\":\"0\",\"dormManager\":\"林\",\"orderNum\":0,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:12:25', 5);
INSERT INTO `sys_oper_log` VALUES (120, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"瓯江口\",\"children\":[],\"delFlag\":\"0\",\"dormManager\":\"林\",\"email\":\"21\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"12\"}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:12:30', 6);
INSERT INTO `sys_oper_log` VALUES (121, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"瓯江口\",\"children\":[],\"delFlag\":\"1\",\"dormManager\":\"林\",\"email\":\"21\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"12\"}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:12:33', 4);
INSERT INTO `sys_oper_log` VALUES (122, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"children\":[],\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:12:40', 3);
INSERT INTO `sys_oper_log` VALUES (123, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"children\":[],\"delFlag\":\"1\",\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:12:53', 2);
INSERT INTO `sys_oper_log` VALUES (124, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,200\",\"buildingName\":\"b\",\"children\":[],\"dormId\":201,\"orderNum\":0,\"params\":{},\"parentId\":200}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:13:58', 55);
INSERT INTO `sys_oper_log` VALUES (125, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"children\":[],\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:14:05', 4);
INSERT INTO `sys_oper_log` VALUES (126, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:14:09', 5);
INSERT INTO `sys_oper_log` VALUES (127, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:14:11', 4);
INSERT INTO `sys_oper_log` VALUES (128, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"dormManager\":\"1\",\"orderNum\":1,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:14:13', 4);
INSERT INTO `sys_oper_log` VALUES (129, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"children\":[],\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:15:43', 14806);
INSERT INTO `sys_oper_log` VALUES (130, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 21:38:06\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 21:38:06\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 21:38:06\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"in', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:21:59', 226);
INSERT INTO `sys_oper_log` VALUES (131, '字典类型', 9, 'com.dorm.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:24:57', 26);
INSERT INTO `sys_oper_log` VALUES (132, '字典类型', 1, 'com.dorm.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"宿舍状态\",\"dictType\":\"dorm_status\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:34:50', 27);
INSERT INTO `sys_oper_log` VALUES (133, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"正常\",\"dictSort\":0,\"dictType\":\"dorm_status\",\"dictValue\":\"0\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:36:12', 65);
INSERT INTO `sys_oper_log` VALUES (134, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"停用\",\"dictSort\":1,\"dictType\":\"dorm_status\",\"dictValue\":\"1\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:36:42', 16);
INSERT INTO `sys_oper_log` VALUES (135, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-03 22:36:12\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"正常\",\"dictSort\":0,\"dictType\":\"dorm_status\",\"dictValue\":\"0\",\"isDefault\":\"N\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:36:50', 11);
INSERT INTO `sys_oper_log` VALUES (136, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:21:59\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:21:59\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:21:59\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"in', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:37:12', 33);
INSERT INTO `sys_oper_log` VALUES (137, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:37:12\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:37:12\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:37:12\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"in', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:37:39', 78);
INSERT INTO `sys_oper_log` VALUES (138, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:37:39\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:37:39\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:37:39\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"in', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:39:48', 65);
INSERT INTO `sys_oper_log` VALUES (139, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"111\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:51:58', 4334);
INSERT INTO `sys_oper_log` VALUES (140, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"111\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:52:03', 3);
INSERT INTO `sys_oper_log` VALUES (141, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"111\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.manage.domain.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-03 22:52:04', 2);
INSERT INTO `sys_oper_log` VALUES (142, '部门管理', 1, 'com.dorm.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,108\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"1\",\"orderNum\":0,\"params\":{},\"parentId\":108,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:53:00', 86);
INSERT INTO `sys_oper_log` VALUES (143, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:39:47\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:39:47\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:39:47\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"in', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:57:02', 104);
INSERT INTO `sys_oper_log` VALUES (144, '部门管理', 1, 'com.dorm.web.controller.system.SysDeptController.add()', 'POST', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"1\",\"orderNum\":0,\"params\":{},\"parentId\":102,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 22:58:02', 87);
INSERT INTO `sys_oper_log` VALUES (145, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:57:02\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"1\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:57:02\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 22:57:02\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"inpu', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 23:00:56', 52);
INSERT INTO `sys_oper_log` VALUES (146, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 23:00:56\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"上级节点\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"1\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 23:00:56\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 23:00:56\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 23:02:28', 83);
INSERT INTO `sys_oper_log` VALUES (147, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"buildingName\":\"1\",\"children\":[],\"dormId\":202,\"dormManager\":\"1\",\"orderNum\":1,\"params\":{},\"parentId\":100}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 23:05:27', 30);
INSERT INTO `sys_oper_log` VALUES (148, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,202\",\"buildingName\":\"1\",\"children\":[],\"dormId\":203,\"orderNum\":1,\"params\":{},\"parentId\":202}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 23:05:40', 86);
INSERT INTO `sys_oper_log` VALUES (149, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/202', '127.0.0.1', '内网IP', '[202]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 23:05:42', 32);
INSERT INTO `sys_oper_log` VALUES (150, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/203', '127.0.0.1', '内网IP', '[203]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-03 23:05:46', 13);
INSERT INTO `sys_oper_log` VALUES (151, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"buildingName\":\"瓯江口\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"delFlag\":\"0\",\"dormId\":100,\"dormManager\":\"若依\",\"email\":\"ry@qq.com\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-06-04 11:13:24\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:13:24', 120);
INSERT INTO `sys_oper_log` VALUES (152, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"buildingName\":\"人工智能学院\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"delFlag\":\"0\",\"dormId\":101,\"dormManager\":\"若依\",\"email\":\"ry@qq.com\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-06-04 11:13:41\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:13:41', 113);
INSERT INTO `sys_oper_log` VALUES (153, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"buildingName\":\"光电制造学院\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"delFlag\":\"0\",\"dormId\":102,\"dormManager\":\"若依\",\"email\":\"ry@qq.com\",\"orderNum\":2,\"params\":{},\"parentId\":100,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-06-04 11:13:54\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:13:54', 78);
INSERT INTO `sys_oper_log` VALUES (154, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"buildingName\":\"观潮公寓\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"delFlag\":\"0\",\"dormId\":103,\"dormManager\":\"李阿姨\",\"email\":\"ry@qq.com\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-06-04 11:14:59\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:14:59', 38);
INSERT INTO `sys_oper_log` VALUES (155, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/104', '127.0.0.1', '内网IP', '[104]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:15:27', 118);
INSERT INTO `sys_oper_log` VALUES (156, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/105', '127.0.0.1', '内网IP', '[105]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:15:28', 15);
INSERT INTO `sys_oper_log` VALUES (157, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/106', '127.0.0.1', '内网IP', '[106]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:15:29', 17);
INSERT INTO `sys_oper_log` VALUES (158, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/107', '127.0.0.1', '内网IP', '[107]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:15:29', 16);
INSERT INTO `sys_oper_log` VALUES (159, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103\",\"buildingName\":\"A\",\"children\":[],\"dormId\":204,\"orderNum\":0,\"params\":{},\"parentId\":103}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:16:50', 64);
INSERT INTO `sys_oper_log` VALUES (160, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"buildingName\":\"观潮公寓\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"delFlag\":\"0\",\"dormId\":103,\"dormManager\":\"\",\"email\":\"ry@qq.com\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"phone\":\"\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-06-04 11:16:57\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:16:57', 12);
INSERT INTO `sys_oper_log` VALUES (161, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103\",\"buildingName\":\"A\",\"children\":[],\"createBy\":\"\",\"delFlag\":\"0\",\"dormId\":204,\"dormManager\":\"李阿姨\",\"orderNum\":0,\"params\":{},\"parentId\":103,\"phone\":\"18888645465\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-06-04 11:17:09\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:17:09', 93);
INSERT INTO `sys_oper_log` VALUES (162, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103\",\"buildingName\":\"A栋\",\"children\":[],\"createBy\":\"\",\"delFlag\":\"0\",\"dormId\":204,\"dormManager\":\"李阿姨\",\"orderNum\":0,\"params\":{},\"parentId\":103,\"phone\":\"18888645465\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-06-04 11:17:20\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:17:20', 83);
INSERT INTO `sys_oper_log` VALUES (163, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103\",\"buildingName\":\"B栋\",\"children\":[],\"dormId\":205,\"dormManager\":\"张阿姨\",\"orderNum\":1,\"params\":{},\"parentId\":103,\"phone\":\"165151\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:17:45', 60);
INSERT INTO `sys_oper_log` VALUES (164, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102\",\"buildingName\":\"听涛公寓\",\"children\":[],\"dormId\":206,\"orderNum\":0,\"params\":{},\"parentId\":102}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:25:12', 66);
INSERT INTO `sys_oper_log` VALUES (165, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206\",\"buildingName\":\"A栋\",\"children\":[],\"dormId\":207,\"orderNum\":0,\"params\":{},\"parentId\":206}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:25:30', 34);
INSERT INTO `sys_oper_log` VALUES (166, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206\",\"buildingName\":\"B栋\",\"children\":[],\"dormId\":208,\"orderNum\":1,\"params\":{},\"parentId\":206}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:25:40', 53);
INSERT INTO `sys_oper_log` VALUES (167, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/109', '127.0.0.1', '内网IP', '[109]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:25:44', 12);
INSERT INTO `sys_oper_log` VALUES (168, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/108', '127.0.0.1', '内网IP', '[108]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:25:45', 16);
INSERT INTO `sys_oper_log` VALUES (169, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/200', '127.0.0.1', '内网IP', '[200]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:25:46', 14);
INSERT INTO `sys_oper_log` VALUES (170, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/201', '127.0.0.1', '内网IP', '[201]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:25:48', 7);
INSERT INTO `sys_oper_log` VALUES (171, '部门管理', 3, 'com.dorm.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/109', '127.0.0.1', '内网IP', '109', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:28:52', 4752);
INSERT INTO `sys_oper_log` VALUES (172, '部门管理', 3, 'com.dorm.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '127.0.0.1', '内网IP', '108', '{\"msg\":\"存在下级部门,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 11:28:56', 4);
INSERT INTO `sys_oper_log` VALUES (173, '部门管理', 3, 'com.dorm.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '127.0.0.1', '内网IP', '108', '{\"msg\":\"存在下级部门,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 11:28:58', 5);
INSERT INTO `sys_oper_log` VALUES (174, '部门管理', 3, 'com.dorm.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '127.0.0.1', '内网IP', '108', '{\"msg\":\"存在下级部门,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 11:29:00', 5);
INSERT INTO `sys_oper_log` VALUES (175, '部门管理', 3, 'com.dorm.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '127.0.0.1', '内网IP', '108', '{\"msg\":\"存在下级部门,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 11:39:56', 81);
INSERT INTO `sys_oper_log` VALUES (176, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206,208\",\"buildingName\":\"1\",\"children\":[],\"dormId\":209,\"orderNum\":1,\"params\":{},\"parentId\":208}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:40:13', 47);
INSERT INTO `sys_oper_log` VALUES (177, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/208', '127.0.0.1', '内网IP', '[208]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:40:15', 12);
INSERT INTO `sys_oper_log` VALUES (178, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/209', '127.0.0.1', '内网IP', '[209]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 11:40:18', 22);
INSERT INTO `sys_oper_log` VALUES (179, '部门管理', 3, 'com.dorm.web.controller.system.SysDeptController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dept/108', '127.0.0.1', '内网IP', '108', '{\"msg\":\"存在下级部门,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 12:05:15', 13);
INSERT INTO `sys_oper_log` VALUES (180, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":207}', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.checkDormNameUnique', '2025-06-04 12:05:26', 11);
INSERT INTO `sys_oper_log` VALUES (181, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":207}', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.checkDormNameUnique', '2025-06-04 12:05:30', 3);
INSERT INTO `sys_oper_log` VALUES (182, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":207}', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.checkDormNameUnique', '2025-06-04 12:05:31', 3);
INSERT INTO `sys_oper_log` VALUES (183, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":207}', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.checkDormNameUnique', '2025-06-04 12:05:33', 1);
INSERT INTO `sys_oper_log` VALUES (184, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":207}', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.checkDormNameUnique', '2025-06-04 12:05:34', 1);
INSERT INTO `sys_oper_log` VALUES (185, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/206', '127.0.0.1', '内网IP', '[206]', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.hasChildByDormId', '2025-06-04 12:05:41', 6);
INSERT INTO `sys_oper_log` VALUES (186, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/206', '127.0.0.1', '内网IP', '[206]', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.hasChildByDormId', '2025-06-04 12:05:46', 1);
INSERT INTO `sys_oper_log` VALUES (187, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"1\",\"children\":[],\"orderNum\":1,\"params\":{},\"parentId\":207}', NULL, 1, 'Invalid bound statement (not found): com.dorm.manage.mapper.DormBuildingMapper.checkDormNameUnique', '2025-06-04 12:06:25', 24);
INSERT INTO `sys_oper_log` VALUES (188, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206,207\",\"buildingName\":\"1\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-04 12:08:44\",\"orderNum\":1,\"params\":{},\"parentId\":207}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 12:08:44', 267);
INSERT INTO `sys_oper_log` VALUES (189, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/207', '127.0.0.1', '内网IP', '[207]', '{\"msg\":\"存在下级宿舍,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 12:08:47', 6);
INSERT INTO `sys_oper_log` VALUES (190, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/207', '127.0.0.1', '内网IP', '[207]', '{\"msg\":\"存在下级宿舍,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 12:08:50', 3);
INSERT INTO `sys_oper_log` VALUES (191, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/207', '127.0.0.1', '内网IP', '[207]', '{\"msg\":\"存在下级宿舍,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 12:08:51', 4);
INSERT INTO `sys_oper_log` VALUES (192, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/210', '127.0.0.1', '内网IP', '[210]', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormBuildingMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormBuildingMapper.checkDormExistUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select count(1) from sys_user where dorm_id = ? and del_flag = \'0\'\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'', '2025-06-04 12:08:54', 70);
INSERT INTO `sys_oper_log` VALUES (193, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/210', '127.0.0.1', '内网IP', '[210]', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormBuildingMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormBuildingMapper.checkDormExistUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select count(1) from sys_user where dorm_id = ? and del_flag = \'0\'\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'', '2025-06-04 12:09:03', 15);
INSERT INTO `sys_oper_log` VALUES (194, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206,207,210\",\"buildingName\":\"1\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-04 12:09:18\",\"orderNum\":1,\"params\":{},\"parentId\":210}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 12:09:18', 86);
INSERT INTO `sys_oper_log` VALUES (195, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/211', '127.0.0.1', '内网IP', '[211]', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormBuildingMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormBuildingMapper.checkDormExistUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select count(1) from sys_user where dorm_id = ? and del_flag = \'0\'\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'', '2025-06-04 12:09:20', 9);
INSERT INTO `sys_oper_log` VALUES (196, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/211', '127.0.0.1', '内网IP', '[211]', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormBuildingMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormBuildingMapper.checkDormExistUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select count(1) from sys_user where dorm_id = ? and del_flag = \'0\'\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'dorm_id\' in \'where clause\'', '2025-06-04 12:09:37', 11);
INSERT INTO `sys_oper_log` VALUES (197, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206,207,210\",\"buildingName\":\"1\",\"children\":[],\"dormId\":211,\"orderNum\":1,\"params\":{},\"parentId\":210,\"parentName\":\"1\",\"status\":\"1\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-04 12:09:54\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 12:09:54', 40);
INSERT INTO `sys_oper_log` VALUES (198, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206,207,210\",\"buildingName\":\"1\",\"children\":[],\"dormId\":211,\"orderNum\":1,\"params\":{},\"parentId\":210,\"parentName\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-04 12:09:57\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 12:09:57', 28);
INSERT INTO `sys_oper_log` VALUES (199, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/211', '127.0.0.1', '内网IP', '[211]', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Table \'ry-vue.dorm_student\' doesn\'t exist\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormBuildingMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormBuildingMapper.checkDormExistUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select count(1) from dorm_student where dorm_id = ? and del_flag = \'0\'\r\n### Cause: java.sql.SQLSyntaxErrorException: Table \'ry-vue.dorm_student\' doesn\'t exist\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Table \'ry-vue.dorm_student\' doesn\'t exist', '2025-06-04 12:11:48', 51);
INSERT INTO `sys_oper_log` VALUES (200, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/210', '127.0.0.1', '内网IP', '[210]', '{\"msg\":\"存在下级宿舍,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 12:54:53', 12);
INSERT INTO `sys_oper_log` VALUES (201, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/211', '127.0.0.1', '内网IP', '[211]', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'del_flag\' in \'where clause\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormBuildingMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormBuildingMapper.checkDormExistUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select count(1) from dorm_student where dorm_id = ? and del_flag = \'0\'\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'del_flag\' in \'where clause\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'del_flag\' in \'where clause\'', '2025-06-04 12:54:55', 16);
INSERT INTO `sys_oper_log` VALUES (202, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/210', '127.0.0.1', '内网IP', '[210]', '{\"msg\":\"存在下级宿舍,不允许删除\",\"code\":601}', 0, NULL, '2025-06-04 12:55:27', 4);
INSERT INTO `sys_oper_log` VALUES (203, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/211', '127.0.0.1', '内网IP', '[211]', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'del_flag\' in \'where clause\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormBuildingMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormBuildingMapper.checkDormExistUser-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select count(1) from dorm_student where dorm_id = ? and del_flag = \'0\'\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'del_flag\' in \'where clause\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'del_flag\' in \'where clause\'', '2025-06-04 12:55:33', 9);
INSERT INTO `sys_oper_log` VALUES (204, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/211', '127.0.0.1', '内网IP', '[211]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:00:20', 146);
INSERT INTO `sys_oper_log` VALUES (205, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/210', '127.0.0.1', '内网IP', '[210]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:00:24', 34);
INSERT INTO `sys_oper_log` VALUES (206, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204\",\"buildingName\":\"一楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:29:16\",\"orderNum\":0,\"params\":{},\"parentId\":204}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:29:16', 99);
INSERT INTO `sys_oper_log` VALUES (207, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204,212\",\"buildingName\":\"101\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:29:25\",\"orderNum\":0,\"params\":{},\"parentId\":212}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:29:25', 32);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-06-03 20:44:14', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-06-03 20:44:14', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-06-04 13:28:24', '2025-06-03 20:44:14', 'admin', '2025-06-03 20:44:14', '', '2025-06-04 13:28:23', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-06-03 20:44:14', '2025-06-03 20:44:14', 'admin', '2025-06-03 20:44:14', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

SET FOREIGN_KEY_CHECKS = 1;
