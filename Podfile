# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RXSwiftDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for RXSwiftDemo
  # pod 'RxSwift', '~> 5.0'
  # pod 'RxCocoa', '~> 5.0'

  pod 'RxSwift', :path => '~/Document/RxSwift'
  pod 'RxCocoa', :path => '~/Document/RxSwift'

  target 'RXSwiftDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RXSwiftDemoUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
end
