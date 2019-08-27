//
//  KNVUNDExpendingTableViewRelatedModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 23/2/18.
//

#import "KNVUNDExpendingTableViewRelatedModel.h"

/// Views
#import "KNVUNDETVRelatedBasicTableViewCell.h"

/// Tools
#import "KNVUNDThreadRelatedTool.h"

@interface KNVUNDExpendingTableViewRelatedModel(){
    
    /// Hirearchy Related Properties
    NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> *_mutableChildrenArray;
    
    /// Selection Related
    BOOL _isCurrentModelSelected;
    KNVUNDETVRelatedModelBooleanStatusChangedBlock _selectionStatusWillChange;
    KNVUNDETVRelatedModelBooleanStatusChangedBlock _selectionStatusOnChange;
    
    /// Expending Status Related
    BOOL _isCurrentModelExpended;
    KNVUNDETVRelatedModelBooleanStatusChangedBlock _expendingStatusWillChange;
    KNVUNDETVRelatedModelBooleanStatusChangedBlock _expendingStatusOnChange;
}

@property (readonly) BOOL hasLinkedToDisplayingHelper;
@property (readonly) NSArray<KNVUNDExpendingTableViewRelatedModel *> *relatedModelArray;

//// Hirearchy Related properties
@property (nonatomic, readwrite) NSUInteger modelDepthLevel;

@end

@implementation KNVUNDExpendingTableViewRelatedModel

#pragma mark - Overrided Methods
#pragma mark - Class Methods
+ (Class _Nonnull)relatedTableViewCell
{
    return [KNVUNDETVRelatedBasicTableViewCell class];
}

#pragma mark - Instance Methods
- (void)isSelectedSatatusChangedTo:(BOOL)isSelected
{
    
}

- (void)isSelectedSatatusChangedFrom:(BOOL)oldValue to:(BOOL)newValue andCouldUpdateExpendStatus:(BOOL)couldUpdateExpendStatus
{
    [self isSelectedSatatusChangedTo:newValue];
    if (self.shouldExpendWhileSelected) {
        if (!oldValue && newValue && couldUpdateExpendStatus && !self.isExpended) {
            [self toggleExpendedStatus];
        } else if (oldValue && !newValue && couldUpdateExpendStatus && self.isExpended) {
            [self toggleExpendedStatus];
        }
    }
}

- (void)isSelectedSatatusWillChangedTo:(BOOL)isSelected
{
    
}

- (void)isSelectedSatatusWillChangedFrom:(BOOL)oldValue to:(BOOL)newValue andCouldUpdateExpendStatus:(BOOL)couldUpdateExpendStatus
{
    [self isSelectedSatatusWillChangedTo:newValue];
}

- (void)isExpendedSatatusChangedTo:(BOOL)isExpended
{
    
}

- (void)isExpendedSatatusChangedFrom:(BOOL)oldValue to:(BOOL)newValue
{
    [self isExpendedSatatusChangedTo:newValue];
}

- (void)isExpendedSatatusWillChangedTo:(BOOL)isExpended
{
    
}

- (void)isExpendedSatatusWillChangedFrom:(BOOL)oldValue to:(BOOL)newValue
{
    [self isExpendedSatatusWillChangedTo:newValue];
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        self.isExpendable = YES;
        self.isSelectable = YES;
        [self setSelectionStatusOnChangeBlock:^(BOOL oldStatusBoolean, BOOL newStatusBoolean, BOOL couldUpdateExpendStatus) {
            [weakSelf isSelectedSatatusChangedFrom:oldStatusBoolean
                                                to:newStatusBoolean
                        andCouldUpdateExpendStatus:couldUpdateExpendStatus];
        }];
        [self setSelectionStatusWillChangeBlock:^(BOOL oldStatusBoolean, BOOL newStatusBoolean, BOOL couldUpdateExpendStatus) {
            [weakSelf isSelectedSatatusWillChangedFrom:oldStatusBoolean
                                                    to:newStatusBoolean
                            andCouldUpdateExpendStatus:couldUpdateExpendStatus];
        }];
        [self setExpendingStatusOnChangeBlock:^(BOOL oldStatusBoolean, BOOL newStatusBoolean, BOOL couldUpdateExpendStatus) {
            [weakSelf isExpendedSatatusChangedFrom:oldStatusBoolean
                                                to:newStatusBoolean];
        }];
        [self setExpendingStatusWillChangeBlock:^(BOOL oldStatusBoolean, BOOL newStatusBoolean, BOOL couldUpdateExpendStatus) {
            [weakSelf isExpendedSatatusWillChangedFrom:oldStatusBoolean
                                                    to:newStatusBoolean];
        }];
    }
    return self;
}

