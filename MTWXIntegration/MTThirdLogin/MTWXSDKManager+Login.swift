//
//  MTWXSDKManager+Login.swift
//  MTWXIntegration
//
//  Created by 李宁 on 2018/12/28.
//  Copyright © 2018 李宁. All rights reserved.
//


// MARK: - 微信登录

extension MTWXSDKManager: WXApiDelegate {
    
    /// 微信登录
    ///
    /// - Parameters:
    ///   - secret: 秘钥
    ///   - scope: 用户授权的作用域，使用逗号（,）分隔
    ///   - state: 用于保持请求和回调的状态，授权请求后原样带回给第三方
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func login(secret: String, scope: String, state: String, success: ((MTWXUserInfoModel) -> Void)? = nil, fail: ((NSError?) -> Void)? = nil) {
        loginSuccessBlock = success
        loginFailBlock = fail
        appSecret = secret
        let req = SendAuthReq()
        req.scope = scope
        req.openID = appid
        req.state = state
        WXApi.send(req)
    }
}

extension MTWXSDKManager {
    internal func handleLoginEvent(authResp: SendAuthResp) {
        let errCode: WXErrCode = WXErrCode(rawValue: authResp.errCode)
        switch errCode {
        case WXSuccess:
            fetchAccessToken(code: authResp.code)
        case WXErrCodeCommon:
            loginFailBy(code: -1, msg: "普通错误")
        case WXErrCodeUserCancel:
            loginFailBy(code: -2, msg: "用户点击取消并返回")
        case WXErrCodeSentFail:
            loginFailBy(code: -3, msg: "发送失败")
        case WXErrCodeAuthDeny:
            loginFailBy(code: -4, msg: "授权失败")
        case WXErrCodeUnsupport:
            loginFailBy(code: -5, msg: "微信不支持")
        default:
            loginFailBy(code: -6, msg: "未知错误")
        }
    }
}

extension MTWXSDKManager {
    
    /// 微信授权成功后需要获取AccessToken
    ///
    /// - Parameter code: 授权码
    fileprivate func fetchAccessToken(code: String) {
        let urlStr: String = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(appid)&secret=\(appSecret)&code=\(code)&grant_type=authorization_code"
        mtwx_fetchLoginAccessToken(urlStr: urlStr, success: { [weak self] (response) in
            guard let tmpResponse: [String : Any] = response, let accessToken: String = tmpResponse["access_token"] as? String, let openid: String = tmpResponse["openid"] as? String else {
                self?.loginFailBy(code: -7, msg: "未获取到AccessToken数据")
                return
            }
            self?.fetchUserInfo(accessToken: accessToken, openid: openid)
        }) { [weak self] (error) in
            self?.loginFailBlock?(error)
            self?.resetLoginBlock()
        }
    }
    
    /// 获取AccessToken后获取用户信息
    ///
    /// - Parameters:
    ///   - accessToken: accessToken
    ///   - openid: openid
    fileprivate func fetchUserInfo(accessToken: String, openid: String) {
        let urlStr: String = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openid)"
        mtwx_fetchUserInfo(urlStr: urlStr, success: { [weak self] (response) in
            guard let strongSelf = self, let result: [String : Any] = response else {
                self?.loginFailBy(code: -8, msg: "未获取到用户信息数据")
                return
            }
            let userInfo: MTWXUserInfoModel = strongSelf.convertUserInfoResponse(result)
            strongSelf.userInfo = userInfo
            strongSelf.loginSuccessBlock?(userInfo)
            strongSelf.resetLoginBlock()
        }) { [weak self] (error) in
            self?.loginFailBlock?(error)
            self?.resetLoginBlock()
        }
    }
    
    /// 将微信返回的用户信息转成模型输出
    ///
    /// - Parameter response: 微信返回的用户信息
    /// - Returns: 模型
    private func convertUserInfoResponse(_ response: [String : Any]) -> MTWXUserInfoModel {
        let model = MTWXUserInfoModel()
        model.openid = response["openid"] as? String
        model.nickname = response["nickname"] as? String
        model.sex = MTWXUserInfoSexType(rawValue: response["sex"] as? Int8 ?? 0) ?? .Unknown
        model.province = response["province"] as? String
        model.city = response["city"] as? String
        model.country = response["country"] as? String
        model.headimgurl = response["country"] as? String
        model.privilege = response["privilege"] as? [Any]
        model.unionid = response["unionid"] as? String
        return model
    }
    
    /// 重置回调
    fileprivate func resetLoginBlock() {
        self.loginSuccessBlock = nil
        self.loginFailBlock = nil
    }
    
    /// 登录失败统一处理逻辑
    ///
    /// - Parameters:
    ///   - code: 错误码
    ///   - msg: 错误描述
    fileprivate func loginFailBy(code: Int, msg: String) {
        self.userInfo = nil
        let err: NSError = NSError(domain: "MTWXSDKLogin", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
        self.loginFailBlock?(err)
        self.resetLoginBlock()
    }
}
