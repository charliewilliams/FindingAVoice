use_frameworks!
platform :ios, '10.0'

def shared
    
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'SVProgressHUD'
    
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
end

target 'ExperimentalTaskTests' do
    inherit! :complete
    pod 'Firebase'
    pod 'AudioKit'
end
