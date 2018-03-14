//
//  KNVUNDExpendingTableViewRelatedModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 23/2/18.
//

#import "KNVUNDExpendingTableViewRelatedModel.h"

@interface KNVUNDExpendingTableViewRelatedModel(){
    
    /// Hirearchy Related Properties
    NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> *_mutableChildrenArray;
    
    /// Selection Related
    BOOL _isCurrentModelSelected;
    
    /// Expending Status Related
    BOOL _isCurrentModelExpended;
}

@property (readonly) NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> *relatedModelArray;

//// Hirearchy Related properties
@property (nonatomic, readwrite) NSUInteger modelDepthLevel;

@end

@implementation KNVUNDExpendingTableViewRelatedModel

#pragma mark - Getters && Setters
#pragma mark Delegate Related
- (NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> *)relatedModelArray
{
    return self.delegate.displayingModels;
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

#pragma mark Setters
- (void)toggleSelectionStatus
{
    [self toggleSelectionStatusAndShouldUpdateRelatedCells:YES];
}

/// This method will return a Set of KNVUNDExpendingTableViewRelatedModel which selection status will be affected.
- (NSSet *)toggleSelectionStatusAndShouldUpdateRelatedCells:(BOOL)shouldUpdateCells
{
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
        if ([self.delegate respondsToSelector:@selector(reloadCellsAtIndexPaths:)]) {
            [self.delegate reloadCellsAtIndexPaths:[self getIndexPathsFromModels:updatedModels.allObjects]];
        }
    }
    
    return updatedModels;
}

#pragma mark - Expending Status Related
#pragma mark Getters
- (BOOL)isExpended
{
    return _isCurrentModelExpended;
}

#pragma mark Setters
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