#pragma mark - Getters && Setters
#pragma mark Delegate Related
- (BOOL)hasLinkedToDisplayingHelper
{
    return self.delegate != nil;
}

- (NSArray <KNVUNDExpendingTableViewRelatedModel *> *)relatedModelArray
{
    return self.delegate.displayingModels;
}

- (BOOL)isSingleSelection
{
    return [self.delegate isSettingSingleSelection];
}

#pragma mark - General Methods
- (void)setupModelWithSelectionStatus:(BOOL)isSelected andExpendedStatus:(BOOL)isExpended
{
    _isCurrentModelSelected = isSelected;
    _isCurrentModelExpended = isExpended;
}

#pragma mark - Hirearchy Related Properties
#pragma mark Getters
- (NSArray<KNVUNDExpendingTableViewRelatedModel *> *)children
{
    if (_mutableChildrenArray == nil) {
        _mutableChildrenArray = [NSMutableArray new];
    }
    return _mutableChildrenArray;
}

- (id<KNVUNDETVRelatedModelDelegate>)delegate
{
    if (_delegate == nil) {
        return self.parent.delegate;
    }
    return _delegate;
}

#pragma mark Setters
- (void)setChildren:(NSArray<KNVUNDExpendingTableViewRelatedModel *> *)children
{
    _mutableChildrenArray = [NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> arrayWithArray:children];
    for (KNVUNDExpendingTableViewRelatedModel *child in _mutableChildrenArray) {
        if (child.parent != self) {
            child.parent = self;
        }
    }
}

- (void)setParent:(KNVUNDExpendingTableViewRelatedModel *)parent
{
    _parent = parent;
    _delegate = nil; /// For convenience, we will only set _delegate to nil as long as it involves parent...
    if (_parent != nil) {
        [_parent addOneChild:self];
        self.modelDepthLevel = _parent.modelDepthLevel + 1;
    } else {
        self.modelDepthLevel = 0;
    }
}

- (void)setModelDepthLevel:(NSUInteger)modelDepthLevel
{
    _modelDepthLevel = modelDepthLevel;
    for (KNVUNDExpendingTableViewRelatedModel *child in self.children) {
        child.modelDepthLevel = modelDepthLevel + 1;
    }
}

#pragma mark Support Methods
/// Inserting new child
- (void)addOneChild:(KNVUNDExpendingTableViewRelatedModel *)child
{
    if (![_mutableChildrenArray containsObject:child]) {
        [_mutableChildrenArray addObject:child];
    }
}

- (void)addOneChild:(KNVUNDExpendingTableViewRelatedModel *)child withChildIndex:(NSInteger)childIndex
{
    if (![_mutableChildrenArray containsObject:child]) {
        NSInteger usingInsertingIndex = childIndex;
        if (usingInsertingIndex > [self.children count]) {
            usingInsertingIndex = [self.children count];
        }
        if (usingInsertingIndex < 0) {
            usingInsertingIndex = 0;
        }
        [_mutableChildrenArray insertObject:child atIndex:usingInsertingIndex];
        
        if (self.hasLinkedToDisplayingHelper && self.isExpended) { /// Which means we need to update the displaying UI, too.
            /// Step One find the inserting Starting Index for the new child model
            NSInteger insertingIndex = [self insertingDisplayingIndexForNewChildWithNewChildIndex:usingInsertingIndex];
            
            /// Step Two find out the Array need to insert in that index
            NSMutableArray *insertingModels = [NSMutableArray arrayWithObject:child];
            [insertingModels addObjectsFromArray:[child getDisplayingDescendants]];
            
            /// Step Three Inserting Displaying Model
            [self insertDisplayingModels:insertingModels
                      withInsertingIndex:insertingIndex];
        }
    }
    
}

