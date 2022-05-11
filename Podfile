# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

def sharedpods
    pod 'ObjectMapper'
    pod "MagicalRecord"
    pod 'Alamofire', '~> 5.1'
    #pod 'AlamofireNetworkActivityIndicator', '~> 3.1'
    #pod 'AlamofireImage', '~> 4.1'
    #pod 'OHHTTPStubs'
    #pod 'OHHTTPStubs/Swift'
    pod 'ProgressHUD'
    pod 'ReactorKit'
    pod 'RxSwift', '~> 6.0'
    pod 'RxCocoa', '~> 6.0'
    #pod 'RxCoreLocation'
    pod 'GooglePlaces'
    pod 'GoogleMaps', '5.1.0'
    pod 'SnapKit'
    pod 'Kingfisher'
end

target 'mvl' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mvl
  sharedpods

  target 'mvlTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'mvlUITests' do
    # Pods for testing
  end

end
