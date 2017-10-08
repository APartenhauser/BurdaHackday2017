//
//  TableHeaderView.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

public class TableHeaderView: UIView {
    var text: String = "" {
        didSet {
            isAccessibilityElement = true
            accessibilityLabel = text
            accessibilityTraits = UIAccessibilityTraitStaticText
        }
    }
    
    
    public func update(with title: String) {
        backgroundColor = .white
        
        text = title.uppercased()
        setNeedsDisplay()
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        // Drawing code
        let font = UIFont.boldSystemFont(ofSize: 12)
        let stringSize = font.sizeOfString(string: text, constrainedTo: CGSize(width: rect.size.width-20, height: rect.size.height))
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let offset: CGFloat = 10
        let borderRect = rect.insetBy(dx: 0, dy: offset)
        let x = borderRect.width/2-stringSize.width/2
        let y = borderRect.height/2-stringSize.height/2
        (text as NSString).draw(in: CGRect(x: x, y: y+offset, width: stringSize.width, height: stringSize.height), withAttributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor(red: 84/255, green: 82/255, blue: 82/255, alpha: 1)])
        (UIApplication.shared.delegate as! AppDelegate).mainThemeColor.setStroke()
        context.setLineWidth(2)
        
        
        context.move(to: CGPoint(x: 0, y: borderRect.height/2+offset))
        context.addLine(to: CGPoint(x: x-10, y: borderRect.height/2+offset))
        context.addLine(to: CGPoint(x: x-10, y: borderRect.minY))
        context.addLine(to: CGPoint(x: rect.width/2+stringSize.width/2+10, y: offset))
        context.addLine(to: CGPoint(x: rect.width/2+stringSize.width/2+10, y: borderRect.height/2+offset))
        context.addLine(to: CGPoint(x: rect.width, y: borderRect.height/2+offset))
        context.addLine(to: CGPoint(x: rect.width/2+stringSize.width/2+10, y: borderRect.height/2+offset))
        context.addLine(to: CGPoint(x: rect.width/2+stringSize.width/2+10, y: borderRect.height+offset))
        context.addLine(to: CGPoint(x: x-10, y: borderRect.height+offset))
        context.addLine(to: CGPoint(x: x-10, y: borderRect.height/2+offset))
        context.closePath()
        
        context.strokePath()
    }
}

extension UIFont {
    func sizeOfString(string: String, constrainedTo size: CGSize) -> CGSize {
        return (string as NSString).boundingRect(with: size,
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedStringKey.font: self], context: nil).size
    }
}
