package com.dorm.web.controller.monitor;

import com.dorm.common.annotation.Anonymous;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.core.domain.entity.DormBuilding;
import com.dorm.framework.web.service.InfluxDBService;
import com.dorm.manage.service.IDormBuildingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * InfluxDB监控控制器
 * 
 * @author dorm
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
        
        // TODO: 可以在这里添加以下功能：
        // 1. 发送短信/邮件通知
        // 2. 推送到管理员手机APP
        // 3. 记录到报警日志表
        // 4. 触发自动应急流程
        
        // 示例：记录报警到数据库
        // saveAlertToDatabase(alertInfo, "CRITICAL");
        
        // 示例：发送通知
        // sendEmergencyNotification(alertInfo);
    }
    
    /**
     * 处理警告级报警
     */
    private void handleWarningAlert(Map<String, Object> alertInfo) {
        // 警告级报警处理逻辑
        log.warn("警告级烟雾报警: {}", alertInfo);
        
        // TODO: 可以在这里添加以下功能：
        // 1. 发送通知到管理人员
        // 2. 记录到监控日志
        // 3. 更新实时监控状态
        
        // 示例：记录报警到数据库
        // saveAlertToDatabase(alertInfo, "WARNING");
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
    @PreAuthorize("@ss.hasPermi('monitor:influxdb:view')")
    @GetMapping("/smoke/overview")
    public AjaxResult getSmokeOverview(@RequestParam(defaultValue = "1") int hours) {
        try {
            // 获取烟雾数据概览
            Map<String, Object> overview = influxDBService.getSmokeDataOverview(hours);
            
            // 获取房间详情并添加宿舍信息
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> roomDetails = (List<Map<String, Object>>) overview.get("roomDetails");
            
            if (roomDetails != null && !roomDetails.isEmpty()) {
                // 为每个房间添加宿舍信息
                for (Map<String, Object> roomDetail : roomDetails) {
                    String dormIdStr = (String) roomDetail.get("dorm_id");
                    if (dormIdStr != null) {
                        try {
                            Long dormId = Long.valueOf(dormIdStr);
                            DormBuilding dormInfo = dormBuildingService.selectDormBuildingByDormId(dormId);
                            
                            if (dormInfo != null) {
                                // 添加宿舍详细信息
                                roomDetail.put("fullName", dormInfo.getFullName() != null ? dormInfo.getFullName() : dormInfo.getBuildingName());
                                roomDetail.put("buildingName", dormInfo.getBuildingName());
                                roomDetail.put("dormManager", dormInfo.getDormManager());
                                roomDetail.put("phone", dormInfo.getPhone());
                                roomDetail.put("maxCapacity", dormInfo.getMaxCapacity());
                                roomDetail.put("currentCount", dormInfo.getCurrentCount());
                                
                                // 实现智能信息继承机制，当房间级没有宿管信息时，自动继承上级楼栋的宿管信息
                                if ((dormInfo.getDormManager() == null || dormInfo.getDormManager().trim().isEmpty()) &&
                                    dormInfo.getParentId() != null && !dormInfo.getParentId().equals(0L)) {
                                    
                                    // 递归查找父级宿管信息
                                    DormBuilding parentDorm = findParentWithManager(dormInfo.getParentId());
                                    if (parentDorm != null) {
                                        roomDetail.put("dormManager", parentDorm.getDormManager());
                                        roomDetail.put("phone", parentDorm.getPhone());
                                    }
                                }
                            } else {
                                // 如果找不到宿舍信息，设置默认值
                                roomDetail.put("fullName", "宿舍 " + dormIdStr);
                                roomDetail.put("buildingName", dormIdStr);
                            }
                        } catch (NumberFormatException e) {
                            // 如果 dormId 不是数字，设置默认值
                            roomDetail.put("fullName", "宿舍 " + dormIdStr);
                            roomDetail.put("buildingName", dormIdStr);
                        }
                    }
                }
            }
            
            return success(overview);
        } catch (Exception e) {
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
}