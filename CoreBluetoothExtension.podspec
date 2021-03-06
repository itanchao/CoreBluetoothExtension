Pod::Spec.new do |s|
  s.name             = 'CoreBluetoothExtension'
  s.version          = '0.6.8'
  s.summary          = 'A simple Extension for CoreBluetooth.'
  s.description      = <<-DESC
    A simple Extension of CoreBluetooth.
                       DESC

  s.homepage         = 'https://github.com/itanchao/CoreBluetoothExtension'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'itanchao' => 'itanchao@gmail.com' }
  s.source           = { :git => 'https://github.com/itanchao/CoreBluetoothExtension.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '4.0'
  s.source_files = 'CoreBluetoothExtension/**/*{.h,.m}'
  s.public_header_files = 'CoreBluetoothExtension/Public/**/*.h'
  s.dependency 'ReactiveObjC'
end
