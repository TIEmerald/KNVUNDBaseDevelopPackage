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
};

typedef NS_ENUM(NSInteger,UNDSideSlidePresentationControllerPresentPosition) {
    UNDSideSlidePresentationControllerPresentPosition_Bottom = 0,
    UNDSideSlidePresentationControllerPresentPosition_Center = 1
};

@interface UNDSideSlideTransitioningConfigModel : NSObject


// Decide what's the effect of the mask between presenting view and presented view. By default, it is MaskDark, which is just a dark transparent view be inserted between presenting view and presented view.
@property (nonatomic) UNDSideSlidePresentationControllerMaskEffect maskEffect;

// Decide where do you want show up presented view, By default it's at the bottom of the presenting view.
@property (nonatomic) UNDSideSlidePresentationControllerPresentPosition presentPosition;

// While user tapped mask view (the part which is not presented view), will presented view dismiss or not. By default it's false.
@property (nonatomic) BOOL shouldDismissWhileClickBackground;

// Will presenting view shrink 10% or not while presented view shown up. by default it's false
@property (nonatomic) BOOL shouldShrinkPresentingViewController;

// Could user drag and move presented view above original position or not, by default it's false
@property (nonatomic) BOOL couldDragInUpDirection;

// While user drage and move presented view belowe original position, could it trigger dismiss presented view or not, by default, it's false
@property (nonatomic) BOOL isDisableManuallySlideToDismiss;

@end

@interface UIViewController (UNDSideSlideTransitioningDelegate)

#pragma mark - General Methods
- (void)und_sideSlideShow:(UIViewController *)presentedViewController;
- (void)und_sideSlideShow:(UIViewController *)presentedViewController withConfig:(UNDSideSlideTransitioningConfigModel *)configModel;

@end

NS_ASSUME_NONNULL_END
