//
//  VipPopView.swift
//  NFASubprojects
//
//  Created by 聂飞安 on 2020/4/23.
//

import UIKit
import SwiftProjects
import NFAToolkit
import SnapKit


open class VipPopView: BasePopVC {

    private var imageSize =  CGSize(width: 290.pd6sW, height: 395.pd6sW + 50.pd6sW)
    
    private var imageView : CustImageView!
    private var closeView : CustImageView!
    private var titleLabel : UILabel!
    
    private var payNow : UIButton!
    private var payAll : UIButton!
    
    private var lineHorizontal : UIView!
    private var lineVertical : UIView!
    
    public var image : UIImage!
    public var nowColor : UIColor! = .initString("#E1B073")
    public var allColor  : UIColor!  = .white
    public var allBgColor  : UIColor!  = UIColor.initString("#E1B073")
    public var lineColor  : UIColor! = UIColor.initString("#E1B073")
    
    public var titleText  : String!  = ""
    public var allText  : String!  = ""
    public var nowText  : String!  = ""
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        regisPopSize(imageSize)
        closeView.image = UIImage.init(named: "close_icon.png")
        // Do any additional setup after loading the view.
    }
    
    override open func initializePage(){
        imageView = CustImageView()
        closeView = CustImageView()
        titleLabel = UILabel()
        payNow = UIButton()
        payNow.tag = 100
        payAll = UIButton()
        payAll.tag = 101
        payNow.addTarget(self, action: Selector(("pay:")), for: .touchUpInside)
        payAll.addTarget(self, action: Selector(("pay:")), for: .touchUpInside)
        
        lineHorizontal = UIView()
        lineVertical = UIView()
        
        self.view.addSubview(closeView)
        self.view.addSubview(imageView)
        imageView.addSubview(titleLabel)
         self.view.addSubview(payNow)
         self.view.addSubview(payAll)
        imageView.addSubview(lineHorizontal)
        imageView.addSubview(lineVertical)
        
        closeView.addClickEvents({[weak self] in
          self?.disappear?()
        })
      }
      

      override open func initLayoutSubviews(){
        imageView.frame = CGRect(x: 0, y: 0, width: 290.pd6sW , height: 395.pd6sW)
        closeView.frame = CGRect(x: imageSize.width/2 - 15.pd6sW, y: 395.pd6sW + 15.pd6sW, width: 30.pd6sW , height: 30.pd6sW)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25.pd6sW)
            make.width.equalToSuperview()
            make.left.equalTo(0)
            make.height.equalTo(20.pd6sW)
        }
       
        lineHorizontal.snp.makeConstraints { (make) in
            make.bottom.equalTo(-42.pd6sW)
            make.height.equalTo(1)
            make.left.equalTo(0)
            make.width.equalToSuperview()
        }
        
        lineVertical.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(42.pd6sW)
            make.left.equalTo(290.pd6sW/2 - 0.5)
            make.width.equalTo(1)
        }
        
        payNow.snp.makeConstraints { (make) in
           make.bottom.equalTo(imageView)
           make.height.equalTo(42.pd6sW)
           make.left.equalTo(0)
           make.width.equalTo(290.pd6sW/2)
        }

        payAll.snp.makeConstraints { (make) in
           make.bottom.equalTo(imageView)
           make.height.equalTo(42.pd6sW)
           make.left.equalTo(290.pd6sW/2)
           make.width.equalTo(290.pd6sW/2)
        }
               
        
        setData()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func pay(_ btn : UIButton){
        callBack?(btn.tag as AnyObject)
    }
    
    func setData(){
        imageView.image = image
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 17.pd6sW)
        titleLabel.textAlignment = .center
        lineHorizontal.backgroundColor = lineColor
        lineVertical.backgroundColor = lineColor
        payNow.setTitleColor(nowColor, for: .normal)
        payAll.setTitleColor(allColor, for: .normal)
        payAll.backgroundColor = allBgColor
        payAll.setTitle(allText, for: .normal)
        payNow.setTitle(nowText, for: .normal)
        payAll.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16.pd6sW)
//        payAll.titleLabel?.textColor = .white
        payNow.titleLabel?.font = UIFont.systemFont(ofSize: 18.pd6sW)
        titleLabel.text = titleText
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
//        payNow.titleLabel?.textColor = .white
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
