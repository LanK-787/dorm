/**
 * 高德地图API工具类
 * 提供地图初始化、定位、地址解析等功能
 * 支持错误处理和自动降级策略
 */

// 高德地图API配置
export const AMAP_CONFIG = {
    key: '33907d64d70f93015b2c1c3b709e088d', // 您的API Key
    version: '2.0',
    plugins: [
        'AMap.Geolocation',
        'AMap.Geocoder',
        'AMap.Scale',
        'AMap.ToolBar',
        'AMap.GeometryUtil'
    ]
}

// 学校配置 - 请根据实际学校位置修改
export const SCHOOL_CONFIG = {
    name: '学校',
    // 学校中心点坐标（用于地图初始化）
    latitude: 27.93225,    // 学校中心纬度
    longitude: 120.9545,   // 学校中心经度
    // 多边形围栏配置
    polygon: {
        // 学校边界多边形坐标点（实际学校边界坐标）
        // 格式：[[经度, 纬度], [经度, 纬度], ...]
        // 注意：坐标点需要按顺序连接形成封闭多边形
        path: [
            [120.95622444326762, 27.937996839819032],  // 西北角
            [120.96389289439514, 27.93309859722805],  // 东北角
            [120.95833940825833, 27.92652588486229],  // 东南角
            [120.95094380290516, 27.931315920814626],  // 西南角
            [120.95622444326762, 27.937996839819032]   // 回到起点形成封闭图形
        ],
        // 多边形样式配置
        strokeColor: '#1890ff',
        strokeWeight: 2,
        strokeOpacity: 0.8,
        fillColor: '#1890ff',
        fillOpacity: 0.2
    },
    // 保留原有圆形围栏配置作为备用
    radius: 500            // 圆形围栏半径(米) - 备用方案
}

/**
 * 高德地图SDK加载状态
 */
let mapScriptLoaded = false
let mapLoadingPromise = null

/**
 * 加载高德地图API
 * @returns {Promise<Object>} AMap对象
 */
export function loadAmapScript() {
    // 如果已经加载过，直接返回
    if (window.AMap && mapScriptLoaded) {
        return Promise.resolve(window.AMap)
    }

    // 如果正在加载，返回同一个Promise
    if (mapLoadingPromise) {
        return mapLoadingPromise
    }

    mapLoadingPromise = new Promise((resolve, reject) => {
        const script = document.createElement('script')
        script.src = `https://webapi.amap.com/maps?v=${AMAP_CONFIG.version}&key=${AMAP_CONFIG.key}&plugin=${AMAP_CONFIG.plugins.join(',')}`

        script.onload = () => {
            if (window.AMap) {
                mapScriptLoaded = true
                console.log('高德地图API加载成功')
                resolve(window.AMap)
            } else {
                console.error('高德地图API加载异常')
                reject(new Error('高德地图API权限异常'))
            }
        }

        script.onerror = (error) => {
            console.error('高德地图加载失败:', error)
            reject(new Error('高德地图加载失败'))
        }

        // 监听API Key权限错误和类型错误
        const handleErrors = (event) => {
            if (event.message) {
                // API Key权限错误
                if (event.message.includes('USERKEY_PLAT_NOMATCH')) {
                    console.error('高德地图API Key权限错误: USERKEY_PLAT_NOMATCH')
                    console.error('请在高德开放平台控制台中为您的API Key添加Web端(JSAPI)权限')
                    window.removeEventListener('error', handleErrors)
                    reject(new Error('API Key权限不匹配，请配置Web端权限'))
                }
                // 类型错误（Unimplemented type）
                else if (event.message.includes('Unimplemented type')) {
                    console.warn('高德地图样式解析错误，将使用简化配置:', event.message)
                    // 不拒绝Promise，继续使用地图但采用更简单的配置
                }
            }
        }

        window.addEventListener('error', handleErrors)

        // 清理监听器的定时器
        setTimeout(() => {
            window.removeEventListener('error', handleErrors)
        }, 10000)

        document.head.appendChild(script)
    })

    return mapLoadingPromise
}

