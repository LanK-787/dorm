package com.dorm.manage.service;

import java.util.List;
import com.dorm.common.core.domain.TreeSelect;
import com.dorm.common.core.domain.entity.DormBuilding;

/**
 * 宿舍管理Service接口
 * 
 * @author 王新瑜
 * @date 2025-06-03
 */
public interface IDormBuildingService 
{
    /**
     * 查询宿舍管理
     * 
     * @param dormId 宿舍管理主键
     * @return 宿舍管理
     */
    public DormBuilding selectDormBuildingByDormId(Long dormId);

    /**
     * 查询宿舍管理列表
     * 
     * @param dormBuilding 宿舍管理
     * @return 宿舍管理集合
     */
    public List<DormBuilding> selectDormBuildingList(DormBuilding dormBuilding);

    /**
     * 查询宿舍树结构信息
     * 
     * @param dormBuilding 宿舍信息
     * @return 宿舍树信息集合
     */
    public List<TreeSelect> selectDormTreeList(DormBuilding dormBuilding);

    /**
     * 构建前端所需要树结构
     * 
     * @param dorms 宿舍列表
     * @return 树结构列表
     */
    public List<DormBuilding> buildDormTree(List<DormBuilding> dorms);

    /**
     * 构建前端所需要下拉树结构
     * 
     * @param dorms 宿舍列表
     * @return 下拉树结构列表
     */
    public List<TreeSelect> buildDormTreeSelect(List<DormBuilding> dorms);

    /**
     * 根据ID查询所有子宿舍（正常状态）
     * 
     * @param dormId 宿舍ID
     * @return 子宿舍数
     */
    public int selectNormalChildrenDormById(Long dormId);

    /**
     * 是否存在宿舍子节点
     * 
     * @param dormId 宿舍ID
     * @return 结果
     */
    public boolean hasChildByDormId(Long dormId);

    /**
     * 查询宿舍是否存在用户
     * 
     * @param dormId 宿舍ID
     * @return 结果 true 存在 false 不存在
     */
    public boolean checkDormExistUser(Long dormId);

    /**
     * 校验宿舍名称是否唯一
     * 
     * @param dormBuilding 宿舍信息
     * @return 结果
     */
    public boolean checkDormNameUnique(DormBuilding dormBuilding);

    /**
     * 新增宿舍管理
     * 
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    public int insertDormBuilding(DormBuilding dormBuilding);

    /**
     * 修改宿舍管理
     * 
     * @param dormBuilding 宿舍管理
     * @return 结果
     */
    public int updateDormBuilding(DormBuilding dormBuilding);

    /**
     * 删除宿舍管理信息
     * 
     * @param dormId 宿舍管理主键
     * @return 结果
     */
    public int deleteDormBuildingByDormId(Long dormId);

    /**
     * 批量删除宿舍管理
     * 
     * @param dormIds 需要删除的宿舍管理主键集合
     * @return 结果
     */
    public int deleteDormBuildingByDormIds(Long[] dormIds);
}
