package com.dorm.framework.web.service;

import com.dorm.framework.config.InfluxDBConfig;
import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.QueryApi;
import com.influxdb.client.WriteApiBlocking;
import com.influxdb.client.domain.WritePrecision;
import com.influxdb.client.write.Point;
import com.influxdb.query.FluxTable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;

/**
 * InfluxDB 时序数据库服务类
 * 用于处理宿舍管理系统的时序数据，如设备监控、用户行为分析等
 * 
 * @author dorm
 * @since 2025-09-01
 */
@Service
public class InfluxDBService {
    
    private static final Logger log = LoggerFactory.getLogger(InfluxDBService.class);
    
    @Autowired
    private InfluxDBConfig influxDBConfig;
    
    private InfluxDBClient client;
    private volatile boolean connected = false;
    
    /**
     * 初始化InfluxDB连接
     */
    @PostConstruct
    public void init() {
        if (!influxDBConfig.isEnabled()) {
            log.info("InfluxDB服务未启用，跳过初始化");
            return;
        }
        
        try {
            // 验证配置
            if (!influxDBConfig.isValid()) {
                log.error("InfluxDB配置无效，跳过初始化");
                return;
            }
            
            log.info("正在初始化InfluxDB连接...");
            log.info("InfluxDB URL: {}", influxDBConfig.getUrl());
            log.info("Organization: {}", influxDBConfig.getOrg());
            log.info("Bucket: {}", influxDBConfig.getBucket());
            
            // 创建InfluxDB客户端
            client = InfluxDBClientFactory.create(
                influxDBConfig.getUrl(), 
                influxDBConfig.getToken().toCharArray(), 
                influxDBConfig.getOrg(), 
                influxDBConfig.getBucket()
            );
            
            // 测试连接
            client.health();
            connected = true;
            
            log.info("InfluxDB客户端已初始化成功: {}", influxDBConfig.getUrl());
        } catch (Exception e) {
            log.error("InfluxDB服务初始化失败: {}", e.getMessage(), e);
            connected = false;
            client = null;
        }
    }
    
    
    /**
     * 通用写入数据点方法
     * 
     * @param measurement 测量名称
     * @param tags 标签
     * @param fields 字段
     * @param time 时间戳
     */
    public void writePoint(String measurement, Map<String, String> tags, Map<String, Object> fields, Instant time) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，写入失败");
            return;
        }
        
        try {
            Point point = Point.measurement(measurement)
                    .addTags(tags)
                    .addFields(fields)
                    .time(time, WritePrecision.MS);
            
            WriteApiBlocking writeApi = client.getWriteApiBlocking();
            writeApi.writePoint(point);
            
            log.debug("写入InfluxDB成功: measurement={}, tags={}, fields={}", measurement, tags, fields);
        } catch (Exception e) {
            log.error("写入InfluxDB失败", e);
        }
    }
    
    /**
     * 专门写烟雾传感器数据
     * 
     * @param dormId 宿舍ID
     * @param smokePpm 烟雾浓度
     * @param quality 质量状态
     * @param timestamp 时间戳
     */
    public void writeSmokeData(String dormId, double smokePpm, boolean quality, long timestamp) {
        Map<String, String> tags = Map.of("dorm_id", dormId);
        Map<String, Object> fields = Map.of("smokePpm", smokePpm, "quality", quality);
        
        writePoint("smoke", tags, fields, Instant.ofEpochMilli(timestamp));
    }
    
    
    /**
     * 写入设备监控数据
     * 
     * @param deviceId 设备ID
     * @param deviceType 设备类型
     * @param dormId 宿舍ID
     * @param measurement 测量值
     * @param value 数值
     * @param unit 单位
     */
    public void writeDeviceData(String deviceId, String deviceType, String dormId, 
                               String measurement, Double value, String unit) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，设备数据写入失败");
            return;
        }
        
        try {
            Map<String, String> tags = new HashMap<>();
            tags.put("device_id", deviceId);
            tags.put("device_type", deviceType);
            tags.put("dorm_id", dormId);
            
            Map<String, Object> fields = new HashMap<>();
            fields.put("value", value);
            fields.put("unit", unit);
            
            writePoint("device_data", tags, fields, Instant.now());
            
            log.debug("设备数据写入成功: deviceId={}, measurement={}, value={}", 
                     deviceId, measurement, value);
        } catch (Exception e) {
            log.error("写入设备数据失败: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 写入用户行为数据
     * 
     * @param userId 用户ID
     * @param action 行为动作
     * @param module 模块名称
     * @param details 详细信息
     */
    public void writeUserBehavior(Long userId, String action, String module, String details) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，用户行为数据写入失败");
            return;
        }
        
        try {
            Map<String, String> tags = new HashMap<>();
            tags.put("user_id", String.valueOf(userId));
            tags.put("action", action);
            tags.put("module", module);
            
            Map<String, Object> fields = new HashMap<>();
            fields.put("details", details);
            fields.put("count", 1);
            
            writePoint("user_behavior", tags, fields, Instant.now());
            
            log.debug("用户行为数据写入成功: userId={}, action={}, module={}", 
                     userId, action, module);
        } catch (Exception e) {
            log.error("写入用户行为数据失败: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 写入系统监控数据
     * 
     * @param metricName 指标名称
     * @param value 指标值
     * @param host 主机名
     */
    public void writeSystemMetrics(String metricName, Double value, String host) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，系统监控数据写入失败");
            return;
        }
        
        try {
            Map<String, String> tags = new HashMap<>();
            tags.put("host", host);
            tags.put("metric", metricName);
            
            Map<String, Object> fields = new HashMap<>();
            fields.put("value", value);
            
            writePoint("system_metrics", tags, fields, Instant.now());
            
            log.debug("系统监控数据写入成功: metric={}, value={}, host={}", 
                     metricName, value, host);
        } catch (Exception e) {
            log.error("写入系统监控数据失败: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 写入报修统计数据
     * 
     * @param repairType 报修类型
     * @param status 状态
     * @param buildingId 楼栋ID
     * @param count 数量
     */
    public void writeRepairStats(String repairType, String status, String buildingId, Integer count) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，报修统计数据写入失败");
            return;
        }
        
        try {
            Map<String, String> tags = new HashMap<>();
            tags.put("repair_type", repairType);
            tags.put("status", status);
            tags.put("building_id", buildingId);
            
            Map<String, Object> fields = new HashMap<>();
            fields.put("count", count);
            
            writePoint("repair_stats", tags, fields, Instant.now());
            
            log.debug("报修统计数据写入成功: type={}, status={}, building={}, count={}", 
                     repairType, status, buildingId, count);
        } catch (Exception e) {
            log.error("写入报修统计数据失败: {}", e.getMessage(), e);
        }
    }
    
    
    /**
     * 查询设备数据
     * 
     * @param deviceId 设备ID
     * @param start 开始时间
     * @param end 结束时间
     * @return 查询结果
     */
    public List<Map<String, Object>> queryDeviceData(String deviceId, Instant start, Instant end) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，设备数据查询失败");
            return Collections.emptyList();
        }
        
        try {
            String query = String.format(
                "from(bucket: \"%s\") " +
                "|> range(start: %s, stop: %s) " +
                "|> filter(fn: (r) => r._measurement == \"device_data\") " +
                "|> filter(fn: (r) => r.device_id == \"%s\")",
                influxDBConfig.getBucket(), start, end, deviceId
            );
            
            log.debug("执行设备数据查询: {}", query);
            
            QueryApi queryApi = client.getQueryApi();
            List<FluxTable> tables = queryApi.query(query, influxDBConfig.getOrg());
            
            List<Map<String, Object>> results = new ArrayList<>();
            tables.forEach(table -> {
                table.getRecords().forEach(record -> {
                    Map<String, Object> result = new HashMap<>();
                    result.put("time", record.getTime());
                    result.put("device_id", record.getValueByKey("device_id"));
                    result.put("value", record.getValue());
                    result.put("unit", record.getValueByKey("unit"));
                    results.add(result);
                });
            });
            
            return results;
        } catch (Exception e) {
            log.error("查询设备数据失败: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }
    
    /**
     * 查询用户行为统计
     * 
     * @param userId 用户ID
     * @param timeRange 时间范围（小时）
     * @return 统计结果
     */
    public Map<String, Long> queryUserBehaviorStats(Long userId, int timeRange) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，用户行为统计查询失败");
            return Collections.emptyMap();
        }
        
        try {
            Instant start = Instant.now().minus(timeRange, ChronoUnit.HOURS);
            Instant end = Instant.now();
            
            String query = String.format(
                "from(bucket: \"%s\") " +
                "|> range(start: %s, stop: %s) " +
                "|> filter(fn: (r) => r._measurement == \"user_behavior\") " +
                "|> filter(fn: (r) => r.user_id == \"%s\") " +
                "|> group(columns: [\"action\"]) " +
                "|> count()",
                influxDBConfig.getBucket(), start, end, userId
            );
            
            log.debug("执行用户行为统计查询: {}", query);
            
            QueryApi queryApi = client.getQueryApi();
            List<FluxTable> tables = queryApi.query(query, influxDBConfig.getOrg());
            
            Map<String, Long> stats = new HashMap<>();
            tables.forEach(table -> {
                table.getRecords().forEach(record -> {
                    String action = (String) record.getValueByKey("action");
                    Long count = (Long) record.getValue();
                    stats.put(action, count);
                });
            });
            
            return stats;
        } catch (Exception e) {
            log.error("查询用户行为统计失败: {}", e.getMessage(), e);
            return Collections.emptyMap();
        }
    }
    
    
    /**
     * 检查连接状态
     * 
     * @return 是否已连接
     */
    public boolean isConnected() {
        return influxDBConfig.isEnabled() && connected && client != null;
    }
    
    /**
     * 健康检查
     * 
     * @return 健康状态
     */
    public Map<String, Object> healthCheck() {
        Map<String, Object> health = new HashMap<>();
        health.put("enabled", influxDBConfig.isEnabled());
        health.put("connected", connected);
        health.put("url", influxDBConfig.getUrl());
        health.put("organization", influxDBConfig.getOrg());
        health.put("bucket", influxDBConfig.getBucket());
        health.put("timestamp", Instant.now());
        
        if (isConnected()) {
            health.put("status", "UP");
            try {
                // 测试InfluxDB连接
                client.health();
                health.put("ping", "SUCCESS");
            } catch (Exception e) {
                health.put("ping", "FAILED: " + e.getMessage());
                health.put("status", "DOWN");
            }
        } else {
            health.put("status", "DOWN");
            health.put("ping", "NOT_CONNECTED");
        }
        
        return health;
    }
        
    /**
     * 获取烟雾传感器数据概览（为首页大屏提供）
     * 
     * @param hours 时间范围（小时）
     * @return 烟雾数据概览
     */
    public Map<String, Object> getSmokeDataOverview(int hours) {
        Map<String, Object> overview = new HashMap<>();
            
        if (!isConnected()) {
            log.warn("InfluxDB未连接，烟雾数据概览查询失败");
            overview.put("totalRooms", 0);
            overview.put("normalRooms", 0);
            overview.put("warningRooms", 0);
            overview.put("alertRooms", 0);
            overview.put("offlineRooms", 0);
            overview.put("roomDetails", new ArrayList<>());
            return overview;
        }
            
        try {
            Instant end = Instant.now();
            Instant start = end.minus(hours, ChronoUnit.HOURS);
                
            // 查询最新的烟雾数据
            String query = String.format(
                "from(bucket: \"%s\") " +
                "|> range(start: %s, stop: %s) " +
                "|> filter(fn: (r) => r._measurement == \"smoke\") " +
                "|> filter(fn: (r) => r._field == \"smokePpm\") " +
                "|> group(columns: [\"dorm_id\"]) " +
                "|> last()",
                influxDBConfig.getBucket(), start, end
            );
                
            log.debug("执行烟雾数据概览查询: {}", query);
                
            QueryApi queryApi = client.getQueryApi();
            List<FluxTable> tables = queryApi.query(query, influxDBConfig.getOrg());
                
            List<Map<String, Object>> roomDetails = new ArrayList<>();
            int normalRooms = 0;
            int warningRooms = 0;
            int alertRooms = 0;
            int offlineRooms = 0;
                
            // 定义烟雾浓度阈值
            double warningThreshold = 100.0;  // 警告阈值
            double alertThreshold = 200.0;    // 报警阈值
            long offlineThreshold = 30 * 60 * 1000; // 30分钟未更新则认为离线
                
            Set<String> activeRooms = new HashSet<>();
                
            for (FluxTable table : tables) {
                for (com.influxdb.query.FluxRecord record : table.getRecords()) {
                    String dormId = (String) record.getValueByKey("dorm_id");
                    Object value = record.getValue();
                    long timestamp = record.getTime().toEpochMilli();
                        
                    if (dormId != null && value instanceof Number) {
                        activeRooms.add(dormId);
                        double smokePpm = ((Number) value).doubleValue();
                            
                        Map<String, Object> roomDetail = new HashMap<>();
                        roomDetail.put("dorm_id", dormId);
                        roomDetail.put("smokePpm", smokePpm);
                        roomDetail.put("timestamp", timestamp);
                        roomDetail.put("lastUpdate", new Date(timestamp));
                            
                        // 判断宿舍状态
                        long timeDiff = System.currentTimeMillis() - timestamp;
                        if (timeDiff > offlineThreshold) {
                            roomDetail.put("status", "offline");
                            roomDetail.put("statusText", "离线");
                            roomDetail.put("level", "info");
                            offlineRooms++;
                        } else if (smokePpm >= alertThreshold) {
                            roomDetail.put("status", "alert");
                            roomDetail.put("statusText", "严重警报");
                            roomDetail.put("level", "danger");
                            alertRooms++;
                        } else if (smokePpm >= warningThreshold) {
                            roomDetail.put("status", "warning");
                            roomDetail.put("statusText", "警告");
                            roomDetail.put("level", "warning");
                            warningRooms++;
                        } else {
                            roomDetail.put("status", "normal");
                            roomDetail.put("statusText", "正常");
                            roomDetail.put("level", "success");
                            normalRooms++;
                        }
                            
                        roomDetails.add(roomDetail);
                    }
                }
            }
                
            // 按烟雾浓度降序排列，报警房间排在前面
            roomDetails.sort((a, b) -> {
                String statusA = (String) a.get("status");
                String statusB = (String) b.get("status");
                    
                // 先按状态排序：alert > warning > offline > normal
                int priorityA = getPriority(statusA);
                int priorityB = getPriority(statusB);
                    
                if (priorityA != priorityB) {
                    return Integer.compare(priorityB, priorityA); // 高优先级在前
                }
                    
                // 相同状态按烟雾浓度排序
                Double smokeA = (Double) a.get("smokePpm");
                Double smokeB = (Double) b.get("smokePpm");
                return Double.compare(smokeB, smokeA); // 浓度高的在前
            });
                
            // 组装返回数据
            overview.put("totalRooms", activeRooms.size());
            overview.put("normalRooms", normalRooms);
            overview.put("warningRooms", warningRooms);
            overview.put("alertRooms", alertRooms);
            overview.put("offlineRooms", offlineRooms);
            overview.put("roomDetails", roomDetails);
            overview.put("warningThreshold", warningThreshold);
            overview.put("alertThreshold", alertThreshold);
            overview.put("lastUpdate", new Date());
                
            log.info("烟雾数据概览查询成功: 总宿舍={}, 正常={}, 警告={}, 报警={}, 离线={}", 
                     activeRooms.size(), normalRooms, warningRooms, alertRooms, offlineRooms);
                
            return overview;
                
        } catch (Exception e) {
            log.error("获取烟雾数据概览失败: {}", e.getMessage(), e);
                
            // 返回错误时的默认数据
            overview.put("totalRooms", 0);
            overview.put("normalRooms", 0);
            overview.put("warningRooms", 0);
            overview.put("alertRooms", 0);
            overview.put("offlineRooms", 0);
            overview.put("roomDetails", new ArrayList<>());
            overview.put("error", e.getMessage());
                
            return overview;
        }
    }
        
    /**
     * 获取状态优先级
     */
    private int getPriority(String status) {
        switch (status) {
            case "alert": return 4;
            case "warning": return 3;
            case "offline": return 2;
            case "normal": return 1;
            default: return 0;
        }
    }
    
    /**
     * 批量写入数据
     * 
     * @param dataPoints 数据点列表
     */
    public void writeBatch(List<DataPoint> dataPoints) {
        if (!isConnected()) {
            log.warn("InfluxDB未连接，批量数据写入失败");
            return;
        }
        
        if (dataPoints == null || dataPoints.isEmpty()) {
            log.warn("批量写入数据为空");
            return;
        }
        
        try {
            WriteApiBlocking writeApi = client.getWriteApiBlocking();
            List<Point> points = new ArrayList<>();
            
            for (DataPoint point : dataPoints) {
                Point influxPoint = Point.measurement(point.getMeasurement())
                        .addTags(point.getTags())
                        .addFields(point.getFields())
                        .time(point.getTime(), WritePrecision.MS);
                points.add(influxPoint);
            }
            
            writeApi.writePoints(points);
            log.debug("批量写入数据成功，共{}条记录", dataPoints.size());
        } catch (Exception e) {
            log.error("批量写入数据失败: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 关闭连接
     */
    @PreDestroy
    public void close() {
        if (client != null) {
            try {
                client.close();
                connected = false;
                log.info("InfluxDB客户端已关闭");
            } catch (Exception e) {
                log.error("关闭InfluxDB连接失败: {}", e.getMessage(), e);
            }
        }
    }
    
    /**
     * 数据点内部类
     */
    public static class DataPoint {
        private String measurement;
        private Map<String, String> tags;
        private Map<String, Object> fields;
        private Instant time;
        
        public DataPoint(String measurement, Map<String, String> tags, 
                        Map<String, Object> fields, Instant time) {
            this.measurement = measurement;
            this.tags = tags != null ? tags : new HashMap<>();
            this.fields = fields != null ? fields : new HashMap<>();
            this.time = time != null ? time : Instant.now();
        }
        
        // Getters
        public String getMeasurement() { return measurement; }
        public Map<String, String> getTags() { return tags; }
        public Map<String, Object> getFields() { return fields; }
        public Instant getTime() { return time; }
        
        // Setters
        public void setMeasurement(String measurement) { this.measurement = measurement; }
        public void setTags(Map<String, String> tags) { this.tags = tags; }
        public void setFields(Map<String, Object> fields) { this.fields = fields; }
        public void setTime(Instant time) { this.time = time; }
    }
}