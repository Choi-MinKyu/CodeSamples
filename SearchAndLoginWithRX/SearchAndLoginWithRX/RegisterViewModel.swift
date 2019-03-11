//
//  RegisterViewModel.swift
//  LoginWithRx
//
//  Created by CHOI MIN KYU on 2018/05/08.
//  Copyright CHOI MIN KYU. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class RegisterViewModel {
    //input:
    let username = Variable<String>("")
    let password = Variable<String>("")
    let repeatPassword = Variable<String>("")
    let registerTaps = PublishSubject<Void>()
    
    // output:
    let usernameUsable: Observable<Result>
    let passwordUsable: Observable<Result>
    let repeatPasswordUsable: Observable<Result>
    let registerButtonEnabled: Observable<Bool>
    
    let registerResult: Observable<Result>
    
    init() {
        let service = ValidationService.instance
        
        usernameUsable = username.asObservable()
            .flatMapLatest{ username in
                return service.validateUsername(username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "username 오류"))
            }
					.share(replay: 1)

        passwordUsable = password.asObservable()
            .map { password in
                return service.validatePassword(password)
            }
					.share(replay: 1)
        
        repeatPasswordUsable = Observable.combineLatest(password.asObservable(), repeatPassword.asObservable()) {
                return service.validateRepeatedPassword($0, repeatedPasswordword: $1)
            }
					.share(replay: 1)
        
        registerButtonEnabled = Observable.combineLatest(usernameUsable, passwordUsable, repeatPasswordUsable) {
            (username, password, repeatPassword) in
                username.isValid && password.isValid && repeatPassword.isValid
            }
            .distinctUntilChanged()
					.share(replay: 1)
        
        let usernameAndPassword = Observable.combineLatest(username.asObservable(), password.asObservable()) {
            ($0, $1)
        }
        
        registerResult = registerTaps.asObservable().withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, password) in
                return service.register(username, password: password)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Register 오류"))
            }
					.share(replay: 1)
    }
        
}

