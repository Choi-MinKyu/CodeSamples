//
//  ViewController.swift
//  RXColorView
//
//  Created by CHOI MIN KYU on 04/03/2019.
//  Copyright © 2019 RX Samples. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
	
	@IBOutlet weak var colorView: UIView!
	@IBOutlet weak var rLabel: UILabel!
	@IBOutlet weak var gLabel: UILabel!
	@IBOutlet weak var bLabel: UILabel!
	@IBOutlet weak var rSlider: UISlider!
	@IBOutlet weak var gSlider: UISlider!
	@IBOutlet weak var bSlider: UISlider!
	@IBOutlet weak var hexColorTextField: UITextField!
	@IBOutlet weak var applyButton: UIButton!
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		bind()
	}
}

extension ViewController {
	func initSlider() {
		rSlider.rx.value.asObservable().map {
			String(format: "%0.2f", $0)
			}.bind(to: rLabel.rx.text).disposed(by: disposeBag)
		
		gSlider.rx.value.asObservable().map {
			String(format: "%0.2f", $0)
			}.bind(to: gLabel.rx.text).disposed(by: disposeBag)
		
		bSlider.rx.value.asObservable().map {
			String(format: "%0.2f", $0)
			}.bind(to: bLabel.rx.text).disposed(by: disposeBag)
	}
	
	func bind() {
		initSlider()
		
		let color = Observable<UIColor>.combineLatest(rSlider.rx.value, gSlider.rx.value, bSlider.rx.value) { (rValue, gValue, bValue) -> UIColor in
			UIColor(red: CGFloat(rValue), green: CGFloat(gValue), blue: CGFloat(bValue), alpha: 1.0)
		}
		
		color.bind(to: colorView.rx.backgroundColor).disposed(by: disposeBag)
		color.map { $0.hexString }.bind(to: hexColorTextField.rx.text).disposed(by: disposeBag)
		
		rSlider.rx.value.asObservable().map { (value) -> UIColor in
			UIColor(white: CGFloat(value), alpha: 1.0)
			}.bind(to: colorView.rx.backgroundColor).disposed(by: disposeBag)
		
		applyButton.rx.tap.asObservable().withLatestFrom(hexColorTextField.rx.text).map { (hexText: String?) -> (Int, Int, Int)? in
			return hexText?.rgb
			}.flatMap { (rgb) -> Observable<(Int, Int, Int)> in
				guard let rgb = rgb else { return Observable.empty() }
				return Observable.just(rgb)
			}.subscribe(onNext: { [weak self] (red, green, blue) in
				guard let `self` = self else { return }
				
				self.rSlider.rx.value.onNext(Float(red) / 255.0) //
				self.rSlider.sendActions(for: .valueChanged)
				
				self.gSlider.rx.value.onNext(Float(green) / 255.0) //
				self.gSlider.sendActions(for: .valueChanged)
				
				self.bSlider.rx.value.onNext(Float(blue) / 255.0) //
				self.bSlider.sendActions(for: .valueChanged)
			}).disposed(by: disposeBag)
		
	}
}

extension Reactive where Base: UIView {
	var backgroundColor: Binder<UIColor> {
		return Binder(self.base) { view, color in
			view.backgroundColor = color
		}
	}
}

extension UIColor {
	var hexString: String {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return String(format: "%.2X%.2X%.2X", Int(255 * red), Int(255 * green), Int(255 * blue))
	}
}

extension String {
	var rgb: (Int, Int, Int)? {
		guard let number: Int = Int(self, radix: 16) else {
			return nil
		}
		
		let blue = number & 0x0000FF
		let green = number  & 0x00FF00 >> 8
		let red = number & 0xff0000 >> 16
		return (red, green, blue)
	}
}

