package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormStudentLeaveMapper;
import com.dorm.manage.domain.DormStudentLeave;
import com.dorm.manage.service.IDormStudentLeaveService;

/**
 * 学生离校登记Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-19
 */
@Service
public class DormStudentLeaveServiceImpl implements IDormStudentLeaveService 
{
    @Autowired
    private DormStudentLeaveMapper dormStudentLeaveMapper;

    /**
     * 查询学生离校登记
     * 
     * @param leaveId 学生离校登记主键
     * @return 学生离校登记
     */
    @Override
    public DormStudentLeave selectDormStudentLeaveByLeaveId(Long leaveId)
    {
        return dormStudentLeaveMapper.selectDormStudentLeaveByLeaveId(leaveId);
    }

    /**
     * 查询学生离校登记列表
     * 
     * @param dormStudentLeave 学生离校登记
     * @return 学生离校登记
     */
    @Override
    public List<DormStudentLeave> selectDormStudentLeaveList(DormStudentLeave dormStudentLeave)
    {
        return dormStudentLeaveMapper.selectDormStudentLeaveList(dormStudentLeave);
    }

    /**
     * 新增学生离校登记
     * 
     * @param dormStudentLeave 学生离校登记
     * @return 结果
     */
    @Override
    public int insertDormStudentLeave(DormStudentLeave dormStudentLeave)
    {
        dormStudentLeave.setCreateTime(DateUtils.getNowDate());
        return dormStudentLeaveMapper.insertDormStudentLeave(dormStudentLeave);
    }

    /**
     * 修改学生离校登记
     * 
     * @param dormStudentLeave 学生离校登记
     * @return 结果
     */
    @Override
    public int updateDormStudentLeave(DormStudentLeave dormStudentLeave)
    {
        dormStudentLeave.setUpdateTime(DateUtils.getNowDate());
        return dormStudentLeaveMapper.updateDormStudentLeave(dormStudentLeave);
    }

    /**
     * 批量删除学生离校登记
     * 
     * @param leaveIds 需要删除的学生离校登记主键
     * @return 结果
     */
    @Override
    public int deleteDormStudentLeaveByLeaveIds(Long[] leaveIds)
    {
        return dormStudentLeaveMapper.deleteDormStudentLeaveByLeaveIds(leaveIds);
    }

    /**
     * 删除学生离校登记信息
     * 
     * @param leaveId 学生离校登记主键
     * @return 结果
     */
    @Override
    public int deleteDormStudentLeaveByLeaveId(Long leaveId)
    {
        return dormStudentLeaveMapper.deleteDormStudentLeaveByLeaveId(leaveId);
    }
}
