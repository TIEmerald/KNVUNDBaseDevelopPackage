//
//  KNVUNDButtonsSelectionHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 20/12/17.
//

#import "KNVUNDButtonsSelectionHelper.h"

#import <LinqToObjectiveC/LinqToObjectiveC.h>

@implementation KNVUNDButtonsSelectionButton

#pragma mark - Initial
- (void)setUpWithSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nonnull)selectedFunction andDeSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nullable)deselectedFunction;
{
    self.selectedFunctionBlock = selectedFunction;
    self.deSelectedFunctionBlock = deselectedFunction;
}

@end

@interface KNVUNDButtonsSelectionHelper(){
    NSArray<KNVUNDButtonsSelectionButton *> *_currentAssociatedButtons;
}

@end

@implementation KNVUNDButtonsSelectionHelper

#pragma mark - Set Up Method
- (void)setupWithHelperButtonsArray:(NSArray<KNVUNDButtonsSelectionButton *> *_Nonnull)buttons
{
    _currentAssociatedButtons = buttons;
    for (KNVUNDButtonsSelectionButton *selectionButton in buttons) {
        [selectionButton addTarget:self
                            action:@selector(didTapBSButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark Event Handlers
- (void)didTapBSButton:(KNVUNDButtonsSelectionButton *)tapedButton
{
    if (tapedButton.isSelected) {
        [self deSelectKNVUNDBSButton:tapedButton];
    } else {
        [self selectKNVUNDBSButton:tapedButton];
    }
}

#pragma mark - Support Methods
- (void)selectKNVUNDBSButton:(KNVUNDButtonsSelectionButton *)button
{
    button.selected = YES;
    if (button.selectedFunctionBlock) {
        button.selectedFunctionBlock(button);
    }
    
    if (self.isSingleSelection) {
        for (KNVUNDButtonsSelectionButton *selectedButton in [self currentSelectedButtons]) {
            if (selectedButton != button) {
                [self deSelectKNVUNDBSButton:selectedButton];
            }
        }
    }
}

- (void)deSelectKNVUNDBSButton:(KNVUNDButtonsSelectionButton *)button
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
