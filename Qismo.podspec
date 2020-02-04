Pod::Spec.new do |s|

s.name         = "Qismo"
s.version      = "1.0.0"
s.summary      = "Customer Chat integration."

s.homepage     = "http://qiscus.com"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

s.license      = "MIT"

s.author       = { "juang@qiscus.co" => "juang@qiscus.co" }

s.platform     = :ios, "10.0"

s.source       = { :path => "." }

s.source_files  = "Qismo", "Qismo/**/*.{h,m,swift,xib}"

s.resources = "Qismo/**/*.xcassets"
s.resource_bundles = {
    'Qismo' => ['Qismo/**/*.{lproj,xib,xcassets,imageset,png}']
}

s.framework		= 'UIKit', 'AVFoundation'
s.requires_arc	= false

s.dependency 'Alamofire'
s.dependency 'AlamofireImage'
s.dependency 'SwiftyJSON'
s.dependency 'QiscusCoreAPI'
s.dependency 'SDWebImage'

end
