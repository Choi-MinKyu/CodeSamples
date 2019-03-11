//
//  Service.swift
//  LoginWithRx
//
//  Created by CHOI MIN KYU on 2018/05/08.
//  Copyright CHOI MIN KYU. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa


/// handle our TextFiled text in RegisterViewController
class ValidationService {
    static let instance = ValidationService()
    
    private init() {}
    
    let minCharactersCount = 6
    
    func validateUsername(_ username: String) -> Observable<Result> {
        
        if username.count == 0 {
            return .just(.empty)
        }
        
        if username.count < minCharactersCount {
            return .just(.failed(message: "6자 이상 입력하세요."))
        }
        
        if usernameValid(username) {
            return .just(.failed(message: "계정이 이미 존재합니다."))
        }
        
        return .just(.ok(message: "사용가능합니다."))
    }
    
    func validatePassword(_ password: String) -> Result {
        if password.count == 0 {
            return .empty
        }
        
        if password.count < minCharactersCount {
            return .failed(message: "패스워드는 6자 이상이어야 합니다.")
        }
        
        return .ok(message: "사용가능합니다.")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPasswordword: String) -> Result {
        if repeatedPasswordword.count == 0 {
            return .empty
        }
        
        if repeatedPasswordword == password {
            return .ok(message: "사용가능합니다.")
        }
        
        return .failed(message: "암호확인 문자가 틀립니다.")
    }
    
    func register(_ username: String, password: String) -> Observable<Result> {
        let userDic = [username: password]
        
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        
        if (userDic as NSDictionary).write(toFile: filePath, atomically: true) {
            return .just(.ok(message: "등록 성공"))
        }
        return .just(.failed(message: "등록 실패"))
    }
    
    func usernameValid(_ username: String) -> Bool {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        let usernameArray = userDic?.allKeys
        guard usernameArray != nil else {
            return false
        }
        
        if (usernameArray! as NSArray).contains(username ) {
            return true
        } else {
            return false
        }
    }
    
    func loginUsernameValid(_ username: String) -> Observable<Result> {
        if username.count == 0 {
            return .just(.empty)
        }
        
        if usernameValid(username) {
            return .just(.ok(message: "사용할 수 있습니다.."))
        }
        return .just(.failed(message: "계정이 존재하지 않습니다."))
    }
    
    func login(_ username: String, password: String) -> Observable<Result> {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        if let userPass = userDic?.object(forKey: username) as? String {
            if  userPass == password {
                return .just(.ok(message: "로그인 성공"))
            }
        }
        return .just(.failed(message: "암호가 잘못 되었습니다."))
    }
}


class SearchService {
    static let share = SearchService()
    
    private init() {}
    
    func getHeros() -> Observable<[Hero]> {
        let herosString = Bundle.main.path(forResource: "heros", ofType: "plist")
        let herosArray = NSArray(contentsOfFile: herosString!) as! Array<[String: String]>
        var heros = [Hero]()
        for heroDic in herosArray {
            let hero = Hero(name: heroDic["name"]!, desc: heroDic["intro"]!, icon: heroDic["icon"]!)
            heros.append(hero)
        }
        
        return Observable.just(heros)
                    .observeOn(MainScheduler.instance)
    }
    
    func getHeros(withName name: String) -> Observable<[Hero]> {
        if name == "" {
            return getHeros()
        }
        
        let herosString = Bundle.main.path(forResource: "heros", ofType: "plist")
        let herosArray = NSArray(contentsOfFile: herosString!) as! Array<[String: String]>
        var heros = [Hero]()
        for heroDic in herosArray {
            if heroDic["name"]!.contains(name) {
                let hero = Hero(name: heroDic["name"]!, desc: heroDic["intro"]!, icon: heroDic["icon"]!)
                heros.append(hero)
            }
        }
        
        return Observable.just(heros)
            .observeOn(MainScheduler.instance)
    }
    
    
    
}
