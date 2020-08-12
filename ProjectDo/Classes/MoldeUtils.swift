//
//  MoldeUtils.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/23.
//

import UIKit

import AutoModel

public class AD : BaseModel {
    @objc public var img = ""
    @objc public var url = ""
    @objc public var type = ""
    @objc public var pos = ""
    @objc public var full = ""
}

public class PayResult: BaseModel {
    @objc public var issubscrib = ""//是否是会员
    @objc public var subscrib = ""//是否是会员
    @objc public var url = ""//网址
    @objc public var ohash = ""//唯一标识
    @objc public var type = "" //商品类型
    
    @objc open var userinfo :  NSDictionary = NSDictionary()//用户信息
}

//import AutoModel
//open class Userinfo: BaseModel {
//    @objc open var memberexpire = ""//是否是会员
//}

