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

/// Tools
#import "KNVUNDThreadRelatedTool.h"

@interface KNVUNDExpendingTableViewRelatedHelper() <KNVUNDETVRelatedModelDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *_storedSupportedModelClasses;
    
    NSArray *_storedDisplayArray;
}

@end

@implementation KNVUNDExpendingTableViewRelatedHelper

@synthesize relatedViewController, associatedTableView;

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

- (KNVUNDExpendingTableViewRelatedModel *)getFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator
{
    return [self.displayingModels linq_firstOrNil:predicator];
}

- (NSUInteger)getIndexOfFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator
{
    return [self.displayingModels indexOfObjectPassingTest:^BOOL(KNVUNDExpendingTableViewRelatedModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (predicator(obj)) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
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
    
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        [self.associatedTableView reloadData]; /// Update UI
    }];
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
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        for (KNVUNDExpendingTableViewRelatedModel *displayingModel in self.displayingModels) {
            displayingModel.delegate = nil; /// re-set the delegate
        }
        
        NSMutableArray *changingDisplayingModel = [NSMutableArray new];
        for (id model in rootModelArray) {
            if ([model isKindOfClass:[KNVUNDExpendingTableViewRelatedModel class]]) {
                KNVUNDExpendingTableViewRelatedModel *convertingModel = (KNVUNDExpendingTableViewRelatedModel *)model;
                [changingDisplayingModel addObject:convertingModel];
                [changingDisplayingModel addObjectsFromArray:[convertingModel getDisplayingDescendants]];
            }
        }
        
        self.displayingModels = [NSArray arrayWithArray:changingDisplayingModel];
        
        for (KNVUNDExpendingTableViewRelatedModel *displayingModel in self.displayingModels) {
            displayingModel.delegate = self; /// re-set the delegate
        }
        
        [self.associatedTableView reloadData];
        
    }];
}

- (NSArray *)insertOneMoreRootModel:(KNVUNDExpendingTableViewRelatedModel *)insertingModel atIndex:(NSUInteger)index shouldMarkAsSelected:(BOOL)shouldMarkAsSelected
{
    /// We need to ensure Array updating should happened inside the same thread where the UI updated...
    NSMutableArray *insertingArray = [NSMutableArray new];
    [insertingArray addObject:insertingModel];
    [insertingArray addObjectsFromArray:[insertingModel getDisplayingDescendants]];
    [self inSertCellsWithDisplayingModelArray:insertingArray
                               withStartIndex:index];
    
    if (shouldMarkAsSelected && !insertingModel.isSelected) { /// Update Selection Status
        [insertingModel toggleSelectionStatus];
    }
    
    return [NSArray arrayWithArray:insertingArray];
}

- (void)insertOneMoreRootModel:(KNVUNDExpendingTableViewRelatedModel *)insertingModel isInTheTop:(BOOL)isInTheTop shouldMarkAsSelected:(BOOL)shouldMarkAsSelected
{
    NSArray *insertingArray = [self insertOneMoreRootModel:insertingModel
                                                   atIndex:isInTheTop ? 0 : [self.displayingModels count]
                                      shouldMarkAsSelected:shouldMarkAsSelected];
    
    /// Scoll to the bottom of the inserted Cell info needed
    if (isInTheTop) {
        [self rollToCellWithDisplayingModel:insertingArray.firstObject
                           atScrollPoisiton:UITableViewScrollPositionTop];
    } else {
        [self rollToCellWithDisplayingModel:insertingArray.lastObject
                           atScrollPoisiton:UITableViewScrollPositionBottom];
    }
}

- (void)deleteFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator
{
    KNVUNDExpendingTableViewRelatedModel *firstMatchingModel = [self getFirstDisplayingModelWithPredicator:predicator];
    if (firstMatchingModel) {
        [self deleteOneDisplayingModel:firstMatchingModel];
    }
}

- (void)deleteOneDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *)deletingModel
{
    NSMutableArray *deletingArray = [NSMutableArray arrayWithObject:deletingModel];
    [deletingArray addObjectsFromArray:[deletingModel getDisplayingDescendants]];
    [self deleteCellsWithDisplayingModelArray:deletingArray];
}

- (void)reloadFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator
{
    KNVUNDExpendingTableViewRelatedModel *firstMatchingModel = [self getFirstDisplayingModelWithPredicator:predicator];
    if (firstMatchingModel) {
        [firstMatchingModel reloadTheCellForSelf];
    }
}

#pragma mark - Delegates
#pragma mark - KNVUNDETVRelatedModelDelegate
- (NSArray<KNVUNDExpendingTableViewRelatedModel *> *)displayingModels
{
    if (_storedDisplayArray == nil) {  /// Lazy set up
        _storedDisplayArray = [NSArray new];
    }
    return _storedDisplayArray;
}

