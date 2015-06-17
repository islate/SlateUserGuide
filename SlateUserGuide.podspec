Pod::Spec.new do |s|
  s.name             = "SlateUserGuide"
  s.version          = "0.1.0"
  s.summary          = "A user guide view."
  s.description      = <<-DESC
			A user guide view. Display user introduce pictures at first launch. 
                       DESC
  s.homepage         = "https://github.com/mmslate/SlateUserGuide"
  s.license          = 'MIT'
  s.author           = { "mengxiangjian" => "mengxiangjian13@163.com" }
  s.source           = { :git => "https://github.com/mmslate/SlateUserGuide.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = '*.{h,m}'
end
