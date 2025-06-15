package com.dorm.manage.service;

import java.util.List;
import com.dorm.manage.domain.DormNoticeLike;

/**
 * 公告点赞记录Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-14
 */
public interface IDormNoticeLikeService 
{
    /**
     * 查询公告点赞记录
     * 
     * @param id 公告点赞记录主键
     * @return 公告点赞记录
     */
    public DormNoticeLike selectDormNoticeLikeById(Long id);

    /**
     * 查询公告点赞记录列表
     * 
     * @param dormNoticeLike 公告点赞记录
     * @return 公告点赞记录集合
     */
    public List<DormNoticeLike> selectDormNoticeLikeList(DormNoticeLike dormNoticeLike);

    /**
     * 新增公告点赞记录
     * 
     * @param dormNoticeLike 公告点赞记录
     * @return 结果
     */
    public int insertDormNoticeLike(DormNoticeLike dormNoticeLike);

    /**
     * 修改公告点赞记录
     * 
     * @param dormNoticeLike 公告点赞记录
     * @return 结果
     */
    public int updateDormNoticeLike(DormNoticeLike dormNoticeLike);

    /**
     * 批量删除公告点赞记录
     * 
     * @param ids 需要删除的公告点赞记录主键集合
     * @return 结果
     */
    public int deleteDormNoticeLikeByIds(Long[] ids);

    /**
     * 删除公告点赞记录信息
     * 
     * @param id 公告点赞记录主键
     * @return 结果
     */
    public int deleteDormNoticeLikeById(Long id);

    /**
     * 用户点赞/取消点赞公告
     * 
     * @param noticeId 公告ID
     * @param userId 用户ID
     * @return 操作结果：true=点赞成功，false=取消点赞成功
     */
    public boolean toggleLike(Long noticeId, Long userId);

    /**
     * 查询用户是否已对公告点赞
     * 
     * @param noticeId 公告ID
     * @param userId 用户ID
     * @return 是否已点赞
     */
    public boolean isUserLiked(Long noticeId, Long userId);

    /**
     * 获取公告的点赞数量
     * 
     * @param noticeId 公告ID
     * @return 点赞数量
     */
    public int getLikeCount(Long noticeId);
}
