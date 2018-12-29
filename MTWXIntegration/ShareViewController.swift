//
//  ShareViewController.swift
//  MTWXIntegration
//
//  Created by 李宁 on 2018/12/29.
//  Copyright © 2018 李宁. All rights reserved.
//

import UIKit

let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.height
let NaviHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

enum ShareType {
    case Text
    case Image
    case Music
    case Vedio
    case WebPage
    case MiniProgram
}

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    let cellReuseIdentifier = "kShareViewControllerCell"

    lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: NaviHeight, width: ScreenWidth, height: ScreenHeight), style: UITableView.Style.plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    let dataArr: [(title: String, type: ShareType)] = [(title: "文字", type: ShareType.Text), (title: "图片", type: ShareType.Image), (title: "音乐", type: ShareType.Music), (title: "视频", type: ShareType.Vedio), (title: "网页", type: ShareType.WebPage), (title: "微信小程序", type: ShareType.MiniProgram)]
}

extension ShareViewController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        title = "分享"
        view.addSubview(tableView)
    }
}

extension ShareViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleCellDidSelectedAction(indexPath: indexPath)
    }
}

extension ShareViewController {
    fileprivate func handleCellDidSelectedAction(indexPath: IndexPath) {
        let type = dataArr[indexPath.row].type
        switch type {
        case .Text:
            debugPrint("文字分享")
            MTWXSDKManager.manager.shareText("随便发点什么吧")
        case .Image:
            debugPrint("图片分享")
            MTWXSDKManager.manager.shareImage(imageData: UIImage(named: "img1")?.pngData())
        case .Music:
            debugPrint("音乐分享")
            MTWXSDKManager.manager.shareMusic(urlStr: "http://www.baidu.com", thumbImage: UIImage(named: "img2"), title: "随便听听", desc: "放得开设法尽量圣诞节疯狂的减肥垃圾收电费了")
        case .Vedio:
            debugPrint("视频分享")
            MTWXSDKManager.manager.shareVedio(urlStr: "http://www.baidu.com", thumbImage: UIImage(named: "img2"), title: "随便看看", desc: "饭卡的说法基督教发动机是分开了")
        case .WebPage:
            debugPrint("网页分享")
            MTWXSDKManager.manager.shareWebPage(urlStr: "http://www.baidu.com", thumbImage: UIImage(named: "img2"), title: "随便看看", desc: "饭卡的说法基督教发动机是分开了")
        case .MiniProgram:
            debugPrint("微信小程序分享")
        }
    }
}
