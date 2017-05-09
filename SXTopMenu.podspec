
Pod::Spec.new do |s|

  s.name         = "SXGps"
  s.version      = "0.0.3"
  s.summary      = "Easy use GPS get address"

  s.homepage     = "https://github.com/poos/SXGpsHelper"

  s.license      = 'MIT'

  s.author             = { "xiaoR" => "bieshixuan@163.com" }

  s.platform     = :ios, "7.1"

  s.source       = { :git => "https://github.com/poos/SXGpsHelper.git", :tag => s.version.to_s }

  s.source_files  = "SXGps/SXGps.h"

  s.requires_arc = true

s.subspec 'SXGps' do |ss|
ss.source_files = 'SXGps/**/*.{h,m}'
ss.public_header_files = "SXGps/**/*.h"
end

end
