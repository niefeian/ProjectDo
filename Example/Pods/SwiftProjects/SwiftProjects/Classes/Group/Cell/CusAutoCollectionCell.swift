//
//  CusAutoCollectionCell.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/5/6.
//

import UIKit
import WebKit

open class CusAutoCollectionCell: CusCollectionViewCell {
    
    public var subViewsData : [(AutoViewClass , Int)]! = [(AutoViewClass , Int)]()

    public func addAutoView(_ subs :[(AutoViewClass , Int)]){
            subViewsData = subs
    }

    open override func initializePage(){
        if subViewsData.count == 0 {
            return
        }
        for viewsData in subViewsData{
            let viewClass = viewsData.0
            for index in 0 ..< viewsData.1 {
                addSubview(autoViewClass: viewClass, index: index + 1)
            }
        }
    }

}
