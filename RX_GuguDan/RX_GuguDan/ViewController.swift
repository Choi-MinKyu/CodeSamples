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
		inputTextField.rx.text
			.orEmpty
			.asObservable()
			.flatMap { text -> Observable<Int> in
				guard let intValue = Int(text) else { return Observable.empty() }
				return Observable.just(intValue)
			}.flatMap { dan -> Observable<String> in
				return Observable<Int>.range(start: 1, count: 9)
					.map{ step -> String in
						return "\(dan) * \(step) = \(dan * step)"
					}.toArray()
					.map { steps -> String in
						return steps.reduce("") { (answer, next) -> String in
							return answer + "\n" + next
						}
				}
			}.debug().subscribe(onNext: { result in
				print(result)
				self.outputLabel.text = result
			}).disposed(by: disposeBag)
	}
}

