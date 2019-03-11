//
//  LoginViewModel.swift
//  LoginWithRx
//
//  Created by CHOI MIN KYU on 2018/05/08.
//  Copyright CHOI MIN KYU. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class LoginViewModel {
    
    //output:
    let usernameUsable: Driver<Result>
    let loginButtonEnabled: Driver<Bool>
    let loginResult: Driver<Result>
    
    init(input: (username: Driver<String>, password: Driver<String>, loginTaps: Driver<Void>),
        service: ValidationService) {
        usernameUsable = input.username
            .flatMapLatest { username in
                    return service.loginUsernameValid(username)
                        .asDriver(onErrorJustReturn: .failed(message: "서버오류, 잠시후 다시 시도해 주세요."))
            }
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            ($0, $1)
        }
        
        loginResult = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, password) in
                return service.login(username, password: password)
                    .asDriver(onErrorJustReturn: .failed(message: "서버오류, 잠시후 다시 시도해 주세요."))
            }
        
        loginButtonEnabled = input.password
            .map { $0.count > 0 }
            .asDriver()
    }
    
    
}
