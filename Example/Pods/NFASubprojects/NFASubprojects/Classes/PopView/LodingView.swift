//
//  PayLoding.swift
//  NFASubprojects
//
//  Created by 聂飞安 on 2020/4/21.
//

import UIKit
import SwiftProjects
import NFAToolkit
//import SnapKit
import MBProgressHUD
class LodingView: BasePopVC {
    
//    private var bgView : UIView!
//    private var lodingImage : UIActivityIndicatorView!
////    private var lodingRunImage : UIImageView!
//    private var lodingLabel : UILabel!
    private var lodingText = ""
    var hub : MBProgressHUD!
    override func viewDidLoad() {
        super.viewDidLoad()
        regisPopSize(CGSize(width: AppWidth, height: AppHeight))

        hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub?.label.text = lodingText
        hub.bezelView.style = .solidColor
        hub.bezelView.backgroundColor = UIColor.black
        hub.label.textColor = .white
        hub.contentColor = .white
        // Do any additional setup after loading the view.
    }
    
    public func setLoding(_ text : String){
        hub?.label.text = text
        lodingText = text
//        lodingLabel?.text = text
    }
    
    override open func initializePage(){
        
//        bgView = UIView()
//        lodingImage = UIActivityIndicatorView()
//        lodingImage.backgroundColor = UIColor.white
//          lodingImage.color = UIColor.red
//        lodingLabel = UILabel()
//
//        bgView.addSubview(lodingImage)
//        bgView.addSubview(lodingLabel)
////        bgView.addSubview(lodingRunImage)
//
//        self.view.addSubview(bgView)
//        lodingImage.style = .white
//        lodingImage.stopAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MBProgressHUD.hide(for: self.view, animated: false)
    }
    override open func initLayoutSubviews(){
//
//        bgView.snp.makeConstraints { (make) in
//            make.size.equalTo(AppWidth/3)
//            make.center.equalToSuperview()
//        }
//
//        lodingImage.center = bgView.center
////        lodingImage.snp.makeConstraints { (make) in
////            make.top.equalTo(10)
//////            make.size.equalTo(AppWidth/3 - 50)
//////            make.width.equalTo(AppWidth/3 - 40)
//////            make.height.equalTo(AppWidth/3 - 60)
////            make.centerX.equalToSuperview()
//////                .offset(-40)
////        }
//
////        lodingRunImage.snp.makeConstraints { (make) in
////            make.left.equalTo(30)
////            make.right.equalTo(-30)
////            make.height.equalTo(10)
////            make.center.equalTo(lodingImage)
////        }
//
//        lodingLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.bottom.equalTo(0)
//            make.height.equalTo(40)
//        }
//
//        bgView.backgroundColor = UIColor.initString("333333", alpha: 1)
//        Tools.setCornerRadius(bgView, rate: 5)
//        lodingLabel.textColor =  .white
//        lodingLabel.textAlignment = .center
//        lodingLabel.font = UIFont.systemFont(ofSize: 16)
//        lodingLabel.numberOfLines = 2
//        lodingLabel.minimumScaleFactor = 0.7
//        lodingLabel.adjustsFontSizeToFitWidth = true
//        setData()
    }
    
   private func setData(){
//        lodingLabel?.text = lodingText
    }
    
}
