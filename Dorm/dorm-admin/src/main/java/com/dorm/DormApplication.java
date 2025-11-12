package com.dorm;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 启动程序
 *
 * @author 王新瑜
 */
@EnableAsync
@EnableScheduling
@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class }, 
    scanBasePackages = {"com.dorm"})
public class DormApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(DormApplication.class, args);
        System.out.println(
                        "╔═════════════════════════════════════════╗\n" +
                        "║ ██████╗  ██████╗ ██████╗ ███╗   ███╗    ║\n" +
                        "║ ██╔══██╗██╔═══██╗██╔══██╗████╗ ████║    ║\n" +
                        "║ ██║  ██║██║   ██║██████╔╝██╔████╔██║    ║\n" +
                        "║ ██║  ██║██║   ██║██╔══██╗██║╚██╔╝██║    ║\n" +
                        "║ ███████║╚██████╔╝██║  ██║██║ ╚═╝ ██║    ║\n" +
                        "║ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝    ║\n" +
                        "║                                         ║\n" +
                        "║          宿舍管理系统启动成功               ║\n" +
                        "╚═════════════════════════════════════════╝"
        );
    }
}
