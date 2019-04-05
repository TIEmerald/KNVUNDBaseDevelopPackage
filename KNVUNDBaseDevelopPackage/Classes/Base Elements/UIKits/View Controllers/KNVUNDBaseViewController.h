//
//  KNVUNDBaseViewController.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 15/12/17.
//

#import <UIKit/UIKit.h>

// Third Party Packages
#import <RMessage/RMessage.h>
#import <TSMessages/TSMessage.h>
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

#pragma mark -
#pragma mark -
// This model is used passing setting's information while you want to show up FormSheet
@interface KNVUNDFormSheetSettingModel : NSObject

#pragma mark General
// In an idea way, we shouldn't never let other people know which third party we are using... Just still need time to find a better way.
// Current for MZFormSheetPresentationViewController this is contentViewControllerTransitionStyle (MZFormSheetPresentationTransitionStyle)
@property (nonatomic) NSInteger typeHolderOne; // This is for any enum type you want to assign.

// Current for MZFormSheetPresentationViewController this is movementActionWhenKeyboardAppears (MZFormSheetActionWhenKeyboardAppears)
@property (nonatomic) NSInteger typeHolderTwo;

#pragma mark Show up View Related Settings
@property (nonatomic) BOOL shouldShowUpWithAnimation;

#pragma mark Dismiss View Related Settings
// Set this boolean to yes if you want to dismiss Form Sheet View while tap view out of presented From sheet View Controller.
@property (nonatomic) BOOL shouldDismissWhileTappingBackend;

// Set this boolean to yes if you want to dismiss the from sheet view with animation
@property (nonatomic) BOOL shouldDismissWithAnimation;

@end

#pragma mark -
#pragma mark -
typedef void(^KNVUNDAlertActionSettingBlock)(UIAlertAction *relatedAction);

// These models is used to show up alert view --- We are using UIAlertController as the showing up logic
@interface KNVUNDAlertActionSettingModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) UIAlertActionStyle actionStyle;

#pragma mark - Generator
+ (instancetype)generateActionModelWithTitle:(NSString *)title style:(UIAlertActionStyle)style andHandler:(KNVUNDAlertActionSettingBlock)handler;

@end

typedef void(^KNVUNDAlertControllerSettingCompleteBlock)(void);

@interface KNVUNDAlertControllerSettingModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@property (nonatomic) UIAlertControllerStyle alertStyle;
@property (nonatomic) BOOL shouldShowUpWithAnimation;
@property (nonatomic) KNVUNDAlertControllerSettingCompleteBlock didShowUpBlock;

#pragma mark - Generator
/// Default Alert Style from this method is UIAlertControllerStyleAlert
+ (instancetype)generateAlertStyleControllerModelWithTitle:(NSString *)title message:(NSString *)message andActions:(NSArray *)actions;

@end

#pragma mark -
#pragma mark -
typedef enum KNVUNDBaseVCBannerMessageType : NSInteger{
    KNVUNDBaseVCBannerMessageType_Success = RMessageTypeSuccess,
    KNVUNDBaseVCBannerMessageType_Notify = RMessageTypeWarning,
    KNVUNDBaseVCBannerMessageType_Failure = RMessageTypeError
}KNVUNDBaseVCBannerMessageType;

typedef enum : NSUInteger {
    KNVUNDBaseVCBannerTool_RMessage,
    KNVUNDBaseVCBannerTool_TMessage
} KNVUNDBaseVCBannerTool;

typedef enum : NSUInteger {
    KNVUNDBaseVCBannerPosition_Top,
    KNVUNDBaseVCBannerPosition_Bottom
} KNVUNDBaseVCBannerPosition;

typedef enum : NSUInteger {
    KNVUNDBaseVCChildViewControlerPresentType_FullSize,
    KNVUNDBaseVCChildViewControlerPresentType_PreferredSize_Centralised
} KNVUNDBaseVCChildViewControlerPresentType;

@interface KNVUNDBaseViewController : UIViewController <UIPopoverPresentationControllerDelegate>

/////****************************************************************
/// Banner Related Settings....
/*!
 * @brief I create a property in here, because in some case some ViewController just want to display banner message other than current view controller... In this case, you need assign which view controller you want to display banner message in here. Otherwise, this property will just return current view controller. ....... There are already some Sub-Classes have it own bannerMessageDisplayingVC... You'd better merge to this property later....
 */
@property (weak, nonatomic) UIViewController *bannerMessageDisplayingVC;
@property (nonatomic) NSTimeInterval bannerShowingTime; /// Default 3.0s
@property (readonly) KNVUNDBaseVCBannerTool bannerToolType; /// Decide which third party package we will using for bannoer.
@property (readonly) KNVUNDBaseVCBannerPosition bannerPosition; /// By default it will show up in the bottom.


