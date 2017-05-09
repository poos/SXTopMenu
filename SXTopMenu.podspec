
Pod::Spec.new do |s|

  s.name         = "SXTopMenu"
  s.version      = "0.0.1"
  s.summary      = "Easy use GPS get address"

  s.homepage     = "https://github.com/poos/SXTopMenu"

  s.license      = 'MIT'

  s.author             = { "xiaoR" => "bieshixuan@163.com" }

  s.platform     = :ios, "7.1"

  s.source       = { :git => "https://github.com/poos/SXTopMenu.git", :tag => s.version.to_s }

  s.source_files  = "SXTopMenu/SXTopMenuView.{h,m}"

  s.requires_arc = true


end
