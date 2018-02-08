//
//  UIButton+KNVUNDButtonsSelectionButton.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import <UIKit/UIKit.h>

typedef void(^KNVUNDBSButtonFunctionBlock)(UIButton *_Nonnull relatedButton);

@interface UIButton (KNVUNDButtonsSelectionButton)

@property (nonatomic, nullable) id associatedModel;
@property (nonatomic, nonnull) KNVUNDBSButtonFunctionBlock selectedFunctionBlock;
@property (nonatomic, nonnull) KNVUNDBSButtonFunctionBlock deSelectedFunctionBlock;

#pragma mark - Initial
- (void)setUpWithSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nonnull)selectedFunction andDeSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nullable)deselectedFunction;

@end
