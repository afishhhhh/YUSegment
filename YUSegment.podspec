Pod::Spec.new do |s|

  s.name         = "YUSegment"
  s.version      = "1.0.1"
  s.summary      = "A customizable Segmented Control for iOS. Supports text and image."
  s.description  = <<-DESC
			#YUSegment
			
			A customizable **Segmented Control** for iOS. Supports text and image.

			##Requirements

			YUSegment works on iOS 8.0 and later version and is compatible with ARC projects.
                   DESC

  s.homepage     = "https://github.com/afishhhhh/YUSegment"
  # s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "afishhhhh" => "ygqdev0126@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/afishhhhh/YUSegment.git", :tag => "#{s.version}" }
  s.source_files  = "Pod", "Pod/**/*.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true
end
