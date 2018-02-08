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
static void * UIButton_AssociatedModel = &UIButton_AssociatedModel;
static void * UIButton_SelectedFunctionBlockKey = &UIButton_SelectedFunctionBlockKey;
static void * UIButton_DeSelectedFunctionBlockKey = &UIButton_DeSelectedFunctionBlockKey;

#pragma mark - Getters
- (id)associatedModel
{
    return objc_getAssociatedObject(self, UIButton_AssociatedModel);
}

- (KNVUNDBSButtonFunctionBlock)selectedFunctionBlock
{
    KNVUNDBSButtonFunctionBlock returningBlock = objc_getAssociatedObject(self, UIButton_SelectedFunctionBlockKey);
    return returningBlock ?: ^(UIButton * _Nonnull relatedButton) {};
}

- (KNVUNDBSButtonFunctionBlock)deSelectedFunctionBlock
{
    KNVUNDBSButtonFunctionBlock returningBlock = objc_getAssociatedObject(self, UIButton_DeSelectedFunctionBlockKey);
    return returningBlock ?: ^(UIButton * _Nonnull relatedButton) {};
}

#pragma mark - Setters
- (void)setAssociatedModel:(id)associatedModel
{
    objc_setAssociatedObject(self, UIButton_AssociatedModel, associatedModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSelectedFunctionBlock:(KNVUNDBSButtonFunctionBlock)selectedFunctionBlock
{
    objc_setAssociatedObject(self, UIButton_SelectedFunctionBlockKey, selectedFunctionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDeSelectedFunctionBlock:(KNVUNDBSButtonFunctionBlock)deSelectedFunctionBlock
{
    objc_setAssociatedObject(self, UIButton_DeSelectedFunctionBlockKey, deSelectedFunctionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Initial
- (void)setUpWithSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nonnull)selectedFunction andDeSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nullable)deselectedFunction;
{
    self.selectedFunctionBlock = selectedFunction;
    self.deSelectedFunctionBlock = deselectedFunction;
}

@end
