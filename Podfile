	use_frameworks!
inhibit_all_warnings!
platform :ios, '12.0'

def shared
    
#    pod 'Firebase'
    pod 'FirebaseAuth'
    pod 'FirebaseAnalytics'
    pod 'FirebaseCrashlytics'
    pod 'FirebaseDatabase'
    pod 'SVProgressHUD'
    pod 'YLProgressBar'
    
end

target 'ControlTask' do
    shared
end

target 'ExperimentalTask' do
    shared
    pod 'AudioKit'
end

target 'ControlTaskTests' do
    inherit! :complete
    pod 'Firebase'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
end

target 'ExperimentalTaskTests' do
    inherit! :complete
    pod 'Firebase'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'AudioKit'
end

