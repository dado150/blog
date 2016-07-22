//
//  lineHeight.swift
//  
//
//  Created by DAdo150 on 5/28/16.
//
//

import UIKit

    extension UILabel {
        
        func setLineHeight(lineHeight: CGFloat) {
            let text = self.text
            if let text = text {
                let attributeString = NSMutableAttributedString(string: text)
                let style = NSMutableParagraphStyle()
                
                style.lineSpacing = lineHeight
                attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, count(text)))
                self.attributedText = attributeString
            }
        }


}