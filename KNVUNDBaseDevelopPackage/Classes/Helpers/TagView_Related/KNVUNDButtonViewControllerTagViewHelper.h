//
//  KNVUNDButtonViewControllerTagViewHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDBaseModel.h"

#import "KNVUNDButtonVCTVHelperTagVCProtocol.h"

#pragma mark -
@interface KNVUNDButtonVCTVHelperModel : KNVUNDBaseModel

// This is the Button related to current Model (a button of the tags).
// We set this as a strong point is because in some case like Tag Button itself should be programmatically added into views like (Collection Cells, or Table Cells)
// Normally, there are two ways to configure this UIButton
//      1. You insert this button to View via .nib or .storyboard files, set up NormalStatus and other Status inside ViewController and assign button to this Model in this ViewController.
//      2. Or, you will override the getter for this Button and will insert this Button programatically.
@property (strong, nonatomic) UIButton *tagButton;

// Different Model might set different supportedData, could be a string, array or dictionary...
@property (strong, nonatomic) id supportedData;

// We can change this method to a property later... Like, if you want to store the all View Controller Information while you switched Tag... (like if you switch to another tag and then switch back to current tag, you don't want the data inside current view controller disappear, you'd better assign a View controller to this property) Otherwise, you need to just override getter method like what we currently do.
@property (strong, nonatomic) UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *relatedTagViewController;

#pragma mark - Initial
- (instancetype)initWithTagButton:(UIButton *)tagButton andRelatedTagViewController:(UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *)relatedTagViewController;

@end

#pragma mark -
@protocol KNVUNDButtonVCTVHelperTargetProtocol <NSObject>

@optional
- (void)didSelectTagModel:(KNVUNDButtonVCTVHelperModel *)tagModel;

@end

@interface KNVUNDButtonViewControllerTagViewHelper : KNVUNDBaseModel

#pragma mark - Life Cycle
#pragma mark - Set Up
// By Default we will pre-select the first Tag Button.
- (void)setupCurrentHelperWithTargetViewController:(UIViewController<KNVUNDButtonVCTVHelperTargetProtocol> *)targetViewController tagViewDisplayingView:(UIView *)displayingView andTagButtonModels:(NSArray<KNVUNDButtonVCTVHelperModel *>*)tagButtonModels;

/*!
 * @brief This method will set up current Helper based on the UIViewController you passed in.|
 * @param targetViewController You have to make should the target View Controller have implemented the methods we defined in the Protocol
 * @param shouldPreselected We will by default select the firest button, if you set this value to yes.
 * @param defaultSelectedIndex This will be useful only if you set shouldPreselected to YES, and this value tell use which Model should we preselected (the index is the index inside      -(void)getKNVTagButtonModels; method)
 */
- (void)setupCurrentHelperWithTargetViewController:(UIViewController<KNVUNDButtonVCTVHelperTargetProtocol> *)targetViewController tagViewDisplayingView:(UIView *)displayingView andTagButtonModels:(NSArray<KNVUNDButtonVCTVHelperModel *>*)tagButtonModels shouldPreselected:(BOOL)shouldPreselected withDefaultSelectedIndex:(NSUInteger)defaultSelectedIndex;

#pragma mark - Release Methods
/*!
 * @brief This method will release all memory for this helper, I am not very sure, I think you'd better handle the release by your self
 */
- (void)releaseCurrentHelper;

#pragma mark - Data Retrieving
/*!
 * @brief This method will return current displayed view controller
 * @return UIViewController<KNVAddMenuItemBasicSubVCProtocol> Current displayed view controller
 */
- (UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *)getCurrentDisplayingVC;

#pragma mark - Data Update
/*!
 * @brief This method will just dismiss current display view controller if it existed
 */
- (void)dismissCurrentDisplayViewController;

/*!
 * @brief You can call this method to programmatically perform select tag function... Be careful if the button you passed in didn't existed in - (NSArray *)getKNVTagButtons; while we setup Current Helper With Target View Controller. We will ignore the button you passed in...
 * @param selectingButton Which tag button you want to select
 */
- (void)selectButton:(UIButton *)selectingButton;

@end
