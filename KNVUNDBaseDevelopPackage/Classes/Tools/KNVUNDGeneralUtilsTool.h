//
//  KNVUNDGeneralUtilsTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 25/1/18.
//

#import "KNVUNDBaseModel.h"

// CocoaPods
#import "SVProgressHUD.h"

@interface KNVUNDGeneralUtilsTool : KNVUNDBaseModel

#pragma mark - Displaying Message Related
#pragma mark Alert View
/*!
 * @brief This method is used to show an alert view for displaying purpose only.... If you want to handle any delegate callback, please use - (void)displayAlertMessageWithAlertSettingModel:(KNVUNDAlertControllerSettingModel *)alertSettingModel; from KNVUNDBaseViewController
 */
+ (void)showUpAlertViewWithTitle:(NSString *_Nonnull)title message:(NSString *_Nonnull)message andCancelButtonTitle:(NSString *_Nonnull)cancelButtonTitle;

#pragma mark SVPorgressHUD
+ (void)showWithStatus:(NSString *_Nonnull)status maskType:(SVProgressHUDMaskType)maskType;
+ (void)showWithStatus:(NSString *_Nonnull)status;

@end
