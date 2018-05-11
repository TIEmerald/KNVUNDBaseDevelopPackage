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
#pragma mark -
@implementation KNVUNDFormSheetSettingModel

@end

#pragma mark -
#pragma mark -
// These models is used to show up alert view --- We are using UIAlertController as the showing up logic
@implementation KNVUNDAlertActionSettingModel{
    KNVUNDAlertActionSettingBlock _storedSettingBlock;
}

#pragma mark - Initial
- (instancetype)initWithTitle:(NSString *)title style:(UIAlertActionStyle)style andHandler:(KNVUNDAlertActionSettingBlock)handler
{
    if (self = [self init]) {
        self.title = title;
        self.actionStyle = style;
        _storedSettingBlock = handler;
    }
    return self;
}

#pragma mark - Generator
+ (instancetype)generateActionModelWithTitle:(NSString *)title style:(UIAlertActionStyle)style andHandler:(KNVUNDAlertActionSettingBlock)handler
{
    return [[self alloc] initWithTitle:title
                                 style:style
                            andHandler:handler];
}

#pragma mark - Support Methods
- (UIAlertAction *)retrieveAlertActionFromSelfWithBaseViewController:(KNVUNDBaseViewController *)baseUIViewController
{
    UIAlertAction *returnAction = [UIAlertAction actionWithTitle:self.title
                                                           style:self.actionStyle
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [baseUIViewController setPresentedViewControllerToNil];
                                                             if (_storedSettingBlock) {
                                                                 _storedSettingBlock(action);
                                                             }
                                                         }];
    return returnAction;
}

@end

@implementation KNVUNDAlertControllerSettingModel {
    NSArray *_storedActions;
}

#pragma mark - Initial
- (instancetype)initWithTitle:(NSString *)title style:(UIAlertControllerStyle)controllerStyle message:(NSString *)message andActions:(NSArray *)actions
{
    if (self = [self init]) {
        self.title = title;
        self.alertStyle = controllerStyle;
        self.message = message;
        _storedActions = actions;
    }
    return self;
}

#pragma mark - Generator
/// Default Alert Style from this method is UIAlertControllerStyleAlert
+ (instancetype)generateAlertStyleControllerModelWithTitle:(NSString *)title message:(NSString *)message andActions:(NSArray *)actions
{
    return [[self alloc] initWithTitle:title
                                 style:UIAlertControllerStyleAlert
                               message:message
                            andActions:actions];
}

#pragma mark - Support Methods
- (UIAlertController *)retrieveAlertControllerFromSelfWithBaseViewController:(KNVUNDBaseViewController *)baseViewController
{
    UIAlertController *returnController = [UIAlertController alertControllerWithTitle:self.title
                                                                              message:self.message
                                                                       preferredStyle:self.alertStyle];
    for (KNVUNDAlertActionSettingModel *actionModel in _storedActions) {
        UIAlertAction *alertAction = [actionModel retrieveAlertActionFromSelfWithBaseViewController:baseViewController];
        [returnController addAction:alertAction];
    }
    return returnController;
}

@end

#pragma mark -
#pragma mark -
@interface KNVUNDBaseViewController () <RMessageProtocol>

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

- (KNVUNDBaseVCBannerPosition)bannerPosition
{
    return KNVUNDBaseVCBannerPosition_Bottom;
}

#pragma mark Support Methods
- (void)setupExclusiveTouchViews
{
    for (UIView *exclusiveTouchView in [self exclusiveTouchViews]) {
        [exclusiveTouchView setExclusiveTouch:YES];
    }
}

#pragma mark - Navigation Related
/// Dirctly Modify Views
- (void)addChildViewControllerWithFullSizeWithCurrentView:(UIViewController *)childViewController
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
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
        [self removeChildViewControllerInMainBlock:childViewController];
    }
}

- (void)removeAllChildrenViewControllers
{
    for (UIViewController *childViewController in self.childViewControllers) {
        [self removeChildViewControllerInMainBlock:childViewController];
    }
}

- (void)removeSelfFromParentViewController
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             [self willMoveToParentViewController:nil];
                                             [self.view removeFromSuperview];
                                             [self removeFromParentViewController];
                                         }];
}

/// Perform Sugure Related .... Override.... Make sure all segue is called in main thread... in case some error
// Details:
// This crash has non-main threads that appear to use UIKit classes or functions. Generally speaking, it is only safe to use UIKit from the main thread. Calling into UIKit from background threads can cause unpredictable behavior (like crashes!).. Please double check that all of your code (that is not on the main thread) has been explicitly marked as safe to use in the background by Apple.
// Resources:
// UIKit Framework Reference (https://developer.apple.com/documentation/uikit)
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             [super performSegueWithIdentifier:identifier sender:sender];
                                         }];
}

#pragma mark Support Methods
- (void)removeChildViewControllerInMainBlock:(UIViewController *)childViewController
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             [childViewController willMoveToParentViewController:nil];
                                             [childViewController.view removeFromSuperview];
                                             [childViewController removeFromParentViewController];
                                         }];
}

#pragma mark - Banner Message Related
- (void)displayBannerMessageWithBannerType:(KNVUNDBaseVCBannerMessageType)type title:(NSString *)title andMessage:(NSString *)message
{
    [self showUpBannerWithTitle:title
                        message:message
                  andBannerType:type];
}

