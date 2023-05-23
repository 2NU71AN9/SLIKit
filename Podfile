#source 'https://github.com/CocoaPods/Specs.git'
#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios, '13.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings["DEVELOPMENT_TEAM"] = "CZ483CQ6S3"
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end

target 'SLIKit' do
  use_frameworks!

pod 'RxSwift'
pod 'RxCocoa'
pod 'Then'
pod 'SnapKit'
pod 'MJRefresh'
pod 'SwiftDate'
pod 'JXPhotoBrowser'
pod 'Kingfisher'
pod 'FSTextView'
pod 'Haptica'
pod 'TagListView'
pod 'HXPhotoPicker'
pod 'swiftScan'
pod 'SwiftMessages'
pod 'ProgressHUD'
pod 'Toaster'

end
