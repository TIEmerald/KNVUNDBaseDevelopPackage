//
//  UIViewController+UNDSideSlideTransitioningDelegate.m
//  ObjectiveCTestProject
//
//  Created by UNDaniel on 2020/11/23.
//

#import "UIViewController+UNDSideSlideTransitioningDelegate.h"

#pragma mark --

@interface UNDSideSlideBaseTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSTimeInterval timeInterval;

@end

@interface UNDSideSlideBaseTransitionAnimator()

@end

@implementation UNDSideSlideBaseTransitionAnimator

#pragma mark - Init
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval {
    if (self = [self init]) {
        self.timeInterval = timeInterval;
    }
    return self;
}

#pragma mark - Protocol
#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(true, @"- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext need be override");
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.timeInterval;
}

@end

#pragma mark --

@interface UNDSideSlidePresentTransitionAnimator : UNDSideSlideBaseTransitionAnimator

@end

@interface UNDSideSlidePresentTransitionAnimator()

@end

@implementation UNDSideSlidePresentTransitionAnimator

#pragma mark - Protocol
#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:toView];
    toView.alpha = 0;
    toView.frame = CGRectMake(toView.frame.origin.x
                              , toView.superview.frame.size.height
                              , toView.frame.size.width
                              , toView.superview.frame.size.height / 2);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        toView.alpha = 1;
        toView.frame = CGRectMake(toView.frame.origin.x
                                  , toView.superview.frame.size.height / 2
                                  , toView.frame.size.width
                                  , toView.superview.frame.size.height / 2);
    }
                     completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end

#pragma mark --

@interface UNDSideSlideDismissTransitionAnimator : UNDSideSlideBaseTransitionAnimator

@end

@interface UNDSideSlideDismissTransitionAnimator()

@end

@implementation UNDSideSlideDismissTransitionAnimator

#pragma mark - Protocol
#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        fromView.alpha = 0;
        fromView.frame = CGRectMake(fromView.frame.origin.x
                                    , fromView.superview.frame.size.height
                                    , fromView.frame.size.width
                                    , fromView.frame.size.height);
    }
                     completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end

#pragma mark --

typedef NS_ENUM(NSInteger,UNDSideSlidePresentationControllerMaskEffect) {
    UNDSideSlidePresentationControllerMaskEffect_MaskDark = 0,
    UNDSideSlidePresentationControllerMaskEffect_BlurDark = 1
} ;

@interface UNDSideSlidePresentationController : UIPresentationController

@property (nonatomic) UNDSideSlidePresentationControllerMaskEffect maskEffect;
@property (nonatomic) BOOL shouldShinkPresentingViewController;
@property (nonatomic) BOOL couldDragInUpDirection;

@end

@interface UNDSideSlidePresentationController() {
    UIView *_dimmingView;
}

@property (nonatomic) BOOL shouldComplete;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (readonly) UIView *dimmingView;

@end

@implementation UNDSideSlidePresentationController

#pragma mark - Getters && Setters
#pragma mark - Getters
- (UIView *)dimmingView {
    if (_dimmingView == nil) {
        [self setUpDimmingView];
    }
    return _dimmingView;
}

- (void)setUpDimmingView {
    CGRect usingFrame = CGRectMake(0, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    UIView *newView = [[UIView alloc] initWithFrame:usingFrame];
    
    [newView addSubview:[self maskViewWithFrame:usingFrame]];
    
    _dimmingView = newView;
}

- (UIView *)maskViewWithFrame:(CGRect)usingFrame {
    switch (self.maskEffect) {
        case UNDSideSlidePresentationControllerMaskEffect_BlurDark: {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.frame = usingFrame;
            
            UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
            UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
            vibrancyEffectView.frame = usingFrame;
            [blurEffectView.contentView addSubview:vibrancyEffectView];
            return blurEffectView;
        }
        case UNDSideSlidePresentationControllerMaskEffect_MaskDark:
        default: {
            UIView *returnView = [[UIView alloc] initWithFrame:usingFrame];
            returnView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0
                                                         alpha:0.7];
            return returnView;
        }
    }
}

#pragma mark - Super
#pragma mark - UIPresentationController
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        self.panGestureRecognizer = [UIPanGestureRecognizer new];
        [self.panGestureRecognizer addTarget:self action:@selector(onPan:)];
        [presentedViewController.view addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0, self.containerView.frame.size.height / 2, self.containerView.frame.size.width, self.containerView.frame.size.height / 2);
}

- (void)presentationTransitionWillBegin {
    UIView *currentDimmingView = self.dimmingView;
    currentDimmingView.alpha = 0;
    [self.containerView addSubview:currentDimmingView];
    [currentDimmingView addSubview:self.presentedViewController.view];
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        currentDimmingView.alpha = 1;
        if (self.shouldShinkPresentingViewController) {
            self.presentingViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
    }
                                                                         completion:nil];
}

- (void)dismissalTransitionWillBegin {
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0;
        self.presentingViewController.view.transform = CGAffineTransformIdentity;
    }
                                                                         completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimmingView removeFromSuperview];
        _dimmingView = nil;
    }
}

#pragma mark - Gesture Recognizer
- (void)onPan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.couldDragInUpDirection || translation.y > 0) {
                self.presentedView.transform = CGAffineTransformMakeTranslation(0, translation.y);
            }
            float threshold = 0.1;
            float dragPercent = translation.y / self.containerView.frame.size.height;
            dragPercent = fmaxf(dragPercent, 0.0);
            dragPercent = fminf(dragPercent, 1.0);
            self.shouldComplete = dragPercent > threshold;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.shouldComplete) {
                [self.presentedViewController dismissViewControllerAnimated:true completion:nil];
            } else {
                [self resetPresentViewBackToIdle];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            [self resetPresentViewBackToIdle];
            break;
        }
        default:
            break;
    }
}

#pragma mark Support Methods
- (void)resetPresentViewBackToIdle {
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.presentedView.transform = CGAffineTransformIdentity;
        [self.presentedViewController.navigationController setNeedsStatusBarAppearanceUpdate];
        self.presentedViewController.navigationController.navigationBarHidden = true;
        self.presentedViewController.navigationController.navigationBarHidden = false;
    }
                     completion:nil];
}

@end

#pragma mark --

@implementation UIViewController (UNDSideSlideTransitioningDelegate)

const NSTimeInterval UNDSideSlideTransitioningDelegate_SlideDuration = 0.4;

#pragma mark - General Methods
- (void)sideSlide_show:(UIViewController *)presentedViewController {
    presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    presentedViewController.modalPresentationCapturesStatusBarAppearance = true;
    presentedViewController.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)self;
    [self presentViewController:presentedViewController animated:true completion:nil];
}

#pragma mark - Protocols
#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[UNDSideSlidePresentTransitionAnimator alloc] initWithTimeInterval:UNDSideSlideTransitioningDelegate_SlideDuration];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[UNDSideSlideDismissTransitionAnimator alloc] initWithTimeInterval:UNDSideSlideTransitioningDelegate_SlideDuration];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[UNDSideSlidePresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
