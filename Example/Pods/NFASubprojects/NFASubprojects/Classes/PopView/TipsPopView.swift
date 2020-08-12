//
//  TipsPopView.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/5/25.
//

import UIKit
import SwiftProjects
import NFAToolkit
import SnapKit

open class TipsPopView: BasePopVC {

    private var viewSize =  CGSize(width: 300.pd6sW, height: 400.pd6sW )
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        regisPopSize(viewSize)
        // Do any additional setup after loading the view.
    }
    
    open override func initializePage() {
        addAutoView([(.view, 1),(.label, 2),(.button, 1)])
        super.initializePage()
    }
    
    open override func initLayoutSubviews() {
        
        getSubview(autoViewClass: .view, index: 1)?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        getSubview(autoViewClass: .label, index: 1)?.snp.makeConstraints({ (make) in
            make.top.equalTo(20.pd6sW)
            make.centerX.equalToSuperview()
        })
        
        getSubview(autoViewClass: .label, index: 2)?.snp.makeConstraints({ (make) in
            make.top.equalTo(60.pd6sW)
            make.centerX.equalToSuperview()
            make.left.equalTo(22.pd6sW)
            make.bottom.lessThanOrEqualTo(-93)
        })
        
        getSubview(autoViewClass: .button, index: 1)?.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 200.pd6sW, height: 40.pd6sW))
            make.bottom.equalTo(-20.pd6sW)
            make.centerX.equalToSuperview()
        })
    }
    
    open override func initializeDraw() {
        
        if let button : UIButton =  self.getNomerView(autoViewClass: .button, index: 1) {
            button.backgroundColor = .initString("#F76C4F")
            button.setTitleColor(.white, for: .normal)
            button.setTitle("我知道了", for: .normal)
            button.addTarget(self, action: Selector(("diss")), for: .touchUpInside)
            Tools.setCornerRadius(button, rate: 20.pd6sW)
        }
        
        if let subview = getSubview(autoViewClass: .view, index: 1) {
            subview.backgroundColor = .white
            Tools.setCornerRadius(subview, rate: 5)
        }
        
        self.view.setLable(index: 1, numberOfLines: 1, font: .boldSystemFont(ofSize: 16), textColor: .initString("#4C4E55"), text: "问答规则", lineSpacing: 1)
        
        let str = """
        1.一次只能提问一个问题，请详细描述您
        的问题与背景信息，此项不填出生信息，
        每次可以提出单个问题，如输入多个问
        题，老师将会选择第一个问题进行解答。
        2.快速问答老师将在2小时内进行解答，
        如老师未回复解答，请联系两仪四象客服
        微信：FeiyaDSP，进行咨询。
        3.如果选择公开提问，会展示在首页和问
        答热门区域，选择不公开，则不会展示，
        同时为保护用户隐私，所有问答生辰不会
        泄露。
        """
        
        self.view.setLable(index: 2, numberOfLines: 0, font: .systemFont(ofSize: 13.pd6sW), textColor: .initString("##7C828D"), text: str, lineSpacing: 3)
        
    }
    
    @objc func diss(){
        
        disappear?()
        
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
