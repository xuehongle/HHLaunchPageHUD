//
//  HHGifImageOperation.swift
//  HHLaunchPageHUDExample
//
//  Created by 薛乐 on 2018/1/7.
//  Copyright © 2018年 ethan. All rights reserved.
//

import UIKit
import ImageIO
import QuartzCore

class HHGifImageOperation: UIView {

    private var gifProperties: NSDictionary!
    private var gif: CGImageSource!
    private var count: size_t = 0
    private var index: size_t = 0
    private var timer: Timer!
    // MARK: - /************************View life************************/
    /**
     *  自定义播放Gif图片(Data)(本地+网络)
     *
     *  @param frame        位置和大小
     *  @param gifImageData Gif图片Data
     *
     *  @return Gif图片对象
     */
    init(frame: CGRect, gifImageData: Data) {
        super.init(frame: frame)
        let temp = NSDictionary.init(object: NSNumber.init(value: 0), forKey: NSString(format: "%d", CFGetTypeID(kCGImagePropertyGIFLoopCount)))
        self.gifProperties = NSDictionary.init(object: temp, forKey: NSString(format: "%d", CFGetTypeID(kCGImagePropertyGIFDictionary)))
        self.gif = CGImageSourceCreateWithData(gifImageData as CFData, gifProperties as CFDictionary)
        count = CGImageSourceGetCount(gif)
        timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(play), userInfo: nil, repeats: true) /**< 0.12->0.06 */
        timer.fire()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func play(){
        if (count > 0) {
            index = index + 1
            index = index%count
            let ref = CGImageSourceCreateImageAtIndex(gif, index, gifProperties as CFDictionary)
//            self.layer.contents = (__bridge id)ref;
            self.layer.contents = ref
//            CFRelease(ref);
        } else {
//            static dispatch_once_t onceToken;
//            //只执行一次
//            dispatch_once(&onceToken, ^{
//            NSLog(@"[DHGifImageOperation]:请检测网络或者http协议");
//            });
        }
    }
}
