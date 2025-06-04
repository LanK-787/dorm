package com.dorm.manage.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.BaseEntity;

/**
 * 学生管理对象 dorm_student
 * 
 * @author 王新瑜
 * @date 2025-06-04
 */
public class DormStudent extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 学生ID，主键 */
    private Long studentId;

    /** 系统用户ID → sys_user.user_id */
    @Excel(name = "系统用户ID → sys_user.user_id")
    private Long userId;

    /** 学号 */
    @Excel(name = "学号")
    private String studentNo;

    /** 学生姓名 */
    @Excel(name = "学生姓名")
    private String name;

    /** 性别（0男 1女） */
    @Excel(name = "性别", readConverterExp = "0=男,1=女")
    private String gender;

    /** 班级名称 */
    @Excel(name = "班级名称")
    private String className;

    /** 手机号 */
    @Excel(name = "手机号")
    private String phone;

    /** 学生状态（0在校 1离校） */
    @Excel(name = "学生状态", readConverterExp = "0=在校,1=离校")
    private String status;

    /** 邮箱地址 */
    @Excel(name = "邮箱地址")
    private String email;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;

    /** 当前宿舍ID → dorm_room.room_id */
    @Excel(name = "当前宿舍ID → dorm_room.room_id")
    private Long dormId;

    public void setStudentId(Long studentId) 
    {
        this.studentId = studentId;
    }

    public Long getStudentId() 
    {
        return studentId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setStudentNo(String studentNo) 
    {
        this.studentNo = studentNo;
    }

    public String getStudentNo() 
    {
        return studentNo;
    }

    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
    }

    public void setGender(String gender) 
    {
        this.gender = gender;
    }

    public String getGender() 
    {
        return gender;
    }

    public void setClassName(String className) 
    {
        this.className = className;
    }

    public String getClassName() 
    {
        return className;
    }

    public void setPhone(String phone) 
    {
        this.phone = phone;
    }

    public String getPhone() 
    {
        return phone;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setEmail(String email) 
    {
        this.email = email;
    }

    public String getEmail() 
    {
        return email;
    }

    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }

    public void setDormId(Long dormId) 
    {
        this.dormId = dormId;
    }

    public Long getDormId() 
    {
        return dormId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("studentId", getStudentId())
            .append("userId", getUserId())
            .append("studentNo", getStudentNo())
            .append("name", getName())
            .append("gender", getGender())
            .append("className", getClassName())
            .append("phone", getPhone())
            .append("status", getStatus())
            .append("email", getEmail())
            .append("delFlag", getDelFlag())
            .append("dormId", getDormId())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
