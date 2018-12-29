//
//  MTWXSDKManager+Share.swift
//  MTWXIntegration
//
//  Created by 李宁 on 2018/12/29.
//  Copyright © 2018 李宁. All rights reserved.
//

import Foundation

/// 分享场景
///
/// - Session: 聊天界面
/// - Timeline: 朋友圈
/// - Favorite: 收藏
/// - SpecifiedSession: 指定联系人
enum MTWXShareScene: Int8 {
    case Session = 0
    case Timeline = 1
    case Favorite = 2
    case SpecifiedSession = 3
}

/// 小程序类型
///
/// - Release: 正式版
/// - Test: 开发版
/// - Preview: 体验版
enum MTWXMiniProgramType: UInt8 {
    case Release = 0
    case Test = 1
    case Preview = 2
}

extension MTWXSDKManager {
    
    /// 分享文字信息
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - scene: 场景
    ///   - toUserOpenId: 指定联系人，当scene == SpecifiedSession时有效
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func shareText(_ text: String, scene: MTWXShareScene = .Session, toUserOpenId: String? = nil, success: (() -> Void)? = nil, fail: ((NSError?) -> Void)? = nil) {
        shareCompletionBlock = success
        shareFailBlock = fail
        let req = SendMessageToWXReq()
        req.bText = true
        req.text = text
        req.scene = Int32(WXSceneSession.rawValue)
        if scene == .SpecifiedSession && toUserOpenId != nil {
            req.toUserOpenId = toUserOpenId
        }
        WXApi.send(req)
    }
    
    /// 分享图片信息
    ///
    /// - Parameters:
    ///   - thumbData: 缩略图Data
    ///   - imageData: 分享图片Data
    ///   - scene: 场景
    ///   - toUserOpenId: 指定联系人，当scene == SpecifiedSession时有效
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func shareImage(imageData: Data?, scene: MTWXShareScene = .Session, toUserOpenId: String? = nil, success: (() -> Void)? = nil, fail: ((NSError?) -> Void)? = nil) {
        let imgObj = WXImageObject()
        imgObj.imageData = imageData
        
        let message = WXMediaMessage()
        message.mediaObject = imgObj
        
        sendMediaMessage(message: message, scene: scene, toUserOpenId: toUserOpenId)
    }
    
    /// 分享音乐信息
    ///
    /// - Parameters:
    ///   - urlStr: 音乐url
    ///   - thumbImage: 缩略图
    ///   - title: 音乐名称
    ///   - desc: 音乐描述
    ///   - scene: 场景
    ///   - toUserOpenId: 指定联系人，当scene == SpecifiedSession时有效
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func shareMusic(urlStr: String, thumbImage: UIImage?, title: String?, desc: String?, scene: MTWXShareScene = .Session, toUserOpenId: String? = nil, success: (() -> Void)? = nil, fail: ((NSError?) -> Void)? = nil) {
        let musicObj = WXMusicObject()
        musicObj.musicUrl = urlStr
        
        let message = WXMediaMessage()
        message.title = title
        message.description = desc
        message.setThumbImage(thumbImage)
        message.mediaObject = musicObj
        
        sendMediaMessage(message: message, scene: scene, toUserOpenId: toUserOpenId)
    }
    
    /// 分享视频信息
    ///
    /// - Parameters:
    ///   - urlStr: 视频url
    ///   - thumbImage: 缩略图
    ///   - title: 视频名称
    ///   - desc: 视频描述
    ///   - scene: 场景
    ///   - toUserOpenId: 指定联系人，当scene == SpecifiedSession时有效
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func shareVedio(urlStr: String, thumbImage: UIImage?, title: String?, desc: String?, scene: MTWXShareScene = .Session, toUserOpenId: String? = nil, success: (() -> Void)? = nil, fail: ((NSError?) -> Void)? = nil) {
        let videoObj = WXVideoObject()
        videoObj.videoUrl = urlStr
        
        let message = WXMediaMessage()
        message.title = title
        message.description = desc
        message.setThumbImage(thumbImage)
        message.mediaObject = videoObj
        
        sendMediaMessage(message: message, scene: scene, toUserOpenId: toUserOpenId)
    }
    
