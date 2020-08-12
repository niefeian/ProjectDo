//
//  AbsTableViewCell.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/2.
//

import UIKit

open class AbsTableViewCell: UITableViewCell {
   
    public var userData : AnyObject?
    weak public var baseView : UIViewController!
    public var cb : (() -> Void)?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initializePage()
        initLayoutSubviews()
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
