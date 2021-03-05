//
//  UNDTestViewController.h
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by UNDaniel on 2021/3/5.
//  Copyright © 2021 niyejunze.j@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// Categories
#import "UIViewController+UNDSideSlideTransitioningDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UNDTestViewController : UIViewController <UNDSideSlidePresentedVCProtocol>

- (instancetype)initWithBackgroundColor:(UIColor *)backGroundColor;

@end

NS_ASSUME_NONNULL_END
