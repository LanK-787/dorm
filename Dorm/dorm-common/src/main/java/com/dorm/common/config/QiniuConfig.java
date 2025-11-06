package com.dorm.common.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.qiniu.storage.Region;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;

/**
 * 七牛云配置信息
 *
 * @author ruoyi
 */
@Configuration
@ConfigurationProperties(prefix = "qiniu")
public class QiniuConfig
{
    /**
     * 访问域名
     */
    private static String url;

    /**
     * AccessKey
     */
    private static String accessKey;

    /**
     * SecretKey
     */
    private static String secretKey;

    /**
     * 存储空间名称
     */
    private static String bucketName;

    public static String getUrl()
    {
        return url;
    }

    public void setUrl(String url)
    {
        QiniuConfig.url = url;
    }

    public static String getAccessKey()
    {
        return accessKey;
    }

    public void setAccessKey(String accessKey)
    {
        QiniuConfig.accessKey = accessKey;
    }

    public static String getSecretKey()
    {
        return secretKey;
    }

    public void setSecretKey(String secretKey)
    {
        QiniuConfig.secretKey = secretKey;
    }

    public static String getBucketName()
    {
        return bucketName;
    }

    public void setBucketName(String bucketName)
    {
        QiniuConfig.bucketName = bucketName;
    }

    /**
     * 创建七牛云认证对象
     */
    @Bean
    public Auth getAuth()
    {
        return Auth.create(accessKey, secretKey);
    }

    /**
     * 创建七牛云上传管理器
     */
    @Bean
    public UploadManager getUploadManager()
    {
        // 华南区域配置（up-z2.qiniup.com）
        com.qiniu.storage.Configuration cfg = new com.qiniu.storage.Configuration(Region.huanan());
        cfg.resumableUploadAPIVersion = com.qiniu.storage.Configuration.ResumableUploadAPIVersion.V2;
        return new UploadManager(cfg);
    }
}

