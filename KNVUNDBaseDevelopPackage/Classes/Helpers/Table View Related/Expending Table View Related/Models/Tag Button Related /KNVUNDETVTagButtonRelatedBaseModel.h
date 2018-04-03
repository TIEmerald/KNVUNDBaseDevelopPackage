//
//  KNVUNDETVTagButtonRelatedBaseModel.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 28/3/18.
//

#import "KNVUNDExpendingTableViewRelatedModel.h"

// Helpers
#import "KNVUNDButtonsSelectionHelper.h"

@class KNVUNDETVTagButtonRelatedBaseModel;

@protocol KNVUNDETVRelatedTagButtonModelDelegate <NSObject>

- (void)tagButtonSelectedWithModel:(KNVUNDETVTagButtonRelatedBaseModel *)relatedModel;
- (void)tagButtonDeSelectedWithModel:(KNVUNDETVTagButtonRelatedBaseModel *)relatedModel;

@end

@interface KNVUNDETVTagButtonRelatedBaseModel : KNVUNDExpendingTableViewRelatedModel

@property (nonatomic, weak) id<KNVUNDETVRelatedTagButtonModelDelegate> tagButtonDelegate;
@property (nonatomic, weak) KNVUNDButtonsSelectionHelper *relatedButtonSelectionHelper;

//// Tag Button Releated
@property (readonly) UIButton *associatedTagButton;

//// General Methods
- (void)markTagButtonAsSelected;

@end
