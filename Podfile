# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

def sharedpods
    pod 'ObjectMapper'
    pod "MagicalRecord"
    pod 'Alamofire', '~> 5.1'
    pod 'ReactorKit'
    pod 'RxSwift', '~> 6.0'
    pod 'RxCocoa', '~> 6.0'
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
