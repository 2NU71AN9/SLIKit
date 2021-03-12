//
//  ViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/12.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let str: ColorString = "asdfd\(message: "Red", color: .red, font: label.font)\(message: "Green", color: .green, font: label.font)\(message: "Blue", color: .blue, font: label.font)"
        label.attributedText = str.value
        
        var array = Array {
            1
            2
            3
            4
            5
        }
        array.append {
            6
            7
            8
            9
            10
        }
        print(array)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        SLTagPickerViewController(["dasdadasc", "dajisdapskdncn", "dsada", "vlp[lpcclpxc"]) { (_) in
            
        }.show()
//        SLPickerViewController(["123", "22222"], complete: nil).show()
//        print(Bundle.main.infoDictionary)
    }
}

@_functionBuilder public struct ArrayBuilder {
    public static func buildBlock<T>(_ items: T...) -> [T] {
        items
    }
}

public extension Array {
    init(@ArrayBuilder _ builder: () -> Self) {
        self = builder()
    }
    
    mutating func append(@ArrayBuilder _ builder: () -> Self) {
        self.append(contentsOf: builder())
    }
}
