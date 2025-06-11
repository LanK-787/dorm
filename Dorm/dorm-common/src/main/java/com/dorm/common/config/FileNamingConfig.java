package com.dorm.common.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 文件命名策略配置
 * 
 * @author dorm
 */
@Component
@ConfigurationProperties(prefix = "file.naming")
public class FileNamingConfig
{
    /**
     * 文件命名策略类型
     * UUID: 使用UUID生成文件名（推荐，安全性高）
     * TIMESTAMP: 使用时间戳生成文件名（兼容旧版本）
     */
    private String strategy = "UUID";

    /**
     * 是否包含业务类型前缀
     */
    private boolean includeBusinessType = true;

    /**
     * 目录分层策略
     * YEAR_MONTH: 按年月分层 (yyyy/MM)
     * YEAR_MONTH_DAY: 按年月日分层 (yyyy/MM/dd)
     * FLAT: 不分层
     */
    private String directoryStrategy = "YEAR_MONTH";

    /**
     * 是否保留原始文件名（不推荐，存在安全风险）
     */
    private boolean preserveOriginalName = false;

    public String getStrategy()
    {
        return strategy;
    }

    public void setStrategy(String strategy)
    {
        this.strategy = strategy;
    }

    public boolean isIncludeBusinessType()
    {
        return includeBusinessType;
    }

    public void setIncludeBusinessType(boolean includeBusinessType)
    {
        this.includeBusinessType = includeBusinessType;
    }

    public String getDirectoryStrategy()
    {
        return directoryStrategy;
    }

    public void setDirectoryStrategy(String directoryStrategy)
    {
        this.directoryStrategy = directoryStrategy;
    }

    public boolean isPreserveOriginalName()
    {
        return preserveOriginalName;
    }

    public void setPreserveOriginalName(boolean preserveOriginalName)
    {
        this.preserveOriginalName = preserveOriginalName;
    }
}
