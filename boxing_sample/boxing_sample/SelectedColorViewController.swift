//
//  SelectedColorViewController.swift
//  boxing_sample
//
//  Created by Choi Min Kyu on 20/11/2018.
//  Copyright © 2018 ChoiMinKyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SelectedColorViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: BehaviorRelay<[UIColor]> = BehaviorRelay(value: [UIColor.cyan, UIColor.magenta, UIColor.orange])
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}
extension SelectedColorViewController {
    func bind() {
        
        addButton.rx.tap.asObservable().flatMap { [weak self]  in
            return ColorViewController.rx.create(parent: self).flatMap { $0.rx.selectedColor }.take(1)
            }.subscribe(onNext: { [weak self] (color) in
                guard let `self` = self else { return }
                
                var datasource = self.datasource.value
                datasource.append(color)
                
                self.datasource.accept(datasource)
            }).disposed(by: disposeBag)
        
        datasource.bind(to: collectionView.rx.items(cellIdentifier: "ColorCell", cellType: UICollectionViewCell.self)) { (index, color, cell) in
            cell.contentView.backgroundColor = color
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self else { return }
            
            var datasource = self.datasource.value
            datasource.remove(at: indexPath.item)
            
            self.datasource.accept(datasource)
        }).disposed(by: disposeBag)
    }
}









