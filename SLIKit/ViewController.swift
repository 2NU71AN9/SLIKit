//
//  ViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/12.
//

import UIKit
import SwiftMessages

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
    
    var a = true
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        SL.pickerDate
//            .mode(.dateAndTime)
            .minDate(Date())
            .show()
        
//        SL.pickerTag
//            .titles(["dasdadasc", "dajisdapskdncn", "dsada", "vlp[lpcclpxc"])
//            .maxNum(2)
//            .primeColor(.blue)
//            .font(SL.PingFang.font(name: .中粗, size: 12))
//            .show()
        
//        SL.pickerNormal
//            .titles(["123123", "dsadasdadasd", "vxv24141"])
//            .show()
        
//        SL.pickerImage?.selectPortrait { [weak self] (image, _) in
//            self?.imageView.image = image
//        }
        
//        SL.pickerImage?
//            .maxNum(3)
//            .aspectRatio(.type_1x1)
//            .show { (_) in
//
//            }
        
//        let vc = SLQRCodeViewController { result in
//            SLHUD.showToast(result?.strScanned)
//        }
//        present(vc, animated: true, completion: nil)
        
//        let image = SLTools.makeBarCode(content: "dasdapsdlapd", size: imageView.frame.size, codeColor: .blue, bgColor: .systemPink)
//        imageView.image = image
        
//        SL.pickerFile.complete { url, data in
//            print(url)
//            print(data)
//            SLFileBrowser(url).show()
//        }.show()
        
//        let vc = SLAddressPickerViewController(.area) { p, c, a in
//            print((p?.name ?? "") + (c?.name ?? "") + (a?.name ?? ""))
//        }
//        present(vc, animated: true, completion: nil)
//        a = !a
//        SLHUD.message(title: a ? "提交成功" : "提交失败", desc: nil) {
//
//        }
//        let vc2 = SLQRCodeViewController { _ in
//
//        }
//        present(vc2, animated: true)
    }
}

@resultBuilder public struct ArrayBuilder {
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
