//
//  ViewController.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let str: ColorString = "asdfd\(message: "Red", color: .red, font: label.font)\(message: "Green", color: .green, font: label.font)\(message: "Blue", color: .blue, font: label.font)"
        label.attributedText = str.value
    }
}

