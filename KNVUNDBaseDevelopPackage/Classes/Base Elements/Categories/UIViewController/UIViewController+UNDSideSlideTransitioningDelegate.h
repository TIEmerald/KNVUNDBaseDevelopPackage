//
//  UIViewController+UNDSideSlideTransitioningDelegate.h
//  ObjectiveCTestProject
//
//  Created by UNDaniel on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UNDSideSlideTransitioningDelegate)

#pragma mark - General Methods
- (void)sideSlide_show:(UIViewController *)presentedViewController;

@end

NS_ASSUME_NONNULL_END