    /// 分享网页
    ///
    /// - Parameters:
    ///   - urlStr: 网页url
    ///   - thumbImage: 缩略图
    ///   - title: 网页名称
    ///   - desc: 网页描述
    ///   - scene: 场景
    ///   - toUserOpenId: 指定联系人，当scene == SpecifiedSession时有效
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func shareWebPage(urlStr: String, thumbImage: UIImage?, title: String?, desc: String?, scene: MTWXShareScene = .Session, toUserOpenId: String? = nil, success: (() -> Void)? = nil, fail: ((NSError?) -> Void)? = nil) {
        let webPageObj = WXWebpageObject()
        webPageObj.webpageUrl = urlStr
        
        let message = WXMediaMessage()
        message.title = title
        message.description = desc
        message.setThumbImage(thumbImage)
        message.mediaObject = webPageObj
        
        sendMediaMessage(message: message, scene: scene, toUserOpenId: toUserOpenId)
    }
    
    /// 分析小程序
    ///
    /// - Parameters:
    ///   - name: 小程序名称
    ///   - path: 小程序页面的路径
    ///   - shareTicket: 是否使用带 shareTicket 的转发
    ///   - type: 分享小程序的版本，默认为正式版本
    ///   - thumbImageData: 缩略图
    ///   - title: 名称
    ///   - desc: 小程序描述
    ///   - scene: 场景
    ///   - toUserOpenId: 指定联系人，当scene == SpecifiedSession时有效
    ///   - success: 成功回调
    ///   - fail: 失败回调
    func shareMiniProgram(name: String?, path: String?, shareTicket: Bool, type: MTWXMiniProgramType = .Release, thumbImageData: Data?, title: String?, desc: String?, scene: MTWXShareScene = .Session, toUserOpenId: String? = nil, success: (() -> Void)? = nil, fail: ((NSError?) -> Void)? = nil) {
        let miniProgramObj = WXMiniProgramObject()
        miniProgramObj.userName = name
        miniProgramObj.path = path
        miniProgramObj.hdImageData = thumbImageData
        miniProgramObj.withShareTicket = shareTicket
        miniProgramObj.miniProgramType = WXMiniProgramType(rawValue: UInt(type.rawValue)) ?? .release
        
        let message = WXMediaMessage()
        message.title = title
        message.description = desc
        message.mediaObject = miniProgramObj
        
        sendMediaMessage(message: message, scene: scene, toUserOpenId: toUserOpenId)
    }
}

extension MTWXSDKManager {
    internal func handleShareEvent(resp: SendMessageToWXResp) {
        let errCode: WXErrCode = WXErrCode(rawValue: resp.errCode)
        switch errCode {
        case WXSuccess:
            shareCompletionBlock?()
            resetShareBlock()
        case WXErrCodeCommon:
            shareFailBy(code: -1, msg: "普通错误")
        case WXErrCodeUserCancel:
            shareFailBy(code: -2, msg: "用户点击取消并返回")
        case WXErrCodeSentFail:
            shareFailBy(code: -3, msg: "发送失败")
        case WXErrCodeAuthDeny:
            shareFailBy(code: -4, msg: "授权失败")
        case WXErrCodeUnsupport:
            shareFailBy(code: -5, msg: "微信不支持")
        default:
            shareFailBy(code: -6, msg: "未知错误")
        }
    }
}

extension MTWXSDKManager {
    /// 分享失败统一处理逻辑
    ///
    /// - Parameters:
    ///   - code: 错误码
    ///   - msg: 错误描述
    fileprivate func shareFailBy(code: Int, msg: String) {
        let err: NSError = NSError(domain: "MTWXSDKShare", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
        self.loginFailBlock?(err)
        self.resetShareBlock()
    }
    
    /// 重置回调
    fileprivate func resetShareBlock() {
        self.shareCompletionBlock = nil
        self.shareFailBlock = nil
    }
    
    fileprivate func sendMediaMessage(message: WXMediaMessage, scene: MTWXShareScene = .Session, toUserOpenId: String? = nil) {
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        if scene == .SpecifiedSession && toUserOpenId != nil {
            req.toUserOpenId = toUserOpenId
        }
        WXApi.send(req)
    }
}
