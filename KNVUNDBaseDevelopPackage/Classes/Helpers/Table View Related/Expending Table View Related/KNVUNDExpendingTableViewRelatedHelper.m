//
//  KNVUNDExpendingTableViewRelatedHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDExpendingTableViewRelatedHelper.h"

/// Models
#import "KNVUNDExpendingTableViewRelatedModel.h"

/// Views
#import "KNVUNDETVRelatedBasicTableViewCell.h"

@interface KNVUNDExpendingTableViewRelatedHelper() <KNVUNDETVRelatedModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *associatedTableView;

@end

@implementation KNVUNDExpendingTableViewRelatedHelper

@synthesize displayingModels;

#pragma mark - KNVUNDBasic
- (BOOL)shouldShowRelatedLog
{
    return NO;
}

#pragma mark - Set Up
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses andRelatedTableView:(UITableView *)relatedTableView
{
    _associatedTableView = relatedTableView;
    _associatedTableView.dataSource = self;
    _associatedTableView.delegate = self;
    
    for (Class supportedModelClass in supportedModelClasses) {
        Class supportedCellClass = [supportedModelClass relatedTableViewCell];
        [supportedCellClass registerSelfIntoTableView:_associatedTableView];
    }
    
    NSMutableArray *usingDisplayingArray = [NSMutableArray new];
    for (id model in rootModelArray) {
        if ([model isKindOfClass:[KNVUNDExpendingTableViewRelatedModel class]]) {
            KNVUNDExpendingTableViewRelatedModel *convertedModel = (KNVUNDExpendingTableViewRelatedModel *)model;
            [usingDisplayingArray addObject:convertedModel];
            convertedModel.delegate = self;
            if (convertedModel.isExpended) {
                [usingDisplayingArray addObjectsFromArray:[convertedModel getDisplayingDescendants]];
            }
        }
    }
    self.displayingModels = usingDisplayingArray;
    
    [_associatedTableView reloadData];
}

#pragma mark - Delegates
#pragma mark - KNVUNDETVRelatedModelDelegate
#pragma mark Setting Related
- (BOOL)isSettingSingleSelection
{
    return self.isSingleSelection;
}

#pragma mark Table View Updating Related
- (void)reloadCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths shouldReloadCell:(BOOL)shouldReloadCell
{
    [self performConsoleLogWithLogStringFormat:@"Reloading Cell At Indexs: %@",
     indexPaths];
    if (shouldReloadCell) {
        [_associatedTableView reloadRowsAtIndexPaths:indexPaths
                                    withRowAnimation:UITableViewRowAnimationNone];
    } else {
        for (NSIndexPath *indexPath in indexPaths) {
            UITableViewCell *relatedTableViewCell = [_associatedTableView cellForRowAtIndexPath:indexPath];
            [relatedTableViewCell updateCellUI];
        }
    }
}

- (void)insertCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths
{
    [self performConsoleLogWithLogStringFormat:@"Inserting Cell At Indexs: %@",
     indexPaths];
    [_associatedTableView insertRowsAtIndexPaths:indexPaths
                                withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)deleteCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths
{
    [self performConsoleLogWithLogStringFormat:@"Deleting Cell At Indexs: %@",
     indexPaths];
    [_associatedTableView deleteRowsAtIndexPaths:indexPaths
                                withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.displayingModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KNVUNDETVRelatedBasicTableViewCell *usingCell = nil;
    KNVUNDExpendingTableViewRelatedModel *usingModel = [self.displayingModels objectAtIndex:indexPath.row];
    Class usingCellClass = [[usingModel class] relatedTableViewCell];
    usingCell = [tableView dequeueReusableCellWithIdentifier:[usingCellClass cellIdentifierName]
                                                forIndexPath:indexPath];
    
    if (usingCell == nil) {
        usingCell = [usingCellClass new];
    }
    
    [usingCell setupCellWitKNVUNDWithModel:usingModel];

    return usingCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KNVUNDExpendingTableViewRelatedModel *usingModel = [self.displayingModels objectAtIndex:indexPath.row];
    Class usingCellClass = [[usingModel class] relatedTableViewCell];
    return [usingCellClass cellHeight];
}

///// If you want to handle the Selection by your self, you might mark the Cell selection style as None and handle the selection logic by yourself in your Table View Cell.
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KNVUNDETVRelatedBasicTableViewCell *usingCell = [tableView cellForRowAtIndexPath:indexPath];
    [usingCell.relatedModel toggleSelectionStatus];
}

@end
