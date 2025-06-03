package com.dorm.manage.service.impl;

import java.util.List;
import com.dorm.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.dorm.manage.mapper.DormBuildingMapper;
import com.dorm.manage.domain.DormBuilding;
import com.dorm.manage.service.IDormBuildingService;

/**
 * 宿舍管理Service业务层处理
 * 
 * @author 王新瑜
 * @date 2025-06-03
 */
@Service
public class DormBuildingServiceImpl implements IDormBuildingService 
{
    @Autowired
    private DormBuildingMapper dormBuildingMapper;

    /**
     * 查询宿舍管理
     * 
     * @param dormId 宿舍管理主键
     * @return 宿舍管理
     */
    @Override
    public DormBuilding selectDormBuildingByDormId(Long dormId)
    {
        return dormBuildingMapper.selectDormBuildingByDormId(dormId);
    }

    /**
     * 查询宿舍管理列表
     * 
     * @param dormBuilding 宿舍管理
     * @return 宿舍管理
     */
    @Override
    public List<DormBuilding> selectDormBuildingList(DormBuilding dormBuilding)
    {
        return dormBuildingMapper.selectDormBuildingList(dormBuilding);
    }

    /**
     * 新增宿舍管理
     * 
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    @Override
    public int insertDormBuilding(DormBuilding dormBuilding)
    {
        dormBuilding.setCreateTime(DateUtils.getNowDate());
        return dormBuildingMapper.insertDormBuilding(dormBuilding);
    }

    /**
     * 修改宿舍管理
     * 
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    @Override
    public int updateDormBuilding(DormBuilding dormBuilding)
    {
        dormBuilding.setUpdateTime(DateUtils.getNowDate());
        return dormBuildingMapper.updateDormBuilding(dormBuilding);
    }

    /**
     * 批量删除宿舍管理
     * 
     * @param dormIds 需要删除的宿舍管理主键
     * @return 结果
     */
    @Override
    public int deleteDormBuildingByDormIds(Long[] dormIds)
    {
        return dormBuildingMapper.deleteDormBuildingByDormIds(dormIds);
    }

    /**
     * 删除宿舍管理信息
     * 
     * @param dormId 宿舍管理主键
     * @return 结果
     */
    @Override
    public int deleteDormBuildingByDormId(Long dormId)
    {
        return dormBuildingMapper.deleteDormBuildingByDormId(dormId);
    }
}
