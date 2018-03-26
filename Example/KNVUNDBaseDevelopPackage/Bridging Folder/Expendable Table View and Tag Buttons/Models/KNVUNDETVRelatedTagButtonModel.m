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

// Tools
#import "KNVUNDImageRelatedTool.h"

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
        _associatedTagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _associatedTagButton.translatesAutoresizingMaskIntoConstraints = NO;
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
    [_associatedTagButton setTitle:[self associatedString]
                          forState:UIControlStateNormal];
    [_associatedTagButton setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
    [_associatedTagButton setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateSelected];
    [_associatedTagButton setBackgroundImage:[KNVUNDImageRelatedTool generateImageWithColor:[UIColor clearColor]]
                                    forState:UIControlStateNormal];
    [_associatedTagButton setBackgroundImage:[KNVUNDImageRelatedTool generateImageWithColor:[UIColor blueColor]]
                                    forState:UIControlStateSelected];
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
