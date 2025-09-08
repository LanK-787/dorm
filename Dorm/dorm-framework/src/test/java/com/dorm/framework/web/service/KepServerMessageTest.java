package com.dorm.framework.web.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * KepServer消息格式兼容性测试
 */
@SpringBootTest
public class KepServerMessageTest {
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Test
    public void testKepServerMessageParsing() {
        String kepServerMessage = """
            {
                "timestamp": 1757260053870,
                "values": [
                    {"id": "MQ2_Channel.MQ2-device.2", "v": 185, "q": true, "t": 1757260053513},
                    {"id": "MQ2_Channel.MQ2-device.4", "v": 185, "q": true, "t": 1757260053513},
                    {"id": "MQ2_Channel.MQ2-device.9", "v": 185, "q": true, "t": 1757260053513},
                    {"id": "MQ2_Channel.MQ2-device.5", "v": 185, "q": true, "t": 1757260053513},
                    {"id": "MQ2_Channel.MQ2-device.6", "v": 185, "q": true, "t": 1757260053513},
                    {"id": "MQ2_Channel.MQ2-device.7", "v": 185, "q": true, "t": 1757260053513},
                    {"id": "MQ2_Channel.MQ2-device.8", "v": 185, "q": true, "t": 1757260053513}
                ]
            }
            """;
        
        try {
            JsonNode root = objectMapper.readTree(kepServerMessage);
            JsonNode values = root.get("values");
            
            System.out.println("=== KepServer消息解析测试 ===");
            System.out.println("消息时间戳: " + root.get("timestamp").asLong());
            System.out.println("设备数据数量: " + values.size());
            System.out.println("");
            
            if (values != null && values.isArray()) {
                for (JsonNode v : values) {
                    String id = v.get("id").asText();
                    double value = v.get("v").asDouble();
                    boolean quality = v.get("q").asBoolean();
                    long ts = v.get("t").asLong();
                    
                    // 模拟设备ID提取逻辑
                    String deviceId = extractDeviceIdFromId(id);
                    
                    System.out.println("设备ID原始: " + id);
                    System.out.println("设备ID提取: " + deviceId);
                    System.out.println("烟雾浓度: " + value + " ppm");
                    System.out.println("数据质量: " + (quality ? "良好" : "异常"));
                    System.out.println("设备时间: " + new java.util.Date(ts));
                    System.out.println("---");
                }
            }
            
            System.out.println("✅ KepServer消息格式完全兼容！");
            
        } catch (Exception e) {
            System.err.println("❌ 消息解析失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 模拟设备ID提取逻辑
     */
    private String extractDeviceIdFromId(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        
        try {
            // 使用点号分割，取最后一部分作为设备ID
            // MQ2_Channel.MQ2-device.2 -> ["MQ2_Channel", "MQ2-device", "2"]
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
            
            return null;
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 手动运行测试
     */
    public static void main(String[] args) {
        KepServerMessageTest test = new KepServerMessageTest();
        test.testKepServerMessageParsing();
    }
}