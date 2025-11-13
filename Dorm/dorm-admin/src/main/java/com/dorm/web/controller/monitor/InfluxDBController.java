package com.dorm.web.controller.monitor;

import com.dorm.common.annotation.Anonymous;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.core.domain.entity.DormBuilding;
import com.dorm.framework.web.service.InfluxDBService;
import com.dorm.manage.service.IDormAlarmLogService;
import com.dorm.manage.domain.DormAlarmLog;
import com.dorm.manage.domain.DormAlarmDevice;
import com.dorm.manage.service.IDormBuildingService;
import com.dorm.manage.service.IDormAlarmDeviceService;
import com.dorm.common.service.MailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * InfluxDB监控控制器
 * 
 * @author 王新瑜
 * @since 2025-09-01
 */
@RestController
@RequestMapping("/monitor/influxdb")
public class InfluxDBController extends BaseController {
    
    private static final Logger log = LoggerFactory.getLogger(InfluxDBController.class);
    
    @Autowired
    private InfluxDBService influxDBService;

    @Autowired
    private IDormBuildingService dormBuildingService;

    @Autowired
    private IDormAlarmLogService dormAlarmLogService;

    @Autowired
    private IDormAlarmDeviceService dormAlarmDeviceService;

    @Autowired(required = false)
    private MailService mailService;
    
    /**
     * 获取InfluxDB健康状态
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:view')")
    @GetMapping("/health")
    public AjaxResult health() {
        Map<String, Object> healthStatus = influxDBService.healthCheck();
        return success(healthStatus);
    }
    
    /**
     * 查询设备监控数据
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:view')")
    @GetMapping("/device/{deviceId}")
    public AjaxResult getDeviceData(@PathVariable String deviceId,
                                  @RequestParam(defaultValue = "24") int hours) {
        Instant end = Instant.now();
        Instant start = end.minus(hours, ChronoUnit.HOURS);
        
        List<Map<String, Object>> data = influxDBService.queryDeviceData(deviceId, start, end);
        return success(data);
    }
    
    /**
     * 查询用户行为统计
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:view')")
    @GetMapping("/user/{userId}/behavior")
    public AjaxResult getUserBehaviorStats(@PathVariable Long userId,
                                         @RequestParam(defaultValue = "24") int hours) {
        Map<String, Long> stats = influxDBService.queryUserBehaviorStats(userId, hours);
        return success(stats);
    }
    
    /**
     * 手动写入设备数据（测试用）
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:edit')")
    @PostMapping("/device/data")
    public AjaxResult writeDeviceData(@RequestBody Map<String, Object> data) {
        try {
            String deviceId = (String) data.get("deviceId");
            String deviceType = (String) data.get("deviceType");
            String dormId = (String) data.get("dormId");
            String measurement = (String) data.get("measurement");
            Double value = Double.valueOf(data.get("value").toString());
            String unit = (String) data.get("unit");
            
            influxDBService.writeDeviceData(deviceId, deviceType, dormId, measurement, value, unit);
            return success("设备数据写入成功");
        } catch (Exception e) {
            return error("设备数据写入失败: " + e.getMessage());
        }
    }
    
    /**
     * 手动写入用户行为数据（测试用）
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:edit')")
    @PostMapping("/user/behavior")
    public AjaxResult writeUserBehavior(@RequestBody Map<String, Object> data) {
        try {
            Long userId = Long.valueOf(data.get("userId").toString());
            String action = (String) data.get("action");
            String module = (String) data.get("module");
            String details = (String) data.get("details");
            
            influxDBService.writeUserBehavior(userId, action, module, details);
            return success("用户行为数据写入成功");
        } catch (Exception e) {
            return error("用户行为数据写入失败: " + e.getMessage());
        }
    }
    
    /**
     * 手动写入系统监控数据（测试用）
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:edit')")
    @PostMapping("/system/metrics")
    public AjaxResult writeSystemMetrics(@RequestBody Map<String, Object> data) {
        try {
            String metricName = (String) data.get("metricName");
            Double value = Double.valueOf(data.get("value").toString());
            String host = (String) data.get("host");
            
            influxDBService.writeSystemMetrics(metricName, value, host);
            return success("系统监控数据写入成功");
        } catch (Exception e) {
            return error("系统监控数据写入失败: " + e.getMessage());
        }
    }
        
    /**
     * 接收InfluxDB烟雾报警通知
     * 该接口用于接收InfluxDB的Notification Endpoint发送的烟雾传感器报警信息
     */
    @Anonymous
    @PostMapping("/smoke/alert")
    public AjaxResult receiveSmokeAlert(@RequestBody Map<String, Object> alertData) {
        try {
            log.info("收到烟雾报警通知: {}", alertData);
            
            // 解析报警数据
            String alertLevel = extractAlertLevel(alertData);
            String dormId = extractDormId(alertData);
            Double smokeValue = extractSmokeValue(alertData);
            String message = extractMessage(alertData);
            
            // 获取宿舍详细信息
            Map<String, Object> dormInfo = getDormDetailInfo(dormId);
            
            // 构建报警信息
            Map<String, Object> alertInfo = new HashMap<>();
            alertInfo.put("alertLevel", alertLevel);
            alertInfo.put("dormId", dormId);
            alertInfo.put("smokeValue", smokeValue);
            alertInfo.put("message", message);
            alertInfo.put("timestamp", System.currentTimeMillis());
            alertInfo.put("dormInfo", dormInfo);
            
            // 根据报警级别进行不同处理
            handleSmokeAlert(alertInfo);
            
            return success("烟雾报警信息接收成功");
        } catch (Exception e) {
            log.error("处理烟雾报警通知失败: {}", e.getMessage(), e);
            return error("处理烟雾报警通知失败: " + e.getMessage());
        }
    }
    
    /**
     * 提取报警级别
     */
    private String extractAlertLevel(Map<String, Object> alertData) {
        // InfluxDB的报警数据结构可能包含 _level 字段
        Object level = alertData.get("_level");
        if (level != null) {
            return level.toString();
        }
        
        // 检查其他可能的字段
        Object status = alertData.get("_status");
        if (status != null) {
            return status.toString();
        }
        
        // 检查自定义字段
        Object severity = alertData.get("severity");
        if (severity != null) {
            return severity.toString();
        }
        
        return "UNKNOWN";
    }
    
    /**
     * 提取宿舍ID
     */
    private String extractDormId(Map<String, Object> alertData) {
        // 从标签中提取宿舍ID
        Object dormId = alertData.get("dorm_id");
        if (dormId != null) {
            return dormId.toString();
        }
        
        // 检查其他可能的字段名
        Object roomId = alertData.get("roomId");
        if (roomId != null) {
            return roomId.toString();
        }
        
        // 检查标签对象
        @SuppressWarnings("unchecked")
        Map<String, Object> tags = (Map<String, Object>) alertData.get("tags");
        if (tags != null) {
            Object tagDormId = tags.get("dorm_id");
            if (tagDormId != null) {
                return tagDormId.toString();
            }
        }
        
        return "UNKNOWN";
    }
    
    /**
     * 提取烟雾浓度值
     */
    private Double extractSmokeValue(Map<String, Object> alertData) {
        // 尝试从不同字段提取数值
        Object value = alertData.get("_value");
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        
        Object smokePpm = alertData.get("smokePpm");
        if (smokePpm instanceof Number) {
            return ((Number) smokePpm).doubleValue();
        }
        
        // 检查字段对象
        @SuppressWarnings("unchecked")
        Map<String, Object> fields = (Map<String, Object>) alertData.get("fields");
        if (fields != null) {
            Object fieldValue = fields.get("smokePpm");
            if (fieldValue instanceof Number) {
                return ((Number) fieldValue).doubleValue();
            }
        }
        
        return 0.0;
    }
    
    /**
     * 提取报警消息
     */
    private String extractMessage(Map<String, Object> alertData) {
        Object message = alertData.get("_message");
        if (message != null) {
            return message.toString();
        }
        
        Object msg = alertData.get("message");
        if (msg != null) {
            return msg.toString();
        }
        
        return "烟雾传感器报警";
    }
    
