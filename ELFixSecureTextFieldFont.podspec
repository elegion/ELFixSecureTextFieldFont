Pod::Spec.new do |s|
  s.name         = "ELFixSecureTextFieldFont"
  s.version      = "0.1.0"
  s.summary      = "Fix for ios7 secure text field font size change on focus/blur."
  s.homepage     = "https://github.com/elegion/ELFixSecureTextFieldFont.git"
  s.license      = "MIT"
  s.author       = { "Vladimir Lyukov" => "v.lyukov@gmail.com" }
  s.source       = { :git => "https://github.com/elegion/ELFixSecureTextFieldFont.git", :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = 'ELFixSecureTextFieldFont/**/*.{h,m}'
  s.requires_arc = true
end