/**
 * 初始化地图实例
 * @param {string} containerId 地图容器ID
 * @param {Object} options 地图配置选项
 * @returns {Promise<Object>} 地图实例
 */
export async function initAmapInstance(containerId, options = {}) {
    try {
        const AMap = await loadAmapScript()

        // 使用更简化和兼容的配置，避免“Unimplemented type”错误
        const defaultOptions = {
            zoom: 16,
            center: [SCHOOL_CONFIG.longitude, SCHOOL_CONFIG.latitude],
            // 使用基础地图样式，避免复杂样式解析问题
            mapStyle: 'amap://styles/whitesmoke',  // 改用简单样式
            viewMode: '2D',
            showLabel: true,
            resizeEnable: true,
            // 添加更多兼容性配置
            rotateEnable: false,
            pitchEnable: false,
            buildingAnimation: false,  // 关闭建筑动画，减少错误可能
            expandZoomRange: false,    // 不扩展缩放范围
            dragEnable: true,
            zoomEnable: true,
            doubleClickZoom: false,    // 关闭双击缩放
            keyboardEnable: false,     // 关闭键盘操作
            jogEnable: false,          // 关闭惯性拖拽
            scrollWheel: true,         // 允许滚轮缩放
            touchZoom: true            // 允许触摸缩放
        }

        const mapInstance = new AMap.Map(containerId, { ...defaultOptions, ...options })

        // 添加地图控件（简化版）
        try {
            mapInstance.addControl(new AMap.Scale({
                position: 'LB'  // 左下角
            }))
        } catch (error) {
            console.warn('添加比例尺控件失败:', error)
        }

        // 地图加载完成事件
        mapInstance.on('complete', () => {
            console.log('高德地图初始化完成')
        })

        return mapInstance
    } catch (error) {
        console.error('初始化高德地图失败:', error)
        throw error
    }
}

/**
 * 高德地图定位
 * @param {Object} options 定位配置选项
 * @returns {Promise<Object>} 定位结果
 */
export function getAmapLocation(options = {}) {
    return new Promise((resolve, reject) => {
        loadAmapScript().then(AMap => {
            const geolocation = new AMap.Geolocation({
                enableHighAccuracy: true,
                timeout: 15000,
                convert: true, // 自动转换为高德坐标系
                showButton: false,
                showMarker: false,
                showCircle: false,
                ...options
            })

            geolocation.getCurrentPosition((status, result) => {
                if (status === 'complete') {
                    resolve({
                        latitude: result.position.lat,
                        longitude: result.position.lng,
                        accuracy: result.accuracy,
                        address: result.formattedAddress || '',
                        addressComponent: result.addressComponent || {},
                        timestamp: Date.now()
                    })
                } else {
                    const errorInfo = {
                        code: result.info || 'UNKNOWN_ERROR',
                        message: result.message || '定位失败'
                    }
                    console.error('高德地图定位失败:', errorInfo)
                    reject(errorInfo)
                }
            })
        }).catch(error => {
            console.error('高德地图定位失败:', error)
            reject(error)
        })
    })
}

/**
 * 地址逆解析
 * @param {number} lng 经度
 * @param {number} lat 纬度
 * @returns {Promise<string>} 地址信息
 */
export function getAddressByLocation(lng, lat) {
    return new Promise((resolve, reject) => {
        loadAmapScript().then(AMap => {
            const geocoder = new AMap.Geocoder({
                radius: 1000,
                extensions: 'all'
            })

            geocoder.getAddress([lng, lat], (status, result) => {
                if (status === 'complete' && result.info === 'OK') {
                    const address = result.regeocode.formattedAddress
                    resolve(address)
                } else {
                    reject(new Error('地址解析失败'))
                }
            })
        }).catch(reject)
    })
}

/**
 * 计算两点距离
 * @param {number} lng1 起点经度
 * @param {number} lat1 起点纬度
 * @param {number} lng2 终点经度
 * @param {number} lat2 终点纬度
 * @returns {number} 距离(米)
 */
