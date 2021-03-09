Pod::Spec.new do |s|

  s.name         = "SLIKit"
  s.version      = "1.4.3"
  s.swift_version  = "5.0"
  s.summary      = "开发常用"
  s.description  = "开发中常用的扩展和工具"
  s.homepage     = "https://github.com/2NU71AN9/SLIKit" #项目主页，不是git地址
  s.license      = { :type => "MIT", :file => "LICENSE" } #开源协议
  s.author       = { "2UN7" => "1491859758@qq.com" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/2NU71AN9/SLIKit.git", :tag => "v#{s.version}" } #存储库的git地址，以及tag值
  s.source_files  =  "SLSupportLibrary/Support/**/*.{h,m,swift}" #需要托管的源代码路径
  s.resource_bundle = { 'SLSupportLibrary' => 'SLSupportLibrary/Support/**/*.xcassets' }
  s.resources     = 'SLSupportLibrary/Support/*.{bundle}'
  
  s.requires_arc = true #是否支持ARC
  s.dependency "RxSwift"
  s.dependency "RxCocoa"
  s.dependency "Then"
  s.dependency "SnapKit"
  s.dependency "pop"
  s.dependency "HandyJSON"
  s.dependency "MJRefresh"
  s.dependency "PKHUD"
  s.dependency "SwiftDate"
  s.dependency "JXPhotoBrowser"
  s.dependency "Kingfisher"
  s.dependency "FSTextView"
  s.dependency "Haptica"
  
end