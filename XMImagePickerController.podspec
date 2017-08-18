
Pod::Spec.new do |s|


  s.name         = "XMImagePickerController"
  s.version      = "0.0.1"

  s.summary      = "A simple framework for image MultiSelect"


#s.description  = "A simple framework for image MultiSelect"

  s.homepage     = "https://github.com/Mazy-ma/XMImagePickerController"

  s.license      = "MIT"

  s.author             = { "Mazy" => "mazy_ios@163.com" }
  # Or just: s.author    = "Mazy"
  # s.authors            = { "Mazy" => "mazy_ios@163.com" }
  # s.social_media_url   = "http://twitter.com/Mazy"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/Mazy-ma/XMImagePickerController.git", :tag => "#{s.version}" }


  s.source_files  = "XMImagePickerController", "XMImagePickerController/AlbumPickerController/*.{h,swift}"


  s.public_header_files = "XMImagePickerController/AlbumPickerController/AlbumPickerController.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  s.resources = "XMImagePickerController/AlbumPickerController/*.png"

  s.requires_arc = true

end
