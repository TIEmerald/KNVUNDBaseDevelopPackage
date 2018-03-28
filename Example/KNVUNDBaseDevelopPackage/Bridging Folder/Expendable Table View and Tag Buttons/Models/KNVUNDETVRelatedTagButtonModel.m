//
//  KNVUNDETVRelatedTagButtonModel.m
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by Erjian Ni on 23/3/18.
//  Copyright © 2018 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDETVRelatedTagButtonModel.h"

// View
#import "KNVUNDETVRelatedTagButtonCell.h"

// Categories
#import "UIButton+KNVUNDButtonsSelectionButton.h"

@interface KNVUNDETVRelatedTagButtonModel(){
    UIButton *_associatedTagButton;
}

@end

@implementation KNVUNDETVRelatedTagButtonModel

#pragma mark - KNVUNDExpendingTableViewRelatedModel
#pragma mark - Class Methods
+ (Class _Nonnull)relatedTableViewCell
{
    return [KNVUNDETVRelatedTagButtonCell class];
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
- (NSString *)associatedString
{
    if ([self.associatedItem isKindOfClass:[NSString class]]) {
        return (NSString *)self.associatedItem;
    } else {
        return @"";
    }
}

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
        
    }];
}

- (void)tapTagButton
{
    if ([self.tagButtonDelegate respondsToSelector:@selector(selectTagButton:)]) {
        [self.tagButtonDelegate selectTagButton:_associatedTagButton];
    }
}

#pragma mark Support Methods
- (void)triggerTagButtonFunction
{
    if ([self.tagButtonDelegate respondsToSelector:@selector(tagButtonTriggeredWithAssociatedItem:)]) {
        [self.tagButtonDelegate tagButtonTriggeredWithAssociatedItem:[self associatedString]];
    }
}

@end
