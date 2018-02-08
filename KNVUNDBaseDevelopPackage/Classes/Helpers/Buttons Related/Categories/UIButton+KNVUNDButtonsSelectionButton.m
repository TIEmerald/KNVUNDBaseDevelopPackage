//
//  UIButton+KNVUNDButtonsSelectionButton.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "UIButton+KNVUNDButtonsSelectionButton.h"
#import <objc/runtime.h>

@implementation UIButton (KNVUNDButtonsSelectionButton)

#pragma mark - Getters & Setters
static void * SelectedFunctionBlockKey = &SelectedFunctionBlockKey;
static void * DeSelectedFunctionBlockKey = &DeSelectedFunctionBlockKey;

#pragma mark - Getters
- (KNVUNDBSButtonFunctionBlock)selectedFunctionBlock
{
    KNVUNDBSButtonFunctionBlock returningBlock = objc_getAssociatedObject(self, SelectedFunctionBlockKey);
    return returningBlock ?: ^(UIButton * _Nonnull relatedButton) {};
}

- (KNVUNDBSButtonFunctionBlock)deSelectedFunctionBlock
{
    KNVUNDBSButtonFunctionBlock returningBlock = objc_getAssociatedObject(self, DeSelectedFunctionBlockKey);
    return returningBlock ?: ^(UIButton * _Nonnull relatedButton) {};
}

#pragma mark - Setters
- (void)setSelectedFunctionBlock:(KNVUNDBSButtonFunctionBlock)selectedFunctionBlock
{
    objc_setAssociatedObject(self, SelectedFunctionBlockKey, selectedFunctionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDeSelectedFunctionBlock:(KNVUNDBSButtonFunctionBlock)deSelectedFunctionBlock
{
    objc_setAssociatedObject(self, DeSelectedFunctionBlockKey, deSelectedFunctionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Initial
- (void)setUpWithSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nonnull)selectedFunction andDeSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nullable)deselectedFunction;
{
    self.selectedFunctionBlock = selectedFunction;
    self.deSelectedFunctionBlock = deselectedFunction;
}

@end
