//
//  ViewController.swift
//  RXAnimation
//
//  Created by CHOI MIN KYU on 04/03/2019.
//  Copyright © 2019 RX Samples. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

enum Animation {
	case left
	case right
	case down
	case up
}

extension Animation {
	func transform( _ transform: CGAffineTransform) -> CGAffineTransform {
		switch self {
		case .left:
			return transform.translatedBy(x: -50, y: 0)
		case .right:
			return transform.translatedBy(x: 50, y: 0)
		case .down:
			return transform.translatedBy(x: 0, y: 50)
		case .up:
			return transform.translatedBy(x: 0, y: -50)
		}
	}
}


final class ViewController: UIViewController {
	@IBOutlet weak var boxView: UIView!
	@IBOutlet weak var upButton: UIButton!
	@IBOutlet weak var leftButton: UIButton!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var downButton: UIButton!
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}


}

