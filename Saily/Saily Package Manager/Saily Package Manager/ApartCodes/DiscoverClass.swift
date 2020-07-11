//
//  DiscoverClass.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
import UIKit

let preview_discover_file = "https://raw.githubusercontent.com/Co2333/SailyHomePagePreview/master/preview"

// subtitle, title, image, detail, link
class discover_C {
    
    public var title_big                = String()
    public var title_small              = String()
    public var text_details             = String()
    public var image_link               = String()
    public var web_link                 = String()
    public var tweak_id                 = String()
    public var tweak_repo               = String()
    public var card_kind                = 0
    
    init() {
        self.card_kind = 1
    }
    
    func apart_init(withString: String) {

        let splited = withString.split(separator: "|")
        
        if (splited.count < 9) {
            self.title_big = "ERROR"
            self.title_small = "Document is in wrong format."
            self.text_details = "Please contact developer for a fix or more. mailto://saily@233owo.com"
            self.image_link = "https://www.virginexperiencedays.co.uk/content/img/product/large/the-view-from-the-12102928.jpg"
            return
        }
        
        self.card_kind = Int(splited[0]) ?? 1
        self.title_big = splited[1].description
        self.title_small = splited[2].description
        self.text_details = splited[3].description
        self.image_link = splited[4].description
        self.web_link = splited[5].description
        
        if (splited[6] == "true") {
            self.tweak_id = splited[7].description
            self.tweak_repo = splited[8].description
        }
        
        
    }
    
    
}


