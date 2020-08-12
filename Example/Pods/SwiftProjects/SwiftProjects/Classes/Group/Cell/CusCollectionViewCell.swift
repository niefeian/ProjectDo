//
//  CusCollectionViewCell.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/28.
//

import UIKit

open class CusCollectionViewCell: UICollectionViewCell {
   
    public var userData : AnyObject?
    weak public var baseView : UIViewController!
    
    override  public init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    open func initializeView(){
         initializePage()
         initLayoutSubviews()
         initializeDelegate()
         initializeDraw()
         initializeData()
     }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
    open func initializePage(){

    }

  
    open  func initLayoutSubviews(){
    }

    open  func initializeDelegate(){
    }

    open  func initializeDraw(){
    }

    open  func initializeData(){

    }

}
