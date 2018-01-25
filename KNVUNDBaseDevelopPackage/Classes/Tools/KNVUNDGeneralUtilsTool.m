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
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                                             message:message
                                                                                            delegate:nil
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


@end