export function calculateDistance(lng1, lat1, lng2, lat2) {
    try {
        // 验证输入参数
        if (typeof lng1 !== 'number' || typeof lat1 !== 'number' ||
            typeof lng2 !== 'number' || typeof lat2 !== 'number' ||
            isNaN(lng1) || isNaN(lat1) || isNaN(lng2) || isNaN(lat2)) {
            console.warn('坐标参数无效:', { lng1, lat1, lng2, lat2 })
            return 0
        }

        // 优先使用高德地图的距离计算方法
        if (window.AMap && window.AMap.GeometryUtil && window.AMap.GeometryUtil.distance) {
            try {
                const amapDistance = window.AMap.GeometryUtil.distance([lng1, lat1], [lng2, lat2])
                if (typeof amapDistance === 'number' && !isNaN(amapDistance) && amapDistance >= 0) {
                    return amapDistance
                }
            } catch (error) {
                console.warn('高德地图距离计算失败:', error)
            }
        }

        // 备用计算方法 - Haversine公式
        const R = 6371000 // 地球半径（米）
        const dLat = (lat2 - lat1) * Math.PI / 180
        const dLon = (lng2 - lng1) * Math.PI / 180
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2)
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
        const distance = R * c

        // 确保返回值是有效数字
        if (typeof distance === 'number' && !isNaN(distance) && distance >= 0) {
            return distance
        } else {
            console.warn('距离计算结果异常:', distance)
            return 0
        }
    } catch (error) {
        console.error('距离计算错误:', error)
        return 0
    }
}

/**
 * 坐标转换：WGS84转GCJ02
 * @param {number} lng 经度
 * @param {number} lat 纬度
 * @returns {Object} 转换后的坐标
 */
export function wgs84ToGcj02(lng, lat) {
    const PI = 3.1415926535897932384626
    const ee = 0.00669342162296594323
    const a = 6378245.0

    const transformLat = (lng, lat) => {
        let ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat + 0.2 * Math.sqrt(Math.abs(lng))
        ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
        ret += (20.0 * Math.sin(lat * PI) + 40.0 * Math.sin(lat / 3.0 * PI)) * 2.0 / 3.0
        ret += (160.0 * Math.sin(lat / 12.0 * PI) + 320 * Math.sin(lat * PI / 30.0)) * 2.0 / 3.0
        return ret
    }

    const transformLng = (lng, lat) => {
        let ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * Math.sqrt(Math.abs(lng))
        ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
        ret += (20.0 * Math.sin(lng * PI) + 40.0 * Math.sin(lng / 3.0 * PI)) * 2.0 / 3.0
        ret += (150.0 * Math.sin(lng / 12.0 * PI) + 300.0 * Math.sin(lng / 30.0 * PI)) * 2.0 / 3.0
        return ret
    }

    const dlat = transformLat(lng - 105.0, lat - 35.0)
    const dlng = transformLng(lng - 105.0, lat - 35.0)
    const radlat = lat / 180.0 * PI
    let magic = Math.sin(radlat)
    magic = 1 - ee * magic * magic
    const sqrtmagic = Math.sqrt(magic)
    const dlat_result = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI)
    const dlng_result = (dlng * 180.0) / (a / sqrtmagic * Math.cos(radlat) * PI)

    return {
        longitude: lng + dlng_result,
        latitude: lat + dlat_result
    }
}

/**
 * 创建地图标记
 * @param {Object} map 地图实例
 * @param {Object} options 标记配置
 * @returns {Object} 标记实例
 */
export function createMarker(map, options = {}) {
    if (!window.AMap || !map) return null

    const defaultOptions = {
        position: [0, 0],
        title: '',
        icon: null,
        anchor: 'center'
    }

    const markerOptions = { ...defaultOptions, ...options }

    try {
        const marker = new window.AMap.Marker(markerOptions)

        if (map) {
            marker.setMap(map)
        }

        return marker
    } catch (error) {
        console.error('创建地图标记失败:', error)
        // 返回null，让上层代码处理降级
        return null
    }
}

/**
 * 创建圆形围栏
 * @param {Object} map 地图实例
 * @param {Object} options 围栏配置
 * @returns {Object} 围栏实例
 */
