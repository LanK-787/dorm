package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import com.dorm.common.utils.SecurityUtils;
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

    @Autowired
    private SysUserMapper sysUserMapper;

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
        if (dormStudent.getUserId() == null) {
            Long userId = sysUserMapper.selectUserByUserName(dormStudent.getStudentNo()).getUserId();
            dormStudent.setUserId(userId);
        }
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
    /**
     * 根据用户名判断user_id是否存在
     *
     * @param userName 用户名
     * @return user_id是否存在
     */
    @Override
    public boolean isUserIdExistsByUserName(String userName)
    {
        DormStudent student = dormStudentMapper.selectDormStudentByUserName(userName);
        return student != null && student.getUserId() != null;
    }

    /**
     * 查询学生信息
     *
     * @return 学生信息
     */
    @Override
    public DormStudent selectDormStudentByUserId()
    {
        DormStudent dormStudent = new DormStudent();
        dormStudent.setUserId(SecurityUtils.getUserId());
        List<DormStudent> dormStudents = dormStudentMapper.selectDormStudentList(dormStudent);
        dormStudent = dormStudents.get(0);
        dormStudent.setDelFlag(null);
        dormStudent.setCreateTime(null);
        dormStudent.setUpdateTime(null);
        dormStudent.setCreateBy(null);
        dormStudent.setUpdateBy(null);
        dormStudent.setRemark(null);
        return dormStudent;
    }


    /**
     * 用户端修改学生信息
     *
     * @return 学生信息
     */
    @Override
    public int UpdateDormStudentInfo(DormStudent dormStudent) {

        // 获取当前用户ID
        Long userId = SecurityUtils.getUserId();

        DormStudent student = new DormStudent();
        student.setUserId(userId);

        List<DormStudent> dormStudents = dormStudentMapper.selectDormStudentList(student);

        dormStudent.setStudentId(dormStudents.get(0).getStudentId());
        dormStudent.setUpdateTime(DateUtils.getNowDate());
        return dormStudentMapper.updateDormStudent(dormStudent);
    }
}
