//
//  ImageAffairUtils.swift
//  Alamofire
//
//  Created by 聂飞安 on 2020/5/11.
//

import UIKit
import SDWebImage

public typealias LoadProgress = (CGFloat?,String) -> Void
class NodeImageView : UIImageView {
    
    var receivedSize =  0
    var expectedSize = 0
    var targetURL = ""
    var finsh = true
    var loadProgress : LoadProgress!
    var imageBlock : CBImage!
    
    func loadUrl(_ url : String , loadProgress : @escaping LoadProgress , imageBlock :  @escaping CBImage){
        targetURL = url
        
        if let urls = URL(string: url ){
            self.loadProgress = loadProgress
            self.imageBlock = imageBlock
            finsh = false
            self.sd_setImage(with: urls, placeholderImage: nil, options: [.highPriority], context: nil, progress: { (receivedSize, expectedSize, targetURL) in
                if self.expectedSize != expectedSize {
                    self.expectedSize = expectedSize
                }
                
                if self.receivedSize != receivedSize {
                    self.receivedSize = receivedSize
                }
                
                let progresss = CGFloat(receivedSize)/CGFloat(expectedSize)
                self.loadProgress?(progresss, self.targetURL)
            }) {  (image, error, type, url) in
                self.finsh = true
                self.imageBlock?(image,self.targetURL)
            }
        }else{
            finsh = true
        }
    }
}



public class ImageAffairUtils: NSObject {
    
    public static let sharedInstance = ImageAffairUtils()
    public var maxLoad = 3 //最多同时加载多少张
    private var imageUrls = [(String,LoadProgress,CBImage)]()
    private var nodeImageViews = [NodeImageView]()
    private var imageUrlsKey = [String]()
    public var finshKey = [String]()
    public var maxSize : CGFloat = 100 //这个单位M
    public var memoryWarning : Bool = false
//    private var nowSize : CGFloat = 0//这个是kb /1024.0 / 1024.0 -> maxSize
//    1024.0 / 1024.0
    public func addImage(_ url : String , loadProgress : @escaping LoadProgress , imageBlock : @escaping CBImage){
        if memoryWarning {
            if !imageUrlsKey.contains(url) {
                imageUrlsKey.append(url)
                imageUrls.append((url,loadProgress,imageBlock))
            }
            return
        }
        var nowSize : CGFloat = 0
        for nodeImageView in nodeImageViews{
            if !nodeImageView.finsh {
                nowSize += CGFloat(nodeImageView.expectedSize)
            }
        }
        
        if nowSize / (1024 * 1024) < maxSize {
            for nodeImageView in nodeImageViews {
               if nodeImageView.finsh {
                    self.loadNodeImageView(nodeImageView, url, loadProgress: loadProgress, imageBlock: imageBlock)
                   return
               }
            }

            if nodeImageViews.count < maxLoad {
               let nodeImageView = NodeImageView()
               self.loadNodeImageView(nodeImageView, url, loadProgress: loadProgress, imageBlock: imageBlock)
               nodeImageViews.append(nodeImageView)
            }else{
               if !imageUrlsKey.contains(url) {
                   imageUrlsKey.append(url)
                   imageUrls.append((url,loadProgress,imageBlock))
               }
               
            }
        }else{
            if !imageUrlsKey.contains(url) {
                imageUrlsKey.append(url)
                imageUrls.append((url,loadProgress,imageBlock))
            }
        }
       
    }
    
    func loadNodeImageView(_ nodeImageView : NodeImageView , _ url : String , loadProgress : @escaping LoadProgress , imageBlock : @escaping CBImage){
        nodeImageView.loadUrl(url, loadProgress: loadProgress) { (image, imageUrl) in
            if imageUrl != nil {
                self.finshKey.append(imageUrl!)
            }
            imageBlock(image, imageUrl)
            self.loadNext(nodeImageView,imageUrl)
        }
    }
    
    private func loadNext(_ nodeImageView : NodeImageView , _ url : String?){
        if imageUrls.count > 0 {
            var nowSize : CGFloat = 0
             for nodeImageView in nodeImageViews{
                 if !nodeImageView.finsh {
                     nowSize += CGFloat(nodeImageView.expectedSize)
                 }
             }
             
            if nowSize / (1024 * 1024) < maxSize {
                if let vo = imageUrls.last {
                  nodeImageView.loadUrl(vo.0, loadProgress: vo.1, imageBlock: vo.2)
                  imageUrls.removeLast()
                }
            }
        }
    }
    
    public func loadNext(){
       if let vo = imageUrls.last {
            addImage(vo.0, loadProgress: vo.1, imageBlock: vo.2)
        }
       
    }
}
