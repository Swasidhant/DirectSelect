#
# Be sure to run `pod lib lint CustomSelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DirectSelect'
  s.version          = '1.0.0'
  s.summary          = 'An ios implementation of Virgil Pana\'s DirectSelect'

  s.description      = <<-DESC
An ios implementation of Virgil Pana\'s DirectSelect. This library allows custom subviews as well as an intro view for coaching users on how to use it.
                       DESC

  s.homepage         =
  'https://github.com/Swasidhant/DirectSelect'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Swasidhant' => 'ssprofessional33@gmail.com' }
  s.source           = { :git => 'https://github.com/Swasidhant/DirectSelect.git', :tag => 1.0.0 }
  s.social_media_url = 'https://twitter.com/Swasidhant7'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DirectSelect/Classes/**/*'
   s.resource_bundles = {
     'DirectSelect' => ['DirectSelect/Assets/**/*.*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
