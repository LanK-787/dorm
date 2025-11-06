package com.dorm.common.utils.file;

import java.io.IOException;

import com.dorm.common.config.QiniuConfig;
import com.dorm.common.utils.spring.SpringUtils;
import com.google.gson.Gson;
import com.qiniu.http.Response;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.util.Auth;
import org.springframework.web.multipart.MultipartFile;


/**
 * 七牛云文件存储工具类
 * 
 * @author ruoyi
 */
public class QiniuUtil
{
    /**
     * 上传文件到七牛云
     * 
     * @param bucketName 存储空间名称
     * @param fileName 文件名称（含路径）
     * @param multipartFile 上传的文件
     * @return 文件访问URL
     * @throws IOException
     */
    public static String uploadFile(String bucketName, String fileName, MultipartFile multipartFile) throws IOException
    {
        try
        {
            // 获取七牛云认证对象和上传管理器
            Auth auth = SpringUtils.getBean(Auth.class);
            UploadManager uploadManager = SpringUtils.getBean(UploadManager.class);
            
            // 生成上传凭证
            String upToken = auth.uploadToken(bucketName);
            
            // 上传文件
            byte[] uploadBytes = multipartFile.getBytes();
            Response response = uploadManager.put(uploadBytes, fileName, upToken);
            
            // 解析上传成功的结果
            DefaultPutRet putRet = new Gson().fromJson(response.bodyString(), DefaultPutRet.class);
            
            // 构建文件访问URL
            String domain = QiniuConfig.getUrl();
            if (!domain.endsWith("/"))
            {
                domain += "/";
            }
            String url = domain + putRet.key;
            
            return url;
        }
        catch (Exception e)
        {
            throw new IOException("七牛云文件上传失败：" + e.getMessage(), e);
        }
    }
}