export function createCircle(map, options = {}) {
    if (!window.AMap || !map) return null

    const defaultOptions = {
        center: [0, 0],
        radius: 500,
        strokeColor: '#1890ff',
        strokeWeight: 2,
        strokeOpacity: 0.8,
        fillColor: '#1890ff',
        fillOpacity: 0.2
    }

    const circleOptions = { ...defaultOptions, ...options }

    try {
        const circle = new window.AMap.Circle(circleOptions)

        if (map) {
            circle.setMap(map)
        }

        return circle
    } catch (error) {
        console.error('创建地图围栏失败:', error)
        // 返回null，让上层代码处理降级
        return null
    }
}

/**
 * 创建多边形围栏
 * @param {Object} map 地图实例
 * @param {Object} options 多边形配置
 * @returns {Object} 多边形实例
 */
export function createPolygon(map, options = {}) {
    if (!window.AMap || !map) return null

    const defaultOptions = {
        path: [],
        strokeColor: '#1890ff',
        strokeWeight: 2,
        strokeOpacity: 0.8,
        fillColor: '#1890ff',
        fillOpacity: 0.2
    }

    const polygonOptions = { ...defaultOptions, ...options }

    try {
        const polygon = new window.AMap.Polygon(polygonOptions)

        if (map) {
            polygon.setMap(map)
        }

        return polygon
    } catch (error) {
        console.error('创建多边形围栏失败:', error)
        return null
    }
}

/**
 * 判断点是否在多边形内部
 * @param {number} lng 经度
 * @param {number} lat 纬度
 * @param {Array} polygonPath 多边形路径坐标数组
 * @returns {boolean} 是否在多边形内部
 */
