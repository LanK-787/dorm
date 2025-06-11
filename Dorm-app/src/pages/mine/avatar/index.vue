<template>
	<view class="container">
		<view class="page-body uni-content-info">
			<view class='cropper-content'>
				<view v-if="isShowImg" class="uni-corpper" :style="'width:'+cropperInitW+'px;height:'+cropperInitH+'px;background:#000'">
					<view class="uni-corpper-content" :style="'width:'+cropperW+'px;height:'+cropperH+'px;left:'+cropperL+'px;top:'+cropperT+'px'">
						<image :src="imageSrc" :style="'width:'+cropperW+'px;height:'+cropperH+'px'"></image>
						<view class="uni-corpper-crop-box" @touchstart.stop="contentStartMove" @touchmove.stop="contentMoveing" @touchend.stop="contentTouchEnd"
						    :style="'left:'+cutL+'px;top:'+cutT+'px;right:'+cutR+'px;bottom:'+cutB+'px'">
							<view class="uni-cropper-view-box">
								<view class="uni-cropper-dashed-h"></view>
								<view class="uni-cropper-dashed-v"></view>
								<view class="uni-cropper-line-t" data-drag="top" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-line-r" data-drag="right" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-line-b" data-drag="bottom" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-line-l" data-drag="left" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-point point-t" data-drag="top" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-point point-tr" data-drag="topTight"></view>
								<view class="uni-cropper-point point-r" data-drag="right" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-point point-rb" data-drag="rightBottom" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-point point-b" data-drag="bottom" @touchstart.stop="dragStart" @touchmove.stop="dragMove" @touchend.stop="dragEnd"></view>
								<view class="uni-cropper-point point-bl" data-drag="bottomLeft"></view>
								<view class="uni-cropper-point point-l" data-drag="left" @touchstart.stop="dragStart" @touchmove.stop="dragMove"></view>
								<view class="uni-cropper-point point-lt" data-drag="leftTop"></view>
							</view>
						</view>
					</view>
				</view>
			</view>
			<view class='cropper-config'>
				<button type="primary reverse" @click="getImage" style='margin-top: 30rpx;'> 选择头像 </button>
				<button type="warn" @click="getImageInfo" style='margin-top: 30rpx;'> 提交 </button>
			</view>
			<canvas canvas-id="myCanvas" :style="'position:absolute;border: 1px solid red; width:'+imageW+'px;height:'+imageH+'px;top:-9999px;left:-9999px;'"></canvas>
		</view>
	</view>
</template>

<script setup>
  import { ref, reactive, onMounted } from 'vue'
  import useUserStore from '@/store/modules/user'
  import { uploadAvatar } from "@/api/system/user"

  const userStore = useUserStore()

  // 系统信息和常量
  const sysInfo = uni.getSystemInfoSync()
  const SCREEN_WIDTH = sysInfo.screenWidth
  const PR = sysInfo.pixelRatio // dpi
  const DRAFG_MOVE_RATIO = 1 // 移动时候的比例
  let INIT_DRAG_POSITION = 100 // 初始化屏幕宽度和裁剪区域的宽度之差（需要动态修改）
  const DRAW_IMAGE_W = sysInfo.screenWidth // 设置生成的图片宽度

  // 触摸和拖拽相关变量
  let PAGE_X, PAGE_Y // 手按下的位置
  let T_PAGE_X, T_PAGE_Y // 手移动时的位置
  let CUT_L, CUT_T, CUT_R, CUT_B // 拖拽元素的位置和尺寸
  let CUT_W, CUT_H // 拖拽元素的宽高
  let IMG_RATIO, IMG_REAL_W, IMG_REAL_H // 图片相关变量

  // 响应式数据
  const imageSrc = ref(userStore.avatar)
  const isShowImg = ref(false)

  // 初始化的宽高
  const cropperInitW = ref(SCREEN_WIDTH)
  const cropperInitH = ref(SCREEN_WIDTH)

  // 动态的宽高
  const cropperW = ref(SCREEN_WIDTH)
  const cropperH = ref(SCREEN_WIDTH)

  // 动态的left top值
  const cropperL = ref(0)
  const cropperT = ref(0)

  const transL = ref(0)
  const transT = ref(0)

  // 图片缩放值
  const scaleP = ref(0)
  const imageW = ref(0)
  const imageH = ref(0)

  // 裁剪框 宽高
  const cutL = ref(0)
  const cutT = ref(0)
  const cutB = ref(SCREEN_WIDTH)
  const cutR = ref('100%')
  const qualityWidth = ref(DRAW_IMAGE_W)
  const innerAspectRadio = ref(DRAFG_MOVE_RATIO)
  // 辅助函数 - 设置数据（替代Vue 2的setData）
  const setData = (obj) => {
    Object.keys(obj).forEach(key => {
      switch(key) {
        case 'imageSrc':
          imageSrc.value = obj[key]
          break
        case 'isShowImg':
          isShowImg.value = obj[key]
          break
        case 'cropperW':
          cropperW.value = obj[key]
          break
        case 'cropperH':
          cropperH.value = obj[key]
          break
        case 'cropperL':
          cropperL.value = obj[key]
          break
        case 'cropperT':
          cropperT.value = obj[key]
          break
        case 'cutL':
          cutL.value = obj[key]
          break
        case 'cutT':
          cutT.value = obj[key]
          break
        case 'cutR':
          cutR.value = obj[key]
          break
        case 'cutB':
          cutB.value = obj[key]
          break
        case 'imageW':
          imageW.value = obj[key]
          break
        case 'imageH':
          imageH.value = obj[key]
          break
        case 'scaleP':
          scaleP.value = obj[key]
          break
        case 'qualityWidth':
          qualityWidth.value = obj[key]
          break
        case 'innerAspectRadio':
          innerAspectRadio.value = obj[key]
          break
      }
    })
  }

  const getImage = () => {
    uni.chooseImage({
      success: function (res) {
        setData({
          imageSrc: res.tempFilePaths[0],
        })
        loadImage()
      },
    })
  }

  const loadImage = () => {
    uni.getImageInfo({
      src: imageSrc.value,
      success: function success(res) {
        IMG_RATIO = 1 / 1
        if (IMG_RATIO >= 1) {
          IMG_REAL_W = SCREEN_WIDTH
          IMG_REAL_H = SCREEN_WIDTH / IMG_RATIO
        } else {
          IMG_REAL_W = SCREEN_WIDTH * IMG_RATIO
          IMG_REAL_H = SCREEN_WIDTH
        }
        let minRange = IMG_REAL_W > IMG_REAL_H ? IMG_REAL_W : IMG_REAL_H
        INIT_DRAG_POSITION = minRange > INIT_DRAG_POSITION ? INIT_DRAG_POSITION : minRange
        // 根据图片的宽高显示不同的效果   保证图片可以正常显示
        if (IMG_RATIO >= 1) {
          let cutTVal = Math.ceil((SCREEN_WIDTH / IMG_RATIO - (SCREEN_WIDTH / IMG_RATIO - INIT_DRAG_POSITION)) / 2)
          let cutBVal = cutTVal
          let cutLVal = Math.ceil((SCREEN_WIDTH - SCREEN_WIDTH + INIT_DRAG_POSITION) / 2)
          let cutRVal = cutLVal
          setData({
            cropperW: SCREEN_WIDTH,
            cropperH: SCREEN_WIDTH / IMG_RATIO,
            // 初始化left right
            cropperL: Math.ceil((SCREEN_WIDTH - SCREEN_WIDTH) / 2),
            cropperT: Math.ceil((SCREEN_WIDTH - SCREEN_WIDTH / IMG_RATIO) / 2),
            cutL: cutLVal,
            cutT: cutTVal,
            cutR: cutRVal,
            cutB: cutBVal,
            // 图片缩放值
            imageW: IMG_REAL_W,
            imageH: IMG_REAL_H,
            scaleP: IMG_REAL_W / SCREEN_WIDTH,
            qualityWidth: DRAW_IMAGE_W,
            innerAspectRadio: IMG_RATIO
          })
        } else {
          let cutLVal = Math.ceil((SCREEN_WIDTH * IMG_RATIO - (SCREEN_WIDTH * IMG_RATIO)) / 2)
          let cutRVal = cutLVal
          let cutTVal = Math.ceil((SCREEN_WIDTH - INIT_DRAG_POSITION) / 2)
          let cutBVal = cutTVal
          setData({
            cropperW: SCREEN_WIDTH * IMG_RATIO,
            cropperH: SCREEN_WIDTH,
            // 初始化left right
            cropperL: Math.ceil((SCREEN_WIDTH - SCREEN_WIDTH * IMG_RATIO) / 2),
            cropperT: Math.ceil((SCREEN_WIDTH - SCREEN_WIDTH) / 2),
            cutL: cutLVal,
            cutT: cutTVal,
            cutR: cutRVal,
            cutB: cutBVal,
            // 图片缩放值
            imageW: IMG_REAL_W,
            imageH: IMG_REAL_H,
            scaleP: IMG_REAL_W / SCREEN_WIDTH,
            qualityWidth: DRAW_IMAGE_W,
            innerAspectRadio: IMG_RATIO
          })
        }
        setData({
          isShowImg: true
        })
        uni.hideLoading()
      }
    })
  }
  // 拖动时候触发的touchStart事件
  const contentStartMove = (e) => {
    PAGE_X = e.touches[0].pageX
    PAGE_Y = e.touches[0].pageY
  }

  // 拖动时候触发的touchMove事件
  const contentMoveing = (e) => {
    var dragLengthX = (PAGE_X - e.touches[0].pageX) * DRAFG_MOVE_RATIO
    var dragLengthY = (PAGE_Y - e.touches[0].pageY) * DRAFG_MOVE_RATIO
    // 左移
    if (dragLengthX > 0) {
      if (cutL.value - dragLengthX < 0) dragLengthX = cutL.value
    } else {
      if (cutR.value + dragLengthX < 0) dragLengthX = -cutR.value
    }

    if (dragLengthY > 0) {
      if (cutT.value - dragLengthY < 0) dragLengthY = cutT.value
    } else {
      if (cutB.value + dragLengthY < 0) dragLengthY = -cutB.value
    }
    setData({
      cutL: cutL.value - dragLengthX,
      cutT: cutT.value - dragLengthY,
      cutR: cutR.value + dragLengthX,
      cutB: cutB.value + dragLengthY
    })

    PAGE_X = e.touches[0].pageX
    PAGE_Y = e.touches[0].pageY
  }

  const contentTouchEnd = () => {
    // Touch end handler
  }

  // 获取图片
  const getImageInfo = () => {
    uni.showLoading({
      title: '图片生成中...',
    })
    // 将图片写入画布
    const ctx = uni.createCanvasContext('myCanvas')
    ctx.drawImage(imageSrc.value, 0, 0, IMG_REAL_W, IMG_REAL_H)
    ctx.draw(true, () => {
      // 获取画布要裁剪的位置和宽度   均为百分比 * 画布中图片的宽度    保证了在微信小程序中裁剪的图片模糊  位置不对的问题
      var canvasW = ((cropperW.value - cutL.value - cutR.value) / cropperW.value) * IMG_REAL_W
      var canvasH = ((cropperH.value - cutT.value - cutB.value) / cropperH.value) * IMG_REAL_H
      var canvasL = (cutL.value / cropperW.value) * IMG_REAL_W
      var canvasT = (cutT.value / cropperH.value) * IMG_REAL_H
      uni.canvasToTempFilePath({
        x: canvasL,
        y: canvasT,
        width: canvasW,
        height: canvasH,
        destWidth: canvasW,
        destHeight: canvasH,
        quality: 0.5,
        canvasId: 'myCanvas',
        success: function (res) {
          uni.hideLoading()
          let data = {name: 'avatarfile', filePath: res.tempFilePath}
          uploadAvatar(data).then(response => {
            userStore.setAvatar(response.imgUrl)
            uni.showToast({ title: "修改成功", icon: 'success' })
            uni.navigateBack()
          })
        }
      })
    })
  }
  // 设置大小的时候触发的touchStart事件
  const dragStart = (e) => {
    T_PAGE_X = e.touches[0].pageX
    T_PAGE_Y = e.touches[0].pageY
    CUT_L = cutL.value
    CUT_R = cutR.value
    CUT_B = cutB.value
    CUT_T = cutT.value
  }

  // 设置大小的时候触发的touchMove事件
  const dragMove = (e) => {
    var dragType = e.target.dataset.drag
    switch (dragType) {
      case 'right':
        var dragLength = (T_PAGE_X - e.touches[0].pageX) * DRAFG_MOVE_RATIO
        if (CUT_R + dragLength < 0) dragLength = -CUT_R
        setData({
          cutR: CUT_R + dragLength
        })
        break
      case 'left':
        var dragLength = (T_PAGE_X - e.touches[0].pageX) * DRAFG_MOVE_RATIO
        if (CUT_L - dragLength < 0) dragLength = CUT_L
        if ((CUT_L - dragLength) > (cropperW.value - cutR.value)) dragLength = CUT_L - (cropperW.value - cutR.value)
        setData({
          cutL: CUT_L - dragLength
        })
        break
      case 'top':
        var dragLength = (T_PAGE_Y - e.touches[0].pageY) * DRAFG_MOVE_RATIO
        if (CUT_T - dragLength < 0) dragLength = CUT_T
        if ((CUT_T - dragLength) > (cropperH.value - cutB.value)) dragLength = CUT_T - (cropperH.value - cutB.value)
        setData({
          cutT: CUT_T - dragLength
        })
        break
      case 'bottom':
        var dragLength = (T_PAGE_Y - e.touches[0].pageY) * DRAFG_MOVE_RATIO
        if (CUT_B + dragLength < 0) dragLength = -CUT_B
        setData({
          cutB: CUT_B + dragLength
        })
        break
      case 'rightBottom':
        var dragLengthX = (T_PAGE_X - e.touches[0].pageX) * DRAFG_MOVE_RATIO
        var dragLengthY = (T_PAGE_Y - e.touches[0].pageY) * DRAFG_MOVE_RATIO

        if (CUT_B + dragLengthY < 0) dragLengthY = -CUT_B
        if (CUT_R + dragLengthX < 0) dragLengthX = -CUT_R
        let cutBVal = CUT_B + dragLengthY
        let cutRVal = CUT_R + dragLengthX

        setData({
          cutB: cutBVal,
          cutR: cutRVal
        })
        break
      default:
        break
    }
  }

  const dragEnd = () => {
    // Drag end handler
  }

  // 生命周期钩子
  onMounted(() => {
    loadImage()
  })
