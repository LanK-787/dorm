package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormRepairerMapper;
import com.dorm.manage.domain.DormRepairer;
import com.dorm.manage.service.IDormRepairerService;

/**
 * 维修人员管理Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-17
 */
@Service
public class DormRepairerServiceImpl implements IDormRepairerService 
{
    @Autowired
    private DormRepairerMapper dormRepairerMapper;

    /**
     * 查询维修人员管理
     *
     * @param repairerId 维修人员管理主键
     * @return 维修人员管理
     */
    @Override
    public DormRepairer selectDormRepairerByRepairerId(Long repairerId)
    {
        return dormRepairerMapper.selectDormRepairerByRepairerId(repairerId);
    }

    /**
     * 根据用户ID查询维修人员管理
     *
     * @param userId 用户ID
     * @return 维修人员管理
     */
    @Override
    public DormRepairer selectDormRepairerByUserId(Long userId)
    {
        return dormRepairerMapper.selectDormRepairerByUserId(userId);
    }

    /**
     * 查询维修人员管理列表
     * 
     * @param dormRepairer 维修人员管理
     * @return 维修人员管理
     */
    @Override
    public List<DormRepairer> selectDormRepairerList(DormRepairer dormRepairer)
    {
        return dormRepairerMapper.selectDormRepairerList(dormRepairer);
    }

    /**
     * 新增维修人员管理
     * 
     * @param dormRepairer 维修人员管理
     * @return 结果
     */
    @Override
    public int insertDormRepairer(DormRepairer dormRepairer)
    {
        dormRepairer.setCreateTime(DateUtils.getNowDate());
        return dormRepairerMapper.insertDormRepairer(dormRepairer);
    }

    /**
     * 修改维修人员管理
     * 
     * @param dormRepairer 维修人员管理
     * @return 结果
     */
    @Override
    public int updateDormRepairer(DormRepairer dormRepairer)
    {
        dormRepairer.setUpdateTime(DateUtils.getNowDate());
        return dormRepairerMapper.updateDormRepairer(dormRepairer);
    }

    /**
     * 批量删除维修人员管理
     * 
     * @param repairerIds 需要删除的维修人员管理主键
     * @return 结果
     */
    @Override
    public int deleteDormRepairerByRepairerIds(Long[] repairerIds)
    {
        return dormRepairerMapper.deleteDormRepairerByRepairerIds(repairerIds);
    }

    /**
     * 删除维修人员管理信息
     * 
     * @param repairerId 维修人员管理主键
     * @return 结果
     */
    @Override
    public int deleteDormRepairerByRepairerId(Long repairerId)
    {
        return dormRepairerMapper.deleteDormRepairerByRepairerId(repairerId);
    }
}
