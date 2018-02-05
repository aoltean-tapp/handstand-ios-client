source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!

def shared_pods
    #Network
    pod 'Alamofire'
    pod 'ReachabilitySwift'
    pod 'SDWebImage', '~>3.7'
    pod 'SwiftyJSON'

    #    pod 'RMPZoomTransitionAnimator'
    pod 'AAViewAnimator'
    pod 'Stripe'
    pod 'TextFieldEffects'
    pod 'IQKeyboardManagerSwift'
    pod 'Tapptitude', :path => '.'

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
end

target 'HandstandStage' do
    shared_pods
end

target 'HandstandLiveDev' do
    shared_pods
end
