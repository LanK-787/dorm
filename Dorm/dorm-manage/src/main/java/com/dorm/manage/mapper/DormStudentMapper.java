package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormStudent;

/**
 * 学生管理Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-04
 */
public interface DormStudentMapper 
{
    /**
     * 查询学生管理
     * 
     * @param studentId 学生管理主键
     * @return 学生管理
     */
    public DormStudent selectDormStudentByStudentId(Long studentId);

    /**
     * 查询学生管理列表
     * 
     * @param dormStudent 学生管理
     * @return 学生管理集合
     */
    public List<DormStudent> selectDormStudentList(DormStudent dormStudent);

    /**
     * 新增学生管理
     * 
     * @param dormStudent 学生管理
     * @return 结果
     */
    public int insertDormStudent(DormStudent dormStudent);

    /**
     * 修改学生管理
     * 
     * @param dormStudent 学生管理
     * @return 结果
     */
    public int updateDormStudent(DormStudent dormStudent);

    /**
     * 删除学生管理
     * 
     * @param studentId 学生管理主键
     * @return 结果
     */
    public int deleteDormStudentByStudentId(Long studentId);

    /**
     * 批量删除学生管理
     *
     * @param studentIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormStudentByStudentIds(Long[] studentIds);

    /**
     * 根据用户名查询学生信息
     *
     * @param userName 用户名
     * @return 学生信息
     */
    public DormStudent selectDormStudentByUserName(String userName);

    /**
     * 根据用户名id查询学生信息
     *
     * @param userId 用户名
     * @return 学生信息
     */
    DormStudent selectDormStudentbyUserId(Long userId);
}
