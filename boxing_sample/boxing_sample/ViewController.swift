//
//  ViewController.swift
//  boxing_sample
//
//  Created by Choi Min Kyu on 20/11/2018.
//  Copyright © 2018 ChoiMinKyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var NextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.eleven.bgColor(type: .fc03)
        colorLabel.eleven.font(type: .fc02, string: "color")
        colorLabel.eleven.font(type: .fc01, string: "label")
    }
}

