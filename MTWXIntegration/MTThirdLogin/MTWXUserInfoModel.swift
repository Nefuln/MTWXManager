//
//  MTWXUserInfoModel.swift
//  MTWXIntegration
//
//  Created by 李宁 on 2018/12/28.
//  Copyright © 2018 李宁. All rights reserved.
//

import UIKit

enum MTWXUserInfoSexType: Int8 {
    case Unknown = 0            // 未知
    case male = 1                   // 男性
    case famale = 2                // 女性
}

class MTWXUserInfoModel: NSObject {
    
    /// 普通用户的标识，对当前开发者帐号唯一
    var openid: String?
    
    /// 普通用户昵称
    var nickname: String?
    
    /// 普通用户性别，1为男性，2为女性
    var sex: MTWXUserInfoSexType = .Unknown
    
    /// 普通用户个人资料填写的省份
    var province: String?
    
    /// 普通用户个人资料填写的城市
    var city: String?
    
    /// 国家，如中国为CN
    var country: String?
    
    /// 用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
    var headimgurl : String?
    
    /// 用户特权信息，json数组，如微信沃卡用户为（chinaunicom）
    var privilege: [Any]?
    
    /// 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
    var unionid: String?
}
