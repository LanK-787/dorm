package com.dorm.common.core.domain.entity;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.dorm.common.annotation.Excel;
import com.dorm.common.core.domain.TreeEntity;

import java.util.ArrayList;
import java.util.List;

/**
 * 宿舍管理对象 dorm_building
 * 
 * @author 王新瑜
 * @date 2025-06-03
 */
public class DormBuilding extends TreeEntity<DormBuilding>
{
    private static final long serialVersionUID = 1L;

    /** 宿舍ID（主键） */
    private Long dormId;

    /** 宿舍名称 */
    @Excel(name = "宿舍名称")
    private String buildingName;

    /** 宿管 */
    @Excel(name = "宿管")
    private String dormManager;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private String phone;

    /** 邮箱 */
    @Excel(name = "邮箱")
    private String email;

    /** 宿舍状态（0正常 1停用） */
    @Excel(name = "宿舍状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 删除标志（0存在 2删除） */
    private String delFlag;

    /** 子部门 */
    private List<DormBuilding> children = new ArrayList<DormBuilding>();

    public void setDormId(Long dormId) 
    {
        this.dormId = dormId;
    }

    public Long getDormId() 
    {
        return dormId;
    }

    public void setBuildingName(String buildingName) 
    {
        this.buildingName = buildingName;
    }

    public String getBuildingName() 
    {
        return buildingName;
    }

    public void setDormManager(String dormManager) 
    {
        this.dormManager = dormManager;
    }

    public String getDormManager() 
    {
        return dormManager;
    }

    public void setPhone(String phone) 
    {
        this.phone = phone;
    }

    public String getPhone() 
    {
        return phone;
    }

    public void setEmail(String email) 
    {
        this.email = email;
    }

    public String getEmail() 
    {
        return email;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }


    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("dormId", getDormId())
            .append("parentId", getParentId())
            .append("ancestors", getAncestors())
            .append("buildingName", getBuildingName())
            .append("orderNum", getOrderNum())
            .append("dormManager", getDormManager())
            .append("phone", getPhone())
            .append("email", getEmail())
            .append("status", getStatus())
            .append("delFlag", getDelFlag())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
