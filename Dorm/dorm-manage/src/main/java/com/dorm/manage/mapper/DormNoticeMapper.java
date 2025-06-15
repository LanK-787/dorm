package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormNotice;
import org.apache.ibatis.annotations.Param;

/**
 * 宿舍公告Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-06
 */
public interface DormNoticeMapper 
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
     * 删除宿舍公告
     * 
     * @param noticeId 宿舍公告主键
     * @return 结果
     */
    public int deleteDormNoticeByNoticeId(Long noticeId);

    /**
     * 批量删除宿舍公告
     *
     * @param noticeIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormNoticeByNoticeIds(Long[] noticeIds);

    /**
     * 批量修改公告状态
     *
     * @param noticeIds 公告ID列表
     * @param status 目标状态
     * @return 结果
     */
    public int batchUpdateNoticeStatus(@Param("noticeIds") List<Long> noticeIds, @Param("status") String status);

    /**
     * 批量设置轮播图显示
     *
     * @param noticeIds 公告ID列表
     * @param isCarousel 轮播图显示设置
     * @return 结果
     */
    public int batchUpdateNoticeCarousel(@Param("noticeIds") List<Long> noticeIds, @Param("isCarousel") String isCarousel);

    /**
     * 更新公告点赞数量
     *
     * @param noticeId 公告ID
     * @param likeCount 点赞数量
     * @return 结果
     */
    public int updateNoticeLikeCount(@Param("noticeId") Long noticeId, @Param("likeCount") Integer likeCount);
}
