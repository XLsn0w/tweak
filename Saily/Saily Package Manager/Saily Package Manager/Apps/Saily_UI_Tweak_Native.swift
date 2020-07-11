//
//  Saily_UI_Tweak_Native.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/22.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

private let reuseIdentifier = "images"

class Saily_UI_Tweak_Native: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    

    public var this_package: packages_C? = nil
    @IBOutlet weak var container: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("[*] Catch package info:")
        print(self.this_package?.info as Any)
        
//        self.download_depiction()
        
    }
    

    override func viewDidLayoutSubviews() {

    }
    
    @objc func add_queue(_ sender: UIButton) {
        
    }
    
    func download_depiction() {
        
    }

}




extension Saily_UI_Tweak_Native: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let scx = self.view.bounds.width
        let scy = self.view.bounds.height
        
        if (scy < 600 && scx < 350) {
            return CGSize(width: scx - 20, height: 420)
        }
        
        if (Saily.device.indentifier_human_readable.uppercased().contains("iPad".uppercased())) {
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
