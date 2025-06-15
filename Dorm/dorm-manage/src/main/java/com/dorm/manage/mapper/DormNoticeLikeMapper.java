package com.dorm.manage.mapper;

import java.util.List;
import com.dorm.manage.domain.DormNoticeLike;
import org.apache.ibatis.annotations.Param;

/**
 * 公告点赞记录Mapper接口
 * 
 * @author 王新瑜
 * @date 2025-06-14
 */
public interface DormNoticeLikeMapper 
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
     * 删除公告点赞记录
     * 
     * @param id 公告点赞记录主键
     * @return 结果
     */
    public int deleteDormNoticeLikeById(Long id);

    /**
     * 批量删除公告点赞记录
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDormNoticeLikeByIds(Long[] ids);

    /**
     * 查询用户是否已对公告点赞
     * 
     * @param noticeId 公告ID
     * @param userId 用户ID
     * @return 点赞记录
     */
    public DormNoticeLike selectUserLikeRecord(@Param("noticeId") Long noticeId, @Param("userId") Long userId);

    /**
     * 删除用户对公告的点赞记录
     * 
     * @param noticeId 公告ID
     * @param userId 用户ID
     * @return 结果
     */
    public int deleteUserLikeRecord(@Param("noticeId") Long noticeId, @Param("userId") Long userId);

    /**
     * 统计公告的点赞数量
     * 
     * @param noticeId 公告ID
     * @return 点赞数量
     */
    public int countLikesByNoticeId(@Param("noticeId") Long noticeId);
}
