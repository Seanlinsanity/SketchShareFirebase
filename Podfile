# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'
  use_frameworks!
def firebase_pods
    # Pods for SketchShareFirebase
    pod 'Firebase/Auth', '~> 5.0'
    pod 'Firebase/Database', '~> 5.0'
    pod 'Firebase/Storage', '~> 5.0'
    #pod 'FirebaseUI', '~> 5.0'       # Pull in all Firebase UI features
end
target 'FirebaseFramework' do
    workspace 'SketchShareFirebase.xcworkspace'
    project 'FirebaseFramework.xcodeproj'
    firebase_pods
end

target 'SketchShareFirebase' do
    workspace 'SketchShareFirebase.xcworkspace'
    project 'SketchShareFirebase.xcodeproj'
    firebase_pods
end

target 'FirebaseFrameworkTests' do
    workspace 'SketchShareFirebase.xcworkspace'
    project 'FirebaseFramework.xcodeproj'
    firebase_pods
end

