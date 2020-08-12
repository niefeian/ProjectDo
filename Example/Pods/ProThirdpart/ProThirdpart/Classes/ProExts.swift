//
//  ProExts.swift
//  FBSnapshotTestCase
//
//  Created by 聂飞安 on 2020/5/6.
//

import UIKit
import SDWebImage

public typealias CBImage = (UIImage?,String?) -> Void
public extension UIImageView{
    
    func setImageFromURL(_ url :String?, defaultIcon : String = "", block : CBImage? = nil) {
        setImageFromURL(url,defaultIcon: defaultIcon, options: .scaleDownLargeImages, block: block)
    }
    
    func setImageFromURL(_ url :String?, defaultIcon : String = "",  options : SDWebImageOptions , block :  CBImage?) {
        if let urls = URL(string: url ?? ""){
            if defaultIcon != "" {
                self.sd_setImage(with: urls, placeholderImage: UIImage(named: defaultIcon), options: options) { (image, error, type, imageUrls) in
                    block?(image,url)
                           }
            }else{
                self.sd_setImage(with: urls,placeholderImage:nil, options: options) { (image, error, type, imageUrls) in
                    block?(image,url)
                 }
            }
           
        }
        else if defaultIcon != ""{
            self.image = UIImage(named: defaultIcon)
        }
        else
        {
            self.image = nil
        }
    }
    
//    func setImageFromURLShowProgress(_ url :String? ,  options : SDWebImageOptions , block :  CBImage?) {
//          print(url)
//        if let urls = URL(string: url ?? ""){
//            self.sd_setImage(with: urls, placeholderImage: nil, options: options, context: nil, progress: { (receivedSize, expectedSize, targetURL) in
//                print(receivedSize,expectedSize,targetURL)
//            }) {  (image, error, type, url) in
//                  print(url)
//            }
//        }
//        
//    }
    
//    progress
    
}
/*
 SDWebImageRetryFailed
 默认情况下，当一个url下载失败，如果URL在黑名单中那么SDWebImage库不进行重试。这个标志使黑名单失效。

 SDWebImageLowPriority
 默认情况下，在UI交互中开始图片下载，这个标志使这个特性失效，例如导致在UIScrollView减速中延迟下载。

 SDWebImageCacheMemoryOnly
 这个标志使硬盘缓存失效。

 SDWebImageProgressiveDownload
 这个标志表示可以逐步下载图片，在下载过程中，网页能够逐步的显示图片。默认情况下，图片只在下载完成后一次性显示。

 SDWebImageRefreshCached
 虽然图片已经被缓存了，但是HTTP响应的缓存控制比较重要，如果需要则从远程地址刷新图片。硬盘缓存将用SDWebImage代替NSURLCache，会导致轻微的性能下降。这个项目帮助处理相同的请求URL而图片已经改变的情况，比如Facebook图形api的概要图片。如果一个缓存的图片被刷新，完成块会被缓存图片调用一次，再被最终的图片调用一次。

 SDWebImageContinueInBackground
 在iOS 4+，当app切换到后台继续下载图片。这是通过向系统请求额外的时间来完成，在后台情况下让请求完成。如果后台任务时间过期那么操作将会被取消。

 SDWebImageHandleCookies
 通过设置NSMutableURLRequest来操作cookies保存到NSHTTPCookieStore。 HTTPShouldHandlerCookies = YES。

 SDWebImageAllowInvalidSSLCertificates
 允许使用不信任的SSL证书。测试目的是有效的。在生产环境被警告。

 SDWebImageHighPriority
 默认情况下，图片在队列中排队下载。这个标志移动他们到前面的队列中。

 SDWebImageDelayPlaceholder
 默认情况下，当图片在加载中默认图片被加载。这个标志将延迟默认图片的显示，直到图片完成加载。

 SDWebImageTransformAnimatedImage
 我们通常在动画图片中不调用transformDownloadedImage代理，大部分的变形代码将损坏图片。使用这个标志在任何情况下变形图片。

 SDWebImageAvoidAutoSetImage
 默认情况下，图片是在下载完成后加载到图片视图。但是在一些情况下，我们想要在设置图片之前进行图片处理（比如，提供一个过滤或添加一个折叠动画）。使用这个标志，如果你想在下载成功后在完成块中手动设置图片。

 SDWebImageScaleDownLargeImages
 默认情况下，图片解码为原始的大小。在iOS，这个标志会把图片缩小到与设备的受限内容相兼容的大小。如果设置了SDWebImageProgressDownload标志，那么缩小被设置为无效。

 */

