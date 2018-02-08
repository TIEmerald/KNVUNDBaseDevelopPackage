//
//  KNVUNDButtonsSelectionHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 20/12/17.
//

#import "KNVUNDButtonsSelectionHelper.h"

#import <LinqToObjectiveC/LinqToObjectiveC.h>

@interface KNVUNDButtonsSelectionHelper(){
    NSArray<UIButton *> *_currentAssociatedButtons;
}

@end

@implementation KNVUNDButtonsSelectionHelper

#pragma mark - Getters & Setters
#pragma mark - Getters

#pragma mark - Setters
- (void)setIsForceSelection:(BOOL)isForceSelection
{
    _isForceSelection = isForceSelection;
    if (isForceSelection && [[self currentSelectedButtons] count] == 0) {
        [self selectKNVUNDBSButton:_currentAssociatedButtons.firstObject];
    }
}

- (void)setIsSingleSelection:(BOOL)isSingleSelection
{
    _isSingleSelection = isSingleSelection;
    BOOL hasSelectedButton = NO;
    for (UIButton *selectedButton in [self currentSelectedButtons]) {
        if (hasSelectedButton) {
            [self deSelectKNVUNDBSButton:selectedButton];
        }
        hasSelectedButton = YES;
    }
}

#pragma mark - Set Up Method
- (void)setupWithHelperButtonsArray:(NSArray<UIButton *> *_Nonnull)buttons withSelectedButtons:(NSArray<UIButton *> *_Nullable)selectedButtons
{
    _currentAssociatedButtons = buttons;
    for (UIButton *selectionButton in buttons) {
        [selectionButton addTarget:self
                            action:@selector(didTapBSButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSArray *preSelectingArray = selectedButtons ?: (self.isForceSelection) ? @[buttons.firstObject] : @[];
    for (UIButton *selectingButton in preSelectingArray) {
        if (self.isSingleSelection && [[self currentSelectedButtons] count] > 0) {
            break;
        }
        [self selectKNVUNDBSButton:selectingButton];
    }
}

#pragma mark Event Handlers
- (void)didTapBSButton:(UIButton *)tapedButton
{
    if (tapedButton.isSelected) {
        [self deSelectKNVUNDBSButton:tapedButton];
    } else {
        [self selectKNVUNDBSButton:tapedButton];
    }
}

#pragma mark - Support Methods
- (void)selectKNVUNDBSButton:(UIButton *)button
{
    button.selected = YES;
    if (button.selectedFunctionBlock) {
        button.selectedFunctionBlock(button);
    }
    
    if (self.isSingleSelection) {
        for (UIButton *selectedButton in [self currentSelectedButtons]) {
            if (selectedButton != button) {
                [self deSelectKNVUNDBSButton:selectedButton];
            }
        }
    }
}

- (void)deSelectKNVUNDBSButton:(UIButton *)button
{
    if (self.isForceSelection && [[self currentSelectedButtons] count] == 1) {
        // If it is force selection, we won't process it.
        return;
    }
    button.selected = NO;
    
    if (button.deSelectedFunctionBlock) {
        button.deSelectedFunctionBlock(button);
    }
}

- (NSArray *)currentSelectedButtons
{
    return [_currentAssociatedButtons linq_where:^BOOL(UIButton *item) {
        return item.isSelected;
    }];
}

@end
