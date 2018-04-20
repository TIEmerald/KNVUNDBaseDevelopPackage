//
//  KNVUNDExpendingTableViewRelatedModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 23/2/18.
//

#import "KNVUNDExpendingTableViewRelatedModel.h"

/// Views
#import "KNVUNDETVRelatedBasicTableViewCell.h"

@interface KNVUNDExpendingTableViewRelatedModel(){
    
    /// Hirearchy Related Properties
    NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> *_mutableChildrenArray;
    
    /// Selection Related
    BOOL _isCurrentModelSelected;
    KNVUNDETVRelatedModelBooleanStatusChangedBlock _selectionStatusOnChange;
    
    /// Expending Status Related
    BOOL _isCurrentModelExpended;
    KNVUNDETVRelatedModelBooleanStatusChangedBlock _expendingStatusOnChange;
}

@property (readonly) NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> *relatedModelArray;

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

- (void)isExpendedSatatusChangedTo:(BOOL)isExpended
{
    
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        self.isExpendable = YES;
        self.isSelectable = YES;
        [self setSelectionStatusOnChangeBlock:^(BOOL newStatusBoolean) {
            [weakSelf isSelectedSatatusChangedTo:newStatusBoolean];
        }];
        [self setExpendingStatusOnChangeBlock:^(BOOL newStatusBoolean) {
            [weakSelf isExpendedSatatusChangedTo:newStatusBoolean];
        }];
    }
    return self;
}

#pragma mark - Getters && Setters
#pragma mark Delegate Related
- (NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> *)relatedModelArray
{
    return self.delegate.displayingModels;
}

- (BOOL)isSingleSelection
{
    return [self.delegate isSettingSingleSelection];
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
    for (KNVUNDExpendingTableViewRelatedModel *child in _mutableChildrenArray) {
        child.parent = nil;
        child.delegate = nil;
        child.modelDepthLevel = 0;
    }
    _mutableChildrenArray = [NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> arrayWithArray:children];
    for (KNVUNDExpendingTableViewRelatedModel *child in _mutableChildrenArray) {
        if (child.parent != self) {
            child.parent = self;
            child.delegate = self.delegate;
            child.modelDepthLevel = self.modelDepthLevel + 1;
        }
    }
}

- (void)setParent:(KNVUNDExpendingTableViewRelatedModel *)parent
{
    [_parent removeOneChild:self];
    self.modelDepthLevel = 0;
    self.delegate = nil;
    _parent = parent;
    if (_parent != nil) {
        [_parent addOneChild:self];
        self.modelDepthLevel = _parent.modelDepthLevel + 1;
        self.delegate = _parent.delegate;
    }
}

#pragma mark Support Methods
// these two methods is called for .parent =
- (void)addOneChild:(KNVUNDExpendingTableViewRelatedModel *)child
{
    if (![_mutableChildrenArray containsObject:child]) {
        [_mutableChildrenArray addObject:child];
    }
}

- (void)removeOneChild:(KNVUNDExpendingTableViewRelatedModel *)child
{
    if ([_mutableChildrenArray containsObject:child]) {
        [_mutableChildrenArray removeObject:child];
    }
}

