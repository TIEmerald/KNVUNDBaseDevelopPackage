//
//  KNVUNDButtonsSelectionHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 20/12/17.
//

#import "KNVUNDBaseModel.h"

// Categories
#import "UIButton+KNVUNDButtonsSelectionButton.h"

@interface KNVUNDButtonsSelectionHelper : KNVUNDBaseModel

// If you want to perform single selection login, please set this value to YES
@property (nonatomic) BOOL isSingleSelection;
@property (nonatomic) BOOL isForceSelection; // If you have set isForceSelection and didn't set the pre-selectedButton in setupMethod... We will by default select the first one.

#pragma mark - Set Up Method
- (void)setupWithHelperButtonsArray:(NSArray<UIButton *> *_Nonnull)buttons withSelectedButtons:(NSArray<UIButton *> *_Nullable)selectedButtons;
- (void)appendOneMoreButton:(UIButton *_Nonnull)appendingButton;
- (void)appendOneMoreButton:(UIButton *_Nonnull)appendingButton shouldCheckForceSelection:(BOOL)shouldCheckForceSelection;

#pragma mark - InterAction Methods
- (void)tapAButton:(UIButton *_Nonnull)tappingButton;
- (void)setAButtonStatusToSelected:(UIButton *_Nonnull)tappingButton;
- (void)setAButtonStatusToUnSelected:(UIButton *_Nonnull)tappingButton;
- (void)clearSelections; /// Only works if isForceSelection != NO;

#pragma mark - Reset Methods
- (void)resetCurrentHelper;

@end