- (void)setDisplayingModels:(NSArray<KNVUNDExpendingTableViewRelatedModel *> *)displayingModels
{
    _storedDisplayArray = displayingModels;
}

#pragma mark Setting Related
- (BOOL)isSettingSingleSelection
{
    return self.isSingleSelection;
}

#pragma mark Table View Updating Related
- (void)deleteCellsWithDisplayingModelArray:(NSArray *_Nonnull)deletingDisplayingModels
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        NSMutableArray *deletingIndexPaths = [NSMutableArray new];
        NSMutableArray *changingDisplayingModel = [NSMutableArray arrayWithArray:self.displayingModels];
        for (KNVUNDExpendingTableViewRelatedModel *deletingModel in deletingDisplayingModels) {
            deletingModel.delegate = nil;
            NSUInteger modelIndex = [self.displayingModels indexOfObject:deletingModel];
            if (modelIndex != NSNotFound) {
                [deletingIndexPaths addObject:[NSIndexPath indexPathForRow:modelIndex
                                                                 inSection:0]];
                [changingDisplayingModel removeObject:deletingModel];
            }
        }
        self.displayingModels = [NSArray arrayWithArray:changingDisplayingModel];
        [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                         andLogStringFormat:@"Deleting Cell At Indexs: %@",
         deletingIndexPaths];
        [self.associatedTableView deleteRowsAtIndexPaths:deletingIndexPaths
                                        withRowAnimation:self.isDisableTableViewAnimation ? UITableViewRowAnimationTop : UITableViewRowAnimationNone];
    }];
}

- (void)inSertCellsWithDisplayingModelArray:(NSArray *_Nonnull)insertingDisplayingModels withStartIndex:(NSUInteger)startIndex
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        NSMutableArray *insertingIndexPaths = [NSMutableArray new];
        NSMutableArray *changingDisplayingModel = [NSMutableArray arrayWithArray:self.displayingModels];
        NSInteger insertingIndex = startIndex;
        if (insertingIndex > [self.displayingModels count]) {
            insertingIndex = [self.displayingModels count];
        } else if (insertingIndex < 0) {
            insertingIndex = 0;
        }
        for (KNVUNDExpendingTableViewRelatedModel *insertingModel in insertingDisplayingModels) {
            [insertingIndexPaths addObject:[NSIndexPath indexPathForRow:insertingIndex
                                                              inSection:0]];
            [changingDisplayingModel insertObject:insertingModel atIndex:insertingIndex];
            insertingModel.delegate = self;
            insertingIndex += 1;
        }
        
        self.displayingModels = [NSArray arrayWithArray:changingDisplayingModel];
        [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                         andLogStringFormat:@"Deleting Cell At Indexs: %@",
         insertingIndexPaths];
        [self.associatedTableView insertRowsAtIndexPaths:insertingIndexPaths
                                        withRowAnimation:self.isDisableTableViewAnimation ? UITableViewRowAnimationBottom : UITableViewRowAnimationNone];
    }];
}

- (void)reloadCellsWithDisplayingModelArray:(NSArray *_Nonnull)reloadingDisplayingModels shouldReloadCell:(BOOL)shouldReloadCell
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        NSMutableArray *reloadingIndexPaths = [NSMutableArray new];
        
        for (KNVUNDExpendingTableViewRelatedModel *reloadingModel in reloadingDisplayingModels) {
            NSUInteger modelIndex = [self.displayingModels indexOfObject:reloadingModel];
            if (modelIndex != NSNotFound) {
                [reloadingIndexPaths addObject:[NSIndexPath indexPathForRow:modelIndex
                                                                  inSection:0]];
            }
        }
        
        [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                         andLogStringFormat:@"Reloading Cell At Indexs: %@",
         reloadingIndexPaths];
        
        if (shouldReloadCell) {
            [self.associatedTableView reloadRowsAtIndexPaths:reloadingIndexPaths
                                            withRowAnimation:UITableViewRowAnimationNone];
        } else {
            for (NSIndexPath *indexPath in reloadingIndexPaths) {
                UITableViewCell *relatedTableViewCell = [self.associatedTableView cellForRowAtIndexPath:indexPath];
                [relatedTableViewCell updateCellUI];
            }
        }
    }];
}

- (void)reloadChildrenCellsWithDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *_Nonnull)relatedModel
                     withChildrenUpdatingBlock:(void(^_Nonnull)(KNVUNDExpendingTableViewRelatedModel *_Nonnull relatedModel))updatingBlock
                             shouldScrollToTop:(BOOL)shouldScrollToTop
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        NSUInteger relatedModelIndex = [self.displayingModels indexOfObject:relatedModel];
        NSArray *displayingChildrenBeforeChange = [relatedModel getDisplayingDescendants];
        updatingBlock(relatedModel);
        NSArray *displayingChildrenAfterChange = [relatedModel getDisplayingDescendants];
        
        if (relatedModelIndex != NSNotFound) { /// We will only perform UI updates while related model is currently displaying
            
            /// Update the Displaying Models
            NSMutableArray *changingDisplayingModel = [NSMutableArray arrayWithArray:self.displayingModels];
            [changingDisplayingModel removeObjectsInArray:displayingChildrenBeforeChange];
            NSUInteger insertingIndex = relatedModelIndex + 1;
            for (KNVUNDExpendingTableViewRelatedModel *newChildeModel in displayingChildrenAfterChange) {
                [changingDisplayingModel insertObject:newChildeModel
                                              atIndex:insertingIndex];
                insertingIndex += 1;
            }
            
            /// Generating Updating IndexPath Array
            NSUInteger countForChildeBeforeChange = [displayingChildrenBeforeChange count];
            NSUInteger countForChildeAfterChange = [displayingChildrenAfterChange count];
            NSUInteger countForIndexNeedReload = MIN(countForChildeBeforeChange, countForChildeAfterChange) + 1; /// Also the model's cell
            NSUInteger countForIndexNeedToChange = MAX(countForChildeBeforeChange, countForChildeAfterChange) -
                                                            MIN(countForChildeBeforeChange, countForChildeAfterChange);
            BOOL changeIsInsert = countForChildeAfterChange > countForChildeBeforeChange;
            
            NSMutableArray *indexPathsToReload = [NSMutableArray new];
            NSMutableArray *indexPathsToChange = [NSMutableArray new];
            NSUInteger startIndex = relatedModelIndex;
            
            for (int index = 0; index < countForIndexNeedReload; index += 1) {
                [indexPathsToReload addObject:[NSIndexPath indexPathForRow:startIndex
                                                                 inSection:0]];
                startIndex += 1;
            }
            
            for (int index = 0; index < countForIndexNeedToChange; index += 1) {
                [indexPathsToChange addObject:[NSIndexPath indexPathForRow:startIndex
                                                                 inSection:0]];
                startIndex += 1;
            }
            
            /// Then Perform the updating
            self.displayingModels = [NSArray arrayWithArray:changingDisplayingModel];
            
            NSIndexPath *lastIndexPathAfterChange = indexPathsToReload.lastObject;
            NSIndexPath *firstIndexPathAfterChange = indexPathsToReload.firstObject;
            
            if ([indexPathsToChange count] > 0) {
                if (changeIsInsert) {
                    [self.associatedTableView insertRowsAtIndexPaths:indexPathsToChange
                                                    withRowAnimation:self.isDisableTableViewAnimation ? UITableViewRowAnimationBottom : UITableViewRowAnimationNone];
                    lastIndexPathAfterChange = indexPathsToChange.lastObject;
                } else {
                    [self.associatedTableView deleteRowsAtIndexPaths:indexPathsToChange
                                                    withRowAnimation:self.isDisableTableViewAnimation ? UITableViewRowAnimationTop : UITableViewRowAnimationNone];
                }
            }
            
            [self.associatedTableView reloadRowsAtIndexPaths:indexPathsToReload
                                            withRowAnimation:UITableViewRowAnimationNone];
            
            /// The last step is scroll down to the Laste IndexPath if the last IndexPath is not visible.
            NSIndexPath *checkingIndexPath = shouldScrollToTop ? firstIndexPathAfterChange : lastIndexPathAfterChange;
            if (![self.associatedTableView.indexPathsForVisibleRows linq_any:^BOOL(NSIndexPath *item) {
                return item.section == checkingIndexPath.section && item.row == checkingIndexPath.row;
            }]) {
                [self.associatedTableView scrollToRowAtIndexPath:checkingIndexPath
                                                atScrollPosition:shouldScrollToTop ? UITableViewScrollPositionTop : UITableViewScrollPositionBottom
                                                        animated:!self.isDisableTableViewAnimation];
            }
        }
        
    }];
}

- (void)rollToCellWithDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *_Nonnull)relatedModel
                     atScrollPoisiton:(UITableViewScrollPosition)position
{
    [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
        NSUInteger modelIndex = [self.displayingModels indexOfObject:relatedModel];
        if (modelIndex != NSNotFound) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:modelIndex
                                                        inSection:0];
            [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                             andLogStringFormat:@"Scroll Cell to Index: %@",
             indexPath];
            [self.associatedTableView scrollToRowAtIndexPath:indexPath
                                            atScrollPosition:position
                                                    animated:!self.isDisableTableViewAnimation];
        }
    }];
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
