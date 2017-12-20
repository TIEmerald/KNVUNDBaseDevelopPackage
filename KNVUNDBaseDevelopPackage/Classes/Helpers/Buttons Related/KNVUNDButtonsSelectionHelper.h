//
//  KNVUNDButtonsSelectionHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 20/12/17.
//

#import "KNVUNDBaseModel.h"

typedef void(^KNVUNDBSButtonFunctionBlock)(UIButton *_Nonnull relatedButton);

@interface KNVUNDButtonsSelectionButton : UIButton

@property (nonatomic, nonnull) KNVUNDBSButtonFunctionBlock selectedFunctionBlock;
@property (nonatomic, nonnull) KNVUNDBSButtonFunctionBlock deSelectedFunctionBlock;

#pragma mark - Initial
- (void)setUpWithSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nonnull)selectedFunction andDeSelectedFunction:(KNVUNDBSButtonFunctionBlock _Nullable)deselectedFunction;

@end

@interface KNVUNDButtonsSelectionHelper : KNVUNDBaseModel

// If you want to perform single selection login, please set this value to YES
@property (nonatomic) BOOL isSingleSelection;
@property (nonatomic) BOOL isForceSelection;

#pragma mark - Set Up Method
- (void)setupWithHelperButtonsArray:(NSArray<KNVUNDButtonsSelectionButton *> *_Nonnull)buttons;

@end
