//
//  PackageDownloadView.swift
//  Saily Package Manager
//
//  Updated by Brecken Lusk on 6/6/19.
//  Copyright © 2019 Saily Team. All rights reserved.
//

import UIKit

class PackageDownloadView: UIView {

    public var image = UIImageView(image: #imageLiteral(resourceName: "iConRound.png"))
    public var name = UILabel(text: "com.Saily.Package.Name")
    public var version = UILabel(text: "Version: 0.1 beta")
    public var button = UIButton()
    
    func apart_init() {
        button.setTitle("Add to Queue", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = #colorLiteral(red: 0.2880531251, green: 0.5978398919, blue: 0.9421789646, alpha: 1)
        name.textColor = #colorLiteral(red: 0.2880531251, green: 0.5978398919, blue: 0.9421789646, alpha: 1)
        version.textColor = .lightGray
        self.addSubview(image)
        self.addSubview(name)
        self.addSubview(version)
        self.addSubview(button)
        image.snp.makeConstraints { (c) in
            c.bottom.equalTo(name.snp.top).offset(-4)
            c.width.equalTo(66)
            c.height.equalTo(66)
            c.centerX.equalTo(self.snp.centerX)
        }
        name.snp.makeConstraints { (c) in
            c.center.equalTo(self.snp.center)
        }
        version.snp.makeConstraints { (c) in
            c.top.equalTo(name.snp.bottom).offset(4)
            c.centerX.equalTo(self.snp.centerX)
        }
        button.snp.makeConstraints { (c) in
            c.top.equalTo(version.snp.bottom).offset(25)
            c.centerX.equalTo(self.snp.centerX)
            c.width.equalTo(138)
        }
        button.setRadius(radius: 16)
        button.addTarget(self, action:  #selector(add_to_quene), for: .touchUpInside)
        button.addTarget(self, action:  #selector(touch_down), for: .touchDown)
        button.addTarget(self, action:  #selector(touch_up), for: .touchUpOutside)
        button.isUserInteractionEnabled = true
    }

    @objc func add_to_quene(_ sender : UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            sender.backgroundColor = #colorLiteral(red: 0.2880531251, green: 0.5978398919, blue: 0.9421789646, alpha: 1)
        }
    }
    
    @objc func touch_down(_ sender : UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    }
    
    @objc func touch_up(_ sender : UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.2880531251, green: 0.5978398919, blue: 0.9421789646, alpha: 1)
    }
    
}
