package com.dorm.web.controller.test;

import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 * 烟雾报警测试控制器
 * 用于测试InfluxDB烟雾报警接口
 * 
 * @author dorm
 * @since 2025-09-02
 */
@RestController
@RequestMapping("/test/smoke")
public class SmokeAlertTestController extends BaseController {

    @Autowired
    private RestTemplate restTemplate;

    /**
     * 测试严重报警
     */
    @PostMapping("/test-critical")
    public AjaxResult testCriticalAlert(@RequestParam(defaultValue = "262") String dormId,
                                       @RequestParam(defaultValue = "250.5") Double smokeValue) {
        Map<String, Object> alertData = new HashMap<>();
        alertData.put("_level", "crit");
        alertData.put("_status", "ALERT");
        alertData.put("_message", "烟雾传感器触发严重报警");
        alertData.put("_value", smokeValue);
        alertData.put("dorm_id", dormId);
        alertData.put("smokePpm", smokeValue);
        alertData.put("quality", true);
        alertData.put("timestamp", System.currentTimeMillis());

        return sendTestAlert(alertData, "严重报警");
    }

    /**
     * 测试警告报警
     */
    @PostMapping("/test-warning")
    public AjaxResult testWarningAlert(@RequestParam(defaultValue = "263") String dormId,
                                      @RequestParam(defaultValue = "150.5") Double smokeValue) {
        Map<String, Object> alertData = new HashMap<>();
        alertData.put("_level", "warn");
        alertData.put("_status", "ALERT");
        alertData.put("_message", "烟雾传感器触发警告");
        alertData.put("_value", smokeValue);
        alertData.put("dorm_id", dormId);
        alertData.put("smokePpm", smokeValue);
        alertData.put("quality", true);
        alertData.put("timestamp", System.currentTimeMillis());

        return sendTestAlert(alertData, "警告报警");
    }

    /**
     * 测试信息级报警
     */
    @PostMapping("/test-info")
    public AjaxResult testInfoAlert(@RequestParam(defaultValue = "264") String dormId,
                                   @RequestParam(defaultValue = "80.5") Double smokeValue) {
        Map<String, Object> alertData = new HashMap<>();
        alertData.put("_level", "info");
        alertData.put("_status", "OK");
        alertData.put("_message", "烟雾传感器正常检测");
        alertData.put("_value", smokeValue);
        alertData.put("dorm_id", dormId);
        alertData.put("smokePpm", smokeValue);
        alertData.put("quality", true);
        alertData.put("timestamp", System.currentTimeMillis());

        return sendTestAlert(alertData, "信息级报警");
    }

    /**
     * 测试自定义报警数据格式
     */
    @PostMapping("/test-custom")
    public AjaxResult testCustomAlert(@RequestBody Map<String, Object> customData) {
        return sendTestAlert(customData, "自定义格式报警");
    }

    /**
     * 批量测试不同宿舍的报警
     */
    @PostMapping("/test-batch")
    public AjaxResult testBatchAlert() {
        String[] dormIds = {"261", "262", "263", "264", "265"};
        String[] levels = {"info", "warn", "crit", "warn", "info"};
        Double[] values = {85.0, 150.0, 280.0, 120.0, 75.0};

        Map<String, Object> results = new HashMap<>();
        
        for (int i = 0; i < dormIds.length; i++) {
            Map<String, Object> alertData = new HashMap<>();
            alertData.put("_level", levels[i]);
            alertData.put("_status", "ALERT");
            alertData.put("_message", "批量测试报警 - " + dormIds[i]);
            alertData.put("_value", values[i]);
            alertData.put("dorm_id", dormIds[i]);
            alertData.put("smokePpm", values[i]);
            alertData.put("quality", true);
            alertData.put("timestamp", System.currentTimeMillis());

            try {
                AjaxResult result = sendTestAlert(alertData, "批量测试-" + dormIds[i]);
                results.put("dorm_" + dormIds[i], result);
                
                // 间隔500ms发送，避免过快
                Thread.sleep(500);
            } catch (Exception e) {
                results.put("dorm_" + dormIds[i], error("发送失败: " + e.getMessage()));
            }
        }

        return success(results);
    }

    /**
     * 发送测试报警数据
     */
    private AjaxResult sendTestAlert(Map<String, Object> alertData, String testType) {
        try {
            // 设置请求头
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 创建请求实体
            HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(alertData, headers);

            // 发送POST请求到报警接口
            String url = "http://localhost:8080/monitor/influxdb/smoke/alert";
            ResponseEntity<Map> response = restTemplate.postForEntity(url, requestEntity, Map.class);

            // 构建返回结果
            Map<String, Object> result = new HashMap<>();
            result.put("testType", testType);
            result.put("alertData", alertData);
            result.put("response", response.getBody());
            result.put("httpStatus", response.getStatusCode());

            return success(result);
        } catch (Exception e) {
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("testType", testType);
            errorResult.put("alertData", alertData);
            errorResult.put("error", e.getMessage());
            
            return error("测试发送失败: " + e.getMessage()).put("data", errorResult);
        }
    }

    /**
     * 获取测试帮助信息
     */
    @GetMapping("/help")
    public AjaxResult getTestHelp() {
        Map<String, Object> help = new HashMap<>();
        
        help.put("description", "烟雾报警接口测试工具");
        help.put("endpoints", Map.of(
            "POST /test/smoke/test-critical", "测试严重报警（参数：dormId, smokeValue）",
            "POST /test/smoke/test-warning", "测试警告报警（参数：dormId, smokeValue）",
            "POST /test/smoke/test-info", "测试信息级报警（参数：dormId, smokeValue）",
            "POST /test/smoke/test-custom", "测试自定义格式报警（请求体：JSON）",
            "POST /test/smoke/test-batch", "批量测试多个宿舍报警",
            "GET /test/smoke/help", "获取测试帮助信息"
        ));
        
        help.put("examples", Map.of(
            "严重报警", "POST /test/smoke/test-critical?dormId=262&smokeValue=250.5",
            "警告报警", "POST /test/smoke/test-warning?dormId=263&smokeValue=150.5",
            "信息报警", "POST /test/smoke/test-info?dormId=264&smokeValue=80.5"
        ));

        help.put("customFormat", Map.of(
            "url", "POST /test/smoke/test-custom",
            "body", Map.of(
                "_level", "crit",
                "dorm_id", "262",
                "smokePpm", 250.5,
                "_message", "自定义测试报警"
            )
        ));

        return success(help);
    }
}