//
//  KNVUNDExpendingTableViewRelatedHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDExpendingTableViewRelatedHelper.h"

/// Models
#import "KNVUNDExpendingTableViewRelatedModel.h"

@interface KNVUNDExpendingTableViewRelatedHelper() <KNVUNDETVRelatedModelDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation KNVUNDExpendingTableViewRelatedHelper

#pragma mark - Delegates
#pragma mark - KNVUNDETVRelatedModelDelegate
#pragma mark Table View Updating Related
- (void)reloadCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths
{
    
}

- (void)insertCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths
{
    
}

- (void)deleteCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.displayingModels count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    KNVExpandableBaseTableViewCell *returningCell = [self getRATreeBaseTableViewCellFromTableView:tableView
////                                                                                    withIndexPath:indexPath];
////
////    KNVETVDataModel *relatedItem = [self getModelWithIndexPath:indexPath];
////
////    [returningCell setupCellBasedOnModelDictionary:@{KNVBaseTableViewCell_BaseModel_Key : relatedItem}];
////    returningCell.tableViewDelegate = self;
////
////    [self setUpTableViewCellBeforeGenerated:returningCell];
////
////    return returningCell;
//}

#pragma mark - UITableViewDelegate

@end
