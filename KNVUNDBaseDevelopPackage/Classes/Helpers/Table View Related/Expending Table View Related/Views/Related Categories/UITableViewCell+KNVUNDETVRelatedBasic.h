//
//  UITableViewCell+KNVUNDETVRelatedBasic.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 7/8/18.
//

// Categories
#import "UITableViewCell+KNVUNDBasic.h"

// Models
#import "KNVUNDExpendingTableViewRelatedModel.h"

@interface UITableViewCell (KNVUNDETVRelatedBasic) <KNVUNDExpendingTableViewRelatedModelCellDelegate>

@property (readonly) KNVUNDExpendingTableViewRelatedModel *relatedModel;

#pragma mark - Methods for Override
/// Theme Related
- (NSString *)selectedBackendColour;
- (NSString *)unSelectedBackendColour;

/// Actions
- (void)setupExpendedStatusUI;
- (void)setupExpendedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime;
- (void)setupGeneralUIBasedOnModel;
- (void)setupGeneralUIBasedOnModelWithFirstTimeCheck:(BOOL)isFirstTime;
- (void)setupSelectedStatusUI;
- (void)setupSelectedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime;

#pragma mark - Set up
- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel;

@end
