use_frameworks!

def shared
    
    pod 'AudioKit'
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
end

target 'ControlTaskTests' do
    inherit! :complete
    pod 'Firebase'
end

target 'ExperimentalTaskTests' do
    inherit! :complete
    pod 'Firebase'
end
