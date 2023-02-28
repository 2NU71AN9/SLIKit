Pod::Spec.new do |s|

  s.name         = "SLIKit"
  s.version      = "1.5.6"
  s.swift_version  = "5.0"
  s.summary      = "开发常用"
  s.description  = "开发中常用的扩展和工具"
  s.homepage     = "https://github.com/2NU71AN9/SLIKit" #项目主页，不是git地址
  s.license      = { :type => "MIT", :file => "LICENSE" } #开源协议
  s.author       = { "2UN7" => "1491859758@qq.com" }
  s.platform     = :ios, "13.0"
  s.source       = { :git => "https://github.com/2NU71AN9/SLIKit.git", :tag => "v#{s.version}" } #存储库的git地址，以及tag值
  s.source_files = "SLIKit/Classes/**/*.{h,m,swift,xib,xcassets}"
  s.resources    = "SLIKit/Classes/Resource/*.bundle"
  s.resource_bundles = {
    'SLIKit' => ['SLIKit/Classes/**/*.xcassets', 'SLIKit/Classes/**/*.xib']
  }
  
  s.subspec 'Lite' do |ss|
  end
  
  s.subspec 'Full' do |ss|
      ss.requires_arc = true #是否支持ARC
      ss.dependency "RxSwift"
      ss.dependency "RxCocoa"
      ss.dependency "Then"
      ss.dependency "SnapKit"
      ss.dependency "MJRefresh"
      ss.dependency "SwiftDate"
      ss.dependency "JXPhotoBrowser"
      ss.dependency "Kingfisher"
      ss.dependency "FSTextView"
      ss.dependency "Haptica"
      ss.dependency "TagListView"
      ss.dependency "HXPhotoPicker"
      ss.dependency "swiftScan"
      ss.dependency "SwiftMessages"
      ss.dependency "ProgressHUD"
      ss.dependency "Toaster"
  end
  
end
