//
//  KNVUNDETVRelatedBasicTableViewCell.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

// Categories
#import "UITableViewCell+KNVUNDBasic.h"

// Models
#import "KNVUNDExpendingTableViewRelatedModel.h"

@interface KNVUNDETVRelatedBasicTableViewCell : UITableViewCell

@property (readonly) KNVUNDExpendingTableViewRelatedModel *relatedModel;

#pragma mark - Set up
- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel;

@end
