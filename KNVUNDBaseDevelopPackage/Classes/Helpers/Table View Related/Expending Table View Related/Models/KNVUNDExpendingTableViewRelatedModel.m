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

//// Hirearchy Related properties
@property (nonatomic, readwrite) NSUInteger modelDepthLevel;

@end

@implementation KNVUNDExpendingTableViewRelatedModel

#pragma mark - Getters && Setters
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
        child.modelDepthLevel = 0;
    }
    _mutableChildrenArray = [NSMutableArray<KNVUNDExpendingTableViewRelatedModel *> arrayWithArray:children];
    for (KNVUNDExpendingTableViewRelatedModel *child in _mutableChildrenArray) {
        if (child.parent != self) {
            child.parent = self;
            child.modelDepthLevel = self.modelDepthLevel + 1;
        }
    }
}

- (void)setParent:(KNVUNDExpendingTableViewRelatedModel *)parent
{
    [_parent removeOneChild:self];
    self.modelDepthLevel = 0;
    _parent = parent;
    if (_parent != nil) {
        [_parent addOneChild:self];
        self.modelDepthLevel = _parent.modelDepthLevel + 1;
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

//#pragma mark Setters
//- (void)toggleSelectionStatus
//{
//    if (self.isSelectable) {
//        /// Step One, if it's not selected, we will select current Model
//        /// Step Two, if it's Selected..
//        /// Step Two One, if current Model is selected, we will set current model to selected.
//        /// Step Two Two, and toggle all selected children....
//    }
//}
//
//#pragme mark - Expending Status Related
//#pragma mark Getters
//- (BOOL)isExpended
//{
//
//}
//
//#pragma mark Setters
//- (void)toggleExpendedStatus
//{
//
//}

@end
