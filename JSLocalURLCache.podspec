Pod::Spec.new do |s|
  s.name         = "JSLocalURLCache"
  s.version      = "2.0.0"
  s.summary      = "JSLocalURLCache is used for local url cache."
  s.description  = <<-DESC
                   JSLocalURLCache is used for local url cache.
                   URL can be opened when net not supported.
                   DESC
  s.homepage     = "https://github.com/JSzixiao/JSLocalURLCache"
  s.license      = "MIT"
  s.author             = { "zixiao0306" => "zixiao0306@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/JSzixiao/JSLocalURLCache.git", :tag => "2.0.0" }
  s.source_files  = "JSLocalURLCache/*.{h,m}"
  s.public_header_files = "JSLocalURLCache/JSLocalURLCache.h"
  s.resources = "JSLocalURLCache/JSLocalURLCache.plist"
  s.requires_arc = true
  s.dependency "Reachability"
end
