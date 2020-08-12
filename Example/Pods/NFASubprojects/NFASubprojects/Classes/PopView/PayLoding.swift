//
//  PayLoding.swift
//  NFASubprojects
//
//  Created by 聂飞安 on 2020/4/21.
//

import UIKit
import SwiftProjects
import NFAToolkit
import SnapKit

class PayLoding: BasePopVC {
    
    private var bgView : UIView!
    private var lodingImage : UIImageView!
    private var lodingRunImage : UIImageView!
    private var lodingLabel : UILabel!
    private var lodingText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        regisPopSize(CGSize(width: AppWidth, height: AppHeight))
        // Do any additional setup after loading the view.
    }
    
    public func setLoding(_ text : String){
        lodingText = text
        lodingLabel?.text = text
    }
    
    override open func initializePage(){
        
        bgView = UIView()
        lodingImage = UIImageView()
        lodingRunImage = UIImageView()
        lodingLabel = UILabel()
        
        bgView.addSubview(lodingImage)
        bgView.addSubview(lodingLabel)
        bgView.addSubview(lodingRunImage)
        
        self.view.addSubview(bgView)
    }

    override open func initLayoutSubviews(){
       
        bgView.snp.makeConstraints { (make) in
            make.size.equalTo(AppWidth/3)
            make.center.equalToSuperview()
        }
        
        lodingImage.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.size.equalTo(AppWidth/3 - 50)
            make.centerX.equalToSuperview()
        }

        lodingRunImage.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(10)
            make.center.equalTo(lodingImage)
        }
        
        lodingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(0)
            make.height.equalTo(40)
        }
        
        bgView.backgroundColor = UIColor.initString("333333", alpha: 1)
        Tools.setCornerRadius(bgView, rate: 5)
        lodingLabel.textColor =  .white
        lodingLabel.textAlignment = .center
        lodingLabel.font = UIFont.systemFont(ofSize: 16)
        lodingLabel.numberOfLines = 2
        lodingLabel.minimumScaleFactor = 0.7
        lodingLabel.adjustsFontSizeToFitWidth = true
        setData()
    }
    
   private func setData(){
        lodingLabel?.text = lodingText
        lodingImage?.image = AppPopDelegate.sharedInstance.lodingImage
        lodingRunImage?.image =  AppPopDelegate.sharedInstance.lodingRunImage
        fanRotationAnim(rotationView: lodingRunImage)
    }
    
    
    func fanRotationAnim(rotationView: UIView) -> Void {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        // 2.设置动画属性
        rotationAnim.fromValue = 0 // 开始角度
        rotationAnim.toValue = Double.pi * 2 // 结束角度
        rotationAnim.repeatCount = 100 // 重复次数
        rotationAnim.duration = 4
        rotationAnim.autoreverses = false // 动画完成后自动重新开始,默认为NO
        rotationAnim.isRemovedOnCompletion = false //默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
        rotationView.layer.add(rotationAnim, forKey: nil) // 给需要旋转的view增加动画
    }
}
