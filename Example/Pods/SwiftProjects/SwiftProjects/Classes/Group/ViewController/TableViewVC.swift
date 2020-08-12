//
//  TableViewVC.swift
//  Created by 聂飞安 on 2019/9/16.
//  Copyright © 2019 聂飞安. All rights reserved.
//

import UIKit
import NFAToolkit

open class TableViewVC: BaseProVC {
    
    public let tableView : UITableView! = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: AppHeight),style: .plain)
    
    override  open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
      
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.initString( "F5F5F5")
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
       
        self.view.addSubview(tableView)
        
        if #available(iOS 11.0, *) {
           tableView.contentInsetAdjustmentBehavior = .never
        }else{
           self.automaticallyAdjustsScrollViewInsets = false
        }
        // Do any additional setup after loading the view.
    }
    
    
   open func registerCell(_ xibName : String , identifier : String){

       
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

extension TableViewVC : UIScrollViewDelegate{
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y >= 10
    }
    
}
