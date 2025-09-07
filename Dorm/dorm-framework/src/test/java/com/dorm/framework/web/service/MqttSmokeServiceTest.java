import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * MqttSmokeService 设备ID提取功能测试
 */
public class MqttSmokeServiceTest {
    
    /**
     * 测试从设备ID中提取设备号的功能
     */
    @Test
    public void testExtractRoomIdFromId() {
        // 使用反射访问私有方法进行测试
        try {
            MqttSmokeService service = new MqttSmokeService(null);
            
            // 使用反射获取私有方法
            java.lang.reflect.Method method = MqttSmokeService.class.getDeclaredMethod("extractDeviceIdFromId", String.class);
            method.setAccessible(true);
            
            // 测试正常情况
            String result1 = (String) method.invoke(service, "MQ2_Channel.MQ2-device.2");
            assertEquals("2", result1, "应该提取到设备号2");
            
            // 测试其他格式
            String result2 = (String) method.invoke(service, "device.sensor.101");
            assertEquals("101", result2, "应该提取到设备号101");
            
            // 测试单个数字
            String result3 = (String) method.invoke(service, "sensor.305");
            assertEquals("305", result3, "应该提取到设备号305");
            
            // 测试异常情况
            String result4 = (String) method.invoke(service, "invalid.format.abc");
            assertNull(result4, "非数字结尾应该返回null");
            
            String result5 = (String) method.invoke(service, null);
            assertNull(result5, "null输入应该返回null");
            
            String result6 = (String) method.invoke(service, "");
            assertNull(result6, "空字符串应该返回null");
            
            System.out.println("✅ 所有设备ID提取测试通过");
            System.out.println("测试结果：");
            System.out.println("  MQ2_Channel.MQ2-device.2 -> " + result1);
            System.out.println("  device.sensor.101 -> " + result2);
            System.out.println("  sensor.305 -> " + result3);
            System.out.println("  invalid.format.abc -> " + result4);
            
        } catch (Exception e) {
            fail("测试失败: " + e.getMessage());
        }
    }
    
    /**
     * 手动运行测试
     */
    public static void main(String[] args) {
        MqttSmokeServiceTest test = new MqttSmokeServiceTest();
        test.testExtractRoomIdFromId();
    }
}