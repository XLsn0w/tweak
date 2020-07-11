//
//  Navigators.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
import UIKit

class initTabBarContoller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .clear
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let button = item.value(forKey: "_view") as? UIView ?? UIView()
        for item in button.subviews {
            if let image = item as? UIImageView {
                image.shineAnimation()
                break
            }
        }
    }
}

class main_tab_bar: UITabBar {
    
    override func awakeFromNib() {

    }
    
}
