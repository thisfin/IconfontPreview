
platform :osx, '10.12'
use_frameworks!

def pods
    pod 'SnapKit'
    #pod 'SnapKit',  :path => '~/Documents/work/git/SnapKit'
end

target 'IconfontPreview' do
    pods
end

# 引用的库使用 3.2 编译
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
