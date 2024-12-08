Pod::Spec.new do |s|
  s.name             = 'ZHHDynamicTextViewHeightHandler'
  s.version          = '0.0.1'
  s.summary          = '一个用于根据内容动态调整 UITextView 高度的实用工具。'

  s.description      = <<-DESC
ZHHDynamicTextViewHeightHandler 是一个轻量级工具，可以根据 UITextView 的文本内容动态调整其高度。
它简化了文本视图的高度调整过程，同时确保动画流畅。
                       DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHDynamicTextViewHeightHandler'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHDynamicTextViewHeightHandler.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.source_files = 'ZHHDynamicTextViewHeightHandler/Classes/**/*'
end
