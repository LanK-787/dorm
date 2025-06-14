package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormNoticeMapper;
import com.dorm.manage.domain.DormNotice;
import com.dorm.manage.domain.dto.BatchUpdateNoticeDTO;
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

    /**
     * 批量修改公告状态
     *
     * @param batchUpdateDTO 批量更新DTO
     * @return 结果
     */
    @Override
    public int batchUpdateNoticeStatus(BatchUpdateNoticeDTO batchUpdateDTO)
    {
        if (batchUpdateDTO.getNoticeIds() == null || batchUpdateDTO.getNoticeIds().isEmpty()) {
            return 0;
        }
        if (batchUpdateDTO.getStatus() == null) {
            throw new IllegalArgumentException("状态不能为空");
        }
        return dormNoticeMapper.batchUpdateNoticeStatus(batchUpdateDTO.getNoticeIds(), batchUpdateDTO.getStatus());
    }

    /**
     * 批量设置轮播图显示
     *
     * @param batchUpdateDTO 批量更新DTO
     * @return 结果
     */
    @Override
    public int batchUpdateNoticeCarousel(BatchUpdateNoticeDTO batchUpdateDTO)
    {
        if (batchUpdateDTO.getNoticeIds() == null || batchUpdateDTO.getNoticeIds().isEmpty()) {
            return 0;
        }
        if (batchUpdateDTO.getIsCarousel() == null) {
            throw new IllegalArgumentException("轮播图显示设置不能为空");
        }
        return dormNoticeMapper.batchUpdateNoticeCarousel(batchUpdateDTO.getNoticeIds(), batchUpdateDTO.getIsCarousel());
    }
}