export function isPointInPolygon(lng, lat, polygonPath) {
    try {
        // 验证输入参数
        if (typeof lng !== 'number' || typeof lat !== 'number' ||
            !Array.isArray(polygonPath) || polygonPath.length < 3) {
            console.warn('多边形判断参数无效:', { lng, lat, polygonPath })
            return false
        }

        // 优先使用高德地图的多边形判断方法
        if (window.AMap && window.AMap.GeometryUtil && window.AMap.GeometryUtil.isPointInPolygon) {
            try {
                const point = new window.AMap.LngLat(lng, lat)
                const polygon = polygonPath.map(coord => new window.AMap.LngLat(coord[0], coord[1]))
                return window.AMap.GeometryUtil.isPointInPolygon(point, polygon)
            } catch (error) {
                console.warn('高德地图多边形判断失败，使用备用算法:', error)
            }
        }

        // 备用算法：Ray Casting Algorithm (射线投射算法)
        let inside = false
        const x = lng
        const y = lat

        for (let i = 0, j = polygonPath.length - 1; i < polygonPath.length; j = i++) {
            const xi = polygonPath[i][0]
            const yi = polygonPath[i][1]
            const xj = polygonPath[j][0]
            const yj = polygonPath[j][1]

            if (((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)) {
                inside = !inside
            }
        }

        return inside
    } catch (error) {
        console.error('多边形判断错误:', error)
        return false
    }
}

/**
 * 计算点到多边形边界的最短距离
 * @param {number} lng 经度
 * @param {number} lat 纬度
 * @param {Array} polygonPath 多边形路径坐标数组
 * @returns {number} 距离(米)
 */
export function calculateDistanceToPolygon(lng, lat, polygonPath) {
    try {
        // 验证输入参数
        if (typeof lng !== 'number' || typeof lat !== 'number' ||
            !Array.isArray(polygonPath) || polygonPath.length < 3) {
            console.warn('多边形距离计算参数无效:', { lng, lat, polygonPath })
            return 0
        }

        let minDistance = Infinity

        // 计算点到多边形每条边的最短距离
        for (let i = 0; i < polygonPath.length - 1; i++) {
            const p1 = polygonPath[i]
            const p2 = polygonPath[i + 1]

            // 计算点到线段的距离
            const distance = calculateDistanceToLineSegment(lng, lat, p1[0], p1[1], p2[0], p2[1])
            minDistance = Math.min(minDistance, distance)
        }

        return minDistance === Infinity ? 0 : minDistance
    } catch (error) {
        console.error('多边形距离计算错误:', error)
        return 0
    }
}

/**
 * 计算点到线段的最短距离
 * @param {number} px 点的经度
 * @param {number} py 点的纬度
 * @param {number} x1 线段起点经度
 * @param {number} y1 线段起点纬度
 * @param {number} x2 线段终点经度
 * @param {number} y2 线段终点纬度
 * @returns {number} 距离(米)
 */
function calculateDistanceToLineSegment(px, py, x1, y1, x2, y2) {
    // 线段长度的平方
    const A = px - x1
    const B = py - y1
    const C = x2 - x1
    const D = y2 - y1

    const dot = A * C + B * D
    const lenSq = C * C + D * D

    if (lenSq === 0) {
        // 线段退化为点
        return calculateDistance(px, py, x1, y1)
    }

    let param = dot / lenSq

    let xx, yy

    if (param < 0) {
        xx = x1
        yy = y1
    } else if (param > 1) {
        xx = x2
        yy = y2
    } else {
        xx = x1 + param * C
        yy = y1 + param * D
    }

    return calculateDistance(px, py, xx, yy)
}

/**
 * 检查学校围栏类型并进行相应的位置验证
 * @param {number} lng 经度
 * @param {number} lat 纬度
 * @returns {Object} 验证结果 {isInRange: boolean, distance: number, type: string}
 */
export function checkSchoolRange(lng, lat) {
    try {
        // 优先使用多边形围栏
        if (SCHOOL_CONFIG.polygon && SCHOOL_CONFIG.polygon.path && SCHOOL_CONFIG.polygon.path.length >= 3) {
            const isInPolygon = isPointInPolygon(lng, lat, SCHOOL_CONFIG.polygon.path)
            const distance = isInPolygon ? 0 : calculateDistanceToPolygon(lng, lat, SCHOOL_CONFIG.polygon.path)

            return {
                isInRange: isInPolygon,
                distance: distance,
                type: 'polygon',
                message: isInPolygon ? '在学校围栏内' : `距离学校围栏 ${distance.toFixed(0)}米`
            }
        }
        // 降级使用圆形围栏
        else if (SCHOOL_CONFIG.radius) {
            const distance = calculateDistance(lng, lat, SCHOOL_CONFIG.longitude, SCHOOL_CONFIG.latitude)
            const isInRange = distance <= SCHOOL_CONFIG.radius

            return {
                isInRange: isInRange,
                distance: distance,
                type: 'circle',
                message: isInRange ? '在学校范围内' : `距离学校 ${distance.toFixed(0)}米`
            }
        }

        return {
            isInRange: false,
            distance: 0,
            type: 'none',
            message: '未配置学校围栏'
        }
    } catch (error) {
        console.error('学校围栏检查失败:', error)
        return {
            isInRange: false,
            distance: 0,
            type: 'error',
            message: '围栏检查失败'
        }
    }
}

/**
 * 检查高德地图API是否可用
 * @returns {boolean} 是否可用
 */
export function isAmapAvailable() {
    return !!(window.AMap && mapScriptLoaded)
}

/**
 * 安全初始化地图（带降级方案）
 * @param {string} containerId 地图容器ID
 * @param {Object} options 配置选项
 * @returns {Promise<Object>} 地图实例
 */
export async function safeInitAmapInstance(containerId, options = {}) {
    try {
        // 首先尝试正常初始化
        return await initAmapInstance(containerId, options)
    } catch (error) {
        console.warn('正常地图初始化失败，尝试简化配置:', error)

        try {
            // 使用最简化的配置重试
            const AMap = await loadAmapScript()

            const fallbackOptions = {
                zoom: 16,
                center: [SCHOOL_CONFIG.longitude, SCHOOL_CONFIG.latitude],
                // 使用最基础的配置，不设置任何样式
                viewMode: '2D',
                resizeEnable: true,
                // 只保留最基础的功能
                dragEnable: true,
                zoomEnable: true
            }

            const mapInstance = new AMap.Map(containerId, { ...fallbackOptions, ...options })
            console.log('简化配置地图初始化成功')
            return mapInstance

        } catch (fallbackError) {
            console.error('简化配置也失败:', fallbackError)
            throw new Error('高德地图初始化完全失败，请检查API Key配置')
        }
    }
}