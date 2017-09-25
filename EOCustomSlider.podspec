Pod::Spec.new do |s|
  s.name             = 'EOCustomSlider'
  s.version          = '0.1.0'
  s.summary          = 'With this custom slider you can use images and colors'
 
  s.description      =  'This custom slider view make things a little bit easier for you!'
 
  s.homepage         = 'https://github.com/eozmen/EOCustomSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ece Özmen' => 'ece@ozmen.gen.tr' }
  s.source           = { :git => 'https://github.com/eozmen/EOCustomSlider.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'EOCustomSlider/*.{swift,xib,xcassets}'
 
end