//
//  CustImageView.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/15.
//

import UIKit
import NFAToolkit

open class CustImageView: UIImageView {

   private var block : CB?
   private var tapGestureRecognizer : UITapGestureRecognizer!

    open func addClickEvents(_ callback : @escaping CB){
        if tapGestureRecognizer == nil {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
            tapGestureRecognizer.numberOfTapsRequired = 1
            self.isUserInteractionEnabled = true
            self.contentMode = .scaleAspectFit
            self.addGestureRecognizer(tapGestureRecognizer)
        }
        self.block = callback
    }

    @objc func tapGesture(){
        self.block?()
    }

}
