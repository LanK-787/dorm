package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormNotice;

/**
 * 宿舍公告Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-06
 */
public interface IDormNoticeService 
{
    /**
     * 查询宿舍公告
     * 
     * @param noticeId 宿舍公告主键
     * @return 宿舍公告
     */
    public DormNotice selectDormNoticeByNoticeId(Long noticeId);

    /**
     * 查询宿舍公告列表
     * 
     * @param dormNotice 宿舍公告
     * @return 宿舍公告集合
     */
    public List<DormNotice> selectDormNoticeList(DormNotice dormNotice);

    /**
     * 新增宿舍公告
     * 
     * @param dormNotice 宿舍公告
     * @return 结果
     */
    public int insertDormNotice(DormNotice dormNotice);

    /**
     * 修改宿舍公告
     * 
     * @param dormNotice 宿舍公告
     * @return 结果
     */
    public int updateDormNotice(DormNotice dormNotice);

    /**
     * 批量删除宿舍公告
     * 
     * @param noticeIds 需要删除的宿舍公告主键集合
     * @return 结果
     */
    public int deleteDormNoticeByNoticeIds(Long[] noticeIds);

    /**
     * 删除宿舍公告信息
     * 
     * @param noticeId 宿舍公告主键
     * @return 结果
     */
    public int deleteDormNoticeByNoticeId(Long noticeId);
}
