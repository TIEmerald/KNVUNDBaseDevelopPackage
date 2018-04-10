//
//  KNVUNDGeneralUtilsTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 25/1/18.
//

#import "KNVUNDGeneralUtilsTool.h"

// Tools
#import "KNVUNDThreadRelatedTool.h"

@implementation KNVUNDGeneralUtilsTool

#pragma mark - Displaying Message Related
#pragma mark Alert View
+ (void)showUpAlertViewWithTitle:(NSString *_Nonnull)title message:(NSString *_Nonnull)message andCancelButtonTitle:(NSString *_Nonnull)cancelButtonTitle
{
    [self showUpAlertViewWithTitle:title
                           message:message
                          delegate:nil
              andCancelButtonTitle:cancelButtonTitle];
}

+ (void)showUpAlertViewWithTitle:(NSString *_Nonnull)title message:(NSString *_Nonnull)message delegate:(id<UIAlertViewDelegate>)delegate andCancelButtonTitle:(NSString *_Nonnull)cancelButtonTitle
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                                             message:message
                                                                                            delegate:delegate
                                                                                   cancelButtonTitle:cancelButtonTitle
                                                                                   otherButtonTitles:nil];
                                             [alert show];
                                         }];
}

#pragma mark SVPorgressHUD
+ (void)showProgressWithStatus:(NSString *_Nonnull)status maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD setDefaultMaskType:maskType];
    [self showProgressWithStatus:status];
}

+ (void)showProgressWithStatus:(NSString *_Nonnull)status
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             [SVProgressHUD showWithStatus:status];
                                         }];
}

+ (void)dismissProgress
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             [SVProgressHUD dismiss];
                                         }];
}

#pragma mark - Storage Related
+ (id)getDataFromUserDefaults:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)setDataToUserDefaults:(NSString *)key value:(id)object
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}


#pragma mark - Version and Build Number Related
/// Call this method to retrieve the Version and Build Description String.
+ (NSString *)getVersionAndBuildDescriptionString
{
    NSDictionary *appInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *buildNumber = appInfoDictionary[(NSString *)kCFBundleVersionKey];
    NSString *versionNumber = appInfoDictionary[@"CFBundleShortVersionString"];
    ///// Format:  @"Version: VersionNumber(BuildNumber)"
    NSString *versionString = [NSString stringWithFormat:@"Version: %@(%@)",
                               versionNumber,
                               buildNumber];
    return versionString;
}

@end
