//
//  Protocol.swift
//  LoginWithRx
//
//  Created by CHOI MIN KYU on 2018/05/08.
//  Copyright CHOI MIN KYU. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


/// service handle result
///
/// - ok: ok
/// - empty: nothing
/// - failed: failed
enum Result {
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension Result {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension Result {
    var textColor: UIColor {
        switch self {
        case .ok:
            return UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
        case .empty:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }
}


extension Result {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        }
    }
}

extension Reactive where Base: UILabel {
    var validationResult: Binder<Result> {
        return Binder(self.base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}

extension Reactive where Base: UITextField {
    var inputEnabled: Binder<Result> {
        return Binder(self.base) { textFiled, result in
            textFiled.isEnabled = result.isValid
        }
    }
}

extension Reactive where Base: UIBarButtonItem {
    var tapEnabled: Binder<Result> {
        return Binder(self.base) { button, result in
            button.isEnabled = result.isValid
        }
    }
}