#pragma mark - Selection Related
#pragma mark Getters
- (BOOL)isSelected
{
    if (_isCurrentModelSelected) {
        return YES;
    } else {
        for (KNVUNDExpendingTableViewRelatedModel *child in self.children) {
            if (child.isSelected) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isCurrentModelSelected
{
    return _isCurrentModelSelected;
}

#pragma mark Setters
- (void)setSelectionStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)selectionStatusOnChangeBlock
{
    _selectionStatusOnChange = selectionStatusOnChangeBlock;
}

- (void)toggleSelectionStatus
{
    [self toggleSelectionStatusAndShouldUpdateRelatedCells:YES];
}

/// This method will return a Set of KNVUNDExpendingTableViewRelatedModel which selection status will be affected.
- (NSSet *)toggleSelectionStatusAndShouldUpdateRelatedCells:(BOOL)shouldUpdateCells
{
    if ([self isSingleSelection] && ![self isCurrentModelSelected]) {
        for (KNVUNDExpendingTableViewRelatedModel *tableModel in self.relatedModelArray) {
            if ([tableModel isCurrentModelSelected]) {
                [tableModel toggleSelectionStatus];
            }
        }
    }
    
    NSMutableSet *updatedModels = [NSMutableSet new];
    if (self.isSelectable) {
        /// Step One, if it's not selected, we will select current Model
        if (!self.isSelected) {
            _isCurrentModelSelected = YES;
        } else {
            if (_isCurrentModelSelected) {
                _isCurrentModelSelected = NO;
            } else {
                for (KNVUNDExpendingTableViewRelatedModel *child in self.children) {
                    if (child.isSelected) {
                        NSSet *updatedModelsFromChild = [child toggleSelectionStatusAndShouldUpdateRelatedCells:NO];
                        [updatedModels addObjectsFromArray:updatedModelsFromChild.allObjects];
                    }
                }
            }
        }
        [updatedModels addObject:self];
        [updatedModels addObjectsFromArray:[self getAllAncestor].allObjects];
    }
    
    if (shouldUpdateCells) {
        if ([self.delegate respondsToSelector:@selector(reloadCellsAtIndexPaths:shouldReloadCell:)]) {
            NSMutableArray *shouldReloadCellModels = [NSMutableArray new];
            NSMutableArray *shouldNotReloadCellModels = [NSMutableArray new];
            for (KNVUNDExpendingTableViewRelatedModel *model in updatedModels.allObjects) {
                if (model.shouldReloadCellWhenSelectionStatusChanged) {
                    [shouldReloadCellModels addObject:model];
                } else {
                    [shouldNotReloadCellModels addObject:model];
                }
            }
            [self.delegate reloadCellsAtIndexPaths:[self getIndexPathsFromModels:shouldReloadCellModels] shouldReloadCell:YES];
            [self.delegate reloadCellsAtIndexPaths:[self getIndexPathsFromModels:shouldNotReloadCellModels] shouldReloadCell:NO];
        }
    }
    
    if (_selectionStatusOnChange) {
        _selectionStatusOnChange(self.isSelected);
    }
    
    return updatedModels;
}

#pragma mark - Expending Status Related
#pragma mark Getters
- (BOOL)isExpended
{
    return _isCurrentModelExpended;
}

- (BOOL)isExpendable
{
    return _isExpendable && [self.children count] > 0;
}

#pragma mark Setters
- (void)setCurrentExpendedStatus:(BOOL)currentExpendedStatus
{
    _isCurrentModelExpended = currentExpendedStatus;
    if (_expendingStatusOnChange) {
        _expendingStatusOnChange(_isCurrentModelExpended);
    }
}

- (void)setExpendingStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)expendingStatusOnChangeBlock
{
    _expendingStatusOnChange = expendingStatusOnChangeBlock;
}

- (void)toggleExpendedStatus
{
    NSArray *displayingDescendants = [self getDisplayingDescendants];
    if (self.isExpended) {
        // Which means current displaying models contains all displaying descendant
        NSArray *updatedIndexPaths = [self getIndexPathsFromModels:displayingDescendants];
        [self.relatedModelArray removeObjectsInArray:displayingDescendants];
        if ([self.delegate respondsToSelector:@selector(deleteCellsAtIndexPaths:)]) {
            [self.delegate deleteCellsAtIndexPaths:updatedIndexPaths];
        }
    } else {
        if ([self.relatedModelArray containsObject:self]) {
            NSInteger selfIndex = [self.relatedModelArray indexOfObject:self];
            NSInteger insertingIndex = selfIndex + 1;
            for (KNVUNDExpendingTableViewRelatedModel *descendant in displayingDescendants) {
                [self.relatedModelArray insertObject:descendant
                                             atIndex:insertingIndex];
                insertingIndex = insertingIndex + 1;
            }
            NSArray *updatedIndexPaths = [self getIndexPathsFromModels:displayingDescendants];
            if ([self.delegate respondsToSelector:@selector(insertCellsAtIndexPaths:)]) {
                [self.delegate insertCellsAtIndexPaths:updatedIndexPaths];
            }
        }
    }
    _isCurrentModelExpended = !_isCurrentModelExpended;
    if (_expendingStatusOnChange) {
        _expendingStatusOnChange(self.isExpended);
    }
}

#pragma mark Support Methods
- (NSArray *)getDisplayingDescendants
{
    NSMutableArray *returnArray = [NSMutableArray new];
    for (KNVUNDExpendingTableViewRelatedModel *child in self.children) {
        [returnArray addObject:child];
        if (child.isExpended) {
            NSArray *childDisplayingDescendants = [child getDisplayingDescendants];
            [returnArray addObjectsFromArray:childDisplayingDescendants];
        }
    }
    return returnArray;
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
- (NSIndexPath *_Nullable)getCurrentIndexPath
{
    if ([self.relatedModelArray containsObject:self]) {
        NSUInteger row = [self.relatedModelArray indexOfObject:self];
        return [NSIndexPath indexPathForRow:row
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

- (void)reloadTheCellForSelf
{
    NSIndexPath *currentIndexForSelf = [self getCurrentIndexPath];
    if (currentIndexForSelf != nil) {
        [self.delegate reloadCellsAtIndexPaths:@[currentIndexForSelf] shouldReloadCell:NO];
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

@end
