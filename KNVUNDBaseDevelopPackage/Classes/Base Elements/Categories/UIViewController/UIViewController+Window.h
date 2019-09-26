//
//  UIViewController+Window.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 26/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Window)

#pragma mark - Methods to Override
+ (UIWindowLevel)windowLevel;

#pragma mark - General Methods
- (void)show;
- (void)show:(BOOL)animated;

- (void)dismiss;
- (void)dismiss:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
