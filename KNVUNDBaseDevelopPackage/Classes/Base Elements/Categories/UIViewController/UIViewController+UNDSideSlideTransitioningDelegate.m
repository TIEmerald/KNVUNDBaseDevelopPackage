//
//  UIViewController+UIViewController_SideSlideTransitioningDelegate.m
//  ObjectiveCTestProject
//
//  Created by UNDaniel on 2020/11/23.
//

#import "UIViewController+UNDSideSlideTransitioningDelegate.h"

#pragma mark --

@interface UNDSideSlideTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface UNDSideSlideTransitionAnimator()

@end

@implementation UNDSideSlideTransitionAnimator

#pragma mark - Protocol
#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        fromController.view.frame = CGRectMake(fromController.view.frame.origin.x
                                               , fromController.view.frame.origin.y
                                               , fromController.view.frame.size.width
                                               , 800);
    }
                     completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
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
            self.presentedView.frame = CGRectMake(self.presentedView.frame.origin.x
                                                   , self.presentedView.frame.origin.y
                                                   , self.presentedView.frame.size.width
                                                   , self.containerView.frame.size.height);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.presentedView.frame = CGRectMake(self.presentedView.frame.origin.x
                                                   , self.containerView.frame.size.height / 2 + translation.y
                                                   , self.presentedView.frame.size.width
                                                   , self.presentedView.frame.size.height);
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
        CGRect containterFrame = self.containerView.frame;
        self.presentedView.frame = containterFrame;
        CGRect halfFrame = CGRectMake(0, containterFrame.size.height / 2, containterFrame.size.width, containterFrame.size.height / 2);
        CGRect usingFrame = halfFrame;
        self.presentedView.frame = usingFrame;
        [self.presentedViewController.navigationController setNeedsStatusBarAppearanceUpdate];
        self.presentedViewController.navigationController.navigationBarHidden = true;
        self.presentedViewController.navigationController.navigationBarHidden = false;
    }
                     completion:nil];
}

@end

#pragma mark --

@implementation UIViewController (UNDSideSlideTransitioningDelegate)

#pragma mark - General Methods
- (void)sideSlide_show:(UIViewController *)presentedViewController {
    presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    presentedViewController.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)self;
    [self presentViewController:presentedViewController animated:true completion:nil];
}

#pragma mark - Protocols
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [UNDSideSlideTransitionAnimator new];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[UNDSideSlidePresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
