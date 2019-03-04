//
//  extensions.swift
//  boxing_sample
//
//  Created by Choi Min Kyu on 20/11/2018.
//  Copyright © 2018 ChoiMinKyu. All rights reserved.
//

import Foundation
import UIKit

public struct ElevenST<Base> {
    let instance: Base
    
    init(_ base: Base) { self.instance = base }
}

protocol BoxCompatibles {
    associatedtype CompatibleType
    
    var eleven: ElevenST<CompatibleType> { get set }
    static var eleven: ElevenST<CompatibleType>.Type { get set }
}

extension BoxCompatibles {
    var eleven: ElevenST<Self> {
        get { return ElevenST(self) }
        set { }
    }
    static var eleven: ElevenST<Self>.Type {
        get { return ElevenST<Self>.self }
        set { }
    }
}

extension NSObject: BoxCompatibles {}
extension ElevenST where Base: UIView {
    func bgColor(type: ElevenFontType) {
        instance.backgroundColor = type.color
    }
}

extension ElevenST where Base: UILabel {
    func fontAndColor(type: ElevenFontType) {
        instance.font = type.font
        instance.textColor = type.color
    }
    
    func font(type: ElevenFontType, string: String?) {
        guard let string = string else { return }
        
        let attributedText = instance.attributedText!.mutableCopy() as! NSMutableAttributedString
        
        let range = ((instance.text ?? "") as NSString).range(of: string)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSAttributedString.Key.font: type.font], range: range)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: type.color , range: range)
        }
        
        instance.attributedText = attributedText
    }
}


