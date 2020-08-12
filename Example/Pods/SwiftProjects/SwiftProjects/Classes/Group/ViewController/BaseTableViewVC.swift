//
//  BaseTableViewVC.swift
//  ZaiyiGouwuSQYHbuy
//
//  Created by 聂飞安 on 2020/6/11.
//  Copyright © 2020 zaiyici. All rights reserved.
//

import UIKit

open class BaseTableViewVC: BaseProVC {

    public var tableView : UITableView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override open func initializePage() {
        addAutoView([(.tableView, 1)])
        super.initializePage()
        tableView = getNomerView(autoViewClass: .tableView, index: 1)
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension

        if #available(iOS 11.0, *) {
         tableView.contentInsetAdjustmentBehavior = .never
        }else{
         self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override open func initLayoutSubviews() {
        tableView.frame = self.view.bounds
       
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
