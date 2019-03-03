//
//  ViewController.swift
//  RX_GuguDan
//
//  Created by CHOI MIN KYU on 04/03/2019.
//  Copyright © 2019 minkyu.rx.gugudan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
	@IBOutlet weak var inputTextField: UITextField!
	@IBOutlet weak var outputLabel: UILabel!
	
	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		bind()
	}
}

extension ViewController {
	func bind() {
		let inputNumber = inputTextField.rx.text.orEmpty.map {
			Int($0) ?? 0
		}
		
		let result = inputNumber.map { (dan) -> String in
			return (1...9).map({ (step) -> String in
				return "\(dan) * \(step) = \(dan * step)\n"
			}).reduce("", +)
		}
		
		result.bind(to: self.outputLabel.rx.text).disposed(by: disposeBag)
	}
}

