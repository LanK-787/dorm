package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import com.dorm.system.mapper.SysUserMapper;
import com.dorm.system.mapper.SysUserRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormStudentMapper;
import com.dorm.manage.domain.DormStudent;
import com.dorm.manage.service.IDormStudentService;

/**
 * 学生管理Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-04
 */
@Service
public class DormStudentServiceImpl implements IDormStudentService 
{
    @Autowired
    private DormStudentMapper dormStudentMapper;

    @Autowired
    private SysUserRoleMapper sysUserRoleMapper;

    /**
     * 查询学生管理
     * 
     * @param studentId 学生管理主键
     * @return 学生管理
     */
    @Override
    public DormStudent selectDormStudentByStudentId(Long studentId)
    {
        return dormStudentMapper.selectDormStudentByStudentId(studentId);
    }

    /**
     * 查询学生管理列表
     * 
     * @param dormStudent 学生管理
     * @return 学生管理
     */
    @Override
    public List<DormStudent> selectDormStudentList(DormStudent dormStudent)
    {
        return dormStudentMapper.selectDormStudentList(dormStudent);
    }

    /**
     * 新增学生管理
     * 
     * @param dormStudent 学生管理
     * @return 结果
     */
    @Override
    public int insertDormStudent(DormStudent dormStudent)
    {
        dormStudent.setCreateTime(DateUtils.getNowDate());
        return dormStudentMapper.insertDormStudent(dormStudent);
    }

    /**
     * 修改学生管理
     * 
     * @param dormStudent 学生管理
     * @return 结果
     */
    @Override
    public int updateDormStudent(DormStudent dormStudent)
    {
        dormStudent.setUpdateTime(DateUtils.getNowDate());
        return dormStudentMapper.updateDormStudent(dormStudent);
    }

    /**
     * 批量删除学生管理
     * 
     * @param studentIds 需要删除的学生管理主键
     * @return 结果
     */
    @Override
    public int deleteDormStudentByStudentIds(Long[] studentIds)
    {
        return dormStudentMapper.deleteDormStudentByStudentIds(studentIds);
    }

    /**
     * 删除学生管理信息
     *
     * @param studentId 学生管理主键
     * @return 结果
     */
    @Override
    public int deleteDormStudentByStudentId(Long studentId)
    {
        return dormStudentMapper.deleteDormStudentByStudentId(studentId);
    }

    /**
     * 根据用户名判断是否为学生
     *
     * @param userName 用户名
     * @return 是否为学生
     */
    @Override
    public boolean isStudentByUserName(String userName)
    {
        List<Long> longs = sysUserRoleMapper.selectRoleIdsByUserName(userName);
        return longs.get(0) == 100;
    }
}
