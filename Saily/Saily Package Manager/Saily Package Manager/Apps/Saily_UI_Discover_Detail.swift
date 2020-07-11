//
//  Saily_UI_Discover_Detail.swift
//  Saily Package Manager
//
//  Updated by Brecken Lusk on 6/6/19.
//  Copyright © 2019 Saily Team. All rights reserved.
//

import UIKit
import WebKit

import Hero
import NVActivityIndicatorView

class Saily_UI_Discover_Detail: UIViewController, WKNavigationDelegate{
    
    public var discover_index = Int()
    @IBOutlet weak var web_container: WKWebView!
    let loading_view = NVActivityIndicatorView(frame: CGRect(), type: .circleStrokeSpin, color: #colorLiteral(red: 0.07285261899, green: 0.5867173076, blue: 0.8592197895, alpha: 1), padding: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Saily.discover_detail_UI = self
        
        web_container.navigationDelegate = self
        
        if (self.discover_index == -666) {
            let url = URL(string: Saily.app_web_site)!
            web_container.load(URLRequest(url: url))
            web_container.allowsBackForwardNavigationGestures = true
        }else{
            if (!Saily.discover_root[discover_index].web_link.uppercased().contains("HTTP")) {
            let url_dead = UIImageView()
            url_dead.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
            url_dead.contentMode = .scaleAspectFit
            url_dead.clipsToBounds = false
            self.view.addSubview(url_dead)
            self.view.bringSubviewToFront(url_dead)
            url_dead.snp.makeConstraints { (c) in
                c.center.equalTo(self.view.snp.center)
                c.width.equalTo(233)
            }
            return
            }
            if let url = URL(string: Saily.discover_root[discover_index].web_link) {
                web_container.load(URLRequest(url: url))
                web_container.allowsBackForwardNavigationGestures = true
            }else{
                let url_dead = UIImageView()
                url_dead.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
                url_dead.contentMode = .scaleAspectFit
                url_dead.clipsToBounds = false
                self.view.addSubview(url_dead)
                self.view.bringSubviewToFront(url_dead)
                url_dead.snp.makeConstraints { (c) in
                    c.center.equalTo(self.view.snp.center)
                }
                
            }
        }
        self.view.addSubview(loading_view)
        loading_view.snp.makeConstraints { (c) in
            c.top.equalTo(self.view.snp.top).offset(90)
            c.right.equalTo(self.view.snp.right).offset(-23)
            c.width.equalTo(23)
            c.height.equalTo(23)
        }
        loading_view.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.233) {
            if (self.discover_index >= Saily.discover_root.count || self.discover_index < 0) {
                return
            }
            if (Saily.discover_root[self.discover_index].tweak_id != "") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.show_tweaks()
                }
            }
        }
    }
    
    var tweak_view = UIView()
    func show_tweaks() {
        
        let withName = Saily.discover_root[self.discover_index].tweak_id
        
        if (Saily.installed[withName.uppercased()] != nil) {
            return
        }
        
        DispatchQueue.main.async {
            
            let this_one = self.tweak_view
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    this_one.alpha = 0
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    this_one.removeFromSuperview()
                })
            }
            
            let package = Saily.search_a_package_with(its_name: withName)
            self.tweak_view = UIView()
            self.tweak_view.backgroundColor = .clear
            self.tweak_view.alpha = 0
            self.tweak_view.setRadius(radius: 20)
            self.view.addSubview(self.tweak_view)
            self.tweak_view.snp.makeConstraints { (x) in
                x.left.equalTo(self.view.snp.left).offset(28)
                x.right.equalTo(self.view.snp.right).offset(-28)
                if (Saily.device.indentifier_human_readable.uppercased().contains("iPad".uppercased()) && UIScreen.main.bounds.width > UIScreen.main.bounds.height) {
                    x.bottom.equalTo(self.view.snp.bottom).offset(-55)
                }else{
                    x.bottom.equalTo(self.view.snp.bottom).offset(-18 - (self.tabBarController?.tabBar.bounds.height ?? 88))
                }
                x.height.equalTo(66)
            }
            
            let visual_effect = UIBlurEffect(style: .extraLight)
            let effect_view = UIVisualEffectView(effect: visual_effect)
            self.tweak_view.addSubview(effect_view)
            effect_view.snp.makeConstraints { (x) in
                x.top.equalTo(self.tweak_view.snp.top)
                x.bottom.equalTo(self.tweak_view.snp.bottom)
                x.right.equalTo(self.tweak_view.snp.right)
                x.left.equalTo(self.tweak_view.snp.left)
            }
            
            let image = UIImageView.init(image: #imageLiteral(resourceName: "iConRound.png"))
            self.tweak_view.addSubview(image)
            self.tweak_view.contentMode = .scaleAspectFit
            image.snp.makeConstraints { (x) in
                x.left.equalTo(self.tweak_view.snp.left).offset(8)
                x.top.equalTo(self.tweak_view.snp.top).offset(8)
                x.bottom.equalTo(self.tweak_view.snp.bottom).offset(-8)
                x.width.equalTo(image.snp.height)
            }
            
            let name = UILabel()
            name.text = package?.info["NAME"] ?? withName
            name.textColor = .darkGray
            name.font = .boldSystemFont(ofSize: 18)
            self.tweak_view.addSubview(name)
            name.snp.makeConstraints { (x) in
                x.left.equalTo(image.snp.right).offset(8)
                x.right.equalTo(self.tweak_view.snp.right).offset(-80)
                x.centerY.equalTo(image.snp.centerY).offset(-8)
                x.height.equalTo(24)
            }
            
            
            let repo = UILabel()
            repo.text = package?.fater_repo.ress.major ?? Saily.discover_root[self.discover_index].tweak_repo
            repo.textColor = .lightGray
            repo.font = .boldSystemFont(ofSize: 10)
            self.tweak_view.addSubview(repo)
            repo.snp.makeConstraints { (x) in
                x.left.equalTo(image.snp.right).offset(10)
                x.right.equalTo(self.tweak_view.snp.right).offset(-77)
                x.centerY.equalTo(image.snp.centerY).offset(10)
                x.height.equalTo(24)
            }
            
            let add_button = UIButton()
            add_button.setTitleColor(.white, for: .normal)
            add_button.setTitleColor(.gray, for: .highlighted)
            add_button.setTitle("GET".localized(), for: .normal)
            for item in Saily.operation_container.installs {
                if (item.info["PACKAGE"] == withName) {
                    add_button.setTitle("QUEUE".localized(), for: .normal)
                    add_button.isEnabled = false
                    break
                }
            }
            add_button.titleLabel?.font = .boldSystemFont(ofSize: 14)
            add_button.addTarget(self, action: #selector(self.add), for: .touchUpInside)
            add_button.backgroundColor = #colorLiteral(red: 0.07285261899, green: 0.5867173076, blue: 0.8592197895, alpha: 1)
            add_button.setRadius(radius: 14)
            self.tweak_view.addSubview(add_button)
            add_button.snp.makeConstraints { (x) in
                x.right.equalTo(self.tweak_view.snp.right).offset(-12)
                x.top.equalTo(self.tweak_view.snp.top).offset(18)
                x.bottom.equalTo(self.tweak_view.snp.bottom).offset(-18)
                x.left.equalTo(name.snp.right).offset(12)
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.tweak_view.alpha = 1
                })
            }
        }
        
    }
    
    @objc func add(_ sender: UIButton) {
        if let packages = Saily.search_a_package_with(its_name: Saily.discover_root[self.discover_index].tweak_id) {
            var has_an_error = false
            let ret = Saily.operation_container.add_a_install(packages)
            if (ret == status_ins.ret_depends) {
                has_an_error = true
                print("[*] Add to Install Failed.")
                onlyOkayAlert(self, title: "Error".localized(), str: "Saily can't find the dependencies of a specified package, or the root daemon is currently offline.".localized())
            }else if (ret == status_ins.ret_no_file) {
                has_an_error = true
                print("[*] Add to Install Failed.")
                onlyOkayAlert(self, title: "Error".localized(), str: "Saily was unable to locate the package URL.".localized())
            }
            if (!has_an_error) {
                sender.setTitle("QUEUE".localized(), for: .normal)
                sender.isEnabled = false
            }
        }else{
            let alert = UIAlertController(title: "No Package Found".localized(), message: "Add this repo to your repo list?\n\n".localized() + Saily.discover_root[self.discover_index].tweak_repo, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (_) in
                var read = Saily.discover_root[self.discover_index].tweak_repo
                guard let url = URL.init(string: read) else {
                    return
                }
                let net_read = (try? String.init(contentsOf: url)) ?? ""
                if (net_read != "") {
                    if (!read.hasSuffix("/")) {
                        read += "/"
                    }
                    for item in Saily.repos_root.repos {
                        if (item.ress.major == read) {
                            return
                        }
                    }
                    Saily.repos_root.repos.append(a_repo(ilink: read))
                    Saily.repos_root.resave()
                    Saily.operation_quene.repo_queue.async {
                        Saily.repos_root.refresh_call()
                    }
                    Saily.repo_UI?.tableView.reloadData()
                    self.show_tweaks()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.web_container.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.web_container.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("[*] This web page is with height: " + height.debugDescription)
                })
            }
        })
        
        loading_view.stopAnimating()
        
    }
    
    var isBeginTouchPositionSet = false
    var beginTouchPosition = CGPoint()
    var endTouchPosition = CGPoint()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { exit(62) }
        var touches = [UITouch]()
        if let coalescedTouches = event?.coalescedTouches(for: touch){
            touches = coalescedTouches
        }else{
            touches.append(touch)
        }
        if (isBeginTouchPositionSet == false) {
            beginTouchPosition = (touches.first?.location(in: self.view))!
            isBeginTouchPositionSet = true
        }
        endTouchPosition = (touches.last?.location(in: self.view))!
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeginTouchPositionSet = false
        
        // 上滑手势
        if (abs(Int(beginTouchPosition.x - endTouchPosition.x)) < 120 && (beginTouchPosition.y - endTouchPosition.y) > 45 ) {
            beginTouchPosition = CGPoint(x: 0, y: 0)
            endTouchPosition = CGPoint(x: 0, y: 0)
            print("[*] Going up~")
            return
        }
        // 下滑手势
        if (abs(Int(beginTouchPosition.x - endTouchPosition.x)) < 120 && (beginTouchPosition.y - endTouchPosition.y) < -45 ) {
            beginTouchPosition = CGPoint(x: 0, y: 0)
            endTouchPosition = CGPoint(x: 0, y: 0)
            print("[*] Going down~")
            return
        }
    }
    
}
