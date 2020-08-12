//
//  ExtsPro.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/5/25.
//

import UIKit
import WebKit

public extension UIView {
    

    func setLable(index : Int , numberOfLines : Int = 1 , font: UIFont , textColor : UIColor , text : String , lineSpacing : CGFloat = 0 , textAlignment : NSTextAlignment = .left){
          if let label = getSubview(autoViewClass: .label, index: index) as? UILabel {
              label.numberOfLines = numberOfLines
              label.font = font
              label.textColor = textColor
              label.text = text
              label.setLineSpacing(lineSpacing)
            label.textAlignment = textAlignment
          }
       }
    
    func addSubview(autoViewClass : AutoViewClass , index : Int) {
        self.addSubview(getSubview(autoViewClass: autoViewClass, index: index, autoInit: true)!)
     }
    
    func getSubImageView(index : Int) -> UIImageView?{
        return getView(autoViewClass: .imageView, index: index)
    }
    
    func getSubLabelView(index : Int) -> UILabel?{
       return getView(autoViewClass: .label, index: index)
    }
     
    func getSubview(autoViewClass : AutoViewClass , index : Int , autoInit : Bool = false) -> UIView?{
        return getView(autoViewClass: autoViewClass, index: index, autoInit: autoInit)
    }
    
    func getView<T>(autoViewClass : AutoViewClass , index : Int , autoInit : Bool = false) -> T?{
       var subView = self.viewWithTag(autoViewClass.rawValue * 100 + index)
       if subView == nil && autoInit {
           switch autoViewClass {
           case .view:
               subView = UIView()
           case .label:
                subView = UILabel()
           case .button:
                subView = UIButton()
           case .imageView:
                subView = UIImageView()
           case .textField:
                subView = UITextField()
           case .collectionView:
               let layout = UICollectionViewFlowLayout()
               subView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
           case .tableView:
                subView = UITableView()
           case .textView:
               subView = UITextView()
           case .web:
               subView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
           }
           subView?.tag = autoViewClass.rawValue * 100 + index*1
       }
       return subView as? T
    }
}
