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

 Date: 09/06/2025 20:40:23
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
  `full_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '宿舍全称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `dorm_manager` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '宿管',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '宿舍状态（0空闲 1满员）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dorm_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 263 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '宿舍表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dorm_building
-- ----------------------------
INSERT INTO `dorm_building` VALUES (100, 0, '0', '瓯江口', NULL, 0, '', '', 'ry@qq.com', '0', '0', 'admin', '2025-06-03 20:44:14', '', '2025-06-04 11:13:25');
INSERT INTO `dorm_building` VALUES (237, 100, '0,100', '人工智能学院', '瓯江口 - 人工智能学院', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:09:54', '', NULL);
INSERT INTO `dorm_building` VALUES (238, 237, '0,100,237', '观潮公寓', '瓯江口 - 人工智能学院 - 观潮公寓', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:10:10', '', NULL);
INSERT INTO `dorm_building` VALUES (239, 238, '0,100,237,238', 'A栋', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:10:21', '', NULL);
INSERT INTO `dorm_building` VALUES (240, 238, '0,100,237,238', 'B栋', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:10:44', '', NULL);
INSERT INTO `dorm_building` VALUES (241, 238, '0,100,237,238', 'C栋', '瓯江口 - 人工智能学院 - 观潮公寓 - C栋', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:11:16', '', NULL);
INSERT INTO `dorm_building` VALUES (242, 100, '0,100', '光电制造学院', '瓯江口 - 光电制造学院', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:11:41', '', NULL);
INSERT INTO `dorm_building` VALUES (243, 242, '0,100,242', '听涛公寓', '瓯江口 - 光电制造学院 - 听涛公寓', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:12:43', '', NULL);
INSERT INTO `dorm_building` VALUES (244, 243, '0,100,242,243', 'A栋', '瓯江口 - 光电制造学院 - 听涛公寓 - A栋', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:12:54', '', NULL);
INSERT INTO `dorm_building` VALUES (245, 243, '0,100,242,243', 'B栋', '瓯江口 - 光电制造学院 - 听涛公寓 - B栋', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:13:05', '', NULL);
INSERT INTO `dorm_building` VALUES (246, 243, '0,100,242,243', 'C栋', '瓯江口 - 光电制造学院 - 听涛公寓 - C栋', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:13:19', '', NULL);
INSERT INTO `dorm_building` VALUES (247, 239, '0,100,237,238,239', '一楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:13:31', '', NULL);
INSERT INTO `dorm_building` VALUES (248, 239, '0,100,237,238,239', '二楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 二楼', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:13:50', '', NULL);
INSERT INTO `dorm_building` VALUES (249, 239, '0,100,237,238,239', '三楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 三楼', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:15:25', '', NULL);
INSERT INTO `dorm_building` VALUES (250, 239, '0,100,237,238,239', '四楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 四楼', 3, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:15:39', '', NULL);
INSERT INTO `dorm_building` VALUES (252, 239, '0,100,237,238,239', '五楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 五楼', 4, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:16:15', '', NULL);
INSERT INTO `dorm_building` VALUES (253, 240, '0,100,237,238,240', '一楼', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 一楼', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:16:38', '', NULL);
INSERT INTO `dorm_building` VALUES (254, 247, '0,100,237,238,239,247', '101', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼 - 101', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:18:32', '', NULL);
INSERT INTO `dorm_building` VALUES (255, 240, '0,100,237,238,240', '二楼', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 二楼', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:37:28', '', NULL);
INSERT INTO `dorm_building` VALUES (256, 240, '0,100,237,238,240', '三楼', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:37:49', 'admin', '2025-06-09 20:38:06');
INSERT INTO `dorm_building` VALUES (257, 256, '0,100,237,238,240,256', '301', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 301', 0, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:38:20', '', NULL);
INSERT INTO `dorm_building` VALUES (258, 256, '0,100,237,238,240,256', '302', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 302', 1, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:38:27', '', NULL);
INSERT INTO `dorm_building` VALUES (259, 256, '0,100,237,238,240,256', '303', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 303', 2, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:38:52', '', NULL);
INSERT INTO `dorm_building` VALUES (260, 256, '0,100,237,238,240,256', '304', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 304', 3, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:39:08', '', NULL);
INSERT INTO `dorm_building` VALUES (261, 256, '0,100,237,238,240,256', '305', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 305', 4, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:39:17', '', NULL);
INSERT INTO `dorm_building` VALUES (262, 256, '0,100,237,238,240,256', '306', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 306', 5, NULL, NULL, NULL, '0', '0', 'admin', '2025-06-09 20:39:25', '', NULL);

-- ----------------------------
-- Table structure for dorm_notice
-- ----------------------------
DROP TABLE IF EXISTS `dorm_notice`;
CREATE TABLE `dorm_notice`  (
  `notice_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '公告ID（主键）',
  `notice_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）',
  `notice_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容（支持HTML/富文本）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0草稿 1已发布 2撤回）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '宿舍公告表（无楼栋字段）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_notice
-- ----------------------------
INSERT INTO `dorm_notice` VALUES (1, '关于期末考试时间安排的公告', '0', '<p>请各位同学提前查阅期末考试时间表，合理安排复习。</p>', '1', 'admin', '2025-06-06 15:44:33', 'admin', '2025-06-06 15:44:33', '教务处发布');
INSERT INTO `dorm_notice` VALUES (2, '宿舍楼用电安全须知', '0', '<p>近期天气炎热，请注意合理用电，避免跳闸。</p>', '1', 'admin', '2025-06-06 15:44:33', '', NULL, '安全提醒');
INSERT INTO `dorm_notice` VALUES (3, '校园网升级通知', '1', '<p>6月10日凌晨校园网将维护升级，期间可能出现短时断网。</p>', '1', 'net_admin', '2025-06-06 15:44:33', 'net_admin', '2025-06-06 15:44:33', '信息中心');
INSERT INTO `dorm_notice` VALUES (4, '图书馆闭馆时间调整通知', '1', '<p>因暑假临近，图书馆将于6月20日起调整开放时间。</p>', '0', 'library_admin', '2025-06-06 15:44:33', '', NULL, '草稿');
INSERT INTO `dorm_notice` VALUES (5, '2025年校园科技节活动安排', '2', '<p>诚邀全校师生参与科技节活动，包括创新作品展、专题讲座等。</p>', '1', 'student_union', '2025-06-06 15:44:33', 'teacher_zhang', '2025-06-06 15:44:33', '校团委主办');
INSERT INTO `dorm_notice` VALUES (6, '端午节包粽子比赛报名中', '2', '<p>欢迎各宿舍报名参加端午节包粽子比赛，名额有限，先到先得！</p>', '0', 'life_committee', '2025-06-06 15:44:33', '', NULL, '学生社区活动');
INSERT INTO `dorm_notice` VALUES (7, '旧版防疫政策公告（已撤回）', '0', '<p>此公告已作废，请以最新政策为准。</p>', '1', 'admin', '2025-06-06 15:44:33', 'admin', '2025-06-06 15:58:02', '已撤回');
INSERT INTO `dorm_notice` VALUES (8, '校园跑步打卡活动（取消）', '2', '<p>受天气影响，该活动取消。</p>', '1', 'sports_admin', '2025-06-06 15:44:33', 'admin', '2025-06-06 15:57:21', '撤回通知');

