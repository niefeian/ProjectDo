//
//  Enumeration.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/7/2.
//

import UIKit

public enum AutoViewClass : Int{
    case  view = 0, label , button , imageView , textField , collectionView , tableView , textView , web
}

public enum LayoutType : Int{
    case  图文 = 0, 图 , 文字下滑块, 文字
}

public enum TestInfoType : Int{
    case  单人 = 0, 双人 , 详批 , 宝宝, 姓名配对
}


//这边目前主要是根据测算信息去定义的
public enum InputBoxType : Int{
    case  文字_输入框 = 0, 文字_双选 , 文字_输入框_双选 , 文字_输入框_按钮
}


public enum ViewType : Int{
    case  正常 = 0, 弹框 , 子视图
}

public enum CalculationType {
      case  无效,精辟, 合婚, 综合, 财运, 取名, 称骨 , 详批 , 配对 , 宅命
}
