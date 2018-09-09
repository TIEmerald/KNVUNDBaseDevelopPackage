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

#pragma mark - KNVUNDBaseModel
- (BOOL)shouldShowRelatedLog
{
    return NO;
}

#pragma mark - Getters & Setters
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
            [self deSelectKNVUNDBSButton:selectedButton
                 followingSelectionCount:0];
        }
        hasSelectedButton = YES;
    }
}

#pragma mark - Set Up Method
- (void)setupWithHelperButtonsArray:(NSArray<UIButton *> *_Nonnull)buttons withSelectedButtons:(NSArray<UIButton *> *_Nullable)selectedButtons
{
    _currentAssociatedButtons = buttons;
    for (UIButton *selectionButton in buttons) {
        [self setUpAssociatedButton:selectionButton];
    }
    
    NSMutableArray *preSelectingArray = [NSMutableArray new];
    for (UIButton *button in _currentAssociatedButtons) {
        if (button.isSelected) {
            [preSelectingArray addObject:button];
            button.selected = NO;
        }
    }
    
    for (UIButton *button in selectedButtons) {
        if (![preSelectingArray containsObject:button]) {
            [preSelectingArray addObject:button];
        }
    }
    
    if (self.isForceSelection && [preSelectingArray count] == 0) {
        [preSelectingArray addObject:_currentAssociatedButtons.firstObject];
    }
    
    for (UIButton *selectingButton in preSelectingArray) {
        if (self.isSingleSelection && [[self currentSelectedButtons] count] > 0) {
            break;
        }
        [self selectKNVUNDBSButton:selectingButton];
    }
}

- (void)appendOneMoreButton:(UIButton *_Nonnull)appendingButton
{
    if (appendingButton != nil) {
        if ([_currentAssociatedButtons count] == 0) {
            [self setupWithHelperButtonsArray:@[appendingButton] withSelectedButtons:nil];
        } else {
            NSMutableArray *tempArray = [NSMutableArray<UIButton *> arrayWithArray:_currentAssociatedButtons];
            [tempArray addObject:appendingButton];
            [self setUpAssociatedButton:appendingButton];
            _currentAssociatedButtons = [NSArray<UIButton *> arrayWithArray:tempArray];
        }
    }
}

#pragma mark Support Methods
- (void)setUpAssociatedButton:(UIButton *)buttonToSetUp
{
    [buttonToSetUp addTarget:self
                      action:@selector(didTapBSButton:)
            forControlEvents:UIControlEventTouchUpInside];
    buttonToSetUp.relatedSelectionHelper = self;
}

#pragma mark - InterAction Methods
- (void)tapAButton:(UIButton *_Nonnull)tappingButton
{
    if ([_currentAssociatedButtons containsObject:tappingButton]) {
        [self didTapBSButton:tappingButton];
    }
}

- (void)setAButtonStatusToSelected:(UIButton *_Nonnull)tappingButton
{
    if ([_currentAssociatedButtons containsObject:tappingButton] && !tappingButton.isSelected) {
        [self didTapBSButton:tappingButton];
    }
}

- (void)setAButtonStatusToUnSelected:(UIButton *_Nonnull)tappingButton
{
    if ([_currentAssociatedButtons containsObject:tappingButton] && tappingButton.isSelected) {
        [self didTapBSButton:tappingButton];
    }
}

- (void)clearSelections
{
    if (self.isForceSelection) {
        return;
    }
    
    for (UIButton *selectedButton in [self currentSelectedButtons]) {
        [self didTapBSButton:selectedButton];
    }
}

#pragma mark - Reset Methods
- (void)resetCurrentHelper
{
    for (UIButton *selectionButton in _currentAssociatedButtons) {
        [selectionButton removeTarget:self
                               action:@selector(didTapBSButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    _currentAssociatedButtons = nil;
}

#pragma mark - Support Methods
- (void)didTapBSButton:(UIButton *)tapedButton
{
    [self performConsoleLogWithLogStringFormat:@"Performing Tap with Button: %@", tapedButton];
    [self performConsoleLogWithLogString:@"Before Tap Status: "];
    [self logAllButtonsStatus];
    if (tapedButton.isSelected) {
        [self deSelectKNVUNDBSButton:tapedButton
             followingSelectionCount:0];
    } else {
        [self selectKNVUNDBSButton:tapedButton];
    }
    [self performConsoleLogWithLogString:@"After Tap Status: "];
    [self logAllButtonsStatus];
}

- (void)selectKNVUNDBSButton:(UIButton *)button
{
    NSInteger buttonIndex = [_currentAssociatedButtons indexOfObject:button];
    [self performConsoleLogWithLogStringFormat:@"Will Select Button with Index: %@",@(buttonIndex)];
    if (self.isSingleSelection) {
        for (UIButton *selectedButton in [self currentSelectedButtons]) {
            if (selectedButton != button) {
                [self deSelectKNVUNDBSButton:selectedButton
                     followingSelectionCount:1];
            }
        }
    }
    
    button.selected = YES;
    if (button.selectedFunctionBlock) {
        button.selectedFunctionBlock(button);
    }
    
    [self performConsoleLogWithLogStringFormat:@"Did Select Button with Index: %@",@(buttonIndex)];
}

- (void)deSelectKNVUNDBSButton:(UIButton *)button followingSelectionCount:(NSInteger)followingSelectionCount
{
    NSInteger buttonIndex = [_currentAssociatedButtons indexOfObject:button];
    [self performConsoleLogWithLogStringFormat:@"Will De-Select Button with Index: %@",@(buttonIndex)];
    if (self.isForceSelection && [[self currentSelectedButtons] count] == (1 - followingSelectionCount)) {
        // If it is force selection, we won't process it.
        return;
    }
    button.selected = NO;
    
    if (button.deSelectedFunctionBlock) {
        button.deSelectedFunctionBlock(button);
    }
    [self performConsoleLogWithLogStringFormat:@"Did De-Select Button with Index: %@",@(buttonIndex)];
}

- (NSArray *)currentSelectedButtons
{
    return [_currentAssociatedButtons linq_where:^BOOL(UIButton *item) {
        return item.isSelected;
    }];
}

#pragma mark Log Related
- (void)logAllButtonsStatus
{
    for (UIButton *aButton in _currentAssociatedButtons) {
        [self performConsoleLogWithLogStringFormat:@"Button: %@\nSelection Status: %@",
         aButton,
         @(aButton.isSelected)];
    }
}

@end
