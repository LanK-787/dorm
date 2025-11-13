package com.dorm.web.controller.test;

import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.framework.rabbitmq.service.MessageService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * RabbitMQ测试控制器
 * 
 * @author 王新瑜
 */
@Api(tags = "RabbitMQ测试接口")
@RestController
@RequestMapping("/test/rabbitmq")
public class RabbitMQTestController extends BaseController {

    @Autowired
    private MessageService messageService;

    /**
     * 测试发送维修工单创建消息
     */
    @ApiOperation("测试发送维修工单创建消息")
    @PostMapping("/repair-order/create")
    public AjaxResult testRepairOrderCreate(
            @ApiParam("工单ID") @RequestParam Long orderId,
            @ApiParam("工单编号") @RequestParam String orderNo,
            @ApiParam("申请人ID") @RequestParam Long applicantId,
            @ApiParam("申请人姓名") @RequestParam String applicantName,
            @ApiParam("宿舍ID") @RequestParam Long dormId,
            @ApiParam("宿舍号") @RequestParam String dormNo,
            @ApiParam("故障描述") @RequestParam String faultDescription,
            @ApiParam("紧急程度") @RequestParam(defaultValue = "2") Integer urgencyLevel) {
        
        try {
            messageService.sendRepairOrderCreateMessage(orderId, orderNo, applicantId, applicantName,
                    dormId, dormNo, faultDescription, urgencyLevel);
            return success("维修工单创建消息发送成功");
        } catch (Exception e) {
            return error("维修工单创建消息发送失败: " + e.getMessage());
        }
    }

    /**
     * 测试发送维修工单分配消息
     */
    @ApiOperation("测试发送维修工单分配消息")
    @PostMapping("/repair-order/assign")
    public AjaxResult testRepairOrderAssign(
            @ApiParam("工单ID") @RequestParam Long orderId,
            @ApiParam("工单编号") @RequestParam String orderNo,
            @ApiParam("维修人员ID") @RequestParam Long repairerId,
            @ApiParam("维修人员姓名") @RequestParam String repairerName) {
        
        try {
            messageService.sendRepairOrderAssignMessage(orderId, orderNo, repairerId, repairerName);
            return success("维修工单分配消息发送成功");
        } catch (Exception e) {
            return error("维修工单分配消息发送失败: " + e.getMessage());
        }
    }

    /**
     * 测试发送维修工单完成消息
     */
    @ApiOperation("测试发送维修工单完成消息")
    @PostMapping("/repair-order/complete")
    public AjaxResult testRepairOrderComplete(
            @ApiParam("工单ID") @RequestParam Long orderId,
            @ApiParam("工单编号") @RequestParam String orderNo,
            @ApiParam("维修人员ID") @RequestParam Long repairerId,
            @ApiParam("维修人员姓名") @RequestParam String repairerName,
            @ApiParam("完成备注") @RequestParam(required = false) String remark) {
        
        try {
            messageService.sendRepairOrderCompleteMessage(orderId, orderNo, repairerId, repairerName, remark);
            return success("维修工单完成消息发送成功");
        } catch (Exception e) {
            return error("维修工单完成消息发送失败: " + e.getMessage());
        }
    }

    /**
     * 测试发送用户注册消息
     */
    @ApiOperation("测试发送用户注册消息")
    @PostMapping("/user/register")
    public AjaxResult testUserRegister(
            @ApiParam("用户ID") @RequestParam Long userId,
            @ApiParam("用户名") @RequestParam String userName,
            @ApiParam("昵称") @RequestParam String nickName,
            @ApiParam("邮箱") @RequestParam String email,
            @ApiParam("手机号") @RequestParam String phoneNumber,
            @ApiParam("用户类型") @RequestParam String userType,
            @ApiParam("注册IP") @RequestParam String registerIp) {
        
        try {
            messageService.sendUserRegisterMessage(userId, userName, nickName, email, phoneNumber, userType, registerIp);
            return success("用户注册消息发送成功");
        } catch (Exception e) {
            return error("用户注册消息发送失败: " + e.getMessage());
        }
    }

