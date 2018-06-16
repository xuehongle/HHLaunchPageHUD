//
//  HHLaunchAdPageHUD.swift
//  HHLaunchPageHUDExample
//
//  Created by 薛乐 on 2018/1/7.
//  Copyright © 2018年 ethan. All rights `reserved.
//

import UIKit

let HHScreenWidth = UIScreen.main.bounds.size.width
let HHScreenHeight = UIScreen.main.bounds.size.height

class HHLaunchAdPageHUD: UIView {
    
    var launchAdClickBlock:(()->())?
    private var adFrame: CGRect!  /**< 广告图片frame */
    private var aDduration: Int = 0 /**< 广告停留时间 */
    private var aDImageUrl: String = "" /**< 广告图片的URL */
    private var aDhideSkipButton: Bool = false /**< 是否影藏'倒计时/跳过'按钮 */
    private var launchImageView: UIImageView!  /**< APP启动图片 */
    private var adImageView: UIImageView!       /**< APP广告图片 */
    private var skipButton: UIButton! /**< 跳过按钮 */
    private var timer: DispatchSourceTimer!
    
    // MARK: - /************************View life************************/
    /**
     *  HHLaunchAdPageHUD
     *
     *  @param frame        位置大小
     *  @param duration     广告停留的时间
     *  @param imageUrl     显示广告的图片(这里可以使用本地图片也可以使用网络图片,使用时只传入URL即可,SDK会自动是识别png\jpg\gif的图片)
     *  @param hideSkip     是否隐藏跳过按钮(YES:隐藏; NO不隐藏)
     *  @param aDClickBlock 用户点击广告图片的回调Block
     *
     *  @return HHLaunchAdPageHUD对象
     */
    init(frame:CGRect, aDduration:Int, aDImageUrl:String, hideSkipButton:Bool, launchAdClickBlock: (()->())?) {
        super.init(frame: frame)
        self.adFrame = frame
        self.aDduration = aDduration
        self.aDImageUrl = aDImageUrl
        self.aDhideSkipButton = hideSkipButton
        self.frame = UIScreen.main.bounds
        self.addSubview(self.setUpLaunchImageView())
        self.addSubview(self.setUpAdImageView())
        self.addSubview(self.setUpSkipButton())
        self.launchAdPageStart()
        self.launchAdPageEnd()
        self.addInWindow()
        self.launchAdClickBlock = launchAdClickBlock
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
//        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
    
}

// MARK: - /************************普通方法************************/
extension HHLaunchAdPageHUD {
    //    设置启动图片
    func setUpLaunchImageView() -> UIImageView {
        if (self.launchImageView == nil) {
            self.launchImageView = UIImageView(frame: UIScreen.main.bounds)
            self.launchImageView.image = self.launchImage()
        }
        return self.launchImageView
    }
    func launchImage() -> UIImage? {
        let viewSize = UIScreen.main.bounds.size
        let viewOrientation = "Portrait" /**< 横屏 @"Landscape" */
        let imageArray = Bundle.main.infoDictionary!["UILaunchImages"]
        if imageArray != nil { // 加这个判断是防止没加 启动图，导致的崩溃
            // 建议不这么做，而是让美工切图，底下那个图
            for dict : Dictionary <String, String> in imageArray as! Array {
                
                let imageSize = CGSizeFromString(dict["UILaunchImageSize"]!)
                if imageSize.equalTo(viewSize) && viewOrientation == dict["UILaunchImageOrientation"]! as String {
                    let image = UIImage(named: dict["UILaunchImageName"]!)
                    return image
                }
            }
        }
        
        print("[DHLaunchAdPageHUD]:请添加启动图片")
        return nil
    }
    //    设置广告图片
    func setUpAdImageView() -> UIImageView {
        if (self.adImageView == nil) {
            self.adImageView = UIImageView.init(frame: self.adFrame)
            self.adImageView.isUserInteractionEnabled = true
            self.adImageView.alpha = 0.2;
            let idString = (self.aDImageUrl as NSString).substring(from: self.aDImageUrl.count - 3)
            if self.checkURL(url: self.aDImageUrl) {
                if idString == "gif" {
                    let urlData = NSData.init(contentsOf: NSURL.init(string: self.aDImageUrl)! as URL)
                    let gifView = HHGifImageOperation.init(frame: self.adFrame, gifImageData: urlData as! Data)
                    self.adImageView.addSubview(gifView)
                } else {
                    let aDimageData = NSData.init(contentsOf: NSURL.init(string: self.aDImageUrl)! as URL)
                    self.adImageView.image = UIImage.init(data: aDimageData as! Data)
                }
            } else {
                if idString == "gif" {
                    let localData = NSData.init(contentsOfFile: self.aDImageUrl)
                    let gifView = HHGifImageOperation.init(frame: self.adFrame, gifImageData: localData as! Data)
                    self.adImageView.addSubview(gifView)
                } else {
                    self.adImageView.image = UIImage.init(named: self.aDImageUrl)
                }
            }
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.adImageViewTapAction(tap:)))
            self.adImageView.addGestureRecognizer(tap)
        }
        return self.adImageView;
    }
    
    @objc func adImageViewTapAction(tap: UITapGestureRecognizer) -> Void {
        if self.launchAdClickBlock != nil {
            self.launchAdClickBlock!()
        }
    }
    //    设置跳过按钮
    func setUpSkipButton() -> UIButton {
        if self.skipButton == nil {
            self.skipButton = UIButton.init(type: .custom)
            self.skipButton.frame = CGRect.init(x: UIScreen.main.bounds.size.width-70, y: 30, width: 60, height: 30)
            self.skipButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.skipButton.layer.cornerRadius = 15.0
            self.skipButton.layer.masksToBounds = true
            self.skipButton.isHidden = self.aDhideSkipButton
            var duration:Int = 3 /**< 默认停留时间 */
            if (self.aDduration != 0) { duration = self.aDduration }
            self.skipButton.setTitle("\(duration) 跳过", for: .normal)
            self.skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.5)
            self.skipButton.addTarget(self, action: #selector(self.skipButtonClick), for: .touchUpInside)
            self.dispath_timer()
        }
        return self.skipButton;
    }
    
    @objc func skipButtonClick() {
        self.removeLaunchAdPageHUD()
        self.timer.cancel()
    }
    
    func removeLaunchAdPageHUD() {
        UIView.animate(withDuration: 0.8, animations: {
            UIView.setAnimationCurve(.easeOut)
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    func dispath_timer() {
        
        let repeatCount = self.aDduration
        if repeatCount <= 0 {
            return
        }
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: 1)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                self.skipButton.setTitle("\(count) 跳过", for: .normal)
                print("\(count)")
            }
            if count == 0 {
                self.timer.cancel()
            }
        })
        timer.resume()
    }
    
    //    设置广告图片的开始
    func launchAdPageStart() {
        UIView.animate(withDuration: 1) {
            self.adImageView.alpha = 1.0
        }
    }
    //    设置广告图片的结束
    func launchAdPageEnd() {
        var duration:Int = 3
        if self.aDduration != 0 {
            duration = self.aDduration
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) {
            self.removeLaunchAdPageHUD()
        }
    }
    
    //添加至主窗口
    func addInWindow() {
        /**< 检测UIApplicationDidFinishLaunchingNotification通知 */
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil, queue: nil) { (note) in
            /**< 等didFinishLaunchingWithOptions方法结束后,将其添加至window上(不然会检测是否有rootViewController) */
            DispatchQueue.main.async {
                UIApplication.shared.delegate?.window!?.addSubview(self)
            }
//        }
    }
    
    //    正则表达式验证URL
    func checkURL(url: String) -> Bool {
        let regex = "http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
        let pred = NSPredicate(format: "SELF MATCHES %@",regex)
        return pred.evaluate(with:url)
    }
}
