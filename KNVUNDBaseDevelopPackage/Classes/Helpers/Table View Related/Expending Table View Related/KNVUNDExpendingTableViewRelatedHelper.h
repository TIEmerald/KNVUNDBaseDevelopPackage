//
//  KNVUNDExpendingTableViewRelatedHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDExpendingTableViewRelatedHelper : KNVUNDBaseModel

@property (nonatomic) BOOL isSingleSelection;

#pragma mark - Set Up
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses andRelatedTableView:(UITableView *)relatedTableView;

#pragma mark - General Methods
- (void)updateTableWithRootModelArray:(NSArray *)rootModelArray;

@end
