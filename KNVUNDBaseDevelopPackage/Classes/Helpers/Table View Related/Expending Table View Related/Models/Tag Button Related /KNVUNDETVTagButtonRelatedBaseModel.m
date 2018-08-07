//
//  KNVUNDETVTagButtonRelatedBaseModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 28/3/18.
//

#import "KNVUNDETVTagButtonRelatedBaseModel.h"

// Categories
#import "UIButton+KNVUNDButtonsSelectionButton.h"

@interface KNVUNDETVTagButtonRelatedBaseModel(){
    UIButton *_associatedTagButton;
}

@end

@implementation KNVUNDETVTagButtonRelatedBaseModel

@dynamic relatedCellDelegate;

#pragma mark - KNVUNDExpendingTableViewRelatedModel
#pragma mark - Overrided Methods
#pragma mark Instance Methods
- (void)isSelectedSatatusChangedFrom:(BOOL)oldValue to:(BOOL)newValue andCouldUpdateExpendStatus:(BOOL)couldUpdateExpendStatus
{
    [super isSelectedSatatusChangedFrom:oldValue to:newValue andCouldUpdateExpendStatus:couldUpdateExpendStatus];
    if (newValue) {
        [self markTagButtonAsSelected];
    }
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        [self setupTagButton];
    }
    return self;
}

#pragma mark - Getters & Setters
#pragma mark - Getters
- (UIButton *)associatedTagButton
{
    return _associatedTagButton;
}

#pragma mark - General Methods
- (void)setupTagButton
{
    __weak typeof(self) weakSelf = self;
    _associatedTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_associatedTagButton setUpWithSelectedFunction:^(UIButton * _Nonnull relatedButton) {
        [weakSelf triggerTagButtonFunction];
    } andDeSelectedFunction:^(UIButton * _Nonnull relatedButton) {
        [weakSelf deTriggerTagButtonFunction];
    }];
}

- (void)markTagButtonAsSelected
{
    [_associatedTagButton triggerSelfToSelectedInRelatedSelectionHelper];
}

- (void)markTagButtonAsUnSelected
{
    [_associatedTagButton triggerSelfToUnSelectedInRelatedSelectionHelper];
}

#pragma mark Support Methods
- (void)triggerTagButtonFunction
{
    [self reloadTheCellForSelf];
    if ([self.tagButtonDelegate respondsToSelector:@selector(tagButtonSelectedWithModel:)]) {
        [self.tagButtonDelegate tagButtonSelectedWithModel:self];
        [self.relatedCellDelegate setUpTagSelectionStatusRelatedUI];
    }
}

- (void)deTriggerTagButtonFunction
{
    [self reloadTheCellForSelf];
    if ([self.tagButtonDelegate respondsToSelector:@selector(tagButtonDeSelectedWithModel:)]) {
        [self.tagButtonDelegate tagButtonDeSelectedWithModel:self];
        [self.relatedCellDelegate setUpTagSelectionStatusRelatedUI];
    }
}

@end
