package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormStudent;

/**
 * 学生管理Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-04
 */
public interface IDormStudentService 
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
     * 批量删除学生管理
     * 
     * @param studentIds 需要删除的学生管理主键集合
     * @return 结果
     */
    public int deleteDormStudentByStudentIds(Long[] studentIds);

    /**
     * 删除学生管理信息
     *
     * @param studentId 学生管理主键
     * @return 结果
     */
    public int deleteDormStudentByStudentId(Long studentId);

    /**
     * 根据用户名判断是否为学生
     *
     * @param userName 用户名
     * @return 是否为学生
     */
    public boolean isStudentByUserName(String userName);

    /**
     * 根据用户名判断user_id是否存在
     *
     * @param userName 用户名
     * @return user_id是否存在
     */
    public boolean isUserIdExistsByUserName(String userName);
}
