source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Artsy/Specs.git'
workspace 'TFJunYouChat.xcworkspace'
platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end

target 'TFJunYouChat' do
  pod 'lottie-ios_Oc'
  pod 'Protobuf'
  pod 'CocoaAsyncSocket'
 
  ####################### 浏览器
  pod 'AFNetworking', '~> 3.1.0'
  pod 'CocoaLumberjack', '~> 3.4.1'
  pod 'MBProgressHUD', '~> 1.1.0'
    #pod 'GCDWebServer', '~> 3.4.2'
#    pod 'SDWebImage', '~> 4.2.3'
  pod 'SDWebImage', '~> 5.10.4 '
  pod 'Mantle', '~> 2.1.0'
 #################################
   pod 'XHToast'
   pod 'pop'
   pod 'FLAnimatedImage'
   pod 'Masonry'
   pod 'AvoidCrash'
   pod 'MJExtension', '~> 3.0.12'
   pod "SimpleAudioPlayer"
   pod 'SVProgressHUD'
#   pod 'JSONModel', '~> 3.0.12'
   pod 'KissXML'
   pod 'GPUImage', '~> 0.1.7'
#   pod 'SDWebImage' , '~> 3.8.2'
#   pod "QBImagePickerController"
#   pod 'RITLViewFrame'
#   pod 'RITLKit'
   pod 'MCDownloader'
#   pod 'XHLaunchAd'
#  pod 'RITLPhotos'
#  pod 'ImageEdit'
#  pod 'SBJson' , '~> 1.4.5'
  pod 'BPush'
  pod 'GoogleMaps'
#  pod 'BMKLocationKit', '~> 3.2.1'
  pod 'BaiduMapKit’, '~> 3.2.1'
    
  pod 'Bugly'
#   pod 'DMTransitions'
  pod 'JPush'
#   pod 'QBPopupMenu'
  pod 'IQKeyboardManager', '~> 3.2.0.3'
  pod 'HXPhotoPicker', '~> 3.1.8'
#  pod 'OpenSSL-Universal'
end
