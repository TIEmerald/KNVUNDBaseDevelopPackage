//
//  KNVUNDETVTagButtonReleatedBaseTableViewCell.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 28/3/18.
//

#import "KNVUNDETVTagButtonReleatedBaseTableViewCell.h"

// Models
#import "KNVUNDETVTagButtonRelatedBaseModel.h"

@implementation KNVUNDETVTagButtonReleatedBaseTableViewCell

#pragma mark Methods for Override
- (void)setupSelectedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    [super setupSelectedStatusUIWithFirstTimeCheck:isFirstTime];
    if (self.relatedModel.isSelected) {
        [(KNVUNDETVTagButtonRelatedBaseModel *)self.relatedModel markTagButtonAsSelected];
    }
}

- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel
{
    if ([associatdModel isKindOfClass:[KNVUNDETVTagButtonRelatedBaseModel class]]) {
        [super setupCellWitKNVUNDWithModel:associatdModel];
    }
}

@end
