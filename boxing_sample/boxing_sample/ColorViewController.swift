//
//  ColorViewController.swift
//  boxing_sample
//
//  Created by Choi Min Kyu on 20/11/2018.
//  Copyright © 2018 ChoiMinKyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ColorViewController: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var rSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
    @IBOutlet weak var hexColorTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

extension ColorViewController {
    func bind() {
        
        let rOvservable = rSlider.rx.value.map{ CGFloat($0) }
        rOvservable.map { String(format: "%.2f", $0)}
            .bind(to: rLabel.rx.text)
            .disposed(by: disposeBag)
        
        gSlider.rx.value.map { String(format: "%.2f", $0)}
            .bind(to: gLabel.rx.text) 
            .disposed(by: disposeBag)
        bSlider.rx.value.map { String(format: "%.2f", $0)}
            .bind(to: bLabel.rx.text)
            .disposed(by: disposeBag)
        let color = Observable<UIColor>.combineLatest(rOvservable, gSlider.rx.value, bSlider.rx.value) { (rValue, gValue, bValue) -> UIColor in
            return UIColor(red: rValue, green: CGFloat(gValue), blue: CGFloat(bValue), alpha: 1.0)
        }
        
        
        color.bind(to: colorView.rx.backgroundColor).disposed(by:disposeBag)
        color.map { $0.hexString }.bind(to: hexColorTextField.rx.text).disposed(by: disposeBag)
        
        applyButton.rx.tap.asObservable().withLatestFrom(hexColorTextField.rx.text).map { (hextTest: String?) -> (Int, Int, Int)? in
            return hextTest?.rgb
            }.flatMap { rgb -> Observable<(Int, Int, Int)> in
                guard let rgb = rgb else { return Observable.empty() }
                return Observable.just(rgb)
            }.subscribe(onNext: { [weak self] (red, green, blue) in
                guard let `self` = self else { return }
                self.rSlider.rx.value.onNext(Float(red)/255.0)
                self.rSlider.sendActions(for: .valueChanged)
                self.gSlider.rx.value.onNext(Float(green)/255.0)
                self.gSlider.sendActions(for: .valueChanged)
                self.bSlider.rx.value.onNext(Float(blue)/255.0)
                self.bSlider.sendActions(for: .valueChanged)
            }).disposed(by: disposeBag)
        
    }
}
// ColorViewcontroller.create(parent: self)  : Observable<ColorViewController>
extension Reactive where Base: ColorViewController {
    static func create(parent: UIViewController?, animated: Bool = true) -> Observable<ColorViewController> {
        return Observable<ColorViewController>.create({ (observer) -> Disposable in
            let colorViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
            
            let dismissDispoable = colorViewController.cancelButton.rx.tap.asObservable()
                .subscribe(onNext: { [weak colorViewController] () in
                    guard let colorViewController = colorViewController else { return }
                    colorViewController.dismiss(animated: animated, completion: nil)
                })
            
            let naviController = UINavigationController(rootViewController: colorViewController)
            parent?.present(naviController, animated: animated, completion: {
                observer.onNext(colorViewController)
            })
            return Disposables.create([dismissDispoable, Disposables.create {
                colorViewController.dismiss(animated: animated, completion: nil)
                }])
        })
    }
    var selectedColor: Observable<UIColor> {
        return base.doneButton.rx.tap.map {  _ -> UIColor in
            return (self.base.colorView.backgroundColor)!
        }
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
        guard let number: Int = Int(self, radix: 16) else { return nil }
        let blue = number & 0x0000ff
        let green = (number & 0x00ff00) >> 8
        let red = (number & 0xff0000) >> 16
        return (red, green, blue)
    }
}














