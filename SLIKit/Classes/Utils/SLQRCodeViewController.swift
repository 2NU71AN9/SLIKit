//
//  SLQRCodeViewController.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/6/25.
//

#if canImport(swiftScan)
import UIKit
import swiftScan

public class SLQRCodeViewController: LBXScanViewController {

    public var complete: ((LBXScanResult?) -> Void)?
    
    private lazy var style: LBXScanViewStyle = {
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = .Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        style.anmiationStyle = .LineMove
        style.colorAngle = UIColor(red: 0.0 / 255, green: 200.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
        style.animationImage = nil //SLAssets.bundledImage(named: "qrcode_Scan_Line")
        return style
    }()
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(SLAssets.bundledImage(named: "navi_back_white"), for: .normal)
        btn.addTarget(self, action: #selector(dismissAnimatedAction), for: .touchUpInside)
        return btn
    }()
    private lazy var flashBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(SLAssets.bundledImage(named: "flash_close50"), for: .normal)
        btn.setImage(SLAssets.bundledImage(named: "flash_open50"), for: .selected)
        btn.addTarget(self, action: #selector(openOrCloseFlash), for: .touchUpInside)
        return btn
    }()
    private lazy var albumBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(SLAssets.bundledImage(named: "album50"), for: .normal)
        btn.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)
        return btn
    }()
    
    /// 闪关灯开启状态
    private var isOpenedFlash = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.addSubview(closeBtn)
        view.insertSubview(flashBtn, aboveSubview: closeBtn)
        view.insertSubview(albumBtn, aboveSubview: closeBtn)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        closeBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(SL.statusBarHeight + 15)
        }
        flashBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-80)
        }
        albumBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(flashBtn)
        }
    }
    
    public init(_ complete: ((LBXScanResult?) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        self.complete = complete
        scanStyle = style
        isOpenInterestRect = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawScanView() {
        super.drawScanView()
        if let qRScanView = qRScanView {
            view.insertSubview(qRScanView, belowSubview: closeBtn)
        }
    }
    
    public override func handleCodeResult(arrayResult: [LBXScanResult]) {
        dismissAction(false)
        complete?(arrayResult.first)
    }
}

extension SLQRCodeViewController {
    /// 开关闪光灯
    @objc private func openOrCloseFlash() {
        scanObj?.changeTorch()
        isOpenedFlash = !isOpenedFlash
        flashBtn.isSelected = isOpenedFlash
    }
    
    @objc private func dismissAnimatedAction() {
        dismissAction()
    }
    
    private func dismissAction(_ animated: Bool = true) {
        if navigationController?.presentingViewController != nil || presentingViewController != nil {
            dismiss(animated: animated, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
#endif
