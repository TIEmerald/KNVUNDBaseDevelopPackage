//
//  UIViewController+UNDSideSlideTransitioningDelegate.h
//  ObjectiveCTestProject
//
//  Created by UNDaniel on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,UNDSideSlidePresentationControllerMaskEffect) {
    UNDSideSlidePresentationControllerMaskEffect_MaskDark = 0,
    UNDSideSlidePresentationControllerMaskEffect_BlurDark = 1
} ;

@interface UNDSideSlideTransitioningConfigModel : NSObject

@property (nonatomic) UNDSideSlidePresentationControllerMaskEffect maskEffect;
@property (nonatomic) BOOL shouldDismissWhileClickBackground;
@property (nonatomic) BOOL shouldShinkPresentingViewController;
@property (nonatomic) BOOL couldDragInUpDirection;
@property (nonatomic) BOOL isDisableManuallySlideToDismiss;

@end

@interface UIViewController (UNDSideSlideTransitioningDelegate)

#pragma mark - General Methods
- (void)sideSlide_show:(UIViewController *)presentedViewController;
- (void)sideSlide_show:(UIViewController *)presentedViewController withConfig:(UNDSideSlideTransitioningConfigModel *)configModel;

@end

NS_ASSUME_NONNULL_END