    /**
     * 获取宿舍详细信息
     */
    private Map<String, Object> getDormDetailInfo(String dormIdStr) {
        Map<String, Object> dormInfo = new HashMap<>();
        
        try {
            if (dormIdStr != null && !"UNKNOWN".equals(dormIdStr)) {
                Long dormId = Long.valueOf(dormIdStr);
                DormBuilding dormBuilding = dormBuildingService.selectDormBuildingByDormId(dormId);
                
                if (dormBuilding != null) {
                    dormInfo.put("fullName", dormBuilding.getFullName() != null ? dormBuilding.getFullName() : dormBuilding.getBuildingName());
                    dormInfo.put("buildingName", dormBuilding.getBuildingName());
                    dormInfo.put("dormManager", dormBuilding.getDormManager());
                    dormInfo.put("phone", dormBuilding.getPhone());
                    dormInfo.put("maxCapacity", dormBuilding.getMaxCapacity());
                    dormInfo.put("currentCount", dormBuilding.getCurrentCount());
                    
                    // 实现智能信息继承机制
                    if ((dormBuilding.getDormManager() == null || dormBuilding.getDormManager().trim().isEmpty()) &&
                        dormBuilding.getParentId() != null && !dormBuilding.getParentId().equals(0L)) {
                        
                        DormBuilding parentDorm = findParentWithManager(dormBuilding.getParentId());
                        if (parentDorm != null) {
                            dormInfo.put("dormManager", parentDorm.getDormManager());
                            dormInfo.put("phone", parentDorm.getPhone());
                        }
                    }
                } else {
                    dormInfo.put("fullName", "宿舍 " + dormIdStr);
                    dormInfo.put("buildingName", dormIdStr);
                }
            }
        } catch (NumberFormatException e) {
            dormInfo.put("fullName", "宿舍 " + dormIdStr);
            dormInfo.put("buildingName", dormIdStr);
        }
        
        return dormInfo;
    }
    
    /**
     * 处理烟雾报警信息
     */
    private void handleSmokeAlert(Map<String, Object> alertInfo) {
        String alertLevel = (String) alertInfo.get("alertLevel");
        String dormId = (String) alertInfo.get("dormId");
        Double smokeValue = (Double) alertInfo.get("smokeValue");
        
        @SuppressWarnings("unchecked")
        Map<String, Object> dormInfo = (Map<String, Object>) alertInfo.get("dormInfo");
        
        // 记录报警日志
        log.warn("烟雾报警 - 宿舍: {}, 浓度: {}ppm, 级别: {}, 宿管: {}, 电话: {}", 
                dormInfo.get("fullName"), smokeValue, alertLevel, 
                dormInfo.get("dormManager"), dormInfo.get("phone"));
        
        // 根据报警级别进行不同处理
        switch (alertLevel.toUpperCase()) {
            case "CRIT":
            case "CRITICAL":
            case "ALERT":
                handleCriticalAlert(alertInfo);
                break;
            case "WARN":
            case "WARNING":
                handleWarningAlert(alertInfo);
                break;
            default:
                handleInfoAlert(alertInfo);
                break;
        }
    }
    
    /**
     * 处理严重报警
     */
    private void handleCriticalAlert(Map<String, Object> alertInfo) {
        // 严重报警处理逻辑
        log.error("严重烟雾报警: {}", alertInfo);
        
        // 保存报警记录到数据库
        saveAlertToDatabase(alertInfo);
        
        // 发送报警邮件
        sendAlertEmail(alertInfo);
        
        // TODO: 可以在这里添加以下功能：
        // 1. 发送短信通知
        // 2. 推送到管理员手机APP
        // 3. 触发自动应急流程
    }
    
    /**
     * 处理警告级报警
     */
    private void handleWarningAlert(Map<String, Object> alertInfo) {
        // 警告级报警处理逻辑
        log.warn("警告级烟雾报警: {}", alertInfo);
        
        // 保存报警记录到数据库
        saveAlertToDatabase(alertInfo);
        
        // 发送报警邮件
        sendAlertEmail(alertInfo);
        
        // TODO: 可以在这里添加以下功能：
        // 1. 发送通知到管理人员
        // 2. 记录到监控日志
        // 3. 更新实时监控状态
    }
    
