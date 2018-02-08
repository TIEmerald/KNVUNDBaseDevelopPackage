//
//  KNVUNDButtonViewControllerTagViewHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDButtonViewControllerTagViewHelper.h"

// Helpers
#import "KNVUNDButtonsSelectionHelper.h"

// Third Party
#import <LinqToObjectiveC/LinqToObjectiveC.h>

@implementation KNVUNDButtonVCTVHelperModel

#pragma mark - Getters & Setters
#pragma mark - Getters
- (UIButton *)tagButton
{
    if (!_tagButton) {
        return _tagButton = [UIButton new];
    }
    return _tagButton;
}

- (UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *)relatedTagViewController
{
    if (!_relatedTagViewController) {
        return [UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> new];
    }
    return _relatedTagViewController;
}

#pragma mark - Initial
- (instancetype)initWithTagButton:(UIButton *)tagButton andRelatedTagViewController:(UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *)relatedTagViewController
{
    if (self = [super init]) {
        self.tagButton = tagButton;
        self.relatedTagViewController = relatedTagViewController;
    }
    return self;
}

@end

@interface KNVUNDButtonViewControllerTagViewHelper(){
    KNVUNDButtonsSelectionHelper *_selectionHelper;
    KNVUNDButtonVCTVHelperModel *_currentSelectedHelperModel;
}

@property (weak, nonatomic) UIViewController<KNVUNDButtonVCTVHelperTargetProtocol> *targetViewController;
@property (weak, nonatomic) UIView *relatedDisplayingView;

@end

@implementation KNVUNDButtonViewControllerTagViewHelper

#pragma mark - Life Cycle
#pragma mark - Initial Methods
- (instancetype)init
{
    if (self = [super init]) {
        _selectionHelper = [KNVUNDButtonsSelectionHelper new];
        _selectionHelper.isSingleSelection = YES;
    }
    return self;
}

#pragma mark - Set Up
// By Default we will pre-select the first Tag Button.
- (void)setupCurrentHelperWithTargetViewController:(UIViewController<KNVUNDButtonVCTVHelperTargetProtocol> *)targetViewController tagViewDisplayingView:(UIView *)displayingView andTagButtonModels:(NSArray<KNVUNDButtonVCTVHelperModel *>*)tagButtonModels
{
    [self setupCurrentHelperWithTargetViewController:targetViewController
                               tagViewDisplayingView:displayingView
                                  andTagButtonModels:tagButtonModels
                                   shouldPreselected:YES
                            withDefaultSelectedIndex:0];
}

- (void)setupCurrentHelperWithTargetViewController:(UIViewController<KNVUNDButtonVCTVHelperTargetProtocol> *)targetViewController tagViewDisplayingView:(UIView *)displayingView andTagButtonModels:(NSArray<KNVUNDButtonVCTVHelperModel *>*)tagButtonModels shouldPreselected:(BOOL)shouldPreselected withDefaultSelectedIndex:(NSUInteger)defaultSelectedIndex
{
    self.targetViewController = targetViewController;
    self.relatedDisplayingView = displayingView;
    NSArray *usingTagButtons = [tagButtonModels linq_select:^UIButton *(KNVUNDButtonVCTVHelperModel *item) {
        UIButton *thisButton = item.tagButton;
        thisButton.associatedModel = item;
        [thisButton setUpWithSelectedFunction:^(UIButton * _Nonnull relatedButton) {
            [self didSelectHelperModel:(KNVUNDButtonVCTVHelperModel *)relatedButton.associatedModel];
        } andDeSelectedFunction:^(UIButton * _Nonnull relatedButton) {
            [self didDeSelectHelperModel:(KNVUNDButtonVCTVHelperModel *)relatedButton.associatedModel];
        }];
        return thisButton;
    }];
    
    NSArray *preSelectButtons = nil;
    if (shouldPreselected) {
        NSUInteger preselectedIndex = 0;
        
        if (defaultSelectedIndex < [usingTagButtons count]) {
            preselectedIndex = defaultSelectedIndex;
        }
        
        preSelectButtons = @[[usingTagButtons objectAtIndex:preselectedIndex]];
    }
    
    [_selectionHelper setupWithHelperButtonsArray:usingTagButtons
                              withSelectedButtons:preSelectButtons];
}

#pragma mark Support Method
- (void)didSelectHelperModel:(KNVUNDButtonVCTVHelperModel *)selectedModel
{
    if ([self.targetViewController respondsToSelector:@selector(didSelectTagModel:)]) {
        [self.targetViewController didSelectTagModel:selectedModel];
    }
    
    if (_currentSelectedHelperModel == selectedModel) {
        return;
    }
    
    [self didDeSelectHelperModel:_currentSelectedHelperModel];
    
    _currentSelectedHelperModel = selectedModel;
    
    if (_currentSelectedHelperModel) {
        UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *relatedViewController = [self getCurrentDisplayingVC];
        if (![relatedViewController isKindOfClass:[UIViewController class]]) {
            return;
        }
        
        if ([relatedViewController respondsToSelector:@selector(tagViewControllerWillAppear)]) {
            [relatedViewController tagViewControllerWillAppear];
        }
        
        [self.targetViewController addChildViewController:relatedViewController];
        relatedViewController.view.frame = self.relatedDisplayingView.bounds;
        [self.relatedDisplayingView addSubview:relatedViewController.view];
        [relatedViewController didMoveToParentViewController:self.targetViewController];
        
        if ([relatedViewController respondsToSelector:@selector(tagViewControllerDidAppear)]) {
            [relatedViewController tagViewControllerDidAppear];
        }
    }
}

- (void)didDeSelectHelperModel:(KNVUNDButtonVCTVHelperModel *)selectedModel
{
    if (_currentSelectedHelperModel != selectedModel) {
        return;
    }
    
    if (_currentSelectedHelperModel) {
        UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *relatedViewController = [self getCurrentDisplayingVC];
        if (![relatedViewController isKindOfClass:[UIViewController class]]) {
            return;
        }
        
        if ([relatedViewController respondsToSelector:@selector(tagViewControllerWillDisappear)]) {
            [relatedViewController tagViewControllerWillDisappear];
        }
        
        [relatedViewController willMoveToParentViewController:nil];
        [relatedViewController.view removeFromSuperview];
        [relatedViewController removeFromParentViewController];
        
        _currentSelectedHelperModel = nil;
    }
}

#pragma mark - Release Methods
- (void)releaseCurrentHelper
{
    self.targetViewController = nil;
    self.relatedDisplayingView = nil;
    _currentSelectedHelperModel = nil;
    [_selectionHelper resetCurrentHelper];
}

#pragma mark - Data Retrieving
- (UIViewController<KNVUNDButtonVCTVHelperTagVCProtocol> *)getCurrentDisplayingVC
{
    return _currentSelectedHelperModel.relatedTagViewController;
}


#pragma mark - Data Update
- (void)dismissCurrentDisplayViewController
{
    if (_currentSelectedHelperModel.tagButton.selected) {
        [_selectionHelper tapAButton:_currentSelectedHelperModel.tagButton];
    }
}

- (void)selectButton:(UIButton *)selectingButton
{
    [_selectionHelper tapAButton:_currentSelectedHelperModel.tagButton];
}

@end
