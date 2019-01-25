//
//  KNVUNDExpendingTableViewRelatedHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDExpendingTableViewRelatedHelper.h"

/// Third Parties
#import <LinqToObjectiveC/LinqToObjectiveC.h>

/// Models
#import "KNVUNDExpendingTableViewRelatedModel.h"

/// Views
#import "KNVUNDETVRelatedBasicTableViewCell.h"

@interface KNVUNDExpendingTableViewRelatedHelper() <KNVUNDETVRelatedModelDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *_storedSupportedModelClasses;
}

@end

@implementation KNVUNDExpendingTableViewRelatedHelper

@synthesize displayingModels, relatedViewController, associatedTableView;

#pragma mark - KNVUNDBasic
//- (BOOL)shouldShowRelatedLog
//{
//    return YES;
//}

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSArray *)getDisplayingModelsWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator
{
    return [self.displayingModels linq_where:predicator];
}

#pragma mark - Setters
- (void)setUpAssociatedTableView:(UITableView *)associatedTableView
{
    /// Step One remove current associated Table View
    self.associatedTableView.dataSource = nil;
    self.associatedTableView.delegate = nil;
    
    /// Step Two set new associatd table view
    self.associatedTableView = associatedTableView;
    self.associatedTableView.dataSource = self;
    self.associatedTableView.delegate = self;
    
    for (Class supportedModelClass in _storedSupportedModelClasses) {
        Class supportedCellClass = [supportedModelClass relatedTableViewCell];
        [supportedCellClass registerSelfIntoTableView:self.associatedTableView];
    }
    
    [self.associatedTableView reloadData];
}

- (void)setUpRelatedViewController:(UIViewController *)viewController
{
    self.relatedViewController = viewController;
}

- (void)setSupportedModelClasses:(NSArray *)supportedModelClasses
{
    _storedSupportedModelClasses = supportedModelClasses;
    
    for (Class supportedModelClass in _storedSupportedModelClasses) {
        Class supportedCellClass = [supportedModelClass relatedTableViewCell];
        [supportedCellClass registerSelfIntoTableView:self.associatedTableView];
    }
    
    /// Don't think Un-register is that matter....
}

#pragma mark - Set Up
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses andRelatedTableView:(UITableView *)relatedTableView
{
    [self setUpWithRootModelArray:rootModelArray
            supportedModelClasses:supportedModelClasses
            relatedViewController:nil
              andRelatedTableView:relatedTableView];
}

- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses relatedViewController:(UIViewController *)viewController andRelatedTableView:(UITableView *)relatedTableView
{
    [self setUpRelatedViewController:viewController];
    
    self.associatedTableView = relatedTableView;
    self.associatedTableView.dataSource = self;
    self.associatedTableView.delegate = self;
    
    _storedSupportedModelClasses = supportedModelClasses;
    
    for (Class supportedModelClass in _storedSupportedModelClasses) {
        Class supportedCellClass = [supportedModelClass relatedTableViewCell];
        [supportedCellClass registerSelfIntoTableView:self.associatedTableView];
    }
    
    [self updateTableWithRootModelArray:rootModelArray];
}

#pragma mark - General Methods
- (void)updateTableWithRootModelArray:(NSArray *)rootModelArray
{
    for (KNVUNDExpendingTableViewRelatedModel *displayingModel in self.displayingModels) {
        displayingModel.delegate = nil; /// re-set the delegate
    }
    
    self.displayingModels = [NSMutableArray new];
    
    for (id model in rootModelArray) {
        if ([model isKindOfClass:[KNVUNDExpendingTableViewRelatedModel class]]) {
            KNVUNDExpendingTableViewRelatedModel *convertedModel = (KNVUNDExpendingTableViewRelatedModel *)model;
            [self addOneRootModelIntoDisplayingModels:model isInTheTop:NO];
        }
    }
    
    [self.associatedTableView reloadData]; /// Update UI
}

