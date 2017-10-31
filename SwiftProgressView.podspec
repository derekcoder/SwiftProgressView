Pod::Spec.new do |s|

  s.name         = "SwiftProgressView"
  s.version      = "0.2.0"
  s.summary      = "A set of progress views written in Swift"

  s.description  = <<-DESC
                   SwiftProgressView is a set of progress views written in Swift. It contains ring and pie style.
                   DESC

  s.homepage     = "https://github.com/derekcoder/SwiftProgressView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "derekcoder" => "derekcoder@gmail.com" }
  s.source       = { :git => "https://github.com/derekcoder/SwiftProgressView.git", :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files  = ['SwiftProgressView/Sources/*.swift', 'SwiftProgressView/SwiftProgressView.h']
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