#pragma mark - Alert Related
- (void)displayAlertMessageWithAlertSettingModel:(KNVUNDAlertControllerSettingModel *)alertSettingModel
{
    UIAlertController *alertControlelr = [alertSettingModel retrieveAlertControllerFromSelfWithBaseViewController:self];
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        [self presentPresentViewWithAnimated:alertSettingModel.shouldShowUpWithAnimation
                       contentViewController:alertControlelr
               viewControllerGeneratingBlock:^UIViewController *{
                   return alertControlelr;
               }
                     andPresentCompleteBlock:alertSettingModel.didShowUpBlock];
    }];
}

#pragma mark - Present View Related
#pragma mark Form Sheet View Related
- (void)presentFormSheetViewController:(UIViewController *)formsheetVC withSettingModel:(KNVUNDFormSheetSettingModel *)settingModel
{
    [self presentFormSheetViewController:formsheetVC
                        withSettingModel:settingModel
             andPresentedCompletionBlock:nil];
}

- (void)presentFormSheetViewController:(UIViewController *)formsheetVC withSettingModel:(KNVUNDFormSheetSettingModel *)settingModel andPresentedCompletionBlock:(void(^)(void))completionBlock
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

- (void)dismissCurrentPresentationViewWithAnimation:(BOOL)animation andCompletionBlock:(void(^)(void))completionBlock
{
    
    if (_currentPresentingViewController) {
        [self setPresentedViewControllerToNil]; // We put this out of completion because we don't want you call dismiss Current FormSheet PresentationView methods multiple times before it completed.
        [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
            [self dismissViewControllerAnimated:animation
                                     completion:^{
                                         [self presentViewControllerDidDisappear];
                                         if (completionBlock) {
                                             completionBlock();
                                         }
                                     }];
        }];
    }
}

// Content VC in here is used to checking to see if we need to present a new ViewController or not.
- (void)presentPresentViewWithAnimated:(BOOL)animated contentViewController:(UIViewController *)contentVC viewControllerGeneratingBlock:(UIViewController *(^_Nonnull)(void))viewControllerGeneratingBlock andPresentCompleteBlock:(void(^_Nullable)(void))completeBlock
{
    if (_currentPresentingViewController == contentVC) {
        return; // we will never present same view controller twice... otherwise, the UI animation will be very wired...
    }
    
    void(^formSheetShowUpBlock)(void) = ^() {
        UIViewController *presentingViewController = viewControllerGeneratingBlock();
        [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
            [self presentViewController:presentingViewController
                               animated:animated
                             completion:^{
                                 _currentPresentingViewController = contentVC;
                                 
                                 [self presentViewControllerDidAppear];
                                 
                                 if (completeBlock) {
                                     completeBlock();
                                 }
                             }];
        }];
    };
    
    if (_currentPresentingViewController != nil && _currentPresentingViewController != contentVC) {
        [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
            [self dismissCurrentPresentationViewWithAnimation:NO
                                           andCompletionBlock:^{
                                               formSheetShowUpBlock();
                                           }];
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
    [self setPresentedViewControllerToNil];
}

#pragma mark - RMessageProtocol
- (void)customizeMessageView:(RMessageView *)messageView
{
    
}


#pragma mark - Support Methods
- (void)setPresentedViewControllerToNil
{
    _currentPresentingViewController = nil;
}

- (void)showUpBannerWithTitle:(NSString *)title message:(NSString *)message andBannerType:(KNVUNDBaseVCBannerMessageType)bannerType
{
    [KNVUNDThreadRelatedTool performBlockSynchronise:NO
                                         inMainQueue:^{
                                             switch (self.bannerToolType) {
                                                 case KNVUNDBaseVCBannerTool_TMessage:
                                                     /// This is a temporary fix for Abacus POS, this method will cause the issue that Example App will crash, but it works fine in Abacus POS.
                                                     [TSMessage showNotificationInViewController:self.bannerMessageDisplayingVC
                                                                                       withTitle:title
                                                                                     withMessage:message
                                                                                        withType:(TSMessageNotificationType)bannerType
                                                                                    withDuration:self.bannerShowingTime
                                                                                    withCallback:nil
                                                                                 withButtonTitle:@""
                                                                              withButtonCallback:nil
                                                                                      atPosition:self.bannerPosition == KNVUNDBaseVCBannerPosition_Bottom ? TSMessageNotificationPositionBottom : TSMessageNotificationPositionTop
                                                                             canBeDismisedByUser:YES];

                                                     break;
                                                 case KNVUNDBaseVCBannerTool_RMessage:
                                                 default:
                                                     [RMessage showNotificationInViewController:self.bannerMessageDisplayingVC
                                                                                          title:title
                                                                                       subtitle:message
                                                                                      iconImage:nil
                                                                                           type:(RMessageType)bannerType
                                                                                 customTypeName:@""
                                                                                       duration:self.bannerShowingTime
                                                                                       callback:nil
                                                                                    buttonTitle:nil
                                                                                 buttonCallback:nil
                                                                                     atPosition:self.bannerPosition == KNVUNDBaseVCBannerPosition_Bottom ? RMessagePositionBottom : RMessagePositionNavBarOverlay
                                                                           canBeDismissedByUser:YES];
                                                     break;
                                             }                                         }];
}

@end
