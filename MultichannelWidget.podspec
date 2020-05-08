Pod::Spec.new do |s|

s.name         = "MultichannelWidget"
s.version      = "1.1.0"
s.summary      = "Customer Chat integration."

s.homepage     = "http://qiscus.com"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

s.license      = "MIT"

s.author       = { "juang@qiscus.co" => "juang@qiscus.co" }

s.platform     = :ios, "10.0"

s.source       = { :path => "." }

s.source_files  = "MultichannelWidget", "MultichannelWidget/**/*.{h,m,swift,xib}"

s.resources = "MultichannelWidget/**/*.xcassets"
s.resource_bundles = {
    'MultichannelWidget' => ['MultichannelWidget/**/*.{lproj,xib,xcassets,imageset,png}']
}

s.framework		= 'UIKit', 'AVFoundation'
s.requires_arc	= false

s.dependency 'Alamofire'
s.dependency 'AlamofireImage'
s.dependency 'SwiftyJSON'
s.dependency 'QiscusCoreAPI', '~> 0.2.1'
s.dependency 'SDWebImage'

end
