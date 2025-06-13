// 应用配置
const config = {
  // API基础URL
  baseUrl: process.env.NODE_ENV === 'development' 
    ? 'http://localhost:8080'  // 开发环境
    : 'https://your-production-domain.com',  // 生产环境
  
  // 图片基础URL
  imageBaseUrl: process.env.NODE_ENV === 'development' 
    ? 'http://localhost:8080'
    : 'https://your-production-domain.com',
    
  // 轮播图配置
  swiper: {
    autoplay: true,
    interval: 4000,
    duration: 500,
    circular: true
  },
  
  // 分页配置
  pagination: {
    pageSize: 10,
    maxPageSize: 50
  }
}

export default config
