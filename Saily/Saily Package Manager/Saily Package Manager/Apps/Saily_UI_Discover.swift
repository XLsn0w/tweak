//
//  Saily_UI_DiscoverCollectionViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

import Hero
import EzPopup

private let reuseIdentifier = "cards"

class Saily_UI_Discover: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collection_view: UICollectionView?
    @IBOutlet weak var no_responed_delegate: UIImageView!
    @IBOutlet weak var mafu_loading: UIImageView!
    @IBOutlet weak var mafu_lll: UIActivityIndicatorView!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Will Transition to size \(size) from super view size \(self.view.frame.size)")
        
        if (size.width > self.view.frame.size.width) {
            print("Landscape")
        } else {
            print("Portrait")
        }
        if (size.width != self.view.frame.size.width) {
            DispatchQueue.main.async {
                self.collection_view?.reloadData()
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Saily.discover_UI = self
        
        collection_view?.delegate = self
        collection_view?.dataSource = self
        
        self.view.layoutIfNeeded()
        self.collection_view?.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.88) {
            UIView.animate(withDuration: 1, animations: {
                self.mafu_lll.alpha = 0
                self.mafu_loading.alpha = 0
                self.no_responed_delegate.alpha = 0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.88) {
            self.mafu_lll.isHidden = true
            self.mafu_loading.isHidden = true
            self.no_responed_delegate.isHidden = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Saily.discover_root.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.contentView.layer.cornerRadius = 12.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        for item in cell.contentView.subviews {
            item.removeFromSuperview()
        }
        
        let whiteBG = UIImageView.init(image: #imageLiteral(resourceName: "WHITE.png"))
        whiteBG.contentMode = .scaleToFill
        cell.contentView.addSubview(whiteBG)
        
        whiteBG.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top)
            c.bottom.equalTo(cell.contentView.snp.bottom)
            c.left.equalTo(cell.contentView.snp.left)
            c.right.equalTo(cell.contentView.snp.right)
        }
        
        if (indexPath.row == Saily.discover_root.count) {
            let bg = UIImageView()
            bg.image = #imageLiteral(resourceName: "BGBlue.png")
            bg.contentMode = .scaleAspectFill
            cell.contentView.addSubview(bg)
            bg.snp.makeConstraints { (c) in
                c.top.equalTo(cell.contentView.snp.top)
                c.bottom.equalTo(cell.contentView.snp.bottom)
                c.left.equalTo(cell.contentView.snp.left)
                c.right.equalTo(cell.contentView.snp.right)
            }
            var udid_str = ""
            if (!Saily.device.udid_is_true) {
                udid_str = "FAKE: ".localized()
            }
            udid_str += Saily.device.udid.description
            let udid_lable = UILabel.init(text: udid_str)
            udid_lable.font = UIFont.systemFont(ofSize: 10)
            udid_lable.textColor = .white
            cell.contentView.addSubview(udid_lable)
            udid_lable.snp.makeConstraints { (c) in
                c.bottom.equalTo(cell.contentView.snp.bottom).offset(-25)
                c.centerX.equalTo(cell.contentView.snp.centerX)
            }
            let main_lable = UILabel.init(text: Saily.device.identifier + " - " + Saily.device.indentifier_human_readable + " - " + Saily.device.version)
            main_lable.textColor = .white
            main_lable.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(main_lable)
            main_lable.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp.centerX)
                c.bottom.equalTo(udid_lable.snp.bottom).offset(-15)
            }
            let welcome_lable = UILabel.init(text: "Welcome to Saily".localized())
            welcome_lable.textColor = .white
            welcome_lable.font = UIFont.systemFont(ofSize: 32)
            cell.contentView.addSubview(welcome_lable)
            welcome_lable.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp.centerX)
                c.centerY.equalTo(cell.contentView.snp.centerY).offset(50)
            }
            let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String) ?? "NAN"
            let buildVersion = (Bundle.main.infoDictionary!["CFBundleVersion"] as? String) ?? "NAN"
            let version_label = UILabel.init(text: "Version: ".localized() + appVersion + " Build: ".localized() + buildVersion)
            version_label.textColor = .white
            version_label.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(version_label)
            version_label.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp.centerX)
                c.centerY.equalTo(cell.contentView.snp.centerY).offset(80)
            }
            let icon = UIImageView()
            icon.image = #imageLiteral(resourceName: "iConWhiteTransparent.png")
            icon.contentMode = .scaleAspectFit
            cell.contentView.addSubview(icon)
            icon.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp.centerX)
                c.centerY.equalTo(cell.contentView.snp.centerY).offset(-55)
                c.width.equalTo(128)
                c.height.equalTo(128)
            }
            
            return cell
        }
        
        var content = UIView()
        cell.contentView.addSubview(content)
        
        switch Saily.discover_root[indexPath.row].card_kind {
        case 1:
            content = CardCellKind1()
            (content as? CardCellKind1)?.apart_init(Saily.discover_root[indexPath.row], fater_View: cell.contentView)
        case 2:
            content = CardCellKind2()
            (content as? CardCellKind2)?.apart_init(Saily.discover_root[indexPath.row], fater_View: cell.contentView)
        default:
            content = CardCellKind1()
            (content as? CardCellKind1)?.apart_init(Saily.discover_root[indexPath.row], fater_View: cell.contentView)
        }
        
        cell.addSubview(content)
        content.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top)
            c.left.equalTo(cell.contentView.snp.left)
            c.right.equalTo(cell.contentView.snp.right)
            c.bottom.equalTo(cell.contentView.snp.bottom)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        let scx = UIScreen.main.bounds.width
//        let scy = UIScreen.main.bounds.height
        let scx = self.view.bounds.width
        let scy = self.view.bounds.height
        if (scy > scx) {
            return 50
        }
        return scx / 18
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let new = sb.instantiateViewController(withIdentifier: "Saily_UI_Discover_Detail_ID") as? Saily_UI_Discover_Detail
        
        let scx = self.view.bounds.width
        let scy = self.view.bounds.height
        
        if (indexPath.row == Saily.discover_root.count) {
            new?.discover_index = -666
        }else{
            new?.discover_index = indexPath.row
        }
        
        if (Saily.device.indentifier_human_readable.uppercased().contains("iPad".uppercased())) {
            if (scx > scy) {
                let popupVC = PopupViewController(contentController: new!, popupWidth: scy * 0.8, popupHeight: scy * 0.8)
                popupVC.canTapOutsideToDismiss = true
                popupVC.cornerRadius = 10
                popupVC.shadowEnabled = false
                present(popupVC, animated: true)
                return
            }
        }
        
        self.navigationController?.pushViewController(new!)
        
    }
    
}


extension Saily_UI_Discover: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let scx = self.view.bounds.width
        let scy = self.view.bounds.height
        
        if (scy < 600 && scx < 350) {
            return CGSize(width: scx - 20, height: 420)
        }
        
        if (Saily.device.indentifier_human_readable.uppercased().contains("iPad".uppercased())) {
            
            if (scx < 366) {
                return CGSize(width: scx - 60, height: 380)
            }
            
            if (scx < 580) {
                return CGSize(width: scx - 60, height: 380)
            }
            
            if (scx < scy) {
                return CGSize(width: (scx - 120) / 2, height: 380)
            }
            // land
            switch indexPath.row % 4 {
            case 0, 3:
                return CGSize(width: scx * 5.2 / 10, height: 380)
            case 1, 2:
                return CGSize(width: scx * 3.6 / 10, height: 380)
            default:
                break
            }
        }
        return CGSize(width: scx - 60, height: 380)
    }
    
    
}