- (NSInteger)insertingDisplayingIndexForNewChildWithNewChildIndex:(NSInteger)newChildInsertingIndex
{
    //// The logic is reach the models belond to next sibling, we will find out the inserting displaying index for the new model
    
    NSInteger selfIndex = [self getCurrentDisplayingIndex]; /// This is the index for parent
   
    KNVUNDExpendingTableViewRelatedModel *nextSubling = nil;
    if (newChildInsertingIndex + 1 < [self.children count] ) {
        nextSubling = [self.children objectAtIndex:newChildInsertingIndex + 1];
    }
    
    /// Then we will keep checking the displaying models until we found what we need
    NSInteger checkingIndex = selfIndex + 1;
    while (checkingIndex < [self.relatedModelArray count]) {
        KNVUNDExpendingTableViewRelatedModel *currentDisplayingModel = self.relatedModelArray[checkingIndex];
        if (currentDisplayingModel == nextSubling) { /// We will return the Index for Next Sibling as the index where we entry the new Displaying model
            return checkingIndex;
        }
        if (![currentDisplayingModel isDescendantOf:self]) { /// Or we will entry the new displaying Model at the end of the displaying descendants...
            return checkingIndex;
        }
        checkingIndex += 1;
    }
    return checkingIndex;
}

/// Removing old child
- (void)removeOneChild:(KNVUNDExpendingTableViewRelatedModel *)child
{
    if ([_mutableChildrenArray containsObject:child]) {
        [_mutableChildrenArray removeObject:child];
        
        if (self.hasLinkedToDisplayingHelper && self.isExpended) {
            NSMutableArray *removingModels = [NSMutableArray arrayWithObject:child];
            [removingModels addObjectsFromArray:[child getDisplayingDescendants]];
            
            [self removeDisplayingModels:removingModels];
        }
    }
}

#pragma mark - Selection Related
#pragma mark Getters
- (BOOL)isSelected
{
    return self.isSelfOrAnyDescendantCurrentSelected;
}

- (BOOL)isSelectable
{
    return _isSelectable;
}

- (BOOL)isSelfOrAnyDescendantCurrentSelected
{
    for (KNVUNDExpendingTableViewRelatedModel *relatedModel in [self getAllDescendantsIncludingSelf]) {
        if (relatedModel.isCurrentModelSelected) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isCurrentModelSelected
{
    if (self.shouldSelectedStatusBasedOnParent) {
        return self.parent.isCurrentModelSelected;
    } else {
        return _isCurrentModelSelected;
    }
}

#pragma mark Setters
- (void)setSelectionStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)selectionStatusOnChangeBlock
{
    _selectionStatusOnChange = selectionStatusOnChangeBlock;
}

- (void)setSelectionStatusWillChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)selectionStatusWillChangeBlock
{
    _selectionStatusWillChange = selectionStatusWillChangeBlock;
}

- (void)toggleSelectionStatus
{
    [self toggleSelectionStatusWithCouldUpdateRelatedCells:YES];
}

/// This method will return a Set of KNVUNDExpendingTableViewRelatedModel which selection status will be affected.
- (void)toggleSelectionStatusWithCouldUpdateRelatedCells:(BOOL)shouldUpdateCells
{
    NSMutableSet *updatedModels = [NSMutableSet new];
    
    if ([self isSingleSelection] && !self->_isCurrentModelSelected) {
        for (KNVUNDExpendingTableViewRelatedModel *tableModel in self.relatedModelArray) {
            if (tableModel->_isCurrentModelSelected) {
                [tableModel  toggleSelectionStatusWithCouldUpdateRelatedCells:NO];
                [updatedModels addObjectsFromArray:[tableModel selectionUIUpdatingRelatedModelsFromSelf]];
            }
        }
    }
    
    BOOL selectionStatusWillChangedFrom = self.isSelected;
    BOOL selectionStatusWillChangedTo = !selectionStatusWillChangedFrom;
    
    if (_selectionStatusWillChange) {
        _selectionStatusWillChange(selectionStatusWillChangedFrom, selectionStatusWillChangedTo, shouldUpdateCells);
    }
    
    if (self.isSelectable) {
        /// Step One, if it's not selected, we will select current Model
        if (!self.isSelected) {
            _isCurrentModelSelected = selectionStatusWillChangedTo;
        } else {
            if (_isCurrentModelSelected) {
                _isCurrentModelSelected = selectionStatusWillChangedTo;
            } else {
                for (KNVUNDExpendingTableViewRelatedModel *child in self.children) {
                    if (child.isSelected && child.isSelectable) {
                        [child toggleSelectionStatusWithCouldUpdateRelatedCells:NO];
                    }
                }
            }
        }
        [updatedModels addObjectsFromArray:[self selectionUIUpdatingRelatedModelsFromSelf]];
    }
    
    if (shouldUpdateCells) {
        if ([self.delegate respondsToSelector:@selector(reloadCellsWithDisplayingModelArray:shouldReloadCell:)]) {
            NSMutableArray *shouldReloadCellModels = [NSMutableArray new];
            NSMutableArray *shouldNotReloadCellModels = [NSMutableArray new];
            for (KNVUNDExpendingTableViewRelatedModel *model in updatedModels.allObjects) {
                if (model.shouldReloadCellWhenSelectionStatusChanged) {
                    [shouldReloadCellModels addObject:model];
                } else {
                    [shouldNotReloadCellModels addObject:model];
                }
            }
            [self.delegate reloadCellsWithDisplayingModelArray:shouldReloadCellModels shouldReloadCell:YES];
            [self.delegate reloadCellsWithDisplayingModelArray:shouldNotReloadCellModels shouldReloadCell:NO];
        }
    }
    
    if (_selectionStatusOnChange) {
        _selectionStatusOnChange(selectionStatusWillChangedFrom, self.isSelected, shouldUpdateCells);
    }
}

