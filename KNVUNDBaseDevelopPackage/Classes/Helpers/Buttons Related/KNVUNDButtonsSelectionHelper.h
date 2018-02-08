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

@end
