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

 Date: 20/06/2025 01:22:47
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
  `max_capacity` int(4) NULL DEFAULT NULL COMMENT '最大入住人数(仅房间级有效)',
  `current_count` int(4) NULL DEFAULT 0 COMMENT '当前入住人数(仅房间级有效)',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '宿舍状态（0空闲 1满员）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dorm_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 264 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '宿舍表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dorm_building
-- ----------------------------
INSERT INTO `dorm_building` VALUES (100, 0, '0', '瓯江口', NULL, 0, '', '', '', 48, 13, '0', '0', 'admin', '2025-06-03 20:44:14', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (237, 100, '0,100', '人工智能学院', '瓯江口 - 人工智能学院', 0, NULL, NULL, NULL, 48, 13, '0', '0', 'admin', '2025-06-09 20:09:54', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (238, 237, '0,100,237', '观潮公寓', '瓯江口 - 人工智能学院 - 观潮公寓', 0, NULL, NULL, NULL, 48, 13, '0', '0', 'admin', '2025-06-09 20:10:10', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (239, 238, '0,100,237,238', 'A栋', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋', 0, '李阿姨', '18867944856', NULL, 12, 6, '0', '0', 'admin', '2025-06-09 20:10:21', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (240, 238, '0,100,237,238', 'B栋', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋', 1, '朱阿姨', '13256489846', NULL, 36, 7, '0', '0', 'admin', '2025-06-09 20:10:44', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (241, 238, '0,100,237,238', 'C栋', '瓯江口 - 人工智能学院 - 观潮公寓 - C栋', 2, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:11:16', 'admin', '2025-06-15 17:55:15');
INSERT INTO `dorm_building` VALUES (242, 100, '0,100', '光电制造学院', '瓯江口 - 光电制造学院', 1, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:11:41', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (243, 242, '0,100,242', '听涛公寓', '瓯江口 - 光电制造学院 - 听涛公寓', 0, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:12:43', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (244, 243, '0,100,242,243', 'A栋', '瓯江口 - 光电制造学院 - 听涛公寓 - A栋', 0, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:12:54', 'admin', '2025-06-15 17:55:33');
INSERT INTO `dorm_building` VALUES (245, 243, '0,100,242,243', 'B栋', '瓯江口 - 光电制造学院 - 听涛公寓 - B栋', 1, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:13:05', 'admin', '2025-06-15 17:55:39');
INSERT INTO `dorm_building` VALUES (246, 243, '0,100,242,243', 'C栋', '瓯江口 - 光电制造学院 - 听涛公寓 - C栋', 2, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:13:19', 'admin', '2025-06-15 17:55:45');
INSERT INTO `dorm_building` VALUES (247, 239, '0,100,237,238,239', '一楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼', 0, NULL, NULL, NULL, 6, 6, '1', '0', 'admin', '2025-06-09 20:13:31', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (248, 239, '0,100,237,238,239', '二楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 二楼', 1, NULL, NULL, NULL, 6, 0, '0', '0', 'admin', '2025-06-09 20:13:50', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (249, 239, '0,100,237,238,239', '三楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 三楼', 2, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:15:25', 'admin', '2025-06-15 17:54:24');
INSERT INTO `dorm_building` VALUES (250, 239, '0,100,237,238,239', '四楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 四楼', 3, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:15:39', 'admin', '2025-06-15 17:54:32');
INSERT INTO `dorm_building` VALUES (252, 239, '0,100,237,238,239', '五楼', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 五楼', 4, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:16:15', 'admin', '2025-06-15 17:54:38');
INSERT INTO `dorm_building` VALUES (253, 240, '0,100,237,238,240', '一楼', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 一楼', 0, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:16:38', 'admin', '2025-06-15 17:54:52');
INSERT INTO `dorm_building` VALUES (254, 247, '0,100,237,238,239,247', '101', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 一楼 - 101', 0, NULL, NULL, NULL, 6, 6, '1', '0', 'admin', '2025-06-09 20:18:32', 'admin', '2025-06-15 17:48:36');
INSERT INTO `dorm_building` VALUES (255, 240, '0,100,237,238,240', '二楼', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 二楼', 1, NULL, NULL, NULL, 0, 0, '0', '0', 'admin', '2025-06-09 20:37:28', 'admin', '2025-06-15 17:55:00');
INSERT INTO `dorm_building` VALUES (256, 240, '0,100,237,238,240', '三楼', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼', 2, NULL, NULL, NULL, 36, 7, '0', '0', 'admin', '2025-06-09 20:37:49', 'admin', '2025-06-20 01:05:21');
INSERT INTO `dorm_building` VALUES (257, 256, '0,100,237,238,240,256', '301', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 301', 0, NULL, NULL, NULL, 6, 0, '0', '0', 'admin', '2025-06-09 20:38:20', 'admin', '2025-06-10 21:39:05');
INSERT INTO `dorm_building` VALUES (258, 256, '0,100,237,238,240,256', '302', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 302', 1, NULL, NULL, NULL, 6, 0, '0', '0', 'admin', '2025-06-09 20:38:27', 'admin', '2025-06-10 20:57:41');
INSERT INTO `dorm_building` VALUES (259, 256, '0,100,237,238,240,256', '303', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 303', 2, NULL, NULL, NULL, 6, 0, '0', '0', 'admin', '2025-06-09 20:38:52', 'admin', '2025-06-10 20:57:41');
INSERT INTO `dorm_building` VALUES (260, 256, '0,100,237,238,240,256', '304', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 304', 3, NULL, NULL, NULL, 6, 0, '0', '0', 'admin', '2025-06-09 20:39:08', 'admin', '2025-06-10 21:32:24');
INSERT INTO `dorm_building` VALUES (261, 256, '0,100,237,238,240,256', '305', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 305', 4, NULL, NULL, NULL, 6, 1, '0', '0', 'admin', '2025-06-09 20:39:17', 'admin', '2025-06-11 00:03:32');
INSERT INTO `dorm_building` VALUES (262, 256, '0,100,237,238,240,256', '306', '瓯江口 - 人工智能学院 - 观潮公寓 - B栋 - 三楼 - 306', 5, '朱阿姨', '13256489846', NULL, 6, 6, '1', '0', 'admin', '2025-06-09 20:39:25', 'admin', '2025-06-16 19:19:16');
INSERT INTO `dorm_building` VALUES (263, 248, '0,100,237,238,239,248', '201', '瓯江口 - 人工智能学院 - 观潮公寓 - A栋 - 二楼 - 201', 1, NULL, NULL, NULL, 6, 0, '0', '0', 'admin', '2025-06-12 13:09:48', 'admin', '2025-06-15 21:40:11');

-- ----------------------------
-- Table structure for dorm_notice
-- ----------------------------
DROP TABLE IF EXISTS `dorm_notice`;
CREATE TABLE `dorm_notice`  (
  `notice_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '公告ID（主键）',
  `notice_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面图片路径（存储图片URL）',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '公告类型（0=公告,1=通知,2=活动）',
  `notice_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容（支持HTML/富文本）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `is_carousel` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否在轮播图显示（0否 1是）',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数量',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '宿舍公告表（无楼栋字段）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_notice
-- ----------------------------
INSERT INTO `dorm_notice` VALUES (1, '关于期末考试时间安排的公告', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/9465a858be354f4cbc42955e551f9681.png', '0', '<p>请各位同学提前查阅期末考试时间表，合理安排复习。<img src=\"http://172.18.34.104:9005/test//profile/upload/2025/06/file/2911c02447f54e6d85cd3b47a0fe66ce.png\"></p>', '0', 'admin', '2025-06-06 15:44:33', 'admin', '2025-06-14 00:32:55', '教务处发布', '1', 2);
INSERT INTO `dorm_notice` VALUES (2, '宿舍楼用电安全须知', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/7dd4523e4af2473fa3f021f2e45e801d.png', '0', '<p>近期天气炎热，请注意合理用电，避免跳闸。</p>', '0', 'admin', '2025-06-06 15:44:33', '', '2025-06-14 00:21:39', '安全提醒', '1', 2);
INSERT INTO `dorm_notice` VALUES (3, '校园网升级通知', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/93bc9e5bb0b445829b62c6e77260bc73.png', '1', '<p>6月10日凌晨校园网将维护升级，期间可能出现短时断网。</p>', '0', 'net_admin', '2025-06-06 15:44:33', 'net_admin', '2025-06-14 00:21:39', '信息中心', '1', 1);
INSERT INTO `dorm_notice` VALUES (4, '图书馆闭馆时间调整通知', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/eb0d3495851048ebafdaa26b0ec1183c.png', '1', '<p>因暑假临近，图书馆将于6月20日起调整开放时间。</p>', '0', 'library_admin', '2025-06-06 15:44:33', '', '2025-06-14 00:21:39', '草稿', '1', 0);
INSERT INTO `dorm_notice` VALUES (5, '2025年校园科技节活动安排', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/929ab889fc8b4e37b49f084e4f76b8bc.png', '2', '<p>诚邀全校师生参与科技节活动，包括创新作品展、专题讲座等。</p>', '0', 'student_union', '2025-06-06 15:44:33', 'teacher_zhang', '2025-06-14 00:21:39', '校团委主办', '1', 1);
INSERT INTO `dorm_notice` VALUES (6, '端午节包粽子比赛报名中', NULL, '2', '<p>欢迎各宿舍报名参加端午节包粽子比赛，名额有限，先到先得！</p>', '0', 'life_committee', '2025-06-06 15:44:33', '', '2025-06-14 00:21:39', '学生社区活动', '0', 0);
INSERT INTO `dorm_notice` VALUES (7, '旧版防疫政策公告（已撤回）', NULL, '0', '<p>此公告已作废，请以最新政策为准。</p>', '0', 'admin', '2025-06-06 15:44:33', 'admin', '2025-06-14 00:21:39', '已撤回', '0', 0);
INSERT INTO `dorm_notice` VALUES (8, '校园跑步打卡活动（取消）', NULL, '2', '<p>受天气影响，该活动取消。</p>', '0', 'sports_admin', '2025-06-06 15:44:33', 'admin', '2025-06-14 00:21:39', '撤回通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (9, '暑期宿舍安全须知', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/e15c5b4902634c5b8674e6e0b9237a30.png', '1', '<p>暑期留校同学请注意用电安全，离开宿舍务必断电。</p>', '0', 'admin', '2025-06-15 09:30:00', 'admin', '2025-06-15 16:34:59', '安全部发布', '1', 1);
INSERT INTO `dorm_notice` VALUES (10, '3号楼热水系统维护通知', NULL, '1', '<p>7月1日9:00-17:00暂停热水供应，请提前储备。</p>', '0', 'dorm_manager', '2025-06-14 10:15:00', NULL, '2025-06-14 00:21:39', '仅限3号楼', '0', 0);
INSERT INTO `dorm_notice` VALUES (11, '全校消防演练安排', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/b755c2669efc4734ab00a667091bd140.png', '2', '<p>6月20日下午2点全校消防演习，请配合疏散。</p>', '0', 'safety_office', '2025-06-10 13:45:00', 'safety_office', '2025-06-15 16:35:10', '年度例行演习', '1', 0);
INSERT INTO `dorm_notice` VALUES (12, '5号楼公共区域消杀通知', NULL, '3', '<p>每周三下午进行公共区域消毒，请收好私人物品。</p>', '0', 'dorm_staff', '2025-06-08 16:30:00', NULL, '2025-06-14 00:13:49', '5号楼专用', '0', 0);
INSERT INTO `dorm_notice` VALUES (13, '校园歌手大赛报名启动', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/d5619fe8a59241199bbe92e2f99015ba.png', '4', '<p>年度校园歌手大赛开始报名，奖品丰厚！</p>', '0', 'culture_center', '2025-06-05 14:00:00', 'admin', '2025-06-15 16:35:16', '文艺部主办', '1', 0);
INSERT INTO `dorm_notice` VALUES (14, '毕业生退宿流程指南', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/545717f5ccae4618a5d3caaa751a3425.png', '0', '<p>2025届毕业生退宿手续办理流程说明。</p>', '0', 'admin', '2025-05-28 09:00:00', 'admin', '2025-06-15 16:35:24', '重要通知', '1', 0);
INSERT INTO `dorm_notice` VALUES (15, '宿舍空调清洗服务', NULL, '5', '<p>6月25日免费空调清洗服务，请到值班室登记。</p>', '0', 'dorm_service', '2025-06-03 11:20:00', 'dorm_service', '2025-06-14 00:13:49', '限2/4/6号楼', '0', 0);
INSERT INTO `dorm_notice` VALUES (16, '禁止大功率电器通告', 'http://172.18.34.104:9005/test//profile/upload/2025/06/file/b755c2669efc4734ab00a667091bd140.png', '0', '<p>重申宿舍禁止使用电炉、电锅等大功率电器。</p>', '0', 'admin', '2025-05-20 08:45:00', NULL, '2025-06-15 16:35:29', '安全警示', '1', 0);
INSERT INTO `dorm_notice` VALUES (17, '新生宿舍分配说明', NULL, '2', '<p>2025级新生宿舍分配规则及查询方式。</p>', '0', 'admission_office', '2025-06-12 14:30:00', NULL, '2025-06-14 00:13:49', '草案待审', '0', 0);
INSERT INTO `dorm_notice` VALUES (18, '宿舍文化节摄影大赛', 'http://img.campus.com/culture-fest/photo.jpg', '5', '<p>“我的宿舍生活”主题摄影作品征集开始！</p>', '0', 'dorm_council', '2025-06-01 10:00:00', 'dorm_council', '2025-06-15 16:34:36', '活动预告', '0', 0);
INSERT INTO `dorm_notice` VALUES (19, '洗衣房设备升级通知', NULL, '1', '<p>7号楼洗衣房6月18-20日暂停服务。</p>', '0', 'facility_mgr', '2025-06-09 17:00:00', NULL, '2025-06-14 00:13:49', '设备更新', '0', 0);
INSERT INTO `dorm_notice` VALUES (20, '暑期宿舍封楼公告', 'http://img.campus.com/summer-closure.jpg', '0', '<p>8月1日-8月25日全校宿舍封楼管理。</p>', '0', 'admin', '2025-05-25 09:30:00', 'admin', '2025-06-15 16:34:36', '后勤处通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (21, '楼层长选举活动', NULL, '5', '<p>9月开展新学年楼层长选举，欢迎报名。</p>', '0', 'dorm_manager', '2025-06-07 13:20:00', NULL, '2025-06-15 16:34:36', '内部通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (22, '宿舍WiFi覆盖升级', 'http://img.campus.com/wifi-upgrade.jpg', '2', '<p>全校宿舍网络将于7月扩容至千兆。</p>', '0', 'it_support', '2025-06-11 11:10:00', 'it_support', '2025-06-15 16:34:36', '信息化办公室', '0', 0);
INSERT INTO `dorm_notice` VALUES (23, '垃圾分类实施指南', NULL, '1', '<p>宿舍区垃圾分类投放点及分类标准说明。</p>', '0', 'env_committee', '2025-05-15 15:45:00', NULL, '2025-06-14 00:13:49', '环保倡议', '0', 0);
INSERT INTO `dorm_notice` VALUES (24, '宿舍门禁系统升级', 'http://img.campus.com/door-access.jpg', '0', '<p>6月25日起启用新版人脸识别门禁系统。</p>', '0', 'security', '2025-06-04 08:30:00', 'security', '2025-06-15 16:34:36', '安保处通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (25, '失物招领平台上线', NULL, '2', '<p>宿舍区失物招领小程序正式启用。</p>', '0', 'lost_found', '2025-05-30 14:20:00', NULL, '2025-06-14 00:13:49', '试运行', '0', 0);
INSERT INTO `dorm_notice` VALUES (26, '宿舍读书会活动', 'http://img.campus.com/book-club.jpg', '4', '<p>每周五晚图书馆开展宿舍读书分享会。</p>', '0', 'library', '2025-06-02 10:40:00', 'library', '2025-06-15 16:34:36', '书香校园', '0', 0);
INSERT INTO `dorm_notice` VALUES (27, '水电费缴纳方式变更', NULL, '1', '<p>7月起水电费改为线上缴纳，停止现金收费。</p>', '0', 'finance', '2025-05-18 09:15:00', 'finance', '2025-06-14 00:13:49', '缴费指南', '0', 0);
INSERT INTO `dorm_notice` VALUES (28, '宿舍应急疏散图更新', 'http://img.campus.com/escape-map.jpg', '0', '<p>各楼层新应急疏散图已张贴在公告栏。</p>', '0', 'safety_office', '2025-06-13 08:45:00', NULL, '2025-06-15 16:34:36', '安全更新', '0', 0);
INSERT INTO `dorm_notice` VALUES (29, '暑期宿舍安全须知', 'http://img.campus.com/safety/cover1.jpg', '1', '<p>暑期留校同学请注意用电安全，离开宿舍务必断电。</p>', '0', 'admin', '2025-06-15 09:30:00', 'admin', '2025-06-15 16:34:36', '安全部发布', '0', 0);
INSERT INTO `dorm_notice` VALUES (30, '3号楼热水系统维护通知', NULL, '3', '<p>7月1日9:00-17:00暂停热水供应，请提前储备。</p>', '0', 'dorm_manager', '2025-06-14 10:15:00', NULL, '2025-06-14 00:13:49', '仅限3号楼', '0', 0);
INSERT INTO `dorm_notice` VALUES (31, '全校消防演练安排', 'http://img.campus.com/fire-drill/cover.png', '2', '<p>6月20日下午2点全校消防演习，请配合疏散。</p>', '0', 'safety_office', '2025-06-10 13:45:00', 'safety_office', '2025-06-15 16:34:36', '年度例行演习', '0', 0);
INSERT INTO `dorm_notice` VALUES (32, '5号楼公共区域消杀通知', NULL, '3', '<p>每周三下午进行公共区域消毒，请收好私人物品。</p>', '0', 'dorm_staff', '2025-06-08 16:30:00', NULL, '2025-06-14 00:13:49', '5号楼专用', '0', 0);
INSERT INTO `dorm_notice` VALUES (33, '校园歌手大赛报名启动', 'http://img.campus.com/singing/2025.jpg', '4', '<p>年度校园歌手大赛开始报名，奖品丰厚！</p>', '0', 'culture_center', '2025-06-05 14:00:00', 'admin', '2025-06-15 16:34:36', '文艺部主办', '0', 0);
INSERT INTO `dorm_notice` VALUES (34, '毕业生退宿流程指南', 'http://img.campus.com/graduate/checkout.jpg', '0', '<p>2025届毕业生退宿手续办理流程说明。</p>', '0', 'admin', '2025-05-28 09:00:00', 'admin', '2025-06-14 00:13:49', '重要通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (35, '宿舍空调清洗服务', NULL, '5', '<p>6月25日免费空调清洗服务，请到值班室登记。</p>', '0', 'dorm_service', '2025-06-03 11:20:00', 'dorm_service', '2025-06-14 00:13:49', '限2/4/6号楼', '0', 0);
INSERT INTO `dorm_notice` VALUES (36, '禁止大功率电器通告', 'http://img.campus.com/electrical-warning.jpg', '0', '<p>重申宿舍禁止使用电炉、电锅等大功率电器。</p>', '0', 'admin', '2025-05-20 08:45:00', NULL, '2025-06-15 16:34:43', '安全警示', '0', 0);
INSERT INTO `dorm_notice` VALUES (37, '新生宿舍分配说明', NULL, '2', '<p>2025级新生宿舍分配规则及查询方式。</p>', '0', 'admission_office', '2025-06-12 14:30:00', NULL, '2025-06-14 00:13:49', '草案待审', '0', 0);
INSERT INTO `dorm_notice` VALUES (38, '宿舍文化节摄影大赛', 'http://img.campus.com/culture-fest/photo.jpg', '0', '<p>“我的宿舍生活”主题摄影作品征集开始！</p>', '0', 'dorm_council', '2025-06-01 10:00:00', 'dorm_council', '2025-06-15 16:34:43', '活动预告', '0', 0);
INSERT INTO `dorm_notice` VALUES (39, '洗衣房设备升级通知', NULL, '1', '<p>7号楼洗衣房6月18-20日暂停服务。</p>', '0', 'facility_mgr', '2025-06-09 17:00:00', NULL, '2025-06-14 00:13:49', '设备更新', '0', 0);
INSERT INTO `dorm_notice` VALUES (40, '暑期宿舍封楼公告', 'http://img.campus.com/summer-closure.jpg', '0', '<p>8月1日-8月25日全校宿舍封楼管理。</p>', '0', 'admin', '2025-05-25 09:30:00', 'admin', '2025-06-15 16:34:43', '后勤处通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (41, '楼层长选举活动', NULL, '5', '<p>9月开展新学年楼层长选举，欢迎报名。</p>', '0', 'dorm_manager', '2025-06-07 13:20:00', NULL, '2025-06-14 00:13:49', '内部通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (42, '宿舍WiFi覆盖升级', 'http://img.campus.com/wifi-upgrade.jpg', '2', '<p>全校宿舍网络将于7月扩容至千兆。</p>', '0', 'it_support', '2025-06-11 11:10:00', 'it_support', '2025-06-15 16:34:43', '信息化办公室', '0', 0);
INSERT INTO `dorm_notice` VALUES (43, '垃圾分类实施指南', NULL, '1', '<p>宿舍区垃圾分类投放点及分类标准说明。</p>', '0', 'env_committee', '2025-05-15 15:45:00', NULL, '2025-06-14 00:13:49', '环保倡议', '0', 0);
INSERT INTO `dorm_notice` VALUES (44, '宿舍门禁系统升级', 'http://img.campus.com/door-access.jpg', '0', '<p>6月25日起启用新版人脸识别门禁系统。</p>', '0', 'security', '2025-06-04 08:30:00', 'security', '2025-06-15 16:34:43', '安保处通知', '0', 0);
INSERT INTO `dorm_notice` VALUES (45, '失物招领平台上线', NULL, '2', '<p>宿舍区失物招领小程序正式启用。</p>', '0', 'lost_found', '2025-05-30 14:20:00', NULL, '2025-06-14 00:13:49', '试运行', '0', 0);
INSERT INTO `dorm_notice` VALUES (46, '宿舍读书会活动', 'http://img.campus.com/book-club.jpg', '4', '<p>每周五晚图书馆开展宿舍读书分享会。</p>', '0', 'library', '2025-06-02 10:40:00', 'library', '2025-06-15 16:34:43', '书香校园', '0', 0);
INSERT INTO `dorm_notice` VALUES (47, '水电费缴纳方式变更', NULL, '1', '<p>7月起水电费改为线上缴纳，停止现金收费。</p>', '0', 'finance', '2025-05-18 09:15:00', 'finance', '2025-06-14 00:13:49', '缴费指南', '0', 0);
INSERT INTO `dorm_notice` VALUES (48, '宿舍应急疏散图更新', 'http://img.campus.com/escape-map.jpg', '0', '<p>各楼层新应急疏散图已张贴在公告栏。</p>', '0', 'safety_office', '2025-06-13 08:45:00', NULL, '2025-06-15 16:34:43', '安全更新', '0', 0);

-- ----------------------------
-- Table structure for dorm_notice_like
-- ----------------------------
DROP TABLE IF EXISTS `dorm_notice_like`;
CREATE TABLE `dorm_notice_like`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `notice_id` bigint(20) NOT NULL COMMENT '公告ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '点赞时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_notice_user`(`notice_id` ASC, `user_id` ASC) USING BTREE COMMENT '确保用户对同一公告只能点赞一次'
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告点赞记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_notice_like
-- ----------------------------
INSERT INTO `dorm_notice_like` VALUES (2, 1, 1, '2025-06-14 10:47:09');
INSERT INTO `dorm_notice_like` VALUES (3, 2, 1, '2025-06-14 10:47:46');
INSERT INTO `dorm_notice_like` VALUES (4, 1, 101, '2025-06-14 10:49:20');
INSERT INTO `dorm_notice_like` VALUES (5, 5, 1, '2025-06-15 16:18:00');
INSERT INTO `dorm_notice_like` VALUES (7, 2, 101, '2025-06-16 20:39:29');
INSERT INTO `dorm_notice_like` VALUES (8, 3, 101, '2025-06-16 20:39:40');
INSERT INTO `dorm_notice_like` VALUES (9, 9, 101, '2025-06-17 17:33:24');

-- ----------------------------
-- Table structure for dorm_repair_assignment
-- ----------------------------
DROP TABLE IF EXISTS `dorm_repair_assignment`;
CREATE TABLE `dorm_repair_assignment`  (
  `assignment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分配ID',
  `request_id` bigint(20) NOT NULL COMMENT '工单ID',
  `request_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工单编号',
  `repairer_id` bigint(20) NOT NULL COMMENT '维修人员ID',
  `repairer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '维修人员姓名',
  `specialty` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '维修项目（0电工，1水工，2木工，3水泥工）',
  `assign_time` datetime NOT NULL COMMENT '分配时间',
  `process_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '处理状态（0-待接单，1-处理中，2-已完成，3-已拒绝）',
  `accept_time` datetime NULL DEFAULT NULL COMMENT '接单时间',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `reject_time` datetime NULL DEFAULT NULL COMMENT '拒绝时间',
  `reject_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `process_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL，多个以逗号分隔，用于完成维修后图片上传',
  PRIMARY KEY (`assignment_id`) USING BTREE,
  INDEX `idx_request_id`(`request_id` ASC) USING BTREE,
  INDEX `idx_request_no`(`request_no` ASC) USING BTREE,
  INDEX `idx_repairer_id`(`repairer_id` ASC) USING BTREE,
  INDEX `idx_process_status`(`process_status` ASC) USING BTREE,
  CONSTRAINT `fk_assignment_repairer` FOREIGN KEY (`repairer_id`) REFERENCES `dorm_repairer` (`repairer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_assignment_request` FOREIGN KEY (`request_id`) REFERENCES `dorm_repair_request` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工单分配表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_repair_assignment
-- ----------------------------
INSERT INTO `dorm_repair_assignment` VALUES (1, 6, 'REQ202506180002', 102, '陈炫霖', '0', '2025-06-18 23:10:36', '2', '2025-06-18 23:12:51', '2025-06-18 23:51:41', NULL, NULL, '12313', '', '2025-06-18 23:10:36', '', '2025-06-18 23:51:41', 'blob:http://localhost:81/797d13f7-d465-42c4-b0be-65f3f7ac5b8c,blob:http://localhost:81/ea81fd2c-62e5-4a83-9cd6-144e0f426342,blob:http://localhost:81/2bd6e48d-1f28-4fc7-a8f9-62c0855a3e55');
INSERT INTO `dorm_repair_assignment` VALUES (2, 7, 'REQ202506190001', 102, '陈炫霖', '0', '2025-06-19 00:02:23', '2', '2025-06-19 00:03:29', '2025-06-19 00:04:32', NULL, NULL, '', '', '2025-06-19 00:02:23', '', '2025-06-19 00:04:32', 'blob:http://localhost:81/fa0cbd41-2a46-493b-9024-1e9c9b79bc55');
INSERT INTO `dorm_repair_assignment` VALUES (3, 8, 'REQ202506190002', 102, '陈炫霖', '1', '2025-06-19 00:05:46', '2', '2025-06-19 00:14:32', '2025-06-19 00:14:54', NULL, NULL, '', '', '2025-06-19 00:05:46', '', '2025-06-19 00:14:54', 'blob:http://localhost:81/0595b58d-9408-4235-a6b0-9896670be222');
INSERT INTO `dorm_repair_assignment` VALUES (4, 9, 'REQ202506190003', 102, '陈炫霖', '2', '2025-06-19 09:21:13', '2', '2025-06-19 09:21:57', '2025-06-19 09:23:54', NULL, NULL, '', '', '2025-06-19 09:21:13', '', '2025-06-19 09:23:54', 'blob:http://localhost:81/ed5de46c-370b-4201-91f8-8fddbfbaa2f7');
INSERT INTO `dorm_repair_assignment` VALUES (5, 10, 'REQ202506190004', 103, '杨豪', '2', '2025-06-19 09:23:06', '3', NULL, NULL, '2025-06-19 09:55:49', '超时未响应，系统自动拒绝', NULL, '', '2025-06-19 09:23:06', '', '2025-06-19 09:55:49', NULL);
INSERT INTO `dorm_repair_assignment` VALUES (6, 11, 'REQ202506190005', 102, '陈炫霖', '2', '2025-06-19 09:24:37', '2', '2025-06-19 09:25:39', '2025-06-19 09:52:05', NULL, NULL, '', '', '2025-06-19 09:24:37', '', '2025-06-19 09:52:05', 'blob:http://localhost:81/f320849f-a8eb-448c-8dfb-1c3eaa865a49');
INSERT INTO `dorm_repair_assignment` VALUES (7, 12, 'REQ202506190006', 102, '陈炫霖', '0', '2025-06-19 09:52:34', '2', '2025-06-19 09:56:18', '2025-06-19 09:56:29', NULL, NULL, '', '', '2025-06-19 09:52:34', '', '2025-06-19 09:56:29', 'blob:http://localhost:81/4df1f176-dbfd-418d-9342-6f5aa4ec96af');
INSERT INTO `dorm_repair_assignment` VALUES (8, 13, 'REQ202506190007', 102, '陈炫霖', '0', '2025-06-19 10:05:05', '2', '2025-06-19 10:06:45', '2025-06-19 10:06:51', NULL, NULL, '', '', '2025-06-19 10:05:05', '', '2025-06-19 10:06:51', 'blob:http://localhost:81/aee4fc5f-1ed1-4fd4-a8a3-5f765ab00ac2');
INSERT INTO `dorm_repair_assignment` VALUES (9, 14, 'REQ202506190008', 102, '陈炫霖', '1', '2025-06-19 10:07:40', '3', NULL, NULL, '2025-06-19 10:08:17', '123', NULL, '', '2025-06-19 10:07:40', '', '2025-06-19 10:08:17', NULL);
INSERT INTO `dorm_repair_assignment` VALUES (10, 15, 'REQ202506190009', 102, '陈炫霖', '2', '2025-06-19 10:15:47', '3', NULL, NULL, '2025-06-19 10:47:17', '超时未响应，系统自动拒绝', NULL, '', '2025-06-19 10:15:47', '', '2025-06-19 10:47:17', NULL);
INSERT INTO `dorm_repair_assignment` VALUES (11, 16, 'REQ202506190010', 102, '陈炫霖', '0', '2025-06-19 12:18:42', '2', '2025-06-19 12:19:14', '2025-06-19 12:19:24', NULL, NULL, '', '', '2025-06-19 12:18:42', '', '2025-06-19 12:19:24', 'blob:http://localhost:81/e5699834-80c2-43f5-9361-ded6547d28ca');
INSERT INTO `dorm_repair_assignment` VALUES (12, 17, 'REQ202506190011', 102, '陈炫霖', '0', '2025-06-19 13:44:44', '3', NULL, NULL, '2025-06-19 13:46:30', '123', NULL, '', '2025-06-19 13:44:44', '', '2025-06-19 13:46:30', NULL);
INSERT INTO `dorm_repair_assignment` VALUES (13, 18, 'REQ202506190012', 102, '陈炫霖', '1', '2025-06-19 13:55:50', '3', NULL, NULL, '2025-06-19 13:56:29', '12313', NULL, '', '2025-06-19 13:55:50', '', '2025-06-19 13:56:29', NULL);
INSERT INTO `dorm_repair_assignment` VALUES (14, 19, 'REQ202506190013', 102, '陈炫霖', '2', '2025-06-19 14:15:36', '3', NULL, NULL, '2025-06-19 14:16:14', '不要了', NULL, '', '2025-06-19 14:15:36', '', '2025-06-19 14:16:14', NULL);
INSERT INTO `dorm_repair_assignment` VALUES (15, 18, 'REQ202506190012', 103, '杨豪', '1', '2025-06-19 14:22:15', '3', NULL, NULL, '2025-06-19 14:54:37', '超时未响应，系统自动拒绝', NULL, '', '2025-06-19 14:22:15', '', '2025-06-19 14:54:37', NULL);
INSERT INTO `dorm_repair_assignment` VALUES (16, 19, 'REQ202506190013', 103, '杨豪', '2', '2025-06-19 14:32:15', '3', NULL, NULL, '2025-06-19 15:04:37', '超时未响应，系统自动拒绝', NULL, '', '2025-06-19 14:32:15', '', '2025-06-19 15:04:37', NULL);

-- ----------------------------
-- Table structure for dorm_repair_dispatch_history
-- ----------------------------
DROP TABLE IF EXISTS `dorm_repair_dispatch_history`;
CREATE TABLE `dorm_repair_dispatch_history`  (
  `history_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '历史记录ID',
  `request_id` bigint(20) NOT NULL COMMENT '工单ID',
  `request_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '工单编号',
  `specialty` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '维修项目',
  `dispatch_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '派单类型（AUTO-自动派单，MANUAL-人工派单，RETRY-重新派单）',
  `selected_repairer_id` bigint(20) NULL DEFAULT NULL COMMENT '选中的维修人员ID',
  `selected_repairer_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '选中的维修人员姓名',
  `candidate_count` int(11) NULL DEFAULT 0 COMMENT '候选维修人员数量',
  `dispatch_result` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '派单结果（SUCCESS-成功，FAILED-失败）',
  `failure_reason` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '失败原因',
  `dispatch_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '派单时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `idx_request_id`(`request_id` ASC) USING BTREE,
  INDEX `idx_request_no`(`request_no` ASC) USING BTREE,
  INDEX `idx_dispatch_time`(`dispatch_time` ASC) USING BTREE,
  INDEX `idx_dispatch_type`(`dispatch_type` ASC) USING BTREE,
  INDEX `idx_dispatch_result`(`dispatch_result` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '派单历史记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_repair_dispatch_history
-- ----------------------------
INSERT INTO `dorm_repair_dispatch_history` VALUES (1, 6, 'REQ202506180002', '0', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-18 23:10:36', '', '2025-06-18 23:10:36');
INSERT INTO `dorm_repair_dispatch_history` VALUES (2, 7, 'REQ202506190001', '0', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 00:02:23', '', '2025-06-19 00:02:23');
INSERT INTO `dorm_repair_dispatch_history` VALUES (3, 8, 'REQ202506190002', '1', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 00:05:46', '', '2025-06-19 00:05:46');
INSERT INTO `dorm_repair_dispatch_history` VALUES (4, 9, 'REQ202506190003', '2', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 09:21:13', '', '2025-06-19 09:21:13');
INSERT INTO `dorm_repair_dispatch_history` VALUES (5, 10, 'REQ202506190004', '2', 'AUTO', 103, '杨豪', 1, 'SUCCESS', NULL, '2025-06-19 09:23:06', '', '2025-06-19 09:23:06');
INSERT INTO `dorm_repair_dispatch_history` VALUES (6, 11, 'REQ202506190005', '2', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 09:24:37', '', '2025-06-19 09:24:37');
INSERT INTO `dorm_repair_dispatch_history` VALUES (7, 12, 'REQ202506190006', '0', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 09:52:34', '', '2025-06-19 09:52:34');
INSERT INTO `dorm_repair_dispatch_history` VALUES (8, 13, 'REQ202506190007', '0', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 10:05:05', '', '2025-06-19 10:05:05');
INSERT INTO `dorm_repair_dispatch_history` VALUES (9, 14, 'REQ202506190008', '1', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 10:07:40', '', '2025-06-19 10:07:40');
INSERT INTO `dorm_repair_dispatch_history` VALUES (10, 15, 'REQ202506190009', '2', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 10:15:47', '', '2025-06-19 10:15:47');
INSERT INTO `dorm_repair_dispatch_history` VALUES (11, 16, 'REQ202506190010', '0', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 12:18:42', '', '2025-06-19 12:18:42');
INSERT INTO `dorm_repair_dispatch_history` VALUES (12, 17, 'REQ202506190011', '0', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 13:44:44', '', '2025-06-19 13:44:44');
INSERT INTO `dorm_repair_dispatch_history` VALUES (13, 18, 'REQ202506190012', '1', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 13:55:50', '', '2025-06-19 13:55:50');
INSERT INTO `dorm_repair_dispatch_history` VALUES (14, 19, 'REQ202506190013', '2', 'AUTO', 102, '陈炫霖', 2, 'SUCCESS', NULL, '2025-06-19 14:15:36', '', '2025-06-19 14:15:36');
INSERT INTO `dorm_repair_dispatch_history` VALUES (15, 18, 'REQ202506190012', '1', 'AUTO', 103, '杨豪', 1, 'SUCCESS', NULL, '2025-06-19 14:22:15', '', '2025-06-19 14:22:15');
INSERT INTO `dorm_repair_dispatch_history` VALUES (16, 19, 'REQ202506190013', '2', 'AUTO', 103, '杨豪', 1, 'SUCCESS', NULL, '2025-06-19 14:32:15', '', '2025-06-19 14:32:15');

-- ----------------------------
-- Table structure for dorm_repair_dispatch_lock
-- ----------------------------
DROP TABLE IF EXISTS `dorm_repair_dispatch_lock`;
CREATE TABLE `dorm_repair_dispatch_lock`  (
  `lock_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '锁ID',
  `request_id` bigint(20) NOT NULL COMMENT '工单ID',
  `lock_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '锁键值',
  `lock_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '锁值',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`lock_id`) USING BTREE,
  UNIQUE INDEX `uk_lock_key`(`lock_key` ASC) USING BTREE,
  INDEX `idx_request_id`(`request_id` ASC) USING BTREE,
  INDEX `idx_expire_time`(`expire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '智能派单分布式锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_repair_dispatch_lock
-- ----------------------------

-- ----------------------------
-- Table structure for dorm_repair_request
-- ----------------------------
DROP TABLE IF EXISTS `dorm_repair_request`;
CREATE TABLE `dorm_repair_request`  (
  `request_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '工单ID',
  `request_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工单编号',
  `student_id` bigint(20) NULL DEFAULT NULL COMMENT '报修学生ID',
  `dorm_id` bigint(20) NOT NULL COMMENT '宿舍ID',
  `specialty` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报修项目（0电工，1水工，2木工，3水泥工）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '问题描述',
  `reporter_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报修人',
  `contact_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系方式',
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL，多个以逗号分隔',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态（0-待派单，1-已派单，2-维修中，3-已完成，4-已取消,5-等待人工派单）',
  `attempt_count` int(11) NULL DEFAULT 0 COMMENT '派单尝试次数',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID',
  PRIMARY KEY (`request_id`) USING BTREE,
  UNIQUE INDEX `uk_repair_request_no`(`request_no` ASC) USING BTREE,
  INDEX `idx_repair_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_repair_dorm`(`dorm_id` ASC) USING BTREE,
  INDEX `idx_repair_status`(`status` ASC) USING BTREE,
  INDEX `idx_repair_item`(`specialty` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '报修工单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dorm_repair_request
-- ----------------------------
INSERT INTO `dorm_repair_request` VALUES (5, 'REQ202506180001', NULL, 262, '0', '下水道堵住了......', '王新瑜', '13282973175', '', '4', 0, NULL, '2025-06-18 22:37:22', NULL, '2025-06-19 00:01:52', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (6, 'REQ202506180002', NULL, 262, '0', '下水道堵了......', '王新瑜', '13282973175', '', '3', 1, NULL, '2025-06-18 23:10:36', NULL, '2025-06-18 23:51:41', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (7, 'REQ202506190001', NULL, 262, '0', '123232312323231', '王新瑜', '13282973175', '', '3', 1, NULL, '2025-06-19 00:02:23', NULL, '2025-06-19 00:04:32', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (8, 'REQ202506190002', NULL, 241, '1', '846645656546456', '54645654', '13282973175', '', '3', 1, NULL, '2025-06-19 00:05:46', NULL, '2025-06-19 00:14:54', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (9, 'REQ202506190003', NULL, 262, '2', '12345623132\n', '王新瑜', '13282973175', '', '3', 1, NULL, '2025-06-19 09:21:13', NULL, '2025-06-19 09:23:54', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (10, 'REQ202506190004', NULL, 246, '2', '12312323123313', '2132323123', '13282973175', '', '1', 1, NULL, '2025-06-19 09:23:06', NULL, NULL, NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (11, 'REQ202506190005', NULL, 246, '2', '123123232323232', '王新瑜', '13282973175', '', '3', 1, NULL, '2025-06-19 09:24:37', NULL, '2025-06-19 09:52:05', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (12, 'REQ202506190006', NULL, 246, '0', '1231312312323123213', '123', '13282973175', '', '3', 1, NULL, '2025-06-19 09:52:34', NULL, '2025-06-19 09:56:29', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (13, 'REQ202506190007', NULL, 255, '0', '2312331321', '123', '13282975463', '', '3', 1, NULL, '2025-06-19 10:05:05', NULL, '2025-06-19 10:06:51', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (14, 'REQ202506190008', NULL, 241, '1', '123123223123', '123', '13282973175', '', '4', 1, NULL, '2025-06-19 10:07:40', NULL, '2025-06-19 10:15:20', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (15, 'REQ202506190009', NULL, 261, '2', '123123123123', '123', '13282973175', '', '4', 1, NULL, '2025-06-19 10:15:47', NULL, '2025-06-19 13:44:11', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (16, 'REQ202506190010', NULL, 241, '0', '123131313123', '123', '13256483156', '', '3', 1, NULL, '2025-06-19 12:18:42', NULL, '2025-06-19 12:19:24', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (17, 'REQ202506190011', NULL, 241, '0', '12345645645', '123', '13282973175', '', '4', 1, NULL, '2025-06-19 13:44:44', NULL, '2025-06-19 14:14:57', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (18, 'REQ202506190012', NULL, 262, '1', '123133123123131', '123', '13564834156', '', '4', 2, NULL, '2025-06-19 13:55:49', NULL, '2025-06-19 15:27:05', NULL, 101);
INSERT INTO `dorm_repair_request` VALUES (19, 'REQ202506190013', NULL, 241, '2', '12313121323', '123', '13256486156', '', '4', 2, NULL, '2025-06-19 14:15:36', NULL, '2025-06-19 15:27:00', NULL, 101);

-- ----------------------------
-- Table structure for dorm_repairer
-- ----------------------------
DROP TABLE IF EXISTS `dorm_repairer`;
CREATE TABLE `dorm_repairer`  (
  `repairer_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '维修人员ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `repairer_no` bigint(20) NOT NULL COMMENT '工号',
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '姓名',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '联系电话',
  `specialty` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '专长领域（0电工，1水工，2木工，3水泥工）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态(0出工,1空闲)',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `order_count` int(11) NULL DEFAULT 0 COMMENT '已接单数量',
  PRIMARY KEY (`repairer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '宿舍维修人员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_repairer
-- ----------------------------
INSERT INTO `dorm_repairer` VALUES (102, 104, 2310305321, '陈炫霖', '13282973175', '0,1,2,3', '1', NULL, '2025-06-17 21:42:46', NULL, '2025-06-19 12:19:24', NULL, 0);
INSERT INTO `dorm_repairer` VALUES (103, 105, 2310305109, '杨豪', '13282973171', '0,1,2,3', '1', NULL, '2025-06-18 16:03:44', NULL, NULL, NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dorm_student
-- ----------------------------
INSERT INTO `dorm_student` VALUES (00000000000000000001, 100, '20230001', '张三', '1', '计算机科学与技术1班', '13800138001', '0', 'zhangsan@school.edu', '0', 262, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 16:41:48', '');
INSERT INTO `dorm_student` VALUES (00000000000000000002, 102, '20230002', '李四', '1', '计算机科学与技术1班', '13800138002', '0', 'lisi@school.edu', '0', 262, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 15:13:45', '');
INSERT INTO `dorm_student` VALUES (00000000000000000003, 109, '20230003', '王五', '1', '计算机科学与技术1班', '13800138003', '0', 'wangwu@school.edu', '0', 262, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-20 01:01:36', '');
INSERT INTO `dorm_student` VALUES (00000000000000000004, 104, '20230004', '赵六', '0', '计算机科学与技术1班', '13800138004', '0', 'zhaoliu@school.edu', '0', 262, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 15:14:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000005, 105, '20230005', '钱七', '0', '计算机科学与技术2班', '13800138005', '0', 'qianqi@school.edu', '0', 254, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 21:32:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000006, 106, '20230006', '孙八', '0', '计算机科学与技术2班', '13800138006', '0', 'sunba@school.edu', '0', 258, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000007, 107, '20230007', '周九', '0', '计算机科学与技术2班', '13800138007', '0', 'zhoujiu@school.edu', '0', 258, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000008, 108, '20230008', '吴十', '0', '计算机科学与技术2班', '13800138008', '0', 'wushi@school.edu', '0', 258, 'admin', '2025-01-10 09:00:00', 'admin', '2025-01-10 09:00:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000009, 109, '20230009', '郑十一', '0', '软件工程1班', '13800138009', '0', 'zhengshiyi@school.edu', '0', 254, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 21:52:23', '');
INSERT INTO `dorm_student` VALUES (00000000000000000010, 110, '20230010', '王小红', '1', '软件工程1班', '13800138010', '0', 'wangxiaohong@school.edu', '0', 254, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 21:32:09', '');
INSERT INTO `dorm_student` VALUES (00000000000000000011, 111, '20230011', '李小花', '1', '软件工程1班', '13800138011', '0', 'lixiaohua@school.edu', '0', 261, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 19:56:50', '');
INSERT INTO `dorm_student` VALUES (00000000000000000012, 112, '20230012', '张美丽', '1', '软件工程1班', '13800138012', '0', 'zhangmeili@school.edu', '0', 254, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 21:32:15', '');
INSERT INTO `dorm_student` VALUES (00000000000000000013, 113, '20230013', '刘芳', '1', '软件工程1班', '13800138013', '0', 'liufang@school.edu', '0', 254, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 21:32:20', '');
INSERT INTO `dorm_student` VALUES (00000000000000000014, 114, '20230014', '陈静', '1', '软件工程2班', '13800138014', '0', 'chenjing@school.edu', '0', 254, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 22:25:01', '');
INSERT INTO `dorm_student` VALUES (00000000000000000015, 115, '20230015', '杨雪', '1', '软件工程2班', '13800138015', '0', 'yangxue@school.edu', '0', 262, 'admin', '2025-01-10 09:00:00', 'admin', '2025-06-10 15:26:00', '');
INSERT INTO `dorm_student` VALUES (00000000000000000025, 101, '2310305320', '王新瑜', '0', '软件2301', '13282973175', '0', '2559118499@qq.com', '0', 262, NULL, '2025-06-08 16:41:07', NULL, '2025-06-11 00:03:32', NULL);

-- ----------------------------
-- Table structure for dorm_student_leave
-- ----------------------------
DROP TABLE IF EXISTS `dorm_student_leave`;
CREATE TABLE `dorm_student_leave`  (
  `leave_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '离校记录ID',
  `student_no` bigint(20) NOT NULL COMMENT '学号',
  `leave_time` datetime NOT NULL COMMENT '离校时间',
  `expected_return_time` datetime NULL DEFAULT NULL COMMENT '预计返校时间',
  `actual_return_time` datetime NULL DEFAULT NULL COMMENT '实际返校时间',
  `leave_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '离校原因',
  `destination` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目的地',
  `contact_during_leave` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '离校期间联系电话',
  `emergency_contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '紧急联系人电话',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态（0-离校中，1-已返校，2-逾期未返）',
  `approver` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `approve_status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '审批状态（0-待审批，1-已批准，2-已拒绝，3-已取消）',
  `approve_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`leave_id`) USING BTREE,
  INDEX `idx_student_id`(`student_no` ASC) USING BTREE,
  INDEX `idx_leave_time`(`leave_time` ASC) USING BTREE,
  INDEX `idx_expected_return_time`(`expected_return_time` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_approve_status`(`approve_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学生离校登记表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dorm_student_leave
-- ----------------------------
INSERT INTO `dorm_student_leave` VALUES (1, 2310305320, '2025-06-20 00:00:00', '2025-06-26 00:00:00', NULL, '回家', '回家', '13282973175', '123', '13282973175', '0', NULL, '2025-06-19 22:57:51', '3', '用户主动取消申请', '', '2025-06-19 21:02:34', '', '2025-06-19 22:57:51', '');
INSERT INTO `dorm_student_leave` VALUES (2, 2310305320, '2025-06-19 00:00:00', '2025-06-20 00:00:00', NULL, '去玩', '北京', '13282973175', '老细', '13282973456', '0', NULL, '2025-06-19 22:57:59', '3', '用户主动取消申请', '', '2025-06-19 21:49:14', '', '2025-06-19 22:57:59', '');
INSERT INTO `dorm_student_leave` VALUES (3, 2310305320, '2025-06-19 00:00:00', '2025-06-20 00:00:00', NULL, '12313323132', '23313', '13282973175', '123123', '13282973175', '0', NULL, '2025-06-19 22:59:52', '3', '用户主动取消申请', '', '2025-06-19 22:59:03', '', '2025-06-19 22:59:52', '');
INSERT INTO `dorm_student_leave` VALUES (4, 2310305320, '2025-06-19 23:32:58', '2025-06-22 23:33:05', NULL, '1231313', '333', '13282973175', '王新瑜', '13282973175', '0', '若依', '2025-06-20 00:00:39', '2', 'lll', '', '2025-06-19 23:33:22', '', '2025-06-20 00:00:39', '');
INSERT INTO `dorm_student_leave` VALUES (5, 2310305320, '2025-06-20 00:01:54', '2025-06-21 00:02:02', '2025-06-20 00:02:44', '12313231', '2111', '13282973175', '123', '13282671515', '1', '若依', '2025-06-20 00:02:35', '1', '可以', '', '2025-06-20 00:02:20', '', '2025-06-20 00:02:44', '');
INSERT INTO `dorm_student_leave` VALUES (6, 2310305320, '2025-06-20 00:03:52', '2025-06-21 00:03:56', '2025-06-20 00:04:44', '1231331231', '123', '13282973175', '222', '13282973175', '1', '若依', '2025-06-20 00:04:28', '1', '66', '', '2025-06-20 00:04:08', '', '2025-06-20 00:04:44', '');
INSERT INTO `dorm_student_leave` VALUES (7, 2310305320, '2025-06-20 00:05:41', '2025-06-21 00:05:44', '2025-06-20 00:06:16', '12312313', '123', '13282973175', '123', '13282973175', '1', '若依', '2025-06-20 00:06:11', '1', '可以', '', '2025-06-20 00:05:54', '', '2025-06-20 00:06:16', '');
INSERT INTO `dorm_student_leave` VALUES (8, 2310305320, '2025-06-20 00:26:12', '2025-06-21 00:26:16', NULL, '1232323', '12313', '13282973175', '23', '13282973175', '0', '若依', '2025-06-20 00:28:52', '1', '123', '', '2025-06-20 00:26:28', '', '2025-06-20 00:28:52', '');

SET FOREIGN_KEY_CHECKS = 1;
