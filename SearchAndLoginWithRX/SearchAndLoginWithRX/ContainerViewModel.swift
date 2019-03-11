//
//  ContainerViewModel.swift
//  LoginWithRx
//
//  Created by CHOI MIN KYU on 2018/05/08.
//  Copyright CHOI MIN KYU. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ContainerViewModel {
    var models: Driver<[Hero]>
    
    init(withSearchText searchText: Observable<String>, service: SearchService) {
        models = searchText
            .debug()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { text in
                return service.getHeros(withName: text)
            }.asDriver(onErrorJustReturn: [])
    }
}
