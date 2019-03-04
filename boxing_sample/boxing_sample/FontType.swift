//
//  FontType.swift
//  boxing_sample
//
//  Created by Choi Min Kyu on 20/11/2018.
//  Copyright © 2018 ChoiMinKyu. All rights reserved.
//

import UIKit

public enum ElevenFontType{
    case fc01;
    case fc02;
    case fc03;
}

extension ElevenFontType {
    var font: UIFont {
        var font: UIFont = UIFont.systemFont(ofSize: 17.0)
        
        switch self {
        case .fc01:
            font = UIFont.systemFont(ofSize: 19.0)
        case .fc02:
            font = UIFont.systemFont(ofSize: 19.0)
        case .fc03:
            font = UIFont.boldSystemFont(ofSize: 31.0)
        }
        
        return font
    }
    
    var color: UIColor {
        var color : UIColor = UIColor.black
        
        switch self {
        case .fc01:
            color = .blue
        case .fc02:
            color = .white
        case .fc03:
            color = .red
        }
        
        return color
    }
}
