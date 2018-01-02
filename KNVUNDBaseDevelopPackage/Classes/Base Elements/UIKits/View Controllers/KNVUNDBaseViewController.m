//
//  KNVUNDBaseViewController.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 15/12/17.
//

#import "KNVUNDBaseViewController.h"


// Tools
#import "KNVUNDThreadRelatedTool.h"

#pragma mark -
@implementation KNVUNDFormSheetSettingModel

@end

#pragma mark -
@interface KNVUNDBaseViewController ()

@end

@implementation KNVUNDBaseViewController{
    UIViewController *_currentPresentingViewController;// This Flag tells you if there is a FormSheet View Presented or not.
}

#pragma mark - Override Methods
#pragma mark - Identifier Method
+ (NSString *)storyboardName
{
    return @"";
}

+ (NSString *)viewControllerIdentifier
{
    return @"";
}

#pragma mark - View Settings
- (NSArray *)exclusiveTouchViews
{
    return @[];
}

#pragma mark - Present View Controller Related
- (void)presentViewControllerDidAppear
{
    
}

- (void)presentViewControllerDidDisappear
{
    
}

#pragma mark - Class Methods
#pragma mark - Generator
+ (KNVUNDBaseViewController *)generateCurrentViewControllerFromStoryboard
{
    UIStoryboard *currentStoryBoard = [UIStoryboard storyboardWithName:[self storyboardName]
                                                                bundle:nil];
    return [currentStoryBoard instantiateViewControllerWithIdentifier:[self viewControllerIdentifier]];
}

#pragma mark - UIViewController Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [self setupExclusiveTouchViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self dismissCurrentPresentationViewWithAnimation:YES]; /// Dismiss Presented View if needed.
}

#pragma mark - Getters & Setters
#pragma mark - Getters
- (UIViewController *)bannerMessageDisplayingVC
{
    if (![_bannerMessageDisplayingVC isKindOfClass:[UIViewController class]]) {
        return self;
    }
    return _bannerMessageDisplayingVC;
}

NSTimeInterval const KNVUNDBaseVC_DefaultValue_BannerShowingTime = 3.0;

- (NSTimeInterval)bannerShowingTime
{
    if (_bannerShowingTime == 0) {
        return KNVUNDBaseVC_DefaultValue_BannerShowingTime;
    }
    return _bannerShowingTime;
}

- (BOOL)isFormsheetActive
{
    return _currentPresentingViewController != nil;
}

#pragma mark Support Methods
- (void)setupExclusiveTouchViews
{
    for (UIView *exclusiveTouchView in [self exclusiveTouchViews]) {
        [exclusiveTouchView setExclusiveTouch:YES];
    }
}

#pragma mark - Navigation Related
- (void)addChildViewControllerWithFullSizeWithCurrentView:(UIViewController *)childViewController
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        [self addChildViewController:childViewController];
        UIView* destView = childViewController.view;
        destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:destView];
        [childViewController didMoveToParentViewController:self];
    }];
}

- (void)checkAndRemoveChildViewController:(UIViewController *)childViewController
{
    if ([self.childViewControllers containsObject:childViewController]) {
        [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
            [childViewController willMoveToParentViewController:nil];
            [childViewController.view removeFromSuperview];
            [childViewController removeFromParentViewController];
        }];
    }
}

- (void)removeSelfFromParentViewController
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - Banner Message Related
- (void)displayBannerMessageWithBannerType:(KNVUNDBaseVCBannerMessageType)type title:(NSString *)title andMessage:(NSString *)message
{
    [self showUpBannerWithTitle:title
                        message:message
                  andBannerType:type];
}

#pragma mark - Present View Related
#pragma mark Form Sheet View Related
- (void)presentFormSheetViewController:(UIViewController *)formsheetVC withSettingModel:(KNVUNDFormSheetSettingModel *)settingModel
{
    [self presentFormSheetViewController:formsheetVC
                        withSettingModel:settingModel
             andPresentedCompletionBlock:nil];
}