</script>

<style scoped>
	.cropper-config {
		padding: 20rpx 40rpx;
	}

	.cropper-content {
		min-height: 750rpx;
		width: 100%;
	}

	.uni-corpper {
		position: relative;
		overflow: hidden;
		-webkit-user-select: none;
		-moz-user-select: none;
		-ms-user-select: none;
		user-select: none;
		-webkit-tap-highlight-color: transparent;
		-webkit-touch-callout: none;
		box-sizing: border-box;
	}

	.uni-corpper-content {
		position: relative;
	}

	.uni-corpper-content image {
		display: block;
		width: 100%;
		min-width: 0 !important;
		max-width: none !important;
		height: 100%;
		min-height: 0 !important;
		max-height: none !important;
		image-orientation: 0deg !important;
		margin: 0 auto;
	}

	/* 移动图片效果 */
	.uni-cropper-drag-box {
		position: absolute;
		top: 0;
		right: 0;
		bottom: 0;
		left: 0;
		cursor: move;
		background: rgba(0, 0, 0, 0.6);
		z-index: 1;
	}

	/* 内部的信息 */
	.uni-corpper-crop-box {
		position: absolute;
		background: rgba(255, 255, 255, 0.3);
		z-index: 2;
	}

	.uni-corpper-crop-box .uni-cropper-view-box {
		position: relative;
		display: block;
		width: 100%;
		height: 100%;
		overflow: visible;
		outline: 1rpx solid #69f;
		outline-color: rgba(102, 153, 255, .75)
	}

	/* 横向虚线 */
	.uni-cropper-dashed-h {
		position: absolute;
		top: 33.33333333%;
		left: 0;
		width: 100%;
		height: 33.33333333%;
		border-top: 1rpx dashed rgba(255, 255, 255, 0.5);
		border-bottom: 1rpx dashed rgba(255, 255, 255, 0.5);
	}

	/* 纵向虚线 */
	.uni-cropper-dashed-v {
		position: absolute;
		left: 33.33333333%;
		top: 0;
		width: 33.33333333%;
		height: 100%;
		border-left: 1rpx dashed rgba(255, 255, 255, 0.5);
		border-right: 1rpx dashed rgba(255, 255, 255, 0.5);
	}

	/* 四个方向的线  为了之后的拖动事件*/
	.uni-cropper-line-t {
		position: absolute;
		display: block;
		width: 100%;
		background-color: #69f;
		top: 0;
		left: 0;
		height: 1rpx;
		opacity: 0.1;
		cursor: n-resize;
	}

	.uni-cropper-line-t::before {
		content: '';
		position: absolute;
		top: 50%;
		right: 0rpx;
		width: 100%;
		-webkit-transform: translate3d(0, -50%, 0);
		transform: translate3d(0, -50%, 0);
		bottom: 0;
		height: 41rpx;
		background: transparent;
		z-index: 11;
	}

	.uni-cropper-line-r {
		position: absolute;
		display: block;
		background-color: #69f;
		top: 0;
		right: 0rpx;
		width: 1rpx;
		opacity: 0.1;
		height: 100%;
		cursor: e-resize;
	}

	.uni-cropper-line-r::before {
		content: '';
		position: absolute;
		top: 0;
		left: 50%;
		width: 41rpx;
		-webkit-transform: translate3d(-50%, 0, 0);
		transform: translate3d(-50%, 0, 0);
		bottom: 0;
		height: 100%;
		background: transparent;
		z-index: 11;
	}

	.uni-cropper-line-b {
		position: absolute;
		display: block;
		width: 100%;
		background-color: #69f;
		bottom: 0;
		left: 0;
		height: 1rpx;
		opacity: 0.1;
		cursor: s-resize;
	}

	.uni-cropper-line-b::before {
		content: '';
		position: absolute;
		top: 50%;
		right: 0rpx;
		width: 100%;
		-webkit-transform: translate3d(0, -50%, 0);
		transform: translate3d(0, -50%, 0);
		bottom: 0;
		height: 41rpx;
		background: transparent;
		z-index: 11;
	}

	.uni-cropper-line-l {
		position: absolute;
		display: block;
		background-color: #69f;
		top: 0;
		left: 0;
		width: 1rpx;
		opacity: 0.1;
		height: 100%;
		cursor: w-resize;
	}

	.uni-cropper-line-l::before {
		content: '';
		position: absolute;
		top: 0;
		left: 50%;
		width: 41rpx;
		-webkit-transform: translate3d(-50%, 0, 0);
		transform: translate3d(-50%, 0, 0);
		bottom: 0;
		height: 100%;
		background: transparent;
		z-index: 11;
	}

	.uni-cropper-point {
		width: 5rpx;
		height: 5rpx;
		background-color: #69f;
		opacity: .75;
		position: absolute;
		z-index: 3;
	}

	.point-t {
		top: -3rpx;
		left: 50%;
		margin-left: -3rpx;
		cursor: n-resize;
	}

	.point-tr {
		top: -3rpx;
		left: 100%;
		margin-left: -3rpx;
		cursor: n-resize;
	}

	.point-r {
		top: 50%;
		left: 100%;
		margin-left: -3rpx;
		margin-top: -3rpx;
		cursor: n-resize;
	}

	.point-rb {
		left: 100%;
		top: 100%;
		-webkit-transform: translate3d(-50%, -50%, 0);
		transform: translate3d(-50%, -50%, 0);
		cursor: n-resize;
		width: 36rpx;
		height: 36rpx;
		background-color: #69f;
		position: absolute;
		z-index: 1112;
		opacity: 1;
	}

	.point-b {
		left: 50%;
		top: 100%;
		margin-left: -3rpx;
		margin-top: -3rpx;
		cursor: n-resize;
	}

	.point-bl {
		left: 0%;
		top: 100%;
		margin-left: -3rpx;
		margin-top: -3rpx;
		cursor: n-resize;
	}

	.point-l {
		left: 0%;
		top: 50%;
		margin-left: -3rpx;
		margin-top: -3rpx;
		cursor: n-resize;
	}

	.point-lt {
		left: 0%;
		top: 0%;
		margin-left: -3rpx;
		margin-top: -3rpx;
		cursor: n-resize;
	}

	/* 裁剪框预览内容 */
	.uni-cropper-viewer {
		position: relative;
		width: 100%;
		height: 100%;
		overflow: hidden;
	}

	.uni-cropper-viewer image {
		position: absolute;
		z-index: 2;
	}
</style>
