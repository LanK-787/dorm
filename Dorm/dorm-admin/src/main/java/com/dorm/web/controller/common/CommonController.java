package com.dorm.web.controller.common;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.dorm.common.config.RuoYiConfig;
import com.dorm.common.constant.Constants;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.utils.StringUtils;
import com.dorm.common.utils.file.FileUploadUtils;
import com.dorm.common.utils.file.FileUtils;
import com.dorm.framework.config.ServerConfig;
import io.minio.*;
import java.io.ByteArrayInputStream;
import java.security.MessageDigest;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 通用请求处理
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/common")
public class CommonController
{
    private static final Logger log = LoggerFactory.getLogger(CommonController.class);

    @Autowired
    private ServerConfig serverConfig;

    @Autowired
    private MinioClient minioClient;
    
    @Value("${minio.bucketName}")
    private String bucket;
    
    @Value("${minio.url}")
    private String minioUrl;
    
    // 用于存储文件MD5与文件路径的映射
    private static final ConcurrentHashMap<String, String> fileHashMap = new ConcurrentHashMap<>();
    // 用于存储文件引用计数
    private static final ConcurrentHashMap<String, AtomicInteger> fileRefCount = new ConcurrentHashMap<>();

    private static final String FILE_DELIMETER = ",";

    /**
     * 计算文件的MD5值
     */
    private String calculateMD5(byte[] fileData) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] hash = md.digest(fileData);
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    /**
     * 通用下载请求
     * 
     * @param fileName 文件名称
     * @param delete 是否删除
     */
    @GetMapping("/download")
    public void fileDownload(String fileName, Boolean delete, HttpServletResponse response, HttpServletRequest request)
    {
        try
        {
            if (!FileUtils.checkAllowDownload(fileName))
            {
                throw new Exception(StringUtils.format("文件名称({})非法，不允许下载。 ", fileName));
            }
            String realFileName = System.currentTimeMillis() + fileName.substring(fileName.indexOf("_") + 1);
            String filePath = RuoYiConfig.getDownloadPath() + fileName;

            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, realFileName);
            FileUtils.writeBytes(filePath, response.getOutputStream());
            if (delete)
            {
                FileUtils.deleteFile(filePath);
            }
        }
        catch (Exception e)
        {
            log.error("下载文件失败", e);
        }
    }

    /**
     * 文件上传（支持MinIO）
     */
    @PostMapping("/upload")
    public AjaxResult uploadFile(MultipartFile file) throws Exception {
        if (file.isEmpty()) {
            return AjaxResult.error("上传文件不能为空");
        }
        
        try {
            byte[] fileData = file.getBytes();
            String md5Hash = calculateMD5(fileData);
            String fileName;
            String objectName;
            
            // 检查文件是否已存在
            if (fileHashMap.containsKey(md5Hash)) {
                // 文件已存在，增加引用计数
                objectName = fileHashMap.get(md5Hash);
                fileRefCount.get(md5Hash).incrementAndGet();
                log.info("文件已存在，增加引用计数: {}", objectName);
            } else {
                // 生成新的文件名
                fileName = FileUploadUtils.extractFilename(file);
                objectName = FileUploadUtils.getPathFileName(RuoYiConfig.getUploadPath(), fileName);
                
                // 上传到MinIO
                try (ByteArrayInputStream bais = new ByteArrayInputStream(fileData)) {
                    minioClient.putObject(PutObjectArgs.builder()
                            .bucket(bucket)
                            .object(objectName)
                            .stream(bais, fileData.length, -1)
                            .contentType(file.getContentType())
                            .build());
                }
                
                // 保存文件哈希和引用计数
                fileHashMap.put(md5Hash, objectName);
                fileRefCount.put(md5Hash, new AtomicInteger(1));
                log.info("文件上传成功: {}", objectName);
            }
            
            // 构建文件访问URL
            String url = minioUrl + "/" + bucket + "/" + objectName;
            
            // 返回上传结果
            AjaxResult ajax = AjaxResult.success();
            ajax.put("url", url);
            ajax.put("fileName", objectName);
            ajax.put("newFileName", FileUtils.getName(objectName));
            ajax.put("originalFilename", file.getOriginalFilename());
            
            return ajax;
        } catch (Exception e) {
            log.error("文件上传失败", e);
            return AjaxResult.error("文件上传失败：" + e.getMessage());
        }
    }

    /**
     * 通用上传请求（多个）
     */
    @PostMapping("/uploads")
    public AjaxResult uploadFiles(List<MultipartFile> files) throws Exception
    {
        try
        {
            // 上传文件路径
            String filePath = RuoYiConfig.getUploadPath();
            List<String> urls = new ArrayList<String>();
            List<String> fileNames = new ArrayList<String>();
            List<String> newFileNames = new ArrayList<String>();
            List<String> originalFilenames = new ArrayList<String>();
            for (MultipartFile file : files)
            {
                // 上传并返回新文件名称
                String fileName = FileUploadUtils.upload(filePath, file);
                String url = serverConfig.getUrl() + fileName;
                urls.add(url);
                fileNames.add(fileName);
                newFileNames.add(FileUtils.getName(fileName));
                originalFilenames.add(file.getOriginalFilename());
            }
            AjaxResult ajax = AjaxResult.success();
            ajax.put("urls", StringUtils.join(urls, FILE_DELIMETER));
            ajax.put("fileNames", StringUtils.join(fileNames, FILE_DELIMETER));
            ajax.put("newFileNames", StringUtils.join(newFileNames, FILE_DELIMETER));
            ajax.put("originalFilenames", StringUtils.join(originalFilenames, FILE_DELIMETER));
            return ajax;
        }
        catch (Exception e)
        {
            return AjaxResult.error(e.getMessage());
        }
    }

    /**
     * 本地资源通用下载
     */
    @GetMapping("/download/resource")
    public void resourceDownload(String resource, HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        try
        {
            if (!FileUtils.checkAllowDownload(resource))
            {
                throw new Exception(StringUtils.format("资源文件({})非法，不允许下载。 ", resource));
            }
            // 本地资源路径
            String localPath = RuoYiConfig.getProfile();
            // 数据库资源地址
            String downloadPath = localPath + StringUtils.substringAfter(resource, Constants.RESOURCE_PREFIX);
            // 下载名称
            String downloadName = StringUtils.substringAfterLast(downloadPath, "/");
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, downloadName);
            FileUtils.writeBytes(downloadPath, response.getOutputStream());
        }
        catch (Exception e)
        {
            log.error("下载文件失败", e);
        }
    }

    /**
     * 自定义 Minio 服务器上传请求
     */
    @PostMapping("/uploadMinio")
    public AjaxResult uploadFileMinio(MultipartFile file) throws Exception
    {
        try
        {
            // 上传并返回新文件名称
            String fileName = FileUploadUtils.uploadMinio(file);
            AjaxResult ajax = AjaxResult.success();
            ajax.put("url", fileName);
            ajax.put("fileName", fileName);
            ajax.put("newFileName", FileUtils.getName(fileName));
            ajax.put("originalFilename", file.getOriginalFilename());
            return ajax;
        }
        catch (Exception e)
        {
            return AjaxResult.error(e.getMessage());
        }
    }

    /**
     * 删除文件
     */
    @DeleteMapping("/file/{md5Hash}")
    public AjaxResult deleteFile(@PathVariable String md5Hash) {
        try {
            if (!fileHashMap.containsKey(md5Hash)) {
                return AjaxResult.error("文件不存在");
            }
            
            // 减少引用计数
            AtomicInteger refCount = fileRefCount.get(md5Hash);
            int currentCount = refCount.decrementAndGet();
            
            // 如果引用计数为0，则删除文件
            if (currentCount == 0) {
                String objectName = fileHashMap.get(md5Hash);
                minioClient.removeObject(RemoveObjectArgs.builder()
                        .bucket(bucket)
                        .object(objectName)
                        .build());
                
                // 清理映射
                fileHashMap.remove(md5Hash);
                fileRefCount.remove(md5Hash);
                log.info("文件已删除: {}", objectName);
            }
            
            return AjaxResult.success();
        } catch (Exception e) {
            log.error("文件删除失败", e);
            return AjaxResult.error("文件删除失败：" + e.getMessage());
        }
    }
}
