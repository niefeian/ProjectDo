//
//  ImagePopVC.swift
//  SwiftProjects
//
//  Created by 聂飞安 on 2020/4/21.
//

import UIKit
import SwiftProjects
import NFAToolkit
import ProThirdpart

open class ImagePopVC: BasePopVC {
    
    public var imageSize =  CGSize(width: 330.pd6sW, height: 365.pd6sW + 50.pd6sW)
    private var imageView : CustImageView!
    private var closeView : CustImageView!
    
    open var missBlock: CB?
    
    public var imageURL = ""
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        regisPopSize(imageSize)
        imageView.setImageFromURL(imageURL)
        closeView.image = UIImage.init(named: "close_icon.png")
           // Do any additional setup after loading the view.
    }
    
    override open func initializePage(){
        imageView = CustImageView()
        closeView = CustImageView()
        self.view.addSubview(closeView)
        self.view.addSubview(imageView)
        
        imageView.addClickEvents({[weak self] in
            self?.callBack?(1 as AnyObject)
        })
        closeView.addClickEvents({[weak self] in
            self?.callBack?(0 as AnyObject)
        })
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.missBlock?()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         
    }

    override open func initLayoutSubviews(){
        imageView.frame = CGRect(x: 0, y: 0, width: 330.pd6sW , height: 365.pd6sW)
        closeView.frame = CGRect(x: imageSize.width/2 - 15.pd6sW, y: 365.pd6sW + 15.pd6sW, width: 30.pd6sW , height: 30.pd6sW)

    }
}
