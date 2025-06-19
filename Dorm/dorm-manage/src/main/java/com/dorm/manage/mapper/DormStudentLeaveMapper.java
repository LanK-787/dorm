package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormStudentLeave;

/**
 * 学生离校登记Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-19
 */
public interface DormStudentLeaveMapper 
{
    /**
     * 查询学生离校登记
     * 
     * @param leaveId 学生离校登记主键
     * @return 学生离校登记
     */
    public DormStudentLeave selectDormStudentLeaveByLeaveId(Long leaveId);

    /**
     * 查询学生离校登记列表
     * 
     * @param dormStudentLeave 学生离校登记
     * @return 学生离校登记集合
     */
    public List<DormStudentLeave> selectDormStudentLeaveList(DormStudentLeave dormStudentLeave);

    /**
     * 新增学生离校登记
     * 
     * @param dormStudentLeave 学生离校登记
     * @return 结果
     */
    public int insertDormStudentLeave(DormStudentLeave dormStudentLeave);

    /**
     * 修改学生离校登记
     * 
     * @param dormStudentLeave 学生离校登记
     * @return 结果
     */
    public int updateDormStudentLeave(DormStudentLeave dormStudentLeave);

    /**
     * 删除学生离校登记
     * 
     * @param leaveId 学生离校登记主键
     * @return 结果
     */
    public int deleteDormStudentLeaveByLeaveId(Long leaveId);

    /**
     * 批量删除学生离校登记
     * 
     * @param leaveIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormStudentLeaveByLeaveIds(Long[] leaveIds);
}