    /**
     * 测试发送用户更新消息
     */
    @ApiOperation("测试发送用户更新消息")
    @PostMapping("/user/update")
    public AjaxResult testUserUpdate(
            @ApiParam("用户ID") @RequestParam Long userId,
            @ApiParam("用户名") @RequestParam String userName,
            @ApiParam("昵称") @RequestParam String nickName,
            @ApiParam("邮箱") @RequestParam String email,
            @ApiParam("手机号") @RequestParam String phoneNumber,
            @ApiParam("用户类型") @RequestParam String userType) {
        
        try {
            messageService.sendUserUpdateMessage(userId, userName, nickName, email, phoneNumber, userType);
            return success("用户更新消息发送成功");
        } catch (Exception e) {
            return error("用户更新消息发送失败: " + e.getMessage());
        }
    }

    /**
     * 测试发送系统日志消息
     */
    @ApiOperation("测试发送系统日志消息")
    @PostMapping("/system/log")
    public AjaxResult testSystemLog(
            @ApiParam("操作模块") @RequestParam String module,
            @ApiParam("业务类型") @RequestParam String businessType,
            @ApiParam("操作类型") @RequestParam Integer operType,
            @ApiParam("操作人员") @RequestParam String operName,
            @ApiParam("请求URL") @RequestParam String operUrl,
            @ApiParam("主机地址") @RequestParam String operIp,
            @ApiParam("请求参数") @RequestParam(required = false) String operParam,
            @ApiParam("返回参数") @RequestParam(required = false) String jsonResult,
            @ApiParam("操作状态") @RequestParam(defaultValue = "0") Integer status,
            @ApiParam("错误消息") @RequestParam(required = false) String errorMsg,
            @ApiParam("消耗时间") @RequestParam(defaultValue = "100") Long costTime) {
        
        try {
            messageService.sendSystemLogMessage(module, businessType, operType, operName, operUrl, operIp,
                    operParam, jsonResult, status, errorMsg, costTime);
            return success("系统日志消息发送成功");
        } catch (Exception e) {
            return error("系统日志消息发送失败: " + e.getMessage());
        }
    }

    /**
     * 测试发送通知消息
     */
    @ApiOperation("测试发送通知消息")
    @PostMapping("/notification")
    public AjaxResult testNotification(
            @ApiParam("通知标题") @RequestParam String title,
            @ApiParam("通知内容") @RequestParam String content,
            @ApiParam("通知类型") @RequestParam String type,
            @ApiParam("目标用户ID") @RequestParam Long targetId) {
        
        try {
            messageService.sendNotificationMessage(title, content, type, targetId);
            return success("通知消息发送成功");
        } catch (Exception e) {
            return error("通知消息发送失败: " + e.getMessage());
        }
    }

    /**
     * 批量测试消息发送
     */
    @ApiOperation("批量测试消息发送")
    @PostMapping("/batch-test")
    public AjaxResult batchTest(@ApiParam("测试数量") @RequestParam(defaultValue = "10") Integer count) {
        try {
            for (int i = 1; i <= count; i++) {
                // 测试维修工单消息
                messageService.sendRepairOrderCreateMessage(
                        (long) i, "RO" + String.format("%06d", i), 1001L, "测试用户" + i,
                        2001L, "A101-" + i, "测试故障描述" + i, 2);

                // 测试用户注册消息
                messageService.sendUserRegisterMessage(
                        (long) (1000 + i), "testuser" + i, "测试用户" + i, "test" + i + "@example.com",
                        "1380000000" + i, "student", "192.168.1." + i);

                // 测试系统日志消息
                messageService.sendSystemLogMessage(
                        "测试模块", "测试业务", 1, "测试操作员" + i, "/test/api" + i, "192.168.1." + i,
                        "{\"param\":\"test" + i + "\"}", "{\"result\":\"success\"}", 0, null, 100L);
            }
            return success("批量测试消息发送成功，共发送 " + (count * 3) + " 条消息");
        } catch (Exception e) {
            return error("批量测试消息发送失败: " + e.getMessage());
        }
    }
}
