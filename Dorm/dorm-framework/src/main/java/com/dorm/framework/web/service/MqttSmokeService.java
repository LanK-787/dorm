package com.dorm.framework.web.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.HashMap;
import java.util.Map;

/**
 * MQTT烟雾传感器数据订阅服务
 * 订阅MQTT消息并将烟雾传感器数据写入InfluxDB
 * 
 * @author dorm
 * @since 2025-09-01
 */
@Service
public class MqttSmokeService {

    @Value("${mqtt.broker-url}")
    private String brokerUrl;

    @Value("${mqtt.client-id}")
    private String clientId;

    @Value("${mqtt.topic}")
    private String topic;

    @Value("${mqtt.qos}")
    private int qos;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final InfluxDBService influxDBService;
    private MqttClient mqttClient;
    private volatile boolean connected = false;

    public MqttSmokeService(InfluxDBService influxDBService) {
        this.influxDBService = influxDBService;
    }

    @PostConstruct
    public void init() {
        try {
            mqttClient = new MqttClient(brokerUrl, clientId);
            mqttClient.connect();
            connected = true;

            mqttClient.subscribe(topic, qos, (t, msg) -> {
                String payload = new String(msg.getPayload());
                try {
                    JsonNode root = objectMapper.readTree(payload);
                    JsonNode values = root.get("values");

                    if (values != null && values.isArray()) {
                        for (JsonNode v : values) {
                            String id = v.get("id").asText();
                            double value = v.get("v").asDouble();
                            boolean quality = v.get("q").asBoolean();
                            long ts = v.get("t").asLong();

                            // 从 id 字段提取 dorm_id（例如：MQ2_Channel.MQ2-device.262 -> 262）
                            String dormId = extractRoomIdFromId(id);
                            if (dormId != null) {
                                influxDBService.writeSmokeData(dormId, value, quality, ts);
//                                System.out.println("处理烟雾数据: dorm_id=" + dormId + ", value=" + value + ", quality=" + quality);
                            } else {
                                System.out.println("无法从 ID 中提取宿舍号: " + id);
                            }
                        }
                    }
                } catch (Exception e) {
                    System.out.println("处理MQTT消息失败: " + e.getMessage());
                    e.printStackTrace();
                }
            });

            System.out.println("MQTT Subscriber已启动, 订阅: " + topic);
        } catch (MqttException e) {
            e.printStackTrace();
            connected = false;
        }
    }

    /**
     * 从 id 字段中提取宿舍ID
     * 例如：MQ2_Channel.MQ2-device.262 -> 262
     *
     * @param id 设备ID字符串
     * @return 宿舍ID
     */
    private String extractRoomIdFromId(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        
        try {
            // 使用点号分割，取最后一部分作为房间ID
            // MQ2_Channel.MQ2-device.262 -> ["MQ2_Channel", "MQ2-device", "262"]
            String[] parts = id.split("\\.");
            if (parts.length > 0) {
                String lastPart = parts[parts.length - 1];
                // 检查最后一部分是否为数字
                if (lastPart.matches("\\d+")) {
                    return lastPart;
                }
            }
            
            // 如果点号分割无效，尝试使用正则表达式提取数字
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\.(\\d+)$");
            java.util.regex.Matcher matcher = pattern.matcher(id);
            if (matcher.find()) {
                return matcher.group(1);
            }
            
            System.out.println("警告：无法从 ID 中提取数字宿舍号: " + id);
            return null;
        } catch (Exception e) {
            System.out.println("提取宿舍ID失败: " + e.getMessage());
            return null;
        }
    }

    /**
     * 检查连接状态
     *
     * @return 是否已连接
     */
    public boolean isConnected() {
        return connected && mqttClient != null && mqttClient.isConnected();
    }

    /**
     * 手动重连
     */
    public void reconnect() {
        try {
            if (mqttClient != null && !mqttClient.isConnected()) {
                mqttClient.reconnect();
                connected = true;
                System.out.println("MQTT重连成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            connected = false;
        }
    }

    /**
     * 获取连接状态信息
     *
     * @return 状态信息
     */
    public Map<String, Object> getStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("connected", connected);
        status.put("brokerUrl", brokerUrl);
        status.put("clientId", clientId);
        status.put("topic", topic);
        status.put("qos", qos);

        if (mqttClient != null) {
            status.put("clientConnected", mqttClient.isConnected());
        } else {
            status.put("clientConnected", false);
        }

        return status;
    }

    /**
     * 关闭MQTT连接
     */
    @PreDestroy
    public void close() {
        if (mqttClient != null) {
            try {
                if (mqttClient.isConnected()) {
                    mqttClient.disconnect();
                    System.out.println("MQTT连接已断开");
                }
                mqttClient.close();
                System.out.println("MQTT客户端已关闭");
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                connected = false;
            }
        }
    }
}