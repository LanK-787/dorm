package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.dorm.manage.mapper.DormNoticeLikeMapper;
import com.dorm.manage.mapper.DormNoticeMapper;
import com.dorm.manage.domain.DormNoticeLike;
import com.dorm.manage.service.IDormNoticeLikeService;

/**
 * 公告点赞记录Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-14
 */
@Service
public class DormNoticeLikeServiceImpl implements IDormNoticeLikeService 
{
    @Autowired
    private DormNoticeLikeMapper dormNoticeLikeMapper;
    
    @Autowired
    private DormNoticeMapper dormNoticeMapper;

    /**
     * 查询公告点赞记录
     * 
     * @param id 公告点赞记录主键
     * @return 公告点赞记录
     */
    @Override
    public DormNoticeLike selectDormNoticeLikeById(Long id)
    {
        return dormNoticeLikeMapper.selectDormNoticeLikeById(id);
    }

    /**
     * 查询公告点赞记录列表
     * 
     * @param dormNoticeLike 公告点赞记录
     * @return 公告点赞记录
     */
    @Override
    public List<DormNoticeLike> selectDormNoticeLikeList(DormNoticeLike dormNoticeLike)
    {
        return dormNoticeLikeMapper.selectDormNoticeLikeList(dormNoticeLike);
    }

    /**
     * 新增公告点赞记录
     * 
     * @param dormNoticeLike 公告点赞记录
     * @return 结果
     */
    @Override
    public int insertDormNoticeLike(DormNoticeLike dormNoticeLike)
    {
        dormNoticeLike.setCreateTime(DateUtils.getNowDate());
        return dormNoticeLikeMapper.insertDormNoticeLike(dormNoticeLike);
    }

    /**
     * 修改公告点赞记录
     * 
     * @param dormNoticeLike 公告点赞记录
     * @return 结果
     */
    @Override
    public int updateDormNoticeLike(DormNoticeLike dormNoticeLike)
    {
        return dormNoticeLikeMapper.updateDormNoticeLike(dormNoticeLike);
    }

    /**
     * 批量删除公告点赞记录
     * 
     * @param ids 需要删除的公告点赞记录主键
     * @return 结果
     */
    @Override
    public int deleteDormNoticeLikeByIds(Long[] ids)
    {
        return dormNoticeLikeMapper.deleteDormNoticeLikeByIds(ids);
    }

    /**
     * 删除公告点赞记录信息
     * 
     * @param id 公告点赞记录主键
     * @return 结果
     */
    @Override
    public int deleteDormNoticeLikeById(Long id)
    {
        return dormNoticeLikeMapper.deleteDormNoticeLikeById(id);
    }

    /**
     * 用户点赞/取消点赞公告
     * 
     * @param noticeId 公告ID
     * @param userId 用户ID
     * @return 操作结果：true=点赞成功，false=取消点赞成功
     */
    @Override
    @Transactional
    public boolean toggleLike(Long noticeId, Long userId)
    {
        // 检查用户是否已点赞
        DormNoticeLike existingLike = dormNoticeLikeMapper.selectUserLikeRecord(noticeId, userId);
        
        if (existingLike != null) {
            // 已点赞，执行取消点赞
            dormNoticeLikeMapper.deleteUserLikeRecord(noticeId, userId);
            // 更新公告点赞数量
            updateNoticeLikeCount(noticeId);
            return false; // 返回false表示取消点赞
        } else {
            // 未点赞，执行点赞
            DormNoticeLike noticeLike = new DormNoticeLike();
            noticeLike.setNoticeId(noticeId);
            noticeLike.setUserId(userId);
            noticeLike.setCreateTime(DateUtils.getNowDate());
            dormNoticeLikeMapper.insertDormNoticeLike(noticeLike);
            // 更新公告点赞数量
            updateNoticeLikeCount(noticeId);
            return true; // 返回true表示点赞成功
        }
    }

    /**
     * 查询用户是否已对公告点赞
     * 
     * @param noticeId 公告ID
     * @param userId 用户ID
     * @return 是否已点赞
     */
    @Override
    public boolean isUserLiked(Long noticeId, Long userId)
    {
        DormNoticeLike existingLike = dormNoticeLikeMapper.selectUserLikeRecord(noticeId, userId);
        return existingLike != null;
    }

    /**
     * 获取公告的点赞数量
     * 
     * @param noticeId 公告ID
     * @return 点赞数量
     */
    @Override
    public int getLikeCount(Long noticeId)
    {
        return dormNoticeLikeMapper.countLikesByNoticeId(noticeId);
    }

    /**
     * 更新公告的点赞数量
     * 
     * @param noticeId 公告ID
     */
    private void updateNoticeLikeCount(Long noticeId)
    {
        int likeCount = dormNoticeLikeMapper.countLikesByNoticeId(noticeId);
        // 这里需要在DormNoticeMapper中添加更新点赞数量的方法
        dormNoticeMapper.updateNoticeLikeCount(noticeId, likeCount);
    }
}