    /**
     * 处理信息级报警
     */
    private void handleInfoAlert(Map<String, Object> alertInfo) {
        // 信息级报警处理逻辑
        log.info("信息级烟雾报警: {}", alertInfo);
        
        // TODO: 可以在这里添加以下功能：
        // 1. 记录到系统日志
        // 2. 更新监控统计数据
    }
    /**
     * 获取烟雾监控大屏数据（基于设备管理列表）
     * 该接口返回的数据固定为设备管理列表中的设备，确保大屏显示内容的稳定性
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:view')")
    @GetMapping("/smoke/overview")
    public AjaxResult getSmokeOverview(@RequestParam(defaultValue = "1") int hours) {
        try {
            log.info("开始查询烟雾监控大屏数据，基于设备管理列表");

            // 1. 查询所有烟雾报警设备（设备类型为0）
            DormAlarmDevice queryDevice = new DormAlarmDevice();
            queryDevice.setDeviceType(0); // 0为烟雾报警器
            List<DormAlarmDevice> allDevices = dormAlarmDeviceService.selectDormAlarmDeviceList(queryDevice);

            log.info("从设备管理列表查询到 {} 个烟雾报警设备", allDevices.size());

            // 2. 统计数据
            int totalRooms = allDevices.size();
            int normalRooms = 0;
            int alertRooms = 0;
            int offlineRooms = 0;

            // 3. 构建房间详情列表
            List<Map<String, Object>> roomDetails = new ArrayList<>();

            // 定义烟雾浓度阈值
            double alertThreshold = 300.0; // 报警阈值

            for (DormAlarmDevice device : allDevices) {
                Map<String, Object> roomDetail = new HashMap<>();

                // 设备基本信息
                roomDetail.put("device_id", device.getDeviceId());
                roomDetail.put("dorm_id", device.getDormId() != null ? device.getDormId().toString() : "");
                roomDetail.put("deviceName", device.getDeviceName());
                roomDetail.put("location", device.getLocation());

                // 从InfluxDB查询该设备的最新烟雾数据
                Double smokePpm = null;
                Date lastUpdate = null;

                try {
                    if (device.getDormId() != null) {
                        // 查询该宿舍的最新烟雾数据
                        Map<String, Object> latestData = influxDBService.getLatestSmokeData(
                            device.getDormId().toString(), hours);

                        if (latestData != null && !latestData.isEmpty()) {
                            smokePpm = (Double) latestData.get("smokePpm");
                            lastUpdate = (Date) latestData.get("lastUpdate");
                        }
                    }
                } catch (Exception e) {
                    log.warn("查询设备 {} 的烟雾数据失败: {}", device.getDeviceId(), e.getMessage());
                }

                // 如果没有从InfluxDB获取到数据，使用默认值
                if (smokePpm == null) {
                    smokePpm = 0.0;
                }
                if (lastUpdate == null) {
                    lastUpdate = device.getLastOnlineTime();
                }

                roomDetail.put("smokePpm", smokePpm);
                roomDetail.put("lastUpdate", lastUpdate);

                // 根据设备状态和烟雾值判断状态
                String level;
                String statusText;

                if (device.getStatus() == null || device.getStatus() == 0) {
                    // 设备离线
                    level = "info";
                    statusText = "离线";
                    offlineRooms++;
                } else if (smokePpm >= alertThreshold) {
                    // 烟雾报警
                    level = "danger";
                    statusText = "报警";
                    alertRooms++;
                } else {
                    // 正常
                    level = "success";
                    statusText = "正常";
                    normalRooms++;
                }

                roomDetail.put("level", level);
                roomDetail.put("statusText", statusText);

                // 获取宿舍详细信息
                if (device.getDormId() != null) {
                    DormBuilding dormInfo = dormBuildingService.selectDormBuildingByDormId(device.getDormId());

                    if (dormInfo != null) {
                        roomDetail.put("fullName", dormInfo.getFullName() != null ?
                            dormInfo.getFullName() : dormInfo.getBuildingName());
                        roomDetail.put("buildingName", dormInfo.getBuildingName());
                        roomDetail.put("dormManager", dormInfo.getDormManager());
                        roomDetail.put("phone", dormInfo.getPhone());
                        roomDetail.put("maxCapacity", dormInfo.getMaxCapacity());
                        roomDetail.put("currentCount", dormInfo.getCurrentCount());

                        // 智能信息继承机制
                        if ((dormInfo.getDormManager() == null || dormInfo.getDormManager().trim().isEmpty()) &&
                            dormInfo.getParentId() != null && !dormInfo.getParentId().equals(0L)) {
                            DormBuilding parentDorm = findParentWithManager(dormInfo.getParentId());
                            if (parentDorm != null) {
                                roomDetail.put("dormManager", parentDorm.getDormManager());
                                roomDetail.put("phone", parentDorm.getPhone());
                            }
                        }
                    } else {
                        roomDetail.put("fullName", device.getDormFullName() != null ?
                            device.getDormFullName() : "宿舍 " + device.getDormId());
                    }
                } else {
                    roomDetail.put("fullName", device.getDeviceName());
                }

                roomDetails.add(roomDetail);
            }

            // 4. 组装返回数据
            Map<String, Object> overview = new HashMap<>();
            overview.put("totalRooms", totalRooms);
            overview.put("normalRooms", normalRooms);
            overview.put("alertRooms", alertRooms);
            overview.put("offlineRooms", offlineRooms);
            overview.put("roomDetails", roomDetails);
            overview.put("alertThreshold", alertThreshold);
            overview.put("lastUpdate", new Date());

            log.info("烟雾监控大屏数据查询成功: 总设备={}, 正常={}, 报警={}, 离线={}",
                totalRooms, normalRooms, alertRooms, offlineRooms);

            return success(overview);
        } catch (Exception e) {
            log.error("获取烟雾监控大屏数据失败: {}", e.getMessage(), e);
            return error("获取烟雾数据概览失败: " + e.getMessage());
        }
    }
    
    /**
     * 递归查找有宿管信息的父级宿舍
     */
    private DormBuilding findParentWithManager(Long parentId) {
        if (parentId == null || parentId.equals(0L)) {
            return null;
        }
        
        DormBuilding parentDorm = dormBuildingService.selectDormBuildingByDormId(parentId);
        if (parentDorm != null) {
            // 如果当前父级有宿管信息，直接返回
            if (parentDorm.getDormManager() != null && !parentDorm.getDormManager().trim().isEmpty()) {
                return parentDorm;
            }
            // 否则继续向上查找
            return findParentWithManager(parentDorm.getParentId());
        }
        
        return null;
    }
    
