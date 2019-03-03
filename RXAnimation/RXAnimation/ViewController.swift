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
		
		bind()
	}
}

extension ViewController {
	func bind() {
		self.leftButton.rx.tap.map {
			Animation.left
			}.subscribe(onNext: { [weak self] _ in
				guard let `self` = self else { return }
				UIView.animate(withDuration: 1.0, animations: {
					self.boxView.transform = self.boxView.transform.translatedBy(x: -50, y: 0)
				})
			}).disposed(by: disposeBag)
		
		
		
		self.rightButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
			guard let `self` = self else { return }
			UIView.animate(withDuration: 1.0, animations: {
				self.boxView.transform = self.boxView.transform.translatedBy(x: 50, y: 0)
			})
		}).disposed(by: disposeBag)
		
		self.downButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
			UIView.animate(withDuration: 1.0, animations: {
				guard let `self` = self else { return }
				self.boxView.transform = self.boxView.transform.translatedBy(x: 0, y: 50)
			})
		}).disposed(by: disposeBag)
		
		self.upButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
			guard let `self` = self else { return }
			UIView.animate(withDuration: 1.0, animations: {
				self.boxView.transform = self.boxView.transform.translatedBy(x: 0, y: -50)
			})
		}).disposed(by: disposeBag)
	}
}

