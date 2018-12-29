//
//  ViewController.swift
//  MTWXIntegration
//
//  Created by 李宁 on 2018/12/28.
//  Copyright © 2018 李宁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate lazy var loginBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = UIColor.purple
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitle("微信登录", for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(ViewController.handleloginByWX), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var launchSoftwareBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = UIColor.purple
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitle("分  享", for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(ViewController.handleLaunchAction), for: UIControl.Event.touchUpInside)
        return btn
    }()

}

extension ViewController {
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor.white
        title = "WXThirdManage"
        loginBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        loginBtn.center = view.center
        view.addSubview(loginBtn)
        
        launchSoftwareBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        launchSoftwareBtn.center = CGPoint(x: view.center.x, y: view.center.y + 65)
        view.addSubview(launchSoftwareBtn)
    }
}

extension ViewController {
    @objc fileprivate func handleloginByWX() {
        MTWXSDKManager.manager.login(secret: "b78e557670653726e4c27d4581b62133", scope: "snsapi_userinfo", state: "2017")
    }
    
    @objc fileprivate func handleLaunchAction() {
        navigationController?.pushViewController(ShareViewController(), animated: true)
    }
}
