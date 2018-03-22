//
//  KNVUNDExpendingTableViewRelatedHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDExpendingTableViewRelatedHelper : KNVUNDBaseModel

#pragma mark - Set Up
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses andRelatedTableView:(UITableView *)relatedTableView;

@end