    /**
     * 批量写入数据
     */
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:edit')")
    @PostMapping("/batch")
    public AjaxResult writeBatch(@RequestBody List<Map<String, Object>> dataList) {
        try {
            List<InfluxDBService.DataPoint> dataPoints = dataList.stream()
                .map(data -> {
                    String measurement = (String) data.get("measurement");
                    @SuppressWarnings("unchecked")
                    Map<String, String> tags = (Map<String, String>) data.get("tags");
                    @SuppressWarnings("unchecked")
                    Map<String, Object> fields = (Map<String, Object>) data.get("fields");
                    Instant time = data.containsKey("time") 
                        ? Instant.parse((String) data.get("time")) 
                        : Instant.now();
                    
                    return new InfluxDBService.DataPoint(measurement, tags, fields, time);
                })
                .collect(java.util.stream.Collectors.toList());
            
            influxDBService.writeBatch(dataPoints);
            return success("批量数据写入成功，共" + dataPoints.size() + "条记录");
        } catch (Exception e) {
            return error("批量数据写入失败: " + e.getMessage());
        }
    }
    
    /**
     * 保存报警信息到数据库
     */
    private void saveAlertToDatabase(Map<String, Object> alertInfo) {
        try {
            // 提取报警信息
            String dormIdStr = (String) alertInfo.get("dormId");
            Double smokeValue = (Double) alertInfo.get("smokeValue");
            String alertLevel = (String) alertInfo.get("alertLevel");
            
            // 解析message中的device_id
            Long deviceId = null;
            Object messageObj = alertInfo.get("message");
            if (messageObj != null) {
                try {
                    // 如果message是字符串，尝试解析为JSON
                    String messageStr = messageObj.toString();
                    ObjectMapper objectMapper = new ObjectMapper();
                    @SuppressWarnings("unchecked")
                    Map<String, Object> messageMap = objectMapper.readValue(messageStr, Map.class);
                    
                    Object deviceIdObj = messageMap.get("device_id");
                    if (deviceIdObj != null) {
                        deviceId = Long.valueOf(deviceIdObj.toString());
                    }
                } catch (Exception e) {
                    log.warn("无法从消息中解析device_id: {}", e.getMessage());
                    // 如果JSON解析失败，尝试简单的字符串匹配
                    String message = messageObj.toString();
                    if (message.contains("device_id")) {
                        try {
                            String[] lines = message.split("\n");
                            for (String line : lines) {
                                if (line.contains("device_id")) {
                                    String deviceIdStr = line.substring(line.indexOf('"') + 1);
                                    deviceIdStr = deviceIdStr.substring(0, deviceIdStr.indexOf('"'));
                                    deviceId = Long.valueOf(deviceIdStr);
                                    break;
                                }
                            }
                        } catch (Exception ex) {
                            log.warn("字符串匹配解析device_id失败: {}", ex.getMessage());
                        }
                    }
                }
            }
            
            // 创建报警记录对象
            DormAlarmLog alarmLog = new DormAlarmLog();
            
            // 设置宿舍ID
            if (dormIdStr != null && !"UNKNOWN".equals(dormIdStr)) {
                try {
                    alarmLog.setDormId(Long.valueOf(dormIdStr));
                } catch (NumberFormatException e) {
                    log.warn("无效的宿舍ID: {}", dormIdStr);
                }
            }
            
            // 设置设备ID（如果无法获取则设为null）
            alarmLog.setDeviceId(deviceId);
            
            // 设置烟雾值
            alarmLog.setSmokeValue(smokeValue);
            
            // 设置报警等级（1=一般，2=严重）
            if ("CRIT".equalsIgnoreCase(alertLevel) || "CRITICAL".equalsIgnoreCase(alertLevel)) {
                alarmLog.setAlarmLevel(2); // 严重
            } else {
                alarmLog.setAlarmLevel(1); // 一般
            }
            
            // 设置报警时间
            alarmLog.setAlarmTime(new Date());
            
            // 设置为未处理
            alarmLog.setHandled(0);
            
            // 设置备注
            alarmLog.setRemarks("系统自动检测到的烟雾报警");
            
            // 保存到数据库
            int result = dormAlarmLogService.insertDormAlarmLog(alarmLog);
            
            if (result > 0) {
                log.info("报警记录保存成功: 宿舍{}, 烟雾值{}ppm, 设备ID: {}", 
                        dormIdStr, smokeValue, deviceId);
            } else {
                log.error("报警记录保存失败: 宿舍{}, 烟雾值{}ppm", 
                        dormIdStr, smokeValue);
            }
            
        } catch (Exception e) {
            log.error("保存报警记录到数据库失败: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 发送报警邮件
     */
    private void sendAlertEmail(Map<String, Object> alertInfo) {
        try {
            // 目标邮箱地址
            String targetEmail = "872384208@qq.com";
            
            // 发送报警邮件
            mailService.sendAlertMail(targetEmail, alertInfo);
            
            log.info("报警邮件发送成功: 宿舍{}, 烟雾值{}ppm -> {}", 
                    alertInfo.get("dormId"), alertInfo.get("smokeValue"), targetEmail);
                    
        } catch (Exception e) {
            log.error("发送报警邮件失败: {}", e.getMessage(), e);
            // 邮件发送失败不影响主流程，只记录错误日志
        }
    }
}