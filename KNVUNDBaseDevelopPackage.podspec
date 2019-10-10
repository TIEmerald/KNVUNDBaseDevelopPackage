#
# Be sure to run `pod lib lint KNVUNDBaseDevelopPackage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KNVUNDBaseDevelopPackage'
  s.version          = '0.3.22'
  s.summary          = 'This is a general support pods library for Abacus Solution Group Pty Ltd'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This Package contains all of Public Support Methods shared between all Abacus POS projects.
  Currently Inside this Package we have following Classes:
  ****** Base Elements
  *********  1.Categories (NSDecimalNumber, NSMutlabeAttributString, NSNumber, NSObject, NSString, UICollectionViewCell, UIColor, UILable)
  *********  2.Core Animation
  ************  a.CATextLayer (KNVUNDVerticalCentralCATextLayer)
  *********  3.Models
  ************  a.KNVUNDBaseModel
  ************  b.Observer (KNVUNDObservable)
  *********  4.UIKit
  ************  a.KNVUNDActivityIndicatorButton
  ************  b.KNVUNDBaseViewController
  ****** Helpers
  *********  1.KNVUNDButtonsSelectionHelper
  *********  2.KNVUNDLogRelatedHelper
  *********  3.KNVUNDPagingRelatedHelper
  *********  4.KNVUNDScannerHelper
  *********  5.KNVUNDExpendingTableViewRelatedHelper
  *********  6.KNVUNDButtonViewControllerTagViewHelper
  ****** Tools
  *********  1.KNVUNDDebugTool
  *********  2.KNVUNDFileRelatedTool
  *********  3.KNVUNDGeneralUtilsTool
  *********  4.KNVUNDLocalRelatedTool
  *********  5.KNVUNDThreadRelatedTool
  *********  6.KNVUNDRootErrorCodeTool
  *********  7.KNVUNDFormatedStringRelatedTool
  *********  8.KNVUNDEmailRelatedTool
  *********  9.KNVUNDRegexRelatedTool
  *********  10.KNVUNDRuntimeRelatedTool
  *********  11.KNVUNDColourRelatedTool
  *********  12.KNVUNDImageRelatedTool
                       DESC

  s.homepage         = 'https://github.com/TIEmerald/KNVUNDBaseDevelopPackage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'UNDaniel' => 'daniel@abacus.co' }
  s.source           = { :git => 'https://github.com/TIEmerald/KNVUNDBaseDevelopPackage.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KNVUNDBaseDevelopPackage/Classes/**/*.{h,m}'
  s.resources = ['KNVUNDBaseDevelopPackage/Classes/**/*.xib', 'KNVUNDBaseDevelopPackage/Classes/**/*.{png,jpg,json}']
  
  # s.resource_bundles = {
  #   'KNVUNDBaseDevelopPackage' => ['KNVUNDBaseDevelopPackage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'ZXingObjC'
    s.dependency 'MZFormSheetPresentationController'
    s.dependency 'RMessage'
    s.dependency 'LinqToObjectiveC'
    s.dependency 'skpsmtpmessage'
    s.dependency 'SVProgressHUD'
end
