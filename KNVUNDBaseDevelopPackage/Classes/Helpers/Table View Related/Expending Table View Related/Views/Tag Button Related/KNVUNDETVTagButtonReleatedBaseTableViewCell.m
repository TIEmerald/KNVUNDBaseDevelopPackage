//
//  KNVUNDETVTagButtonReleatedBaseTableViewCell.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 28/3/18.
//

#import "KNVUNDETVTagButtonReleatedBaseTableViewCell.h"

// Models
#import "KNVUNDETVTagButtonRelatedBaseModel.h"

// Tools
#import "KNVUNDThreadRelatedTool.h"

@interface KNVUNDETVTagButtonReleatedBaseTableViewCell() <KNVUNDETVTagButtonRelatedBaseModelCellDelegate>

@property (readonly) KNVUNDETVTagButtonRelatedBaseModel *etvtbBaseModel;

@end

@implementation KNVUNDETVTagButtonReleatedBaseTableViewCell

#pragma mark - Getters && Setters
#pragma mark - Getters
- (KNVUNDETVTagButtonRelatedBaseModel *)etvtbBaseModel
{
    return (KNVUNDETVTagButtonRelatedBaseModel *)self.relatedModel;
}

#pragma mark - Methods for Override
- (void)setupSelectedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    if (isFirstTime) {
        [self setUpTagSelectionStatusRelatedUIWithStatus:self.etvtbBaseModel.associatedTagButton.isSelected];
    }
}

- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel
{
    if ([associatdModel isKindOfClass:[KNVUNDETVTagButtonRelatedBaseModel class]]) {
        [super setupCellWitKNVUNDWithModel:associatdModel];
    }
}

- (void)setUpTagSelectionStatusRelatedUIWithStatus:(BOOL)tagViewSelectionStatus
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        self.backgroundColor = tagViewSelectionStatus ? [UIColor yellowColor] : [UIColor whiteColor];
    }];
}

#pragma mark - Delegates
#pragma mark - KNVUNDETVTagButtonRelatedBaseModelCellDelegate
- (void)setUpTagSelectionStatusRelatedUI
{
    [self setUpTagSelectionStatusRelatedUIWithStatus:self.etvtbBaseModel.associatedTagButton.isSelected];
}

@end