-- ----------------------------
-- Table structure for dorm_student
-- ----------------------------
DROP TABLE IF EXISTS `dorm_student`;
CREATE TABLE `dorm_student`  (
  `student_id` bigint(20) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT COMMENT '学生ID，主键',
  `user_id` bigint(20) NOT NULL COMMENT '系统用户ID → sys_user.user_id',
  `student_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生姓名',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '性别（0男 1女）',
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '班级名称',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '学生状态（0在校 1离校）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱地址',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
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
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_student
-- ----------------------------
INSERT INTO `dorm_student` VALUES (00000000000000000001, 100, '20230001', '张三', '男', '计算机科学与技术1班', '13800138001', '0', 'zhangsan@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-09 20:06:18', '');
INSERT INTO `dorm_student` VALUES (00000000000000000002, 102, '20230002', '李四', '女', '计算机科学与技术1班', '13800138002', '0', 'lisi@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-04 20:25:38', '');
INSERT INTO `dorm_student` VALUES (00000000000000000003, 103, '20230003', '王五', '0', '计算机科学与技术1班', '13800138003', '0', 'wangwu@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000004, 104, '20230004', '赵六', '0', '计算机科学与技术1班', '13800138004', '0', 'zhaoliu@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000005, 105, '20230005', '钱七', '0', '计算机科学与技术2班', '13800138005', '0', 'qianqi@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000006, 106, '20230006', '孙八', '0', '计算机科学与技术2班', '13800138006', '0', 'sunba@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000007, 107, '20230007', '周九', '0', '计算机科学与技术2班', '13800138007', '0', 'zhoujiu@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000008, 108, '20230008', '吴十', '0', '计算机科学与技术2班', '13800138008', '0', 'wushi@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000009, 109, '20230009', '郑十一', '0', '软件工程1班', '13800138009', '0', 'zhengshiyi@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000010, 110, '20230010', '王小红', '1', '软件工程1班', '13800138010', '0', 'wangxiaohong@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000011, 111, '20230011', '李小花', '1', '软件工程1班', '13800138011', '0', 'lixiaohua@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000012, 112, '20230012', '张美丽', '1', '软件工程1班', '13800138012', '0', 'zhangmeili@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000013, 113, '20230013', '刘芳', '1', '软件工程1班', '13800138013', '0', 'liufang@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000014, 114, '20230014', '陈静', '1', '软件工程2班', '13800138014', '0', 'chenjing@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000015, 115, '20230015', '杨雪', '1', '软件工程2班', '13800138015', '0', 'yangxue@school.edu', '0', NULL, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000017, 1, '1222', '1', NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '2025-06-05 19:52:06', NULL, NULL, NULL);
INSERT INTO `dorm_student` VALUES (00000000000000000018, 111, '1', '1', '男', '111', '111', '0', NULL, NULL, NULL, NULL, '2025-06-05 19:52:31', NULL, NULL, NULL);
INSERT INTO `dorm_student` VALUES (00000000000000000020, 1, '1213', '1', NULL, '1', NULL, '0', NULL, NULL, NULL, NULL, '2025-06-05 19:55:03', NULL, NULL, NULL);
INSERT INTO `dorm_student` VALUES (00000000000000000022, 1111, '2310313', '111', NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '2025-06-05 20:09:39', NULL, NULL, NULL);
INSERT INTO `dorm_student` VALUES (00000000000000000025, 101, '2310305320', '王新瑜', '0', '软件2301', '13282973175', '0', '2559118499@qq.com', '0', NULL, NULL, '2025-06-08 16:41:07', NULL, '2025-06-09 13:56:42', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (2, 'dorm_building', '宿舍楼表', '', '', 'DormBuilding', 'tree', 'element-plus', 'com.dorm.manage', 'dorm', 'building', '宿舍管理', '王新瑜', '0', '/', '{\"treeCode\":\"dorm_id\",\"treeName\":\"building_name\",\"treeParentCode\":\"parent_id\",\"parentMenuId\":2000}', 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29', NULL);
INSERT INTO `gen_table` VALUES (3, 'dorm_student', '学生表', NULL, NULL, 'DormStudent', 'crud', 'element-plus', 'com.dorm.manage', 'dorm', 'student', '学生管理', '王新瑜', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01', NULL);
INSERT INTO `gen_table` VALUES (4, 'dorm_notice', '宿舍公告表', NULL, NULL, 'DormNotice', 'crud', 'element-plus', 'com.dorm.manage', 'dorm', 'notices', '宿舍公告', '王新瑜', '0', '/', '{\"parentMenuId\":2000}', 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (15, 2, 'dorm_id', '宿舍ID（主键）', 'bigint(20)', 'Long', 'dormId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (16, 2, 'parent_id', '父宿舍ID', 'bigint(20)', 'Long', 'parentId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (17, 2, 'ancestors', '祖级列表', 'varchar(50)', 'String', 'ancestors', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (18, 2, 'building_name', '宿舍名称', 'varchar(30)', 'String', 'buildingName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (19, 2, 'order_num', '显示顺序', 'int(4)', 'Integer', 'orderNum', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (20, 2, 'dorm_manager', '宿管', 'varchar(20)', 'String', 'dormManager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (21, 2, 'phone', '联系电话', 'varchar(11)', 'String', 'phone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (22, 2, 'email', '邮箱', 'varchar(50)', 'String', 'email', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (23, 2, 'status', '宿舍状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'dorm_status', 10, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (24, 2, 'del_flag', '删除标志（0存在 2删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (25, 2, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (26, 2, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (27, 2, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 14, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (28, 2, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2025-06-03 21:32:07', '', '2025-06-09 16:21:29');
INSERT INTO `gen_table_column` VALUES (29, 3, 'student_id', '学生ID，主键', 'bigint(20)', 'Long', 'studentId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (30, 3, 'user_id', '系统用户ID → sys_user.user_id', 'bigint(20)', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (31, 3, 'student_no', '学号', 'varchar(30)', 'String', 'studentNo', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (32, 3, 'name', '学生姓名', 'varchar(50)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (33, 3, 'gender', '性别（0男 1女）', 'char(1)', 'String', 'gender', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (34, 3, 'class_name', '班级名称', 'varchar(50)', 'String', 'className', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (35, 3, 'phone', '手机号', 'varchar(11)', 'String', 'phone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (36, 3, 'status', '学生状态（0在校 1离校）', 'char(1)', 'String', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', '', 8, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (37, 3, 'email', '邮箱地址', 'varchar(100)', 'String', 'email', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (38, 3, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (39, 3, 'dorm_id', '当前宿舍ID → dorm_room.room_id', 'bigint(20)', 'Long', 'dormId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (40, 3, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (41, 3, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (42, 3, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 14, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (43, 3, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (44, 3, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 16, 'admin', '2025-06-04 13:45:59', '', '2025-06-04 13:53:01');
INSERT INTO `gen_table_column` VALUES (45, 4, 'notice_id', '公告ID（主键）', 'bigint(20)', 'Long', 'noticeId', '1', '1', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (46, 4, 'notice_title', '公告标题', 'varchar(100)', 'String', 'noticeTitle', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (47, 4, 'notice_type', '公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）', 'char(1)', 'String', 'noticeType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'dorm_notice_type', 3, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (49, 4, 'notice_content', '公告内容（支持HTML/富文本）', 'longtext', 'String', 'noticeContent', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'editor', '', 4, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (50, 4, 'status', '状态（0草稿 1已发布 2撤回）', 'char(1)', 'String', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', 'sys_notice_status', 5, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (51, 4, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (52, 4, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (53, 4, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (54, 4, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (55, 4, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '0', '0', '0', NULL, 'EQ', 'textarea', '', 10, 'admin', '2025-06-06 14:09:18', '', '2025-06-06 15:45:53');
INSERT INTO `gen_table_column` VALUES (56, 2, 'full_name', '宿舍全称', 'varchar(100)', 'String', 'fullName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 5, '', '2025-06-09 16:19:37', '', '2025-06-09 16:21:29');

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
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-purple', 'Y', 'admin', '2025-06-03 20:44:14', 'admin', '2025-06-07 12:15:37', '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-06-03 20:44:14', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2025-06-03 20:44:14', 'admin', '2025-06-07 12:15:27', '是否开启注册用户功能（true开启，false关闭）');
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
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_dict_data` VALUES (100, 0, '空闲', '0', 'dorm_status', NULL, 'success', 'N', '0', 'admin', '2025-06-03 22:36:12', 'admin', '2025-06-09 20:03:19', NULL);
INSERT INTO `sys_dict_data` VALUES (101, 1, '满员', '1', 'dorm_status', NULL, 'danger', 'N', '0', 'admin', '2025-06-03 22:36:42', 'admin', '2025-06-09 20:03:44', NULL);
INSERT INTO `sys_dict_data` VALUES (102, 0, '公告', '0', 'dorm_notice_type', NULL, 'primary', 'N', '0', 'admin', '2025-06-06 14:05:31', 'admin', '2025-06-06 15:23:11', '类似学校宣传文章之类的');
INSERT INTO `sys_dict_data` VALUES (103, 1, '通知', '1', 'dorm_notice_type', NULL, 'warning', 'N', '0', 'admin', '2025-06-06 14:06:16', 'admin', '2025-06-06 15:23:39', '类似放假信息');
INSERT INTO `sys_dict_data` VALUES (104, 2, '活动', '2', 'dorm_notice_type', NULL, 'success', 'N', '0', 'admin', '2025-06-06 14:07:00', 'admin', '2025-06-06 15:23:59', '活动信息');

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
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_dict_type` VALUES (101, '宿舍通知类型', 'dorm_notice_type', '0', 'admin', '2025-06-06 13:29:30', '', NULL, '宿舍通知类型列表');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 412 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-03 21:16:08');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 11:13:01');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 12:54:47');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 13:28:23');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 15:33:29');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-04 18:33:12');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 18:33:15');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 19:51:35');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 20:58:42');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-04 22:40:21');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-05 15:03:17');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-05 16:09:56');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-05 18:49:55');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-05 18:49:58');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-05 20:57:13');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 10:50:43');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 12:38:12');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 14:55:04');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 18:36:27');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-06-06 19:18:45');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 19:18:49');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 19:56:55');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 22:25:32');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-06 23:02:11');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-06 23:39:12');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 12:13:48');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 12:15:59');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 12:16:03');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 12:16:09');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 12:16:18');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 12:17:23');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 12:18:22');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 12:19:11');
INSERT INTO `sys_logininfor` VALUES (133, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-06-07 12:19:27');
INSERT INTO `sys_logininfor` VALUES (134, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 12:19:37');
INSERT INTO `sys_logininfor` VALUES (135, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 12:19:51');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 12:19:59');
INSERT INTO `sys_logininfor` VALUES (137, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 12:22:58');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 13:17:25');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 13:27:43');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 13:28:25');
INSERT INTO `sys_logininfor` VALUES (141, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-06-07 13:28:37');
INSERT INTO `sys_logininfor` VALUES (142, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 13:28:44');
INSERT INTO `sys_logininfor` VALUES (143, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 13:34:32');
INSERT INTO `sys_logininfor` VALUES (144, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 13:34:49');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 14:23:13');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-07 14:25:25');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 14:31:58');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 14:56:21');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 15:23:10');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 15:24:06');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '1', '用户不存在/密码错误', '2025-06-07 15:30:15');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '1', '用户不存在/密码错误', '2025-06-07 15:30:29');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '1', '验证码错误', '2025-06-07 15:30:30');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '1', '验证码错误', '2025-06-07 15:30:31');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-07 15:37:12');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-06-07 15:48:09');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 15:48:55');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 15:49:07');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-07 15:51:14');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 15:51:23');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-06-07 15:54:10');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 15:54:15');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 15:56:00');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 15:56:20');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 15:56:24');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 15:59:04');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 16:25:00');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 16:25:39');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 16:36:10');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 16:36:29');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-07 16:43:37');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 16:45:33');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 16:45:36');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 16:45:44');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-06-07 17:03:39');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:03:44');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:26:46');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:26:51');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:27:31');
INSERT INTO `sys_logininfor` VALUES (180, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:27:48');
INSERT INTO `sys_logininfor` VALUES (181, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:28:08');
INSERT INTO `sys_logininfor` VALUES (182, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:28:23');
INSERT INTO `sys_logininfor` VALUES (183, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:29:24');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:29:29');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:29:35');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:30:55');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:32:20');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:32:25');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:32:43');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:32:46');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:33:04');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:33:08');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:35:41');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:35:45');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 17:36:15');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 17:36:18');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:13:14');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 18:13:20');
INSERT INTO `sys_logininfor` VALUES (199, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:13:33');
INSERT INTO `sys_logininfor` VALUES (200, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 18:18:33');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:18:38');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 18:18:44');
INSERT INTO `sys_logininfor` VALUES (203, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:18:55');
INSERT INTO `sys_logininfor` VALUES (204, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 18:21:01');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:21:07');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 18:21:13');
INSERT INTO `sys_logininfor` VALUES (207, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:21:24');
INSERT INTO `sys_logininfor` VALUES (208, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 18:22:41');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:22:49');
INSERT INTO `sys_logininfor` VALUES (210, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 18:26:18');
INSERT INTO `sys_logininfor` VALUES (211, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 18:26:36');
INSERT INTO `sys_logininfor` VALUES (212, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-06-07 19:40:33');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-07 19:40:36');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-07 19:40:42');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-07 19:40:45');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 19:40:51');
INSERT INTO `sys_logininfor` VALUES (217, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-07 21:55:11');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 21:55:23');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 23:24:45');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-07 23:25:00');
INSERT INTO `sys_logininfor` VALUES (221, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-07 23:25:14');
INSERT INTO `sys_logininfor` VALUES (222, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 00:20:36');
INSERT INTO `sys_logininfor` VALUES (223, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 00:21:13');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 00:21:26');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 00:21:54');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 00:21:58');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 00:22:08');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 00:22:11');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 00:22:16');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-06-08 00:22:55');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 00:23:10');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-06-08 00:24:25');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 00:24:31');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 00:24:44');
INSERT INTO `sys_logininfor` VALUES (235, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 00:24:58');
INSERT INTO `sys_logininfor` VALUES (236, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 11:22:53');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 11:23:06');
INSERT INTO `sys_logininfor` VALUES (238, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:00:13');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:00:18');
INSERT INTO `sys_logininfor` VALUES (240, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:00:22');
INSERT INTO `sys_logininfor` VALUES (241, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:00:33');
INSERT INTO `sys_logininfor` VALUES (242, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:01:03');
INSERT INTO `sys_logininfor` VALUES (243, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:01:14');
INSERT INTO `sys_logininfor` VALUES (244, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:01:46');
INSERT INTO `sys_logininfor` VALUES (245, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:01:57');
INSERT INTO `sys_logininfor` VALUES (246, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:03:48');
INSERT INTO `sys_logininfor` VALUES (247, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:03:57');
INSERT INTO `sys_logininfor` VALUES (248, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:04:16');
INSERT INTO `sys_logininfor` VALUES (249, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 12:04:34');
INSERT INTO `sys_logininfor` VALUES (250, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:04:45');
INSERT INTO `sys_logininfor` VALUES (251, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:04:55');
INSERT INTO `sys_logininfor` VALUES (252, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:05:15');
INSERT INTO `sys_logininfor` VALUES (253, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:06:14');
INSERT INTO `sys_logininfor` VALUES (254, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:06:31');
INSERT INTO `sys_logininfor` VALUES (255, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 12:06:43');
INSERT INTO `sys_logininfor` VALUES (256, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2025-06-08 12:06:52');
INSERT INTO `sys_logininfor` VALUES (257, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 12:07:01');
INSERT INTO `sys_logininfor` VALUES (258, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 13:35:17');
INSERT INTO `sys_logininfor` VALUES (259, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 13:46:14');
INSERT INTO `sys_logininfor` VALUES (260, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 13:46:37');
INSERT INTO `sys_logininfor` VALUES (261, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 13:46:45');
INSERT INTO `sys_logininfor` VALUES (262, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 13:59:53');
INSERT INTO `sys_logininfor` VALUES (263, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 13:59:58');
INSERT INTO `sys_logininfor` VALUES (264, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 14:00:05');
INSERT INTO `sys_logininfor` VALUES (265, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 14:00:15');
INSERT INTO `sys_logininfor` VALUES (266, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-08 14:13:36');
INSERT INTO `sys_logininfor` VALUES (267, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 14:13:44');
INSERT INTO `sys_logininfor` VALUES (268, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-08 14:28:25');
INSERT INTO `sys_logininfor` VALUES (269, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 14:28:29');
INSERT INTO `sys_logininfor` VALUES (270, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 14:29:16');
INSERT INTO `sys_logininfor` VALUES (271, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 14:29:33');
INSERT INTO `sys_logininfor` VALUES (272, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 14:36:12');
INSERT INTO `sys_logininfor` VALUES (273, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 14:36:17');
INSERT INTO `sys_logininfor` VALUES (274, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 14:36:27');
INSERT INTO `sys_logininfor` VALUES (275, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 14:44:11');
INSERT INTO `sys_logininfor` VALUES (276, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 14:44:22');
INSERT INTO `sys_logininfor` VALUES (277, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 14:47:57');
INSERT INTO `sys_logininfor` VALUES (278, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 14:48:06');
INSERT INTO `sys_logininfor` VALUES (279, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 14:48:18');
INSERT INTO `sys_logininfor` VALUES (280, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 14:53:23');
INSERT INTO `sys_logininfor` VALUES (281, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 15:14:57');
INSERT INTO `sys_logininfor` VALUES (282, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-06-08 15:24:45');
INSERT INTO `sys_logininfor` VALUES (283, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 15:25:10');
INSERT INTO `sys_logininfor` VALUES (284, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 16:08:07');
INSERT INTO `sys_logininfor` VALUES (285, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-08 16:10:52');
INSERT INTO `sys_logininfor` VALUES (286, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 16:10:58');
INSERT INTO `sys_logininfor` VALUES (287, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-08 16:11:19');
INSERT INTO `sys_logininfor` VALUES (288, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 16:11:23');
INSERT INTO `sys_logininfor` VALUES (289, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-06-08 16:18:04');
INSERT INTO `sys_logininfor` VALUES (290, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 16:18:09');
INSERT INTO `sys_logininfor` VALUES (291, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 16:35:27');
INSERT INTO `sys_logininfor` VALUES (292, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 16:35:38');
INSERT INTO `sys_logininfor` VALUES (293, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 16:36:34');
INSERT INTO `sys_logininfor` VALUES (294, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 16:36:44');
INSERT INTO `sys_logininfor` VALUES (295, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 16:40:40');
INSERT INTO `sys_logininfor` VALUES (296, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 18:00:13');
INSERT INTO `sys_logininfor` VALUES (297, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 18:00:18');
INSERT INTO `sys_logininfor` VALUES (298, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 18:00:35');
INSERT INTO `sys_logininfor` VALUES (299, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-08 18:04:17');
INSERT INTO `sys_logininfor` VALUES (300, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 19:44:25');
INSERT INTO `sys_logininfor` VALUES (301, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 19:46:43');
INSERT INTO `sys_logininfor` VALUES (302, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 19:46:54');
INSERT INTO `sys_logininfor` VALUES (303, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 19:50:40');
INSERT INTO `sys_logininfor` VALUES (304, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 19:50:51');
INSERT INTO `sys_logininfor` VALUES (305, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 19:50:55');
INSERT INTO `sys_logininfor` VALUES (306, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 20:26:17');
INSERT INTO `sys_logininfor` VALUES (307, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 20:26:28');
INSERT INTO `sys_logininfor` VALUES (308, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 20:26:33');
INSERT INTO `sys_logininfor` VALUES (309, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 20:29:25');
INSERT INTO `sys_logininfor` VALUES (310, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 20:29:40');
INSERT INTO `sys_logininfor` VALUES (311, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 20:31:58');
INSERT INTO `sys_logininfor` VALUES (312, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 20:32:33');
INSERT INTO `sys_logininfor` VALUES (313, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 20:33:03');
INSERT INTO `sys_logininfor` VALUES (314, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 20:33:25');
INSERT INTO `sys_logininfor` VALUES (315, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 20:35:51');
INSERT INTO `sys_logininfor` VALUES (316, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 20:36:32');
INSERT INTO `sys_logininfor` VALUES (317, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 20:39:01');
INSERT INTO `sys_logininfor` VALUES (318, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 20:39:21');
INSERT INTO `sys_logininfor` VALUES (319, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-06-08 21:05:58');
INSERT INTO `sys_logininfor` VALUES (320, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 21:06:02');
INSERT INTO `sys_logininfor` VALUES (321, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 21:11:14');
INSERT INTO `sys_logininfor` VALUES (322, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 21:11:35');
INSERT INTO `sys_logininfor` VALUES (323, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 21:30:34');
INSERT INTO `sys_logininfor` VALUES (324, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 21:30:38');
INSERT INTO `sys_logininfor` VALUES (325, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 22:53:58');
INSERT INTO `sys_logininfor` VALUES (326, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 22:59:32');
INSERT INTO `sys_logininfor` VALUES (327, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2025-06-08 22:59:47');
INSERT INTO `sys_logininfor` VALUES (328, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 22:59:54');
INSERT INTO `sys_logininfor` VALUES (329, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 23:00:48');
INSERT INTO `sys_logininfor` VALUES (330, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:00:52');
INSERT INTO `sys_logininfor` VALUES (331, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:03:12');
INSERT INTO `sys_logininfor` VALUES (332, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:04:19');
INSERT INTO `sys_logininfor` VALUES (333, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:05:16');
INSERT INTO `sys_logininfor` VALUES (334, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:06:20');
INSERT INTO `sys_logininfor` VALUES (335, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2025-06-08 23:10:37');
INSERT INTO `sys_logininfor` VALUES (336, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:10:45');
INSERT INTO `sys_logininfor` VALUES (337, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:13:54');
INSERT INTO `sys_logininfor` VALUES (338, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:14:41');
INSERT INTO `sys_logininfor` VALUES (339, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:15:25');
INSERT INTO `sys_logininfor` VALUES (340, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:23:33');
INSERT INTO `sys_logininfor` VALUES (341, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 23:24:34');
INSERT INTO `sys_logininfor` VALUES (342, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:24:39');
INSERT INTO `sys_logininfor` VALUES (343, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:29:10');
INSERT INTO `sys_logininfor` VALUES (344, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:29:34');
INSERT INTO `sys_logininfor` VALUES (345, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 23:29:46');
INSERT INTO `sys_logininfor` VALUES (346, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:29:55');
INSERT INTO `sys_logininfor` VALUES (347, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:30:13');
INSERT INTO `sys_logininfor` VALUES (348, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:31:01');
INSERT INTO `sys_logininfor` VALUES (349, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 23:31:28');
INSERT INTO `sys_logininfor` VALUES (350, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 23:33:36');
INSERT INTO `sys_logininfor` VALUES (351, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:33:42');
INSERT INTO `sys_logininfor` VALUES (352, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 23:33:52');
INSERT INTO `sys_logininfor` VALUES (353, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:34:02');
INSERT INTO `sys_logininfor` VALUES (354, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 23:34:34');
INSERT INTO `sys_logininfor` VALUES (355, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:34:49');
INSERT INTO `sys_logininfor` VALUES (356, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:36:07');
INSERT INTO `sys_logininfor` VALUES (357, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 23:37:07');
INSERT INTO `sys_logininfor` VALUES (358, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 23:37:12');
INSERT INTO `sys_logininfor` VALUES (359, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:37:16');
INSERT INTO `sys_logininfor` VALUES (360, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 23:37:22');
INSERT INTO `sys_logininfor` VALUES (361, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:37:25');
INSERT INTO `sys_logininfor` VALUES (362, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-08 23:38:19');
INSERT INTO `sys_logininfor` VALUES (363, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-06-08 23:38:29');
INSERT INTO `sys_logininfor` VALUES (364, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:38:33');
INSERT INTO `sys_logininfor` VALUES (365, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:38:54');
INSERT INTO `sys_logininfor` VALUES (366, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-08 23:45:47');
INSERT INTO `sys_logininfor` VALUES (367, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 09:28:30');
INSERT INTO `sys_logininfor` VALUES (368, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-09 09:28:56');
INSERT INTO `sys_logininfor` VALUES (369, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-06-09 12:35:13');
INSERT INTO `sys_logininfor` VALUES (370, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 12:35:21');
INSERT INTO `sys_logininfor` VALUES (371, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-06-09 12:36:47');
INSERT INTO `sys_logininfor` VALUES (372, '2310305320', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-06-09 12:36:58');
INSERT INTO `sys_logininfor` VALUES (373, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 12:39:11');
INSERT INTO `sys_logininfor` VALUES (374, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 12:39:48');
INSERT INTO `sys_logininfor` VALUES (375, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 12:40:48');
INSERT INTO `sys_logininfor` VALUES (376, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 12:40:57');
INSERT INTO `sys_logininfor` VALUES (377, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 12:41:06');
INSERT INTO `sys_logininfor` VALUES (378, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 12:56:23');
INSERT INTO `sys_logininfor` VALUES (379, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 12:59:20');
INSERT INTO `sys_logininfor` VALUES (380, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 12:59:35');
INSERT INTO `sys_logininfor` VALUES (381, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 13:03:33');
INSERT INTO `sys_logininfor` VALUES (382, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:03:38');
INSERT INTO `sys_logininfor` VALUES (383, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:04:07');
INSERT INTO `sys_logininfor` VALUES (384, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:08:16');
INSERT INTO `sys_logininfor` VALUES (385, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 13:08:24');
INSERT INTO `sys_logininfor` VALUES (386, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:08:40');
INSERT INTO `sys_logininfor` VALUES (387, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 13:09:37');
INSERT INTO `sys_logininfor` VALUES (388, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:09:41');
INSERT INTO `sys_logininfor` VALUES (389, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 13:10:03');
INSERT INTO `sys_logininfor` VALUES (390, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:10:14');
INSERT INTO `sys_logininfor` VALUES (391, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 13:12:13');
INSERT INTO `sys_logininfor` VALUES (392, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:12:20');
INSERT INTO `sys_logininfor` VALUES (393, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 13:16:29');
INSERT INTO `sys_logininfor` VALUES (394, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:16:43');
INSERT INTO `sys_logininfor` VALUES (395, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 13:17:00');
INSERT INTO `sys_logininfor` VALUES (396, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 13:51:08');
INSERT INTO `sys_logininfor` VALUES (397, '2310305320', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-06-09 13:51:21');
INSERT INTO `sys_logininfor` VALUES (398, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 13:51:28');
INSERT INTO `sys_logininfor` VALUES (399, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 14:30:19');
INSERT INTO `sys_logininfor` VALUES (400, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2025-06-09 14:38:00');
INSERT INTO `sys_logininfor` VALUES (401, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 1.x', '0', '退出成功', '2025-06-09 14:38:11');
INSERT INTO `sys_logininfor` VALUES (402, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2025-06-09 14:44:22');
INSERT INTO `sys_logininfor` VALUES (403, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '1', '验证码已失效', '2025-06-09 14:56:06');
INSERT INTO `sys_logininfor` VALUES (404, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 14:56:13');
INSERT INTO `sys_logininfor` VALUES (405, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 14:56:35');
INSERT INTO `sys_logininfor` VALUES (406, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 14:56:39');
INSERT INTO `sys_logininfor` VALUES (407, 'admin', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '退出成功', '2025-06-09 14:56:50');
INSERT INTO `sys_logininfor` VALUES (408, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 16:10:39');
INSERT INTO `sys_logininfor` VALUES (409, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-09 19:02:56');
INSERT INTO `sys_logininfor` VALUES (410, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '1', '验证码已失效', '2025-06-09 20:01:02');
INSERT INTO `sys_logininfor` VALUES (411, '2310305320', '127.0.0.1', '内网IP', 'Chrome Mobile', 'Android 6.x', '0', '登录成功', '2025-06-09 20:01:06');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2037 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_menu` VALUES (2007, '学生管理', 2000, 2, 'student', 'dorm/student/index', NULL, '', 1, 0, 'C', '0', '0', 'dorm:student:list', '#', 'admin', '2025-06-04 13:58:14', 'admin', '2025-06-06 14:32:19', '学生管理菜单');
INSERT INTO `sys_menu` VALUES (2008, '学生管理查询', 2007, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:student:query', '#', 'admin', '2025-06-04 13:58:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '学生管理新增', 2007, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:student:add', '#', 'admin', '2025-06-04 13:58:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '学生管理修改', 2007, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:student:edit', '#', 'admin', '2025-06-04 13:58:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '学生管理删除', 2007, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:student:remove', '#', 'admin', '2025-06-04 13:58:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '学生管理导出', 2007, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:student:export', '#', 'admin', '2025-06-04 13:58:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '宿舍公告', 2000, 1, 'notices', 'dorm/notices/index', NULL, '', 1, 0, 'C', '0', '0', 'dorm:notices:list', '#', 'admin', '2025-06-06 15:01:45', '', NULL, '宿舍公告菜单');
INSERT INTO `sys_menu` VALUES (2032, '宿舍公告查询', 2031, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:notices:query', '#', 'admin', '2025-06-06 15:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '宿舍公告新增', 2031, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:notices:add', '#', 'admin', '2025-06-06 15:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '宿舍公告修改', 2031, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:notices:edit', '#', 'admin', '2025-06-06 15:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '宿舍公告删除', 2031, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:notices:remove', '#', 'admin', '2025-06-06 15:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '宿舍公告导出', 2031, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'dorm:notices:export', '#', 'admin', '2025-06-06 15:01:45', '', NULL, '');

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
) ENGINE = InnoDB AUTO_INCREMENT = 383 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_oper_log` VALUES (208, '代码生成', 6, 'com.dorm.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_student\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:45:59', 274);
INSERT INTO `sys_oper_log` VALUES (209, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"student\",\"className\":\"DormStudent\",\"columns\":[{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生ID，主键\",\"columnId\":29,\"columnName\":\"student_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"studentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"系统用户ID → sys_user.user_id\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"StudentNo\",\"columnComment\":\"学号\",\"columnId\":31,\"columnName\":\"student_no\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"学生姓名\",\"columnId\":32,\"columnName\":\"name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:46:46', 143);
INSERT INTO `sys_oper_log` VALUES (210, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 23:02:27\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"上级节点\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"1\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 23:02:27\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-03 23:02:27\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:46:53', 78);
INSERT INTO `sys_oper_log` VALUES (211, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"student\",\"className\":\"DormStudent\",\"columns\":[{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生ID，主键\",\"columnId\":29,\"columnName\":\"student_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"studentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-06-04 13:46:46\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"系统用户ID → sys_user.user_id\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-06-04 13:46:46\",\"usableColumn\":false},{\"capJavaField\":\"StudentNo\",\"columnComment\":\"学号\",\"columnId\":31,\"columnName\":\"student_no\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-06-04 13:46:46\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"学生姓名\",\"columnId\":32,\"columnName\":\"name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:47:14', 114);
INSERT INTO `sys_oper_log` VALUES (212, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_student\"}', NULL, 0, NULL, '2025-06-04 13:47:17', 228);
INSERT INTO `sys_oper_log` VALUES (213, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"student\",\"className\":\"DormStudent\",\"columns\":[{\"capJavaField\":\"StudentId\",\"columnComment\":\"学生ID，主键\",\"columnId\":29,\"columnName\":\"student_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"studentId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-06-04 13:47:14\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"系统用户ID → sys_user.user_id\",\"columnId\":30,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-06-04 13:47:14\",\"usableColumn\":false},{\"capJavaField\":\"StudentNo\",\"columnComment\":\"学号\",\"columnId\":31,\"columnName\":\"student_no\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"studentNo\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-06-04 13:47:14\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"学生姓名\",\"columnId\":32,\"columnName\":\"name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-04 13:45:59\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 13:53:01', 74);
INSERT INTO `sys_oper_log` VALUES (214, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_student\"}', NULL, 0, NULL, '2025-06-04 13:53:14', 215);
INSERT INTO `sys_oper_log` VALUES (215, '学生管理', 2, 'com.dorm.manage.controller.DormStudentController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"计算机科学与技术1班\",\"createBy\":\"admin\",\"createTime\":\"2025-01-10 09:00:00\",\"dormId\":213,\"email\":\"zhangsan@school.edu\",\"gender\":\"男\",\"name\":\"张三\",\"params\":{},\"phone\":\"13800138001\",\"remark\":\"\",\"status\":\"0\",\"studentId\":1,\"studentNo\":\"20230001\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-04 20:25:31\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 20:25:31', 161);
INSERT INTO `sys_oper_log` VALUES (216, '学生管理', 2, 'com.dorm.manage.controller.DormStudentController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"计算机科学与技术1班\",\"createBy\":\"admin\",\"createTime\":\"2025-01-10 09:00:00\",\"dormId\":213,\"email\":\"lisi@school.edu\",\"gender\":\"女\",\"name\":\"李四\",\"params\":{},\"phone\":\"13800138002\",\"remark\":\"\",\"status\":\"0\",\"studentId\":2,\"studentNo\":\"20230002\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-04 20:25:37\",\"userId\":102}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-04 20:25:37', 15);
INSERT INTO `sys_oper_log` VALUES (217, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"11\",\"createTime\":\"2025-06-05 19:15:39\",\"dormId\":213,\"email\":\"1\",\"gender\":\"男\",\"name\":\"1\",\"params\":{},\"phone\":\"11\",\"studentId\":16,\"studentNo\":\"1\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:15:40', 319);
INSERT INTO `sys_oper_log` VALUES (218, '学生管理', 3, 'com.dorm.manage.controller.DormStudentController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/student/16', '127.0.0.1', '内网IP', '[16]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:16:32', 119);
INSERT INTO `sys_oper_log` VALUES (219, '用户管理', 1, 'com.dorm.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"email\":\"\",\"nickName\":\"1\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"roleIds\":[],\"status\":\"0\",\"userId\":100,\"userName\":\"11111\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:17:27', 191);
INSERT INTO `sys_oper_log` VALUES (220, '用户管理', 3, 'com.dorm.web.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/100', '127.0.0.1', '内网IP', '[100]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:17:42', 35);
INSERT INTO `sys_oper_log` VALUES (221, '学生管理', 2, 'com.dorm.manage.controller.DormStudentController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"计算机科学与技术1班\",\"createBy\":\"admin\",\"createTime\":\"2025-01-10 09:00:00\",\"delFlag\":\"0\",\"dormBuilding\":{\"buildingName\":\"101\",\"children\":[],\"dormId\":213,\"params\":{},\"status\":\"0\"},\"dormId\":223,\"email\":\"zhangsan@school.edu\",\"gender\":\"男\",\"name\":\"张三\",\"params\":{},\"phone\":\"13800138001\",\"remark\":\"\",\"status\":\"0\",\"studentId\":1,\"studentNo\":\"20230001\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-05 19:33:48\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:33:49', 124);
INSERT INTO `sys_oper_log` VALUES (222, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-06-05 19:52:06\",\"name\":\"1\",\"params\":{},\"studentId\":17,\"studentNo\":\"1222\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:52:06', 282);
INSERT INTO `sys_oper_log` VALUES (223, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"111\",\"createTime\":\"2025-06-05 19:52:31\",\"dormId\":213,\"gender\":\"男\",\"name\":\"1\",\"params\":{},\"phone\":\"111\",\"studentId\":18,\"studentNo\":\"1\",\"userId\":111}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:52:31', 103);
INSERT INTO `sys_oper_log` VALUES (224, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"1\",\"createTime\":\"2025-06-05 19:53:27\",\"name\":\"1\",\"params\":{},\"studentNo\":\"1\",\"userId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormStudentMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormStudentMapper.insertDormStudent-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into dorm_student          ( user_id,             student_no,             name,                          class_name,                                                                                           create_time )           values ( ?,             ?,             ?,                          ?,                                                                                           ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'\n; Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'; nested exception is java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'', '2025-06-05 19:53:27', 130);
INSERT INTO `sys_oper_log` VALUES (225, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"1\",\"createTime\":\"2025-06-05 19:55:02\",\"dormId\":213,\"name\":\"1\",\"params\":{},\"studentId\":20,\"studentNo\":\"1213\",\"userId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 19:55:02', 90);
INSERT INTO `sys_oper_log` VALUES (226, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206,220\",\"buildingName\":\"123\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-05 20:02:50\",\"orderNum\":1,\"params\":{},\"parentId\":220}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 20:02:50', 104);
INSERT INTO `sys_oper_log` VALUES (227, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/229', '127.0.0.1', '内网IP', '[229]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 20:03:08', 80);
INSERT INTO `sys_oper_log` VALUES (228, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-06-05 20:09:14\",\"dormId\":213,\"name\":\"1\",\"params\":{},\"studentNo\":\"1\",\"userId\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormStudentMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormStudentMapper.insertDormStudent-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into dorm_student          ( user_id,             student_no,             name,                                                                              dorm_id,                          create_time )           values ( ?,             ?,             ?,                                                                              ?,                          ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'\n; Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'; nested exception is java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'uk_dorm_student_student_no\'', '2025-06-05 20:09:15', 354);
INSERT INTO `sys_oper_log` VALUES (229, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"createTime\":\"2025-06-05 20:09:38\",\"dormId\":213,\"name\":\"111\",\"params\":{},\"studentId\":22,\"studentNo\":\"2310313\",\"userId\":1111}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 20:09:38', 60);
INSERT INTO `sys_oper_log` VALUES (230, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"buildingName\":\"12332\",\"children\":[],\"createBy\":\"admin\",\"orderNum\":2131,\"params\":{},\"parentId\":0}', NULL, 1, 'Cannot invoke \"com.dorm.common.core.domain.entity.DormBuilding.getStatus()\" because \"info\" is null', '2025-06-05 20:10:33', 33);
INSERT INTO `sys_oper_log` VALUES (231, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204\",\"buildingName\":\"12332\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-05 20:10:48\",\"orderNum\":2131,\"params\":{},\"parentId\":204}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 20:10:48', 109);
INSERT INTO `sys_oper_log` VALUES (232, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"buildingName\":\"5151\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-05 20:11:55\",\"orderNum\":415,\"params\":{},\"parentId\":100}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 20:11:55', 41);
INSERT INTO `sys_oper_log` VALUES (233, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101\",\"buildingName\":\"5312\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-05 20:13:36\",\"dormManager\":\"55\",\"orderNum\":51,\"params\":{},\"parentId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 20:14:59', 162953);
INSERT INTO `sys_oper_log` VALUES (234, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/231', '127.0.0.1', '内网IP', '[231]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-05 21:07:42', 241);
INSERT INTO `sys_oper_log` VALUES (235, '字典类型', 1, 'com.dorm.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"宿舍通知类型\",\"dictType\":\"dorm_notice_type\",\"params\":{},\"remark\":\"宿舍通知类型列表\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 13:29:30', 133);
INSERT INTO `sys_oper_log` VALUES (236, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"全校公告\",\"dictSort\":0,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"0\",\"listClass\":\"info\",\"params\":{},\"remark\":\"类似学校宣传文章之类的\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:05:31', 271);
INSERT INTO `sys_oper_log` VALUES (237, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:05:31\",\"default\":false,\"dictCode\":102,\"dictLabel\":\"全校公告\",\"dictSort\":0,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"0\",\"isDefault\":\"N\",\"listClass\":\"primary\",\"params\":{},\"remark\":\"类似学校宣传文章之类的\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:05:42', 84);
INSERT INTO `sys_oper_log` VALUES (238, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"楼栋公告\",\"dictSort\":1,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"1\",\"listClass\":\"primary\",\"params\":{},\"remark\":\"类似学校宣传文章之类的\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:06:16', 70);
INSERT INTO `sys_oper_log` VALUES (239, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"全校通知\",\"dictSort\":2,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"2\",\"listClass\":\"warning\",\"params\":{},\"remark\":\"类似放假信息\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:07:00', 57);
INSERT INTO `sys_oper_log` VALUES (240, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"楼栋通知\",\"dictSort\":3,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"3\",\"listClass\":\"warning\",\"params\":{},\"remark\":\"类似放假信息\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:07:25', 51);
INSERT INTO `sys_oper_log` VALUES (241, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"全校活动\",\"dictSort\":5,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"4\",\"listClass\":\"success\",\"params\":{},\"remark\":\"活动信息\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:08:05', 51);
INSERT INTO `sys_oper_log` VALUES (242, '字典数据', 1, 'com.dorm.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"楼栋活动\",\"dictSort\":5,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"5\",\"listClass\":\"success\",\"params\":{},\"remark\":\"活动信息\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:08:39', 73);
INSERT INTO `sys_oper_log` VALUES (243, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:08:05\",\"default\":false,\"dictCode\":106,\"dictLabel\":\"全校活动\",\"dictSort\":4,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"4\",\"isDefault\":\"N\",\"listClass\":\"success\",\"params\":{},\"remark\":\"活动信息\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:08:54', 74);
INSERT INTO `sys_oper_log` VALUES (244, '代码生成', 6, 'com.dorm.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_notice\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:09:18', 221);
INSERT INTO `sys_oper_log` VALUES (245, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"notice\",\"className\":\"DormNotice\",\"columns\":[{\"capJavaField\":\"NoticeId\",\"columnComment\":\"公告ID\",\"columnId\":45,\"columnName\":\"notice_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"noticeId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"NoticeTitle\",\"columnComment\":\"公告标题\",\"columnId\":46,\"columnName\":\"notice_title\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeTitle\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"NoticeType\",\"columnComment\":\"公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）\",\"columnId\":47,\"columnName\":\"notice_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"dorm_notice_type\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"DormId\",\"columnComment\":\"关联宿舍楼ID（逻辑外键）\",\"columnId\":48,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:21:54', 125);
INSERT INTO `sys_oper_log` VALUES (246, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_notice\"}', NULL, 0, NULL, '2025-06-06 14:21:58', 82);
INSERT INTO `sys_oper_log` VALUES (247, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2013', '127.0.0.1', '内网IP', '2013', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-06-06 14:30:03', 11);
INSERT INTO `sys_oper_log` VALUES (248, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2014', '127.0.0.1', '内网IP', '2014', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:30:06', 32);
INSERT INTO `sys_oper_log` VALUES (249, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2015', '127.0.0.1', '内网IP', '2015', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:30:07', 23);
INSERT INTO `sys_oper_log` VALUES (250, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2016', '127.0.0.1', '内网IP', '2016', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:30:08', 19);
INSERT INTO `sys_oper_log` VALUES (251, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2017', '127.0.0.1', '内网IP', '2017', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:30:09', 27);
INSERT INTO `sys_oper_log` VALUES (252, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2018', '127.0.0.1', '内网IP', '2018', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:30:11', 24);
INSERT INTO `sys_oper_log` VALUES (253, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2013', '127.0.0.1', '内网IP', '2013', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:30:12', 23);
INSERT INTO `sys_oper_log` VALUES (254, '菜单管理', 2, 'com.dorm.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"dorm/student/index\",\"createTime\":\"2025-06-04 13:58:14\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2007,\"menuName\":\"学生管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"student\",\"perms\":\"dorm:student:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:32:20', 95);
INSERT INTO `sys_oper_log` VALUES (255, '菜单管理', 2, 'com.dorm.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"dorm/notice/index\",\"createTime\":\"2025-06-06 14:31:19\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"宿舍公告\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2000,\"path\":\"notice\",\"perms\":\"dorm:notice:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:32:26', 36);
INSERT INTO `sys_oper_log` VALUES (256, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_notice\"}', NULL, 0, NULL, '2025-06-06 14:43:09', 505);
INSERT INTO `sys_oper_log` VALUES (257, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2020', '127.0.0.1', '内网IP', '2020', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:44:12', 41);
INSERT INTO `sys_oper_log` VALUES (258, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2021', '127.0.0.1', '内网IP', '2021', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:44:14', 32);
INSERT INTO `sys_oper_log` VALUES (259, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2022', '127.0.0.1', '内网IP', '2022', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:44:15', 16);
INSERT INTO `sys_oper_log` VALUES (260, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2023', '127.0.0.1', '内网IP', '2023', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:44:16', 28);
INSERT INTO `sys_oper_log` VALUES (261, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2024', '127.0.0.1', '内网IP', '2024', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:44:16', 25);
INSERT INTO `sys_oper_log` VALUES (262, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2019', '127.0.0.1', '内网IP', '2019', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:44:18', 20);
INSERT INTO `sys_oper_log` VALUES (263, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"dr_notice\",\"className\":\"DormNotice\",\"columns\":[{\"capJavaField\":\"NoticeId\",\"columnComment\":\"公告ID\",\"columnId\":45,\"columnName\":\"notice_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"noticeId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 14:21:54\",\"usableColumn\":false},{\"capJavaField\":\"NoticeTitle\",\"columnComment\":\"公告标题\",\"columnId\":46,\"columnName\":\"notice_title\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeTitle\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 14:21:54\",\"usableColumn\":false},{\"capJavaField\":\"NoticeType\",\"columnComment\":\"公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）\",\"columnId\":47,\"columnName\":\"notice_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"dorm_notice_type\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 14:21:54\",\"usableColumn\":false},{\"capJavaField\":\"DormId\",\"columnComment\":\"关联宿舍楼ID（逻辑外键）\",\"columnId\":48,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"202', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 14:57:57', 105);
INSERT INTO `sys_oper_log` VALUES (264, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"notices\",\"className\":\"DormNotice\",\"columns\":[{\"capJavaField\":\"NoticeId\",\"columnComment\":\"公告ID\",\"columnId\":45,\"columnName\":\"notice_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"noticeId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 14:57:57\",\"usableColumn\":false},{\"capJavaField\":\"NoticeTitle\",\"columnComment\":\"公告标题\",\"columnId\":46,\"columnName\":\"notice_title\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeTitle\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 14:57:57\",\"usableColumn\":false},{\"capJavaField\":\"NoticeType\",\"columnComment\":\"公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）\",\"columnId\":47,\"columnName\":\"notice_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"dorm_notice_type\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 14:57:57\",\"usableColumn\":false},{\"capJavaField\":\"DormId\",\"columnComment\":\"关联宿舍楼ID（逻辑外键）\",\"columnId\":48,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:00:09', 96);
INSERT INTO `sys_oper_log` VALUES (265, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_notice\"}', NULL, 0, NULL, '2025-06-06 15:00:15', 252);
INSERT INTO `sys_oper_log` VALUES (266, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2026', '127.0.0.1', '内网IP', '2026', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:01:20', 72);
INSERT INTO `sys_oper_log` VALUES (267, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2027', '127.0.0.1', '内网IP', '2027', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:01:20', 41);
INSERT INTO `sys_oper_log` VALUES (268, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2028', '127.0.0.1', '内网IP', '2028', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:01:21', 35);
INSERT INTO `sys_oper_log` VALUES (269, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2029', '127.0.0.1', '内网IP', '2029', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:01:22', 24);
INSERT INTO `sys_oper_log` VALUES (270, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2030', '127.0.0.1', '内网IP', '2030', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:01:22', 29);
INSERT INTO `sys_oper_log` VALUES (271, '菜单管理', 3, 'com.dorm.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2025', '127.0.0.1', '内网IP', '2025', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:01:26', 8);
INSERT INTO `sys_oper_log` VALUES (272, '宿舍公告', 5, 'com.dorm.manage.controller.DormNoticeController.export()', 'POST', 1, 'admin', '研发部门', '/dorm/notices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2025-06-06 15:11:01', 978);
INSERT INTO `sys_oper_log` VALUES (273, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:05:31\",\"default\":false,\"dictCode\":102,\"dictLabel\":\"公告\",\"dictSort\":0,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"0\",\"isDefault\":\"N\",\"listClass\":\"primary\",\"params\":{},\"remark\":\"类似学校宣传文章之类的\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:23:11', 132);
INSERT INTO `sys_oper_log` VALUES (274, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:06:16\",\"default\":false,\"dictCode\":103,\"dictLabel\":\"通知\",\"dictSort\":1,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"remark\":\"类似放假信息\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:23:39', 107);
INSERT INTO `sys_oper_log` VALUES (275, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:07:00\",\"default\":false,\"dictCode\":104,\"dictLabel\":\"活动\",\"dictSort\":2,\"dictType\":\"dorm_notice_type\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"success\",\"params\":{},\"remark\":\"活动信息\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:23:59', 111);
INSERT INTO `sys_oper_log` VALUES (276, '字典类型', 3, 'com.dorm.web.controller.system.SysDictDataController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/data/106', '127.0.0.1', '内网IP', '[106]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:24:02', 28);
INSERT INTO `sys_oper_log` VALUES (277, '字典类型', 3, 'com.dorm.web.controller.system.SysDictDataController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/data/107', '127.0.0.1', '内网IP', '[107]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:24:04', 29);
INSERT INTO `sys_oper_log` VALUES (278, '字典类型', 3, 'com.dorm.web.controller.system.SysDictDataController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/data/105', '127.0.0.1', '内网IP', '[105]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:24:05', 17);
INSERT INTO `sys_oper_log` VALUES (279, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_notice\"}', NULL, 0, NULL, '2025-06-06 15:28:53', 195);
INSERT INTO `sys_oper_log` VALUES (280, '代码生成', 2, 'com.dorm.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/dorm_notice', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:29:16', 142);
INSERT INTO `sys_oper_log` VALUES (281, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"notices\",\"className\":\"DormNotice\",\"columns\":[{\"capJavaField\":\"NoticeId\",\"columnComment\":\"公告ID（主键）\",\"columnId\":45,\"columnName\":\"notice_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"noticeId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:29:16\",\"usableColumn\":false},{\"capJavaField\":\"NoticeTitle\",\"columnComment\":\"公告标题\",\"columnId\":46,\"columnName\":\"notice_title\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeTitle\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:29:16\",\"usableColumn\":false},{\"capJavaField\":\"NoticeType\",\"columnComment\":\"公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）\",\"columnId\":47,\"columnName\":\"notice_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"dorm_notice_type\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:29:16\",\"usableColumn\":false},{\"capJavaField\":\"NoticeContent\",\"columnComment\":\"公告内容（支持HTML/富文本）\",\"columnId\":49,\"columnName\":\"notice_content\",\"columnType\":\"longtext\",\"createBy\":\"admin\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:31:30', 129);
INSERT INTO `sys_oper_log` VALUES (282, '代码生成', 8, 'com.dorm.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"dorm_notice\"}', NULL, 0, NULL, '2025-06-06 15:31:46', 222);
INSERT INTO `sys_oper_log` VALUES (283, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"notices\",\"className\":\"DormNotice\",\"columns\":[{\"capJavaField\":\"NoticeId\",\"columnComment\":\"公告ID（主键）\",\"columnId\":45,\"columnName\":\"notice_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"noticeId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:31:30\",\"usableColumn\":false},{\"capJavaField\":\"NoticeTitle\",\"columnComment\":\"公告标题\",\"columnId\":46,\"columnName\":\"notice_title\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeTitle\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:31:30\",\"usableColumn\":false},{\"capJavaField\":\"NoticeType\",\"columnComment\":\"公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）\",\"columnId\":47,\"columnName\":\"notice_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"dorm_notice_type\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:31:30\",\"usableColumn\":false},{\"capJavaField\":\"NoticeContent\",\"columnComment\":\"公告内容（支持HTML/富文本）\",\"columnId\":49,\"columnName\":\"notice_content\",\"columnType\":\"longtext\",\"createBy\":\"admin\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:45:41', 39);
INSERT INTO `sys_oper_log` VALUES (284, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"notices\",\"className\":\"DormNotice\",\"columns\":[{\"capJavaField\":\"NoticeId\",\"columnComment\":\"公告ID（主键）\",\"columnId\":45,\"columnName\":\"notice_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"noticeId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:45:41\",\"usableColumn\":false},{\"capJavaField\":\"NoticeTitle\",\"columnComment\":\"公告标题\",\"columnId\":46,\"columnName\":\"notice_title\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeTitle\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:45:41\",\"usableColumn\":false},{\"capJavaField\":\"NoticeType\",\"columnComment\":\"公告类型（0全校公告 1楼栋公告 2全校通知 3楼栋通知 4全校活动 5楼栋活动）\",\"columnId\":47,\"columnName\":\"notice_type\",\"columnType\":\"char(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-06 14:09:18\",\"dictType\":\"dorm_notice_type\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"noticeType\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-06-06 15:45:41\",\"usableColumn\":false},{\"capJavaField\":\"NoticeContent\",\"columnComment\":\"公告内容（支持HTML/富文本）\",\"columnId\":49,\"columnName\":\"notice_content\",\"columnType\":\"longtext\",\"createBy\":\"admin\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:45:53', 79);
INSERT INTO `sys_oper_log` VALUES (285, '宿舍公告', 2, 'com.dorm.manage.controller.DormNoticeController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/notices', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-06 15:44:33\",\"noticeContent\":\"<p>此公告已作废，请以最新政策为准。</p>\",\"noticeId\":7,\"noticeTitle\":\"旧版防疫政策公告（已撤回）\",\"noticeType\":\"0\",\"params\":{},\"remark\":\"已撤回\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-06 15:57:17\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:57:17', 92);
INSERT INTO `sys_oper_log` VALUES (286, '宿舍公告', 2, 'com.dorm.manage.controller.DormNoticeController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/notices', '127.0.0.1', '内网IP', '{\"createBy\":\"sports_admin\",\"createTime\":\"2025-06-06 15:44:33\",\"noticeContent\":\"<p>受天气影响，该活动取消。</p>\",\"noticeId\":8,\"noticeTitle\":\"校园跑步打卡活动（取消）\",\"noticeType\":\"2\",\"params\":{},\"remark\":\"撤回通知\",\"status\":\"1\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-06 15:57:20\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:57:20', 18);
INSERT INTO `sys_oper_log` VALUES (287, '宿舍公告', 2, 'com.dorm.manage.controller.DormNoticeController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/notices', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-06 15:44:33\",\"noticeContent\":\"<p>此公告已作废，请以最新政策为准。</p>\",\"noticeId\":7,\"noticeTitle\":\"旧版防疫政策公告（已撤回）\",\"noticeType\":\"0\",\"params\":{},\"remark\":\"已撤回\",\"status\":\"1\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-06 15:58:02\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-06 15:58:02', 83);
INSERT INTO `sys_oper_log` VALUES (288, '参数管理', 2, 'com.dorm.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 12:15:27', 115);
INSERT INTO `sys_oper_log` VALUES (289, '参数管理', 2, 'com.dorm.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":1,\"configKey\":\"sys.index.skinName\",\"configName\":\"主框架页-默认皮肤样式名称\",\"configType\":\"Y\",\"configValue\":\"skin-purple\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"params\":{},\"remark\":\"蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 12:15:38', 23);
INSERT INTO `sys_oper_log` VALUES (290, '角色管理', 1, 'com.dorm.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[4],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 12:20:49', 47);
INSERT INTO `sys_oper_log` VALUES (291, '用户管理', 2, 'com.dorm.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2025-06-07 12:19:27\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2025-06-07 12:22:58\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"2310305320\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"pwdUpdateDate\":\"2025-06-07 12:19:27\",\"roleIds\":[100],\"roles\":[],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"2310305320\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 13:23:29', 101);
INSERT INTO `sys_oper_log` VALUES (292, '用户管理', 2, 'com.dorm.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2025-06-07 12:19:27\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2025-06-07 13:28:44\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"2310305320\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"pwdUpdateDate\":\"2025-06-07 12:19:27\",\"roleIds\":[],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"2310305320\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 13:33:02', 100);
INSERT INTO `sys_oper_log` VALUES (293, '用户管理', 2, 'com.dorm.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2025-06-07 12:19:27\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2025-06-07 13:28:44\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"2310305320\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"pwdUpdateDate\":\"2025-06-07 12:19:27\",\"roleIds\":[100],\"roles\":[],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"2310305320\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 13:33:10', 33);
INSERT INTO `sys_oper_log` VALUES (294, '个人信息', 2, 'com.dorm.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":true,\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"研发部门\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{\"@type\":\"java.util.HashMap\"},\"parentId\":101,\"status\":\"0\"},\"deptId\":103,\"email\":\"ry@163.com\",\"loginDate\":\"2025-06-07 14:56:22\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"若依\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2025-06-03 20:44:14\",\"remark\":\"管理员\",\"roles\":[{\"admin\":true,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 15:23:27', 107);
INSERT INTO `sys_oper_log` VALUES (295, '个人信息', 2, 'com.dorm.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":true,\"createBy\":\"admin\",\"createTime\":\"2025-06-03 20:44:14\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"研发部门\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{\"@type\":\"java.util.HashMap\"},\"parentId\":101,\"status\":\"0\"},\"deptId\":103,\"email\":\"ry@163.com\",\"loginDate\":\"2025-06-07 14:56:22\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"若依\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2025-06-03 20:44:14\",\"remark\":\"管理员\",\"roles\":[{\"admin\":true,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-07 15:23:30', 32);
INSERT INTO `sys_oper_log` VALUES (296, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2003,2004,2005,2006,2031,2032,2033,2034,2035,2036,2007,2008,2009,2010,2011,2012],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 14:02:28', 162);
INSERT INTO `sys_oper_log` VALUES (297, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2003,2004,2005,2006,2031,2032,2033,2034,2035,2036,2007,2008,2009,2010,2011,2012],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 14:13:29', 33);
INSERT INTO `sys_oper_log` VALUES (298, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, '2310305320', NULL, '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"12\",\"createTime\":\"2025-06-08 14:15:55\",\"email\":\"21\",\"gender\":\"男\",\"name\":\"12\",\"params\":{},\"phone\":\"21\",\"studentId\":23,\"studentNo\":\"21\",\"userId\":21}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 14:15:58', 4101);
INSERT INTO `sys_oper_log` VALUES (299, '学生管理', 3, 'com.dorm.manage.controller.DormStudentController.remove()', 'DELETE', 1, '2310305320', NULL, '/dorm/student/23', '127.0.0.1', '内网IP', '[23]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 14:16:05', 9);
INSERT INTO `sys_oper_log` VALUES (300, '个人信息', 2, 'com.dorm.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '2310305320', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"nickName\":\"1515616\",\"params\":{},\"phonenumber\":\"13282973175\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 14:27:48', 47);
INSERT INTO `sys_oper_log` VALUES (301, '用户管理', 2, 'com.dorm.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2025-06-07 12:19:27\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2025-06-08 13:46:46\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"2310305320\",\"params\":{},\"phonenumber\":\"13282973175\",\"postIds\":[],\"pwdUpdateDate\":\"2025-06-07 12:19:27\",\"roleIds\":[100],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"2310305320\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 14:28:54', 75);
INSERT INTO `sys_oper_log` VALUES (302, '个人信息', 2, 'com.dorm.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '2310305320', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"nickName\":\"王新瑜\",\"params\":{},\"phonenumber\":\"13282973175\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 14:39:03', 116);
INSERT INTO `sys_oper_log` VALUES (303, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, '2310305320', NULL, '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"软件2301\",\"createTime\":\"2025-06-08 14:55:52\",\"email\":\"2559118499@qq.com\",\"gender\":\"0\",\"name\":\"王新瑜\",\"params\":{},\"phone\":\"13282973175\",\"studentNo\":\"2310305320\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'user_id\' doesn\'t have a default value\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormStudentMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormStudentMapper.insertDormStudent-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into dorm_student          ( student_no,             name,             gender,             class_name,             phone,                          email,                                       create_time )           values ( ?,             ?,             ?,             ?,             ?,                          ?,                                       ? )\r\n### Cause: java.sql.SQLException: Field \'user_id\' doesn\'t have a default value\n; Field \'user_id\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'user_id\' doesn\'t have a default value', '2025-06-08 14:56:01', 9878);
INSERT INTO `sys_oper_log` VALUES (304, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, '2310305320', NULL, '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"软件2301\",\"createTime\":\"2025-06-08 14:56:38\",\"email\":\"2559118499@qq.com\",\"gender\":\"0\",\"name\":\"王新瑜\",\"params\":{},\"phone\":\"13282973175\",\"studentNo\":\"2310305320\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'user_id\' doesn\'t have a default value\r\n### The error may exist in file [C:\\Users\\25591\\Desktop\\dorm\\Dorm\\dorm-manage\\target\\classes\\mapper\\dorm\\DormStudentMapper.xml]\r\n### The error may involve com.dorm.manage.mapper.DormStudentMapper.insertDormStudent-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into dorm_student          ( student_no,             name,             gender,             class_name,             phone,                          email,                                       create_time )           values ( ?,             ?,             ?,             ?,             ?,                          ?,                                       ? )\r\n### Cause: java.sql.SQLException: Field \'user_id\' doesn\'t have a default value\n; Field \'user_id\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'user_id\' doesn\'t have a default value', '2025-06-08 14:56:38', 6);
INSERT INTO `sys_oper_log` VALUES (305, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, '2310305320', NULL, '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"软件2301\",\"createTime\":\"2025-06-08 15:06:18\",\"email\":\"2559118499@qq.com\",\"gender\":\"0\",\"name\":\"王新瑜\",\"params\":{},\"phone\":\"13282973175\",\"studentId\":24,\"studentNo\":\"2310305320\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 15:06:19', 126);
INSERT INTO `sys_oper_log` VALUES (306, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2001,2002,2003,2004,2005,2006,2031,2032,2033,2034,2035,2036,2007,2008,2009,2010,2011,2012],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 16:09:43', 118);
INSERT INTO `sys_oper_log` VALUES (307, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 16:10:48', 34);
INSERT INTO `sys_oper_log` VALUES (308, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 16:34:34', 63);
INSERT INTO `sys_oper_log` VALUES (309, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 16:35:17', 47);
INSERT INTO `sys_oper_log` VALUES (310, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2007,2009],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 16:38:28', 77);
INSERT INTO `sys_oper_log` VALUES (311, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2007,2008,2009,2010],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 16:40:09', 59);
INSERT INTO `sys_oper_log` VALUES (312, '学生管理', 1, 'com.dorm.manage.controller.DormStudentController.add()', 'POST', 1, '2310305320', NULL, '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"软件2301\",\"createTime\":\"2025-06-08 16:41:06\",\"email\":\"2559118499@qq.com\",\"gender\":\"0\",\"name\":\"王新瑜\",\"params\":{},\"phone\":\"13282973175\",\"studentId\":25,\"studentNo\":\"2310305320\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 16:41:06', 100);
INSERT INTO `sys_oper_log` VALUES (313, '个人信息', 2, 'com.dorm.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '2310305320', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:19:27\",\"delFlag\":\"0\",\"email\":\"2559118499@qq.com\",\"loginDate\":\"2025-06-08 20:39:21\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"王新瑜\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"13282973175\",\"pwdUpdateDate\":\"2025-06-07 12:19:27\",\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"permissions\":[\"dorm:student:list\",\"dorm:student:edit\",\"dorm:student:query\",\"dorm:student:add\"],\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"userId\":101,\"userName\":\"2310305320\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 21:29:42', 114);
INSERT INTO `sys_oper_log` VALUES (314, '个人信息', 2, 'com.dorm.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '2310305320', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:19:27\",\"delFlag\":\"0\",\"email\":\"2559118499@qq.com\",\"loginDate\":\"2025-06-08 20:39:21\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"王新瑜\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"13282973175\",\"pwdUpdateDate\":\"2025-06-07 12:19:27\",\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"permissions\":[\"dorm:student:list\",\"dorm:student:edit\",\"dorm:student:query\",\"dorm:student:add\"],\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"userId\":101,\"userName\":\"2310305320\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 21:29:53', 84);
INSERT INTO `sys_oper_log` VALUES (315, '个人信息', 2, 'com.dorm.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, '2310305320', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:19:27\",\"delFlag\":\"0\",\"email\":\"2559118499@qq.com\",\"loginDate\":\"2025-06-08 20:39:21\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"王新瑜\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"13282973175\",\"pwdUpdateDate\":\"2025-06-07 12:19:27\",\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"permissions\":[\"dorm:student:list\",\"dorm:student:edit\",\"dorm:student:query\",\"dorm:student:add\"],\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"userId\":101,\"userName\":\"2310305320\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-08 21:30:00', 51);
INSERT INTO `sys_oper_log` VALUES (316, '角色管理', 2, 'com.dorm.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-06-07 12:20:49\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2007,2008,2009,2010],\"params\":{},\"roleId\":100,\"roleKey\":\"student\",\"roleName\":\"学生\",\"roleSort\":1,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 12:40:18', 117);
INSERT INTO `sys_oper_log` VALUES (317, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,205\",\"buildingName\":\"三楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 13:53:21\",\"orderNum\":3,\"params\":{},\"parentId\":205,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 13:53:21', 5954);
INSERT INTO `sys_oper_log` VALUES (318, '学生管理', 2, 'com.dorm.manage.controller.DormStudentController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"软件2301\",\"createTime\":\"2025-06-08 16:41:07\",\"delFlag\":\"0\",\"dormId\":233,\"email\":\"2559118499@qq.com\",\"gender\":\"0\",\"name\":\"王新瑜\",\"params\":{},\"phone\":\"13282973175\",\"status\":\"0\",\"studentId\":25,\"studentNo\":\"2310305320\",\"updateTime\":\"2025-06-09 13:53:54\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 13:53:54', 30);
INSERT INTO `sys_oper_log` VALUES (319, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204,217\",\"buildingName\":\"306\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 13:55:30\",\"orderNum\":1,\"params\":{},\"parentId\":217,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 13:55:30', 59);
INSERT INTO `sys_oper_log` VALUES (320, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,205,233\",\"buildingName\":\"306\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 13:56:19\",\"orderNum\":0,\"params\":{},\"parentId\":233}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 13:56:19', 104);
INSERT INTO `sys_oper_log` VALUES (321, '学生管理', 2, 'com.dorm.manage.controller.DormStudentController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"软件2301\",\"createTime\":\"2025-06-08 16:41:07\",\"delFlag\":\"0\",\"dormId\":235,\"email\":\"2559118499@qq.com\",\"gender\":\"0\",\"name\":\"王新瑜\",\"params\":{},\"phone\":\"13282973175\",\"status\":\"0\",\"studentId\":25,\"studentNo\":\"2310305320\",\"updateTime\":\"2025-06-09 13:56:42\",\"userId\":101}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 13:56:42', 76);
INSERT INTO `sys_oper_log` VALUES (322, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/232', '127.0.0.1', '内网IP', '[232]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 15:12:17', 68);
INSERT INTO `sys_oper_log` VALUES (323, '代码生成', 2, 'com.dorm.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/dorm_building', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 16:19:37', 80);
INSERT INTO `sys_oper_log` VALUES (324, '代码生成', 2, 'com.dorm.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"DormBuilding\",\"columns\":[{\"capJavaField\":\"DormId\",\"columnComment\":\"宿舍ID（主键）\",\"columnId\":15,\"columnName\":\"dorm_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dormId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-09 16:19:37\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父宿舍ID\",\"columnId\":16,\"columnName\":\"parent_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-09 16:19:37\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":17,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2025-06-09 16:19:37\",\"usableColumn\":false},{\"capJavaField\":\"BuildingName\",\"columnComment\":\"宿舍名称\",\"columnId\":18,\"columnName\":\"building_name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-06-03 21:32:07\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"incr', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 16:21:29', 144);
INSERT INTO `sys_oper_log` VALUES (325, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204\",\"buildingName\":\"一楼\",\"children\":[],\"dormId\":212,\"fullName\":\"瓯江口人工智能学院观潮公寓A栋一楼101\",\"orderNum\":0,\"params\":{},\"parentId\":204,\"parentName\":\"A栋\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 19:07:37\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:07:37', 185);
INSERT INTO `sys_oper_log` VALUES (326, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204\",\"buildingName\":\"一楼\",\"children\":[],\"dormId\":212,\"fullName\":\"\",\"orderNum\":0,\"params\":{},\"parentId\":204,\"parentName\":\"A栋\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 19:08:01\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:08:02', 81);
INSERT INTO `sys_oper_log` VALUES (327, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204,212\",\"buildingName\":\"101\",\"children\":[],\"dormId\":213,\"fullName\":\"瓯江口人工智能学院观潮公寓A栋一楼101\",\"orderNum\":0,\"params\":{},\"parentId\":212,\"parentName\":\"一楼\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 19:08:07\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:08:07', 51);
INSERT INTO `sys_oper_log` VALUES (328, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,102,206,207,221\",\"buildingName\":\"101\",\"children\":[],\"dormId\":227,\"fullName\":\"瓯江口光电制造学院听涛公寓A栋一楼101\",\"orderNum\":0,\"params\":{},\"parentId\":221,\"parentName\":\"一楼\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 19:09:38\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:09:38', 110);
INSERT INTO `sys_oper_log` VALUES (329, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204,212\",\"buildingName\":\"105\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 19:34:49\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼 - 105\",\"orderNum\":3,\"params\":{},\"parentId\":212}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:34:49', 116);
INSERT INTO `sys_oper_log` VALUES (330, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204,212\",\"buildingName\":\"103\",\"children\":[],\"dormId\":224,\"orderNum\":2,\"params\":{},\"parentId\":212,\"parentName\":\"一楼\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 19:35:06\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:35:06', 54);
INSERT INTO `sys_oper_log` VALUES (331, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204,212\",\"buildingName\":\"104\",\"children\":[],\"dormId\":236,\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼 - 10\",\"orderNum\":3,\"params\":{},\"parentId\":212,\"parentName\":\"一楼\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 19:35:17\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:35:17', 110);
INSERT INTO `sys_oper_log` VALUES (332, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,101,103,204,212\",\"buildingName\":\"104\",\"children\":[],\"dormId\":236,\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼 - 104\",\"orderNum\":3,\"params\":{},\"parentId\":212,\"parentName\":\"一楼\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 19:35:24\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 19:35:24', 43);
INSERT INTO `sys_oper_log` VALUES (333, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-03 22:36:12\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"空闲\",\"dictSort\":0,\"dictType\":\"dorm_status\",\"dictValue\":\"0\",\"isDefault\":\"N\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:03:19', 70);
INSERT INTO `sys_oper_log` VALUES (334, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-03 22:36:42\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"满员\",\"dictSort\":1,\"dictType\":\"dorm_status\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:03:37', 57);
INSERT INTO `sys_oper_log` VALUES (335, '字典数据', 2, 'com.dorm.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-06-03 22:36:42\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"满员\",\"dictSort\":1,\"dictType\":\"dorm_status\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:03:44', 33);
INSERT INTO `sys_oper_log` VALUES (336, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/101', '127.0.0.1', '内网IP', '[101]', '{\"msg\":\"存在下级宿舍,不允许删除\",\"code\":601}', 0, NULL, '2025-06-09 20:05:03', 8);
INSERT INTO `sys_oper_log` VALUES (337, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/101', '127.0.0.1', '内网IP', '[101]', '{\"msg\":\"存在下级宿舍,不允许删除\",\"code\":601}', 0, NULL, '2025-06-09 20:05:09', 5);
INSERT INTO `sys_oper_log` VALUES (338, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/213', '127.0.0.1', '内网IP', '[213]', '{\"msg\":\"宿舍存在用户,不允许删除\",\"code\":601}', 0, NULL, '2025-06-09 20:05:16', 10);
INSERT INTO `sys_oper_log` VALUES (339, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/213', '127.0.0.1', '内网IP', '[213]', '{\"msg\":\"宿舍存在用户,不允许删除\",\"code\":601}', 0, NULL, '2025-06-09 20:05:19', 12);
INSERT INTO `sys_oper_log` VALUES (340, '学生管理', 2, 'com.dorm.manage.controller.DormStudentController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/student', '127.0.0.1', '内网IP', '{\"className\":\"计算机科学与技术1班\",\"createBy\":\"admin\",\"createTime\":\"2025-01-10 09:00:00\",\"delFlag\":\"0\",\"dormId\":100,\"email\":\"zhangsan@school.edu\",\"gender\":\"男\",\"name\":\"张三\",\"params\":{},\"phone\":\"13800138001\",\"remark\":\"\",\"status\":\"0\",\"studentId\":1,\"studentNo\":\"20230001\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 20:06:17\",\"userId\":100}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:06:17', 65);
INSERT INTO `sys_oper_log` VALUES (341, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/220', '127.0.0.1', '内网IP', '[220]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:38', 54);
INSERT INTO `sys_oper_log` VALUES (342, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/222', '127.0.0.1', '内网IP', '[222]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:45', 37);
INSERT INTO `sys_oper_log` VALUES (343, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/228', '127.0.0.1', '内网IP', '[228]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:46', 35);
INSERT INTO `sys_oper_log` VALUES (344, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/227', '127.0.0.1', '内网IP', '[227]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:48', 34);
INSERT INTO `sys_oper_log` VALUES (345, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/221', '127.0.0.1', '内网IP', '[221]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:48', 48);
INSERT INTO `sys_oper_log` VALUES (346, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/207', '127.0.0.1', '内网IP', '[207]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:49', 46);
INSERT INTO `sys_oper_log` VALUES (347, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/206', '127.0.0.1', '内网IP', '[206]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:52', 17);
INSERT INTO `sys_oper_log` VALUES (348, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/102', '127.0.0.1', '内网IP', '[102]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:54', 28);
INSERT INTO `sys_oper_log` VALUES (349, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/215', '127.0.0.1', '内网IP', '[215]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:55', 30);
INSERT INTO `sys_oper_log` VALUES (350, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/214', '127.0.0.1', '内网IP', '[214]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:56', 24);
INSERT INTO `sys_oper_log` VALUES (351, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/235', '127.0.0.1', '内网IP', '[235]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:07:59', 23);
INSERT INTO `sys_oper_log` VALUES (352, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/233', '127.0.0.1', '内网IP', '[233]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:08:00', 20);
INSERT INTO `sys_oper_log` VALUES (353, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/219', '127.0.0.1', '内网IP', '[219]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:08:04', 27);
INSERT INTO `sys_oper_log` VALUES (354, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"buildingName\":\"人工智能学院\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:09:54\",\"fullName\":\"瓯江口 - 人工智能学院\",\"orderNum\":0,\"params\":{},\"parentId\":100}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:09:54', 63);
INSERT INTO `sys_oper_log` VALUES (355, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237\",\"buildingName\":\"观潮公寓\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:10:10\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓\",\"orderNum\":0,\"params\":{},\"parentId\":237}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:10:10', 76);
INSERT INTO `sys_oper_log` VALUES (356, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238\",\"buildingName\":\"A栋\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:10:21\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋\",\"orderNum\":0,\"params\":{},\"parentId\":238}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:10:21', 56);
INSERT INTO `sys_oper_log` VALUES (357, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238\",\"buildingName\":\"B栋\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:10:44\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋\",\"orderNum\":1,\"params\":{},\"parentId\":238}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:10:44', 130);
INSERT INTO `sys_oper_log` VALUES (358, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238\",\"buildingName\":\"C栋\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:11:16\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - C栋\",\"orderNum\":2,\"params\":{},\"parentId\":238}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:11:16', 62);
INSERT INTO `sys_oper_log` VALUES (359, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"buildingName\":\"光电制造学院\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:11:41\",\"fullName\":\"瓯江口 - 光电制造学院\",\"orderNum\":1,\"params\":{},\"parentId\":100}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:11:41', 92);
INSERT INTO `sys_oper_log` VALUES (360, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,242\",\"buildingName\":\"听涛公寓\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:12:43\",\"fullName\":\"瓯江口 - 光电制造学院 - 听涛公寓\",\"orderNum\":0,\"params\":{},\"parentId\":242}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:12:43', 70);
INSERT INTO `sys_oper_log` VALUES (361, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,242,243\",\"buildingName\":\"A栋\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:12:54\",\"fullName\":\"瓯江口 - 光电制造学院 - 听涛公寓 - A栋\",\"orderNum\":0,\"params\":{},\"parentId\":243}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:12:54', 114);
INSERT INTO `sys_oper_log` VALUES (362, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,242,243\",\"buildingName\":\"B栋\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:13:05\",\"fullName\":\"瓯江口 - 光电制造学院 - 听涛公寓 - B栋\",\"orderNum\":1,\"params\":{},\"parentId\":243}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:13:05', 69);
INSERT INTO `sys_oper_log` VALUES (363, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,242,243\",\"buildingName\":\"C栋\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:13:19\",\"fullName\":\"瓯江口 - 光电制造学院 - 听涛公寓 - C栋\",\"orderNum\":2,\"params\":{},\"parentId\":243}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:13:19', 96);
INSERT INTO `sys_oper_log` VALUES (364, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,239\",\"buildingName\":\"一楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:13:31\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼\",\"orderNum\":0,\"params\":{},\"parentId\":239}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:13:32', 75);
INSERT INTO `sys_oper_log` VALUES (365, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,239\",\"buildingName\":\"二楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:13:50\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 二楼\",\"orderNum\":1,\"params\":{},\"parentId\":239}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:13:50', 17);
INSERT INTO `sys_oper_log` VALUES (366, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,239\",\"buildingName\":\"三楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:15:25\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 三楼\",\"orderNum\":2,\"params\":{},\"parentId\":239}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:15:25', 92);
INSERT INTO `sys_oper_log` VALUES (367, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,239\",\"buildingName\":\"四楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:15:39\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 四楼\",\"orderNum\":3,\"params\":{},\"parentId\":239}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:15:39', 29);
INSERT INTO `sys_oper_log` VALUES (368, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238\",\"buildingName\":\"五楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:15:54\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - 五楼\",\"orderNum\":4,\"params\":{},\"parentId\":238}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:15:54', 57);
INSERT INTO `sys_oper_log` VALUES (369, '宿舍管理', 3, 'com.dorm.manage.controller.DormBuildingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/dorm/building/251', '127.0.0.1', '内网IP', '[251]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:16:03', 45);
INSERT INTO `sys_oper_log` VALUES (370, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,239\",\"buildingName\":\"五楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:16:15\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 五楼\",\"orderNum\":4,\"params\":{},\"parentId\":239}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:16:15', 33);
INSERT INTO `sys_oper_log` VALUES (371, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240\",\"buildingName\":\"一楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:16:38\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 一楼\",\"orderNum\":0,\"params\":{},\"parentId\":240}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:16:38', 52);
INSERT INTO `sys_oper_log` VALUES (372, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,239,247\",\"buildingName\":\"101\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:18:32\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼 - 101\",\"orderNum\":0,\"params\":{},\"parentId\":247}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:18:32', 47);
INSERT INTO `sys_oper_log` VALUES (373, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240\",\"buildingName\":\"二楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:37:28\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 二楼\",\"orderNum\":1,\"params\":{},\"parentId\":240}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:37:28', 67);
INSERT INTO `sys_oper_log` VALUES (374, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240\",\"buildingName\":\"3楼\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:37:49\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 3楼\",\"orderNum\":2,\"params\":{},\"parentId\":240}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:37:49', 120);
INSERT INTO `sys_oper_log` VALUES (375, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240\",\"buildingName\":\"三楼\",\"children\":[],\"dormId\":256,\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 3楼\",\"orderNum\":2,\"params\":{},\"parentId\":240,\"parentName\":\"B栋\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 20:37:56\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:37:56', 39);
INSERT INTO `sys_oper_log` VALUES (376, '宿舍管理', 2, 'com.dorm.manage.controller.DormBuildingController.edit()', 'PUT', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240\",\"buildingName\":\"三楼\",\"children\":[],\"dormId\":256,\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼\",\"orderNum\":2,\"params\":{},\"parentId\":240,\"parentName\":\"B栋\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-06-09 20:38:06\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:38:06', 66);
INSERT INTO `sys_oper_log` VALUES (377, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240,256\",\"buildingName\":\"301\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:38:20\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 301\",\"orderNum\":0,\"params\":{},\"parentId\":256}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:38:20', 95);
INSERT INTO `sys_oper_log` VALUES (378, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240,256\",\"buildingName\":\"302\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:38:27\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 302\",\"orderNum\":1,\"params\":{},\"parentId\":256}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:38:28', 59);
INSERT INTO `sys_oper_log` VALUES (379, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240,256\",\"buildingName\":\"303\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:38:52\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 303\",\"orderNum\":2,\"params\":{},\"parentId\":256}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:38:52', 100);
INSERT INTO `sys_oper_log` VALUES (380, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240,256\",\"buildingName\":\"304\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:39:08\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 304\",\"orderNum\":3,\"params\":{},\"parentId\":256}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:39:08', 48);
INSERT INTO `sys_oper_log` VALUES (381, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240,256\",\"buildingName\":\"305\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:39:17\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 305\",\"orderNum\":4,\"params\":{},\"parentId\":256}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:39:17', 31);
INSERT INTO `sys_oper_log` VALUES (382, '宿舍管理', 1, 'com.dorm.manage.controller.DormBuildingController.add()', 'POST', 1, 'admin', '研发部门', '/dorm/building', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100,237,238,240,256\",\"buildingName\":\"306\",\"children\":[],\"createBy\":\"admin\",\"createTime\":\"2025-06-09 20:39:25\",\"fullName\":\"瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 306\",\"orderNum\":5,\"params\":{},\"parentId\":256}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-06-09 20:39:25', 40);

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
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-06-03 20:44:14', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '学生', 'student', 1, '1', 1, 1, '0', '0', 'admin', '2025-06-07 12:20:49', 'admin', '2025-06-09 12:40:18', NULL);

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
INSERT INTO `sys_role_menu` VALUES (100, 2000);
INSERT INTO `sys_role_menu` VALUES (100, 2007);
INSERT INTO `sys_role_menu` VALUES (100, 2008);
INSERT INTO `sys_role_menu` VALUES (100, 2009);
INSERT INTO `sys_role_menu` VALUES (100, 2010);

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
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-06-09 19:02:56', '2025-06-03 20:44:14', 'admin', '2025-06-03 20:44:14', '', '2025-06-09 19:02:56', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-06-03 20:44:14', '2025-06-03 20:44:14', 'admin', '2025-06-03 20:44:14', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (101, NULL, '2310305320', '王新瑜', '00', '2559118499@qq.com', '13282973175', '0', '', '$2a$10$KxpBw6D/j92BmWb18xK/xOZ3Iwzv/HkKmPR1/CXgmse6HFrXAKWWS', '0', '0', '127.0.0.1', '2025-06-09 20:01:07', '2025-06-07 12:19:27', '', '2025-06-07 12:19:27', 'admin', '2025-06-09 20:01:06', NULL);

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
INSERT INTO `sys_user_role` VALUES (101, 100);

SET FOREIGN_KEY_CHECKS = 1;
