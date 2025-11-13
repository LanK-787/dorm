package com.dorm.common.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * 类型转换工具类
 * 主要用于处理前端传递的数据类型转换问题
 * 
 * @author 王新瑜
 * @date 2025-06-19
 */
public class TypeConvertUtils {
    
    private static final Logger logger = LoggerFactory.getLogger(TypeConvertUtils.class);
    
    /**
     * 安全地将Object列表转换为Long列表
     * 支持Integer、Long、String类型的自动转换
     * 
     * @param rawList 原始对象列表
     * @return Long类型列表
     */
    public static List<Long> convertToLongList(List<Object> rawList) {
        List<Long> result = new ArrayList<>();
        
        if (rawList == null) {
            return result;
        }
        
        for (Object item : rawList) {
            Long convertedValue = convertToLong(item);
            if (convertedValue != null) {
                result.add(convertedValue);
            }
        }
        
        return result;
    }
    
    /**
     * 安全地将Object转换为Long
     * 支持Integer、Long、String类型的自动转换
     * 
     * @param value 要转换的值
     * @return 转换后的Long值，转换失败返回null
     */
    public static Long convertToLong(Object value) {
        if (value == null) {
            return null;
        }
        
        try {
            if (value instanceof Integer) {
                return ((Integer) value).longValue();
            } else if (value instanceof Long) {
                return (Long) value;
            } else if (value instanceof String) {
                String strValue = (String) value;
                if (strValue.trim().isEmpty()) {
                    return null;
                }
                return Long.parseLong(strValue);
            } else if (value instanceof Number) {
                return ((Number) value).longValue();
            } else {
                logger.warn("无法识别的数值类型: {}, 值: {}", value.getClass().getName(), value);
                return null;
            }
        } catch (NumberFormatException e) {
            logger.warn("数值转换失败: {}, 错误: {}", value, e.getMessage());
            return null;
        }
    }
    
    /**
     * 安全地将Object列表转换为Integer列表
     * 支持Integer、Long、String类型的自动转换
     * 
     * @param rawList 原始对象列表
     * @return Integer类型列表
     */
    public static List<Integer> convertToIntegerList(List<Object> rawList) {
        List<Integer> result = new ArrayList<>();
        
        if (rawList == null) {
            return result;
        }
        
        for (Object item : rawList) {
            Integer convertedValue = convertToInteger(item);
            if (convertedValue != null) {
                result.add(convertedValue);
            }
        }
        
        return result;
    }
    
    /**
     * 安全地将Object转换为Integer
     * 支持Integer、Long、String类型的自动转换
     * 
     * @param value 要转换的值
     * @return 转换后的Integer值，转换失败返回null
     */
    public static Integer convertToInteger(Object value) {
        if (value == null) {
            return null;
        }
        
        try {
            if (value instanceof Integer) {
                return (Integer) value;
            } else if (value instanceof Long) {
                Long longValue = (Long) value;
                if (longValue > Integer.MAX_VALUE || longValue < Integer.MIN_VALUE) {
                    logger.warn("Long值超出Integer范围: {}", longValue);
                    return null;
                }
                return longValue.intValue();
            } else if (value instanceof String) {
                String strValue = (String) value;
                if (strValue.trim().isEmpty()) {
                    return null;
                }
                return Integer.parseInt(strValue);
            } else if (value instanceof Number) {
                return ((Number) value).intValue();
            } else {
                logger.warn("无法识别的数值类型: {}, 值: {}", value.getClass().getName(), value);
                return null;
            }
        } catch (NumberFormatException e) {
            logger.warn("数值转换失败: {}, 错误: {}", value, e.getMessage());
            return null;
        }
    }
    
    /**
     * 安全地将Object转换为String
     * 
     * @param value 要转换的值
     * @return 转换后的String值，null值返回null
     */
    public static String convertToString(Object value) {
        if (value == null) {
            return null;
        }
        return value.toString();
    }
    
    /**
     * 检查列表是否为空或null
     * 
     * @param list 要检查的列表
     * @return 如果列表为null或空则返回true
     */
    public static boolean isEmpty(List<?> list) {
        return list == null || list.isEmpty();
    }
    
    /**
     * 检查列表是否不为空
     * 
     * @param list 要检查的列表
     * @return 如果列表不为null且不为空则返回true
     */
    public static boolean isNotEmpty(List<?> list) {
        return !isEmpty(list);
    }
}