- (void)insertOneMoreRootModel:(KNVUNDExpendingTableViewRelatedModel *)insertingModel isInTheTop:(BOOL)isInTheTop shouldMarkAsSelected:(BOOL)shouldMarkAsSelected
{
    if (self.displayingModels == nil) {
        self.displayingModels = [NSMutableArray new];
    }
    
    [self addOneRootModelIntoDisplayingModels:insertingModel isInTheTop:isInTheTop];
    
    NSArray *insertingIndexPaths = [insertingModel getCurrentDisplayedIndexPathIncludingDecedants];
    
    [self insertCellsAtIndexPaths:insertingIndexPaths]; /// Update UI
    
    if (shouldMarkAsSelected && !insertingModel.isSelected) { /// Update Selection Status
        [insertingModel toggleSelectionStatus];
    }
    
    /// Scoll to the bottom of the inserted Cell info needed
    if (isInTheTop) {
        NSIndexPath *firstIndexPath = insertingIndexPaths.firstObject;
        for (NSIndexPath *indexPath in insertingIndexPaths) {
            if (indexPath.section < firstIndexPath.section || (indexPath.section == firstIndexPath.section && indexPath.row < firstIndexPath.row)) {
                firstIndexPath = indexPath;
            }
        }
        
        if (firstIndexPath) {
            [self rollToCellAtIndexPath:firstIndexPath
                       atScrollPoisiton:UITableViewScrollPositionTop];
        }
    } else {
        NSIndexPath *latestIndexPath = insertingIndexPaths.firstObject;
        for (NSIndexPath *indexPath in insertingIndexPaths) {
            if (indexPath.section > latestIndexPath.section || (indexPath.section == latestIndexPath.section && indexPath.row > latestIndexPath.row)) {
                latestIndexPath = indexPath;
            }
        }
        
        if (latestIndexPath) {
            [self rollToCellAtIndexPath:latestIndexPath
                       atScrollPoisiton:UITableViewScrollPositionBottom];
        }
    }
}

- (void)deleteOneDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *)deletingModel
{
    if ([self.displayingModels containsObject:deletingModel]) {
        NSMutableArray *deletingArray = [NSMutableArray arrayWithObject:deletingModel];
        [deletingArray addObjectsFromArray:[deletingModel getDisplayingDescendants]];
        NSArray *deletingIndexPathArray = [deletingModel getCurrentDisplayedIndexPathIncludingDecedants];
        [self.displayingModels removeObjectsInArray:deletingArray];
        [self deleteCellsAtIndexPaths:deletingIndexPathArray];
    }
}

#pragma mark Support Methods
- (void)addOneRootModelIntoDisplayingModels:(KNVUNDExpendingTableViewRelatedModel *)insertingModel isInTheTop:(BOOL)isInTheTop
{
    if (isInTheTop) {
        [self.displayingModels insertObject:insertingModel atIndex:0];
        NSInteger insertingIndex = 1;
        insertingModel.delegate = self;
        for (KNVUNDExpendingTableViewRelatedModel *descedant in [insertingModel getDisplayingDescendants]) {
            [self.displayingModels insertObject:descedant
                                        atIndex:insertingIndex];
            insertingIndex += 1;
        }
    } else {
        [self.displayingModels addObject:insertingModel];
        insertingModel.delegate = self;
        if (insertingModel.isExpended) {
            [self.displayingModels addObjectsFromArray:[insertingModel getDisplayingDescendants]];
        }
    }
}

#pragma mark - Delegates
#pragma mark - KNVUNDETVRelatedModelDelegate
#pragma mark Setting Related
- (BOOL)isSettingSingleSelection
{
    return self.isSingleSelection;
}

#pragma mark Table View Updating Related
- (void)rollToCellAtIndexPath:(NSIndexPath *)indexPath atScrollPoisiton:(UITableViewScrollPosition)position
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Scroll Cell to Index: %@",
     indexPath];
    [self.associatedTableView scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:position
                                            animated:!self.isDisableTableViewAnimation];
}

- (void)reloadCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths shouldReloadCell:(BOOL)shouldReloadCell
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Reloading Cell At Indexs: %@",
     indexPaths];
    if (shouldReloadCell) {
        [self.associatedTableView reloadRowsAtIndexPaths:indexPaths
                                        withRowAnimation:UITableViewRowAnimationNone];
    } else {
        for (NSIndexPath *indexPath in indexPaths) {
            UITableViewCell *relatedTableViewCell = [self.associatedTableView cellForRowAtIndexPath:indexPath];
            [relatedTableViewCell updateCellUI];
        }
    }
}

- (void)insertCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Inserting Cell At Indexs: %@",
     indexPaths];
    [self.associatedTableView insertRowsAtIndexPaths:indexPaths
                                    withRowAnimation:self.isDisableTableViewAnimation ? UITableViewRowAnimationBottom : UITableViewRowAnimationNone];
}

- (void)deleteCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Deleting Cell At Indexs: %@",
     indexPaths];
    [self.associatedTableView deleteRowsAtIndexPaths:indexPaths
                                    withRowAnimation:self.isDisableTableViewAnimation ? UITableViewRowAnimationTop : UITableViewRowAnimationNone];
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
    [self tableView:tableView didTappedCellAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didTappedCellAtIndexPath:indexPath];
}

#pragma mark Support Methods
- (void)tableView:(UITableView *)tableView didTappedCellAtIndexPath:(NSIndexPath *)indexPath
{
    /// We are handle Selection and De-Selection Action by ourselves... that's why we don't care if the click is select or diselect
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Did select Cell At Index: %@",
     indexPath];
    KNVUNDETVRelatedBasicTableViewCell *usingCell = [tableView cellForRowAtIndexPath:indexPath];
    [usingCell.relatedModel toggleSelectionStatus];
}

@end
