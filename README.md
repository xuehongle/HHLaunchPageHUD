# HHLaunchPageHUD
### Swift 一行代码迅速集成APP启动页,带广告AD
### Xcode9.1 Swift4.0 测试通过
#### 声明: 部分图片来源于网络,如有涉及版权会马上删除,敬请谅解;
#### 此工程是Swift版本，OC版本移步 https://github.com/dingding3w/DHLaunchPageHUD，
#### 但是我用的Swift，就用了原OC作者的资源，方便了很多，感谢!
## HHLaunchAdPageHUD - 有广告(Ad)
### 效果图展示:
<table>
    <tr>
		<th>加载网络/本地静态图片广告</th>
		<th>加载网络/本地动态图片广告</th>
	</tr>
	<tr>
		<td><img src="https://github.com/xuehongle/HHLaunchPageHUD/blob/master/DeviceImages/Untitled-1.gif" width="300"></td>
		<td><img src="https://github.com/xuehongle/HHLaunchPageHUD/blob/master/DeviceImages/Untitled-4.gif" width="300"></td>
	</tr>
</table>

### 方法说明:
```swift
/**
     *  HHLaunchAdPageHUD
     *
     *  @param frame            位置大小
     *  @param aDduration       广告停留的时间
     *  @param aDImageUrl       显示广告的图片(这里可以使用本地图片也可以使用网络图片,使用时只传入URL即可,SDK会自动是识别png\jpg\gif的图片)
     *  @param hideSkipButton   是否隐藏跳过按钮(YES:隐藏; NO不隐藏)
     *  @param launchAdClickBlock 用户点击广告图片的回调Block
     *
     *  @return HHLaunchAdPageHUD对象
     */
    init(frame:CGRect, aDduration:Int, aDImageUrl:String, hideSkipButton:Bool, launchAdClickBlock: (()->())?) {
    }

```

### 使用方式:
#### 1.下载项目或者下载项目中的HHLaunchAdPageHUD文件,将下载好的DHLaunchAdPageHUD文件拖拽到自己的工程文件夹中
#### 2.在application:didFinishLaunchingWithOptions:方法写一句代码即可，代码如下:
```swift
let adImageJPGUrl = "http://p5.image.hiapk.com/uploads/allimg/150112/7730-150112143S3.jpg";
let adimageGIFUrl = "http://img.ui.cn/data/file/3/4/6/210643.gif";
let adImageJPGPath:String = Bundle.main.path(forResource: "adImage2", ofType: "jpg")!
let adImageGifPath:String = Bundle.main.path(forResource: "adImage3", ofType: "gif")!

HHLaunchAdPageHUD.init(frame: CGRect.init(x: 0, y: 0, width: HHScreenWidth, height: HHScreenHeight-100), aDduration: 4, aDImageUrl: adImageGifPath, hideSkipButton: false) {
            print("[AppDelegate]:点了广告图片")
            UIApplication.shared.openURL(URL.init(string: "https://www.baidu.com")!)
        }
```
## 分享是一种美德,Star是一种鼓励!
