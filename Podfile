# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'

 use_frameworks!
def firebase_pods
    # Pods for SketchShareFirebase
    pod 'Firebase', '~> 5.0'
    pod 'Firebase/Core', '~> 5.0'
    pod 'Firebase/Auth', '~> 5.0'
    pod 'Firebase/Database', '~> 5.0'
    pod 'Firebase/Storage', '~> 5.0'
    pod 'Firebase/Firestore', '~> 5.0'
#    pod 'PromiseKit', '~> 6.0'
    pod 'FBSDKCoreKit', '~> 4.0'
    pod 'FBSDKShareKit', '~> 4.0'
    pod 'FBSDKLoginKit', '~> 4.0'
    pod 'GoogleSignIn', '~> 4.0'
    pod 'PromisesSwift', '~> 1.2.3'
    #pod 'FirebaseUI', '~> 5.0'       # Pull in all Firebase UI features
end

target 'SketchShareFirebase' do
    workspace 'SketchShareFirebase.xcworkspace'
    project 'SketchShareFirebase.xcodeproj'
      pod 'PromisesSwift', '~> 1.2.3'
        target 'FirebaseFramework' do
           firebase_pods
        end
    
end
#platform: osx,'10.13'
target 'SketchShare_macOS' do
    workspace 'SketchShareFirebase.xcworkspace'
    project 'SketchShareFirebase.xcodeproj'
     pod 'PromisesSwift', '~> 1.2.3'
    
end

#abstract_target 'SketchShare' do
#
#    target 'FirebaseFramework' do
#        workspace 'SketchShareFirebase.xcworkspace'
#        project 'FirebaseFramework.xcodeproj'
#        target 'FirebaseFrameworkTests' do
#            inherit! :search_paths
#        end
#
#    end
#
#end

#target 'FirebaseFrameworkTests' do
#    workspace 'SketchShareFirebase.xcworkspace'
#    project 'FirebaseFramework.xcodeproj'
#    firebase_pods
#end