- (NSArray *)selectionUIUpdatingRelatedModelsFromSelf
{
    NSMutableArray *returnArray = [NSMutableArray new];
    [returnArray addObjectsFromArray:[self getAllAncestor].allObjects];
    [returnArray addObjectsFromArray:[self getAllDescendantsIncludingSelf].allObjects];
    
    NSArray *relatedModels = self.selectionStatusRelatedModels;
    if ([relatedModels count] > 0) {
        [returnArray addObjectsFromArray:relatedModels];
    }
    return returnArray;
}

#pragma mark - Expending Status Related
#pragma mark Getters
- (BOOL)isExpended
{
    if (self.shouldAlwaysExpended) {
        return YES;
    } else {
        return _isCurrentModelExpended;
    }
}

- (BOOL)isExpendable
{
    if (self.shouldAlwaysExpended) {
        return NO;
    } else {
        return _isExpendable && [self.children count] > 0;
    }
}

#pragma mark Setters
- (void)setCurrentExpendedStatus:(BOOL)currentExpendedStatus
{
    BOOL previousExpendStatus = _isCurrentModelExpended;
    _isCurrentModelExpended = currentExpendedStatus;
    if (_expendingStatusOnChange) {
        _expendingStatusOnChange(previousExpendStatus, _isCurrentModelExpended, YES);
    }
}

- (void)setExpendingStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)expendingStatusOnChangeBlock
{
    _expendingStatusOnChange = expendingStatusOnChangeBlock;
}

- (void)setExpendingStatusWillChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)expendingStatusWillChangeBlock
{
    _expendingStatusWillChange = expendingStatusWillChangeBlock;
}

- (BOOL)canToggleExpendedStatus {
    return true;
}

- (void)toggleExpendedStatus
{
    NSArray *displayingDescendants = [self getAllDescndantsThatShouldDisplay];
    BOOL expendedStatusWillChangedFrom = _isCurrentModelExpended;
    BOOL expendedStatusWillChangedTo = !expendedStatusWillChangedFrom;
    
    if (_expendingStatusWillChange) {
        _expendingStatusWillChange(expendedStatusWillChangedFrom, expendedStatusWillChangedTo, YES);
    }
    
    if (self.isExpended) {
        // Which means current displaying models contains all displaying descendant
        [self removeDisplayingModels:displayingDescendants];
    } else {
        if ([self.relatedModelArray containsObject:self]) {
            NSInteger selfIndex = [self.relatedModelArray indexOfObject:self];
            [self insertDisplayingModels:displayingDescendants
                      withInsertingIndex:selfIndex + 1];
        }
    }
    
    _isCurrentModelExpended = expendedStatusWillChangedTo;
    
    if (_expendingStatusOnChange) {
        _expendingStatusOnChange(expendedStatusWillChangedFrom, self.isExpended, YES);
    }
}

#pragma mark Support Methods
- (NSIndexPath *)currentDisplayingIndexPath
{
    return [self getCurrentIndexPath];
}

- (NSArray<KNVUNDExpendingTableViewRelatedModel *> *)siblings
{
    NSMutableArray *tempArray = [NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> arrayWithArray:self.parent.children];
    [tempArray removeObject:self];
    return [NSArray<KNVUNDExpendingTableViewRelatedModel *> arrayWithArray:tempArray];
}

