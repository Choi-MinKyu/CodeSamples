//
//  ViewController.swift
//  LoginWithRx
//
//  Created by CHOI MIN KYU on 2018/05/08.
//  Copyright CHOI MIN KYU. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = RegisterViewModel()
        
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
					.disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
					.disposed(by: disposeBag)
        
        repeatPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.repeatPassword)
					.disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(to: viewModel.registerTaps)
					.disposed(by: disposeBag)
        
        
        viewModel.usernameUsable
            .bind(to: usernameLabel.rx.validationResult)
					.disposed(by: disposeBag)
        viewModel.usernameUsable
            .bind(to: passwordTextField.rx.inputEnabled)
					.disposed(by: disposeBag)
        
        viewModel.passwordUsable
            .bind(to: passwordLabel.rx.validationResult)
					.disposed(by: disposeBag)
        viewModel.passwordUsable
            .bind(to: repeatPasswordTextField.rx.inputEnabled)
            .disposed(by: disposeBag)
        
        viewModel.repeatPasswordUsable
            .bind(to: repeatPasswordLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.registerButtonEnabled
            .subscribe(onNext: { [weak self] valid in
								guard let self = self else { return }
							
                self.registerButton.isEnabled = valid
                self.registerButton.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        viewModel.registerResult
            .subscribe(onNext: { [weak self] result in
								guard let self = self else { return }
							
                switch result {
                case let .ok(message):
                    self.showAlert(message: message)
                case .empty:
                    self.showAlert(message: "")
                case let .failed(message):
                    self.showAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.registerResult
            .bind(to: loginButton.rx.tapEnabled)
            .disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertViewController.addAction(action)
        present(alertViewController, animated: true, completion: nil)
    }

}

