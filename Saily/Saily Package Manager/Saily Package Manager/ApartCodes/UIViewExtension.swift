//
//  UIViewExtension.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2;
        self.layer.masksToBounds = true;
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension String {
    func height(constrainedBy width: CGFloat, with font: UIFont) -> CGFloat {
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(constrainedBy height: CGFloat, with font: UIFont) -> CGFloat {
        let constrainedSize = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
}

//MARK: - UIView Extensions

extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}

func onlyOkayAlert(_ sender: UIViewController, title: String, str: String) {
    let alert = UIAlertController(title: title, message: str, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay".localized(), style: .cancel, handler: nil))
    sender.present(alert, animated: true, completion: nil)
}
