source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!

def shared_pods
    #Network
    pod 'Alamofire'
    pod 'ReachabilitySwift'
    pod 'SDWebImage', '~>3.7'
    pod 'SwiftyJSON'
    pod 'Socket.IO-Client-Swift'

    #    pod 'RMPZoomTransitionAnimator'
    pod 'AAViewAnimator'
    pod 'Stripe'
    pod 'TextFieldEffects'
    pod 'IQKeyboardManagerSwift'
    pod 'Tapptitude', :path => '.'
    pod 'TTSegmentedControl'

    #Google
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    
    #Analytics & Reporting Tools
    pod 'GoogleAnalytics'
    pod 'Kahuna'
    pod 'AppsFlyerFramework'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Mixpanel-swift'
    pod 'TestFairy'

    #Social
    pod 'FacebookShare'
end

target 'Handstand' do
    shared_pods
    
    swift4Targets = ['TTSegmentedControl', 'Socket.IO-Client-Swift']

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                if swift4Targets.include? target.name
                    config.build_settings['SWIFT_VERSION'] = '4'
                else
                    config.build_settings['SWIFT_VERSION'] = '3.2'
                end
            end
        end
    end
end

target 'HandstandStage' do
    shared_pods
end

target 'HandstandLiveDev' do
    shared_pods
end