/////****************************************************************
/// View Controller Presentation Related
// This property will tell you if we are currently displaying Formsheet or not.
@property (readonly) BOOL isPresentingViewController;
@property (readonly) UIViewController *currentPresentingViewController;
@property (readonly) BOOL isFormsheetActive __attribute__((deprecated("Use -isPresentingViewController instead.")));

#pragma mark - Override Methods
#pragma mark - Identifiers
/*!
 * @brief This method will tell you in which story board you can retrieve this View Controller.
 * @return NSString In which story board you can retrieve this View Controller.
 */
+ (NSString *)storyboardName;

/*!
 * @brief This method will tell you what the identifier is for this view controller.
 * @return NSString What the identifier is for this view controller.
 */
+ (NSString *)viewControllerIdentifier;

#pragma mark - View Settings
/*!
 * @brief To be safe, some buttons you won't want them to be touched at the same time. If there is, you'd better add this button in to this exclusiveTouchViews in your customer subClasses. And we will autoMatically set all views in this array exclusiveTouch to be YES in - viewDidLoad method.
 * @return NSArray The Views you want to set Exclusive Touch to be YES.
 */
- (NSArray *)exclusiveTouchViews;

#pragma mark - Present View Controller Related
// This two method is used to handle the workflow of presenting view controller logic...... Currently, the presenting view controller we are handling is popover and formsheet.
- (void)presentViewControllerDidAppear;
- (void)presentViewControllerDidDisappear;

#pragma mark - Generator
/*!
 * @brief In order to generate View Controller from this method, you'd better make sure storyboardName and viewControllerIdentifier have valid value.
 */
+ (KNVUNDBaseViewController *)generateCurrentViewControllerFromStoryboard;

#pragma mark - Navigation Related
/*!
 * @brief As the name says, it will add a child view controller into current view controller and put the size of your child view as the same size as you current view.
 * @param childViewController Which View controller you want to add as child view controller.
 */
- (void)addChildViewControllerWithFullSizeWithCurrentView:(UIViewController *)childViewController;
- (void)addChildViewController:(UIViewController *)childViewController withPresentingType:(KNVUNDBaseVCChildViewControlerPresentType)presentingType;
- (void)addChildViewController:(UIViewController *)childViewController withFrameRect:(CGRect)frameRect;
- (void)checkAndRemoveChildViewController:(UIViewController *)childViewController;
- (void)removeAllChildrenViewControllers;

/*!
 * @brief This method will remove currrent view controller from parent view controller and dismiss view
 */
- (void)removeSelfFromParentViewController;

#pragma mark - Banner Message Related
/*!
 * @brief Combine with bannerMessageDisplayingVC property... This method will display the related message in the target view controller.... If you didn't set and banner Message Displaying VC.. It will display the banner in current VC...
 */
- (void)displayBannerMessageWithBannerType:(KNVUNDBaseVCBannerMessageType)type title:(NSString *)title andMessage:(NSString *)message;

#pragma mark - Alert Related
/*!
 * @brief This method will show up Alert View with UIAlertController
 */
- (void)displayAlertMessageWithAlertSettingModel:(KNVUNDAlertControllerSettingModel *)alertSettingModel;

#pragma mark - Present View Related
#pragma mark Form Sheet View Related
/*!
 * @brief This method will display the formsheetVC you passed in upon current view controller. How will it show up will based on the setting Model you passed in.
 */
- (void)presentFormSheetViewController:(UIViewController *)formsheetVC withSettingModel:(KNVUNDFormSheetSettingModel *)settingModel;
- (void)presentFormSheetViewController:(UIViewController *)formsheetVC withSettingModel:(KNVUNDFormSheetSettingModel *)settingModel andPresentedCompletionBlock:(void(^)(void))completionBlock;

#pragma mark Popover Related Methods
/*!
 * @brief Please call this method if you want to present any popover view controller
 *      //// Important.... please don't re-assign relatedPresentController's delegate
 */
- (void)presentPopoverViewController:(UIViewController *)popOverViewController andPopoverUpdatingBlock:(void(^)(UIPopoverPresentationController *relatedPresentController))popoverUpdatingBlock;

#pragma mark Support Methods
/*!
 * @brief This method will dismiss current Form Sheet View if it existed.
 */
- (void)dismissCurrentPresentationViewWithAnimation:(BOOL)animation;
- (void)dismissCurrentPresentationViewWithAnimation:(BOOL)animation andCompletionBlock:(void(^)(void))completionBlock;

#pragma mark - Support Methods
- (void)setPresentedViewControllerToNil;

@end

