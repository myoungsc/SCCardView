Pod::Spec.new do |s|
  s.name             = 'SCCardView'
  s.version          = '0.1.0'
  s.summary          = 'Selector card to change content view'

  s.description      = 'Selector card to change content view.'

  s.homepage         = 'https://github.com/myoungsc/SCCardView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'myoung' => 'myoungsc.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/myoungsc/SCCardView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SCCardView/Classes/**/*'
  
end
