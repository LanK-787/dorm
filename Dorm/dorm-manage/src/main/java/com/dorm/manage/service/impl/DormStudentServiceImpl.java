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
import com.dorm.manage.service.IDormBuildingService;
import com.dorm.common.exception.ServiceException;

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

    @Autowired
    private IDormBuildingService dormBuildingService;

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
     * 新增学生管理（带容量检查）
     *
     * @param dormStudent 学生管理
     * @return 结果
     */
    @Override
    public int insertDormStudentWithCapacityCheck(DormStudent dormStudent)
    {
        // 如果分配了宿舍，检查容量
        if (dormStudent.getDormId() != null) {
            if (!dormBuildingService.checkDormCapacityAvailable(dormStudent.getDormId())) {
                throw new ServiceException("该宿舍已满员，无法分配更多学生");
            }
        }

        dormStudent.setCreateTime(DateUtils.getNowDate());
        if (dormStudent.getUserId() == null) {
            Long userId = sysUserMapper.selectUserByUserName(dormStudent.getStudentNo()).getUserId();
            dormStudent.setUserId(userId);
        }

        int result = dormStudentMapper.insertDormStudent(dormStudent);

        // 如果插入成功且分配了宿舍，增加宿舍当前入住人数
        if (result > 0 && dormStudent.getDormId() != null) {
            dormBuildingService.incrementDormCurrentCount(dormStudent.getDormId());
        }

        return result;
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
     * 修改学生管理（带容量检查）
     *
     * @param dormStudent 学生管理
     * @return 结果
     */
    @Override
    public int updateDormStudentWithCapacityCheck(DormStudent dormStudent)
    {
        // 获取原学生信息
        DormStudent originalStudent = dormStudentMapper.selectDormStudentByStudentId(dormStudent.getStudentId());
        if (originalStudent == null) {
            throw new ServiceException("学生信息不存在");
        }

        Long originalDormId = originalStudent.getDormId();
        Long newDormId = dormStudent.getDormId();

        // 如果宿舍发生变化
        if (!java.util.Objects.equals(originalDormId, newDormId)) {
            // 如果新分配了宿舍，检查容量
            if (newDormId != null) {
                if (!dormBuildingService.checkDormCapacityAvailable(newDormId)) {
                    throw new ServiceException("目标宿舍已满员，无法转移");
                }
            }
        }

        dormStudent.setUpdateTime(DateUtils.getNowDate());
        int result = dormStudentMapper.updateDormStudent(dormStudent);

        // 如果更新成功且宿舍发生变化，更新宿舍容量
        if (result > 0 && !java.util.Objects.equals(originalDormId, newDormId)) {
            // 原宿舍人数减1
            if (originalDormId != null) {
                dormBuildingService.decrementDormCurrentCount(originalDormId);
            }
            // 新宿舍人数加1
            if (newDormId != null) {
                dormBuildingService.incrementDormCurrentCount(newDormId);
            }
        }

        return result;
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
        // 在删除前，减少相关宿舍的当前入住人数
        for (Long studentId : studentIds) {
            DormStudent student = dormStudentMapper.selectDormStudentByStudentId(studentId);
            if (student != null && student.getDormId() != null) {
                dormBuildingService.decrementDormCurrentCount(student.getDormId());
            }
        }

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
        // 在删除前，减少相关宿舍的当前入住人数
        DormStudent student = dormStudentMapper.selectDormStudentByStudentId(studentId);
        if (student != null && student.getDormId() != null) {
            dormBuildingService.decrementDormCurrentCount(student.getDormId());
        }

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