- (NSArray *)getCurrentDisplayedIndexPathIncludingDecedants
{
    NSMutableArray *returnIndexPaths = [NSMutableArray new];
    NSIndexPath *relatedIndexPath = [self getCurrentIndexPath];
    if (relatedIndexPath != nil) {
        [returnIndexPaths addObject:relatedIndexPath];
    }
    for (KNVUNDExpendingTableViewRelatedModel *model in [self getDisplayingDescendants]) {
        NSIndexPath *relatedChildIndexPath = [model getCurrentIndexPath];
        if (relatedChildIndexPath != nil) {
            [returnIndexPaths addObject:relatedChildIndexPath];
        }
    }
    return returnIndexPaths;
}

- (NSArray *)getDisplayingDescendants
{
    return self.isExpended ? [self getAllDescndantsThatShouldDisplay] : [NSArray new];
}

- (NSArray *)getAllDescndantsThatShouldDisplay
{
    NSMutableArray *returnArray = [NSMutableArray new];
    for (KNVUNDExpendingTableViewRelatedModel *child in self.children) {
        [returnArray addObject:child];
        NSArray *childDisplayingDescendants = [child getDisplayingDescendants];
        [returnArray addObjectsFromArray:childDisplayingDescendants];
    }
    return returnArray;
}

- (BOOL)isDescendantOf:(KNVUNDExpendingTableViewRelatedModel *)ancester
{
    KNVUNDExpendingTableViewRelatedModel *checkingParent = self;
    while (checkingParent != nil) {
        if (checkingParent == ancester) {
            return YES;
        } else {
            checkingParent = checkingParent.parent;
        }
    }
    return NO;
}

#pragma mark - Log Related
- (NSString *_Nonnull)logDescription
{
    return [NSString stringWithFormat:@"Model Item: %@ (Depth Level %@, Is Expended %@, Is Selected %@",
            [self.associatedItem description],
            @(self.modelDepthLevel),
            @(self.isExpended),
            @(self.isSelected)];
}

#pragma mark - Support Methods
#pragma mark Table View Related
- (NSUInteger)getCurrentDisplayingIndex
{
    return [self.relatedModelArray indexOfObject:self];
}

- (NSIndexPath *_Nullable)getCurrentIndexPath
{
    if ([self.relatedModelArray containsObject:self]) {
        return [NSIndexPath indexPathForRow:[self getCurrentDisplayingIndex]
                                  inSection:0];
    } else {
        return nil;
    }
}

- (NSArray *)getIndexPathsFromModels:(NSArray *)models
{
    NSMutableArray *returnIndexPaths = [NSMutableArray new];
    for (KNVUNDExpendingTableViewRelatedModel *model in models) {
        NSIndexPath *relatedIndexPath = [model getCurrentIndexPath];
        if (relatedIndexPath != nil) {
            [returnIndexPaths addObject:relatedIndexPath];
        }
    }
    return returnIndexPaths;
}

- (void)insertDisplayingModels:(NSArray *)displayingModels withInsertingIndex:(NSInteger)insertingIndex
{
    if ([self.delegate respondsToSelector:@selector(inSertCellsWithDisplayingModelArray:withStartIndex:)]) {
        [self.delegate inSertCellsWithDisplayingModelArray:displayingModels
                                            withStartIndex:insertingIndex];
    }
}

- (void)reloadTheCellForSelf
{
    [self.delegate reloadCellsWithDisplayingModelArray:@[self] shouldReloadCell:NO];
}

- (void)removeDisplayingModels:(NSArray *)displayingModels
{
    if ([self.delegate respondsToSelector:@selector(deleteCellsWithDisplayingModelArray:)]) {
        [self.delegate deleteCellsWithDisplayingModelArray:displayingModels];
    }
}

#pragma mark Ancestors and Descendants
- (NSSet *)getAllAncestor
{
    NSMutableSet *returnSet = [NSMutableSet new];
    KNVUNDExpendingTableViewRelatedModel *checkingModel = self;
    while (checkingModel.parent != nil && ![returnSet containsObject:checkingModel.parent]) {
        [returnSet addObject:checkingModel.parent];
        checkingModel = checkingModel.parent;
    }
    return returnSet;
}

- (NSSet *)getAllDescendantsIncludingSelf
{
    NSMutableSet *returnSet = [NSMutableSet new];
    [returnSet addObject:self];
    for (KNVUNDExpendingTableViewRelatedModel *child in self.children) {
        [returnSet addObjectsFromArray:[child getAllDescendantsIncludingSelf].allObjects];
    }
    return returnSet;
}

@end
