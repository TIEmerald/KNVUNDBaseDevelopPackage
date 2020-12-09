//
//  UIViewController+UNDSideSlideTransitioningDelegate.m
//  ObjectiveCTestProject
//
//  Created by UNDaniel on 2020/11/23.
//

#import "UIViewController+UNDSideSlideTransitioningDelegate.h"

// Thid Parties
#import <objc/runtime.h>

#pragma mark --

@interface UNDSideSlideTransitioningConfigModel() <UIViewControllerTransitioningDelegate>

@property (nonatomic) CGSize preferredSize;
@property (readonly) CGPoint(^preferredOriginPoint)(UIView *fromView);

@end

#pragma mark --

@interface UNDSideSlideBaseTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, strong) UNDSideSlideTransitioningConfigModel *configModel;

@end

@interface UNDSideSlideBaseTransitionAnimator()

@end

@implementation UNDSideSlideBaseTransitionAnimator

#pragma mark - Init
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval andConfigModel:(UNDSideSlideTransitioningConfigModel *)configModel {
    if (self = [self init]) {
        self.timeInterval = timeInterval;
        self.configModel = configModel;
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
    CGPoint presentingOrigin = self.configModel.preferredOriginPoint(transitionContext.containerView);
    CGRect originalToViewFrame = CGRectMake(presentingOrigin.x
                                            , transitionContext.containerView.frame.size.height
                                            , self.configModel.preferredSize.width
                                            , self.configModel.preferredSize.height);
    CGRect presentingToViewFrame = CGRectMake(presentingOrigin.x
                                            , presentingOrigin.y
                                            , self.configModel.preferredSize.width
                                            , self.configModel.preferredSize.height);
    [transitionContext.containerView addSubview:toView];
    toView.alpha = 0;
    toView.frame = originalToViewFrame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        toView.alpha = 1;
        toView.frame = presentingToViewFrame;
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

@interface UNDSideSlidePresentationController : UIPresentationController

@property (nonatomic, strong) UNDSideSlideTransitioningConfigModel *configureModel;

@end

@interface UNDSideSlidePresentationController() {
    UIView *_dimmingView;
}

@property (nonatomic) BOOL shouldComplete;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *dismissTapGestureRecognizer;

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
    _dimmingView = [self maskViewWithFrame:usingFrame];
}

- (UIView *)maskViewWithFrame:(CGRect)usingFrame {
    switch (self.configureModel.maskEffect) {
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
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController andConfigModel:(UNDSideSlideTransitioningConfigModel *)configModel {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        self.configureModel = configModel;
        if (!self.configureModel.isDisableManuallySlideToDismiss) {
            self.panGestureRecognizer = [UIPanGestureRecognizer new];
            [self.panGestureRecognizer addTarget:self action:@selector(onPan:)];
            [presentedViewController.view addGestureRecognizer:self.panGestureRecognizer];
        }
        if (self.configureModel.shouldDismissWhileClickBackground) {
            self.dismissTapGestureRecognizer = [UITapGestureRecognizer new];
            [self.dismissTapGestureRecognizer addTarget:self
                                                 action:@selector(dismissPresentedViewController)];
            [self.dimmingView addGestureRecognizer:self.dismissTapGestureRecognizer];
        }
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGPoint presentingOrigin = self.configureModel.preferredOriginPoint(self.containerView);
    return CGRectMake(presentingOrigin.x
                      , presentingOrigin.y
                      , self.configureModel.preferredSize.width
                      , self.configureModel.preferredSize.height);
}

- (void)presentationTransitionWillBegin {
    UIView *currentDimmingView = self.dimmingView;
    currentDimmingView.frame = self.containerView.bounds;
    currentDimmingView.alpha = 0;
    [self.containerView addSubview:currentDimmingView];
    [currentDimmingView addSubview:self.presentedViewController.view];
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        currentDimmingView.alpha = 1;
        if (self.configureModel.shouldShinkPresentingViewController) {
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
            if (self.configureModel.couldDragInUpDirection || translation.y > 0) {
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
                [self dismissPresentedViewController];
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
- (void)dismissPresentedViewController {
    [self.presentedViewController dismissViewControllerAnimated:true completion:nil];
}

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

@implementation UNDSideSlideTransitioningConfigModel

#pragma mark - Constants
const NSTimeInterval UNDSideSlideTransitioningDelegate_SlideDuration = 0.4;

#pragma mark - Accessors
#pragma mark - Getters
- (CGPoint (^)(UIView *))preferredOriginPoint
{
    return ^(UIView *fromView) {
        CGFloat presentingX = fromView.frame.size.width - self.preferredSize.width;
        CGFloat presentingY = fromView.frame.size.height - self.preferredSize.height;
        switch (self.presentPosition) {
            case UNDSideSlidePresentationControllerPresentPosition_Center:
                presentingX /= 2;
                presentingY /= 2;
                break;
            case UNDSideSlidePresentationControllerPresentPosition_Bottom:
            default:
                presentingX /= 2;
                break;
        }
        return CGPointMake(presentingX, presentingY);
    };
}

#pragma mark - Protocols
#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[UNDSideSlidePresentTransitionAnimator alloc] initWithTimeInterval:UNDSideSlideTransitioningDelegate_SlideDuration
                                                                andConfigModel:self];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[UNDSideSlideDismissTransitionAnimator alloc] initWithTimeInterval:UNDSideSlideTransitioningDelegate_SlideDuration
                                                                andConfigModel:self];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[UNDSideSlidePresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting andConfigModel:self];
}

@end

#pragma mark --

@implementation UIViewController (UNDSideSlideTransitioningDelegate)

#pragma mark - Getters & Setters
static void * UIViewController_UNDSideSlideTransitioningConfigModel = &UIViewController_UNDSideSlideTransitioningConfigModel;

#pragma mark - Getters
- (UNDSideSlideTransitioningConfigModel *)sideSlide_TransitioningConfigModel
{
    return objc_getAssociatedObject(self, UIViewController_UNDSideSlideTransitioningConfigModel);
}

#pragma mark - Setters
- (void)setSideSlide_TransitioningConfigModel:(UNDSideSlideTransitioningConfigModel *)sideSlideTransitioningConfigModel
{
    objc_setAssociatedObject(self, UIViewController_UNDSideSlideTransitioningConfigModel, sideSlideTransitioningConfigModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - General Methods
- (void)und_sideSlideShow:(UIViewController *)presentedViewController {
    [self und_sideSlideShow:presentedViewController
              withConfig:[UNDSideSlideTransitioningConfigModel new]];
}

- (void)und_sideSlideShow:(UIViewController *)presentedViewController withConfig:(UNDSideSlideTransitioningConfigModel *)configModel {
    self.sideSlide_TransitioningConfigModel = configModel;
    if (CGSizeEqualToSize(presentedViewController.preferredContentSize, CGSizeZero)) {
        self.sideSlide_TransitioningConfigModel.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width
                                                                          , [UIScreen mainScreen].bounds.size.height / 2);
    } else {
        self.sideSlide_TransitioningConfigModel.preferredSize = presentedViewController.preferredContentSize;
    }
    presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    presentedViewController.modalPresentationCapturesStatusBarAppearance = true;
    presentedViewController.transitioningDelegate = configModel;
    [self presentViewController:presentedViewController animated:true completion:nil];
}

@end
