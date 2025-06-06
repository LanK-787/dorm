package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormNoticeMapper;
import com.dorm.manage.domain.DormNotice;
import com.dorm.manage.service.IDormNoticeService;

/**
 * 宿舍公告Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-06
 */
@Service
public class DormNoticeServiceImpl implements IDormNoticeService 
{
    @Autowired
    private DormNoticeMapper dormNoticeMapper;

    /**
     * 查询宿舍公告
     * 
     * @param noticeId 宿舍公告主键
     * @return 宿舍公告
     */
    @Override
    public DormNotice selectDormNoticeByNoticeId(Long noticeId)
    {
        return dormNoticeMapper.selectDormNoticeByNoticeId(noticeId);
    }

    /**
     * 查询宿舍公告列表
     * 
     * @param dormNotice 宿舍公告
     * @return 宿舍公告
     */
    @Override
    public List<DormNotice> selectDormNoticeList(DormNotice dormNotice)
    {
        return dormNoticeMapper.selectDormNoticeList(dormNotice);
    }

    /**
     * 新增宿舍公告
     * 
     * @param dormNotice 宿舍公告
     * @return 结果
     */
    @Override
    public int insertDormNotice(DormNotice dormNotice)
    {
        dormNotice.setCreateTime(DateUtils.getNowDate());
        return dormNoticeMapper.insertDormNotice(dormNotice);
    }

    /**
     * 修改宿舍公告
     * 
     * @param dormNotice 宿舍公告
     * @return 结果
     */
    @Override
    public int updateDormNotice(DormNotice dormNotice)
    {
        dormNotice.setUpdateTime(DateUtils.getNowDate());
        return dormNoticeMapper.updateDormNotice(dormNotice);
    }

    /**
     * 批量删除宿舍公告
     * 
     * @param noticeIds 需要删除的宿舍公告主键
     * @return 结果
     */
    @Override
    public int deleteDormNoticeByNoticeIds(Long[] noticeIds)
    {
        return dormNoticeMapper.deleteDormNoticeByNoticeIds(noticeIds);
    }

    /**
     * 删除宿舍公告信息
     * 
     * @param noticeId 宿舍公告主键
     * @return 结果
     */
    @Override
    public int deleteDormNoticeByNoticeId(Long noticeId)
    {
        return dormNoticeMapper.deleteDormNoticeByNoticeId(noticeId);
    }
}