- (void)presentFormSheetViewController:(UIViewController *)formsheetVC withSettingModel:(KNVUNDFormSheetSettingModel *)settingModel andPresentedCompletionBlock:(void(^)())completionBlock
{
    [self presentPresentViewWithAnimated:settingModel.shouldShowUpWithAnimation
                   contentViewController:formsheetVC
           viewControllerGeneratingBlock:^UIViewController *{
               // We can try to move this part logic to Super Class like KNVBaseViewController.
               MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:formsheetVC];
               formSheetController.presentationController.contentViewSize = [formsheetVC preferredContentSize];
               
               // Here is the code let it dismiss while clicked back end.
               if (settingModel.shouldDismissWhileTappingBackend) {
                   formSheetController.presentationController.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location){
                       [self dismissCurrentPresentationViewWithAnimation:settingModel.shouldDismissWithAnimation];
                   };
               }
               
               formSheetController.presentationController.shouldCenterVertically = YES;
               formSheetController.contentViewControllerTransitionStyle = settingModel.typeHolderOne;
               formSheetController.presentationController.movementActionWhenKeyboardAppears = settingModel.typeHolderTwo;
               
               return formSheetController;
           }
                 andPresentCompleteBlock:completionBlock];
}

#pragma mark Popover Related Methods
- (void)presentPopoverViewController:(UIViewController *)popOverViewController andPopoverUpdatingBlock:(void(^)(UIPopoverPresentationController *relatedPresentController))popoverUpdatingBlock
{
    [self presentPresentViewWithAnimated:NO
                   contentViewController:popOverViewController
           viewControllerGeneratingBlock:^UIViewController *{
               popOverViewController.modalPresentationStyle = UIModalPresentationPopover;
               
               UIPopoverPresentationController *popover = popOverViewController.popoverPresentationController;
               popover.delegate = self;
               if (popoverUpdatingBlock) {
                   popoverUpdatingBlock(popover);
               }
               
               return popOverViewController;
           }
                 andPresentCompleteBlock:nil];
}

#pragma mark Support Methods
- (void)dismissCurrentPresentationViewWithAnimation:(BOOL)animation
{
    [self dismissCurrentPresentationViewWithAnimation:animation
                                   andCompletionBlock:nil];
}

- (void)dismissCurrentPresentationViewWithAnimation:(BOOL)animation andCompletionBlock:(void(^)())completionBlock
{
    
    if (_currentPresentingViewController) {
        _currentPresentingViewController = nil; // We put this out of completion because we don't want you call dismiss Current FormSheet PresentationView methods multiple times before it completed.
        [self dismissViewControllerAnimated:animation
                                 completion:^{
                                     [self presentViewControllerDidDisappear];
                                     if (completionBlock) {
                                         completionBlock();
                                     }
                                 }];
    }
}

// Content VC in here is used to checking to see if we need to present a new ViewController or not.
- (void)presentPresentViewWithAnimated:(BOOL)animated contentViewController:(UIViewController *)contentVC viewControllerGeneratingBlock:(UIViewController *(^_Nonnull)())viewControllerGeneratingBlock andPresentCompleteBlock:(void(^_Nullable)())completeBlock
{
    if ([_currentPresentingViewController isKindOfClass:[contentVC class]]) {
        return; // we will never present same view controller twice... otherwise, the UI animation will be very wired...
    }
    
    void(^formSheetShowUpBlock)() = ^() {
        UIViewController *presentingViewController = viewControllerGeneratingBlock();
        [self presentViewController:presentingViewController
                           animated:animated
                         completion:^{
                             _currentPresentingViewController = contentVC;
                             
                             [self presentViewControllerDidAppear];
                             
                             if (completeBlock) {
                                 completeBlock();
                             }
                         }];
    };
    
    if (_currentPresentingViewController != nil && _currentPresentingViewController != contentVC) {
        [self dismissCurrentPresentationViewWithAnimation:NO
                                       andCompletionBlock:^{
                                           formSheetShowUpBlock();
                                       }];
    } else if(_currentPresentingViewController == nil) {
        formSheetShowUpBlock();
    } else {
        if (completeBlock) {
            completeBlock();
        }
    }
}

#pragma mark - Delegate
#pragma mark - UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    _currentPresentingViewController = nil;
}

#pragma mark - Support Methods
- (void)showUpBannerWithTitle:(NSString *)title message:(NSString *)message andBannerType:(KNVUNDBaseVCBannerMessageType)bannerType
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        [RMessage showNotificationInViewController:self.bannerMessageDisplayingVC
                                             title:title subtitle:message
                                         iconImage:nil
                                              type:(RMessageType)bannerType
                                    customTypeName:@""
                                          duration:self.bannerShowingTime
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionBottom
                              canBeDismissedByUser:YES];
    }];
}

@end
