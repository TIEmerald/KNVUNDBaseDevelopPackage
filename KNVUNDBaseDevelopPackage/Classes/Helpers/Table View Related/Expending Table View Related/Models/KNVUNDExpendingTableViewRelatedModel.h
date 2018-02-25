//
//  KNVUNDExpendingTableViewRelatedModel.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 23/2/18.
//

#import "KNVUNDBaseModel.h"

@class KNVUNDExpendingTableViewRelatedModel;

@protocol KNVUNDETVRelatedModelDelegate <NSObject>

@property (nonatomic, strong, nonnull) NSMutableArray <KNVUNDExpendingTableViewRelatedModel *> *displayingModels;

/// Table View Updating Related
- (void)reloadCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths;

@end

@interface KNVUNDExpendingTableViewRelatedModel : KNVUNDBaseModel

@property (nonatomic, strong, nonnull) id associatedItem;
@property (nonatomic, weak, nullable) id<KNVUNDETVRelatedModelDelegate> delegate;

//// Hirearchy Related properties
@property (nonatomic, readonly) NSUInteger modelDepthLevel; /// This value is set from parent
@property (nonatomic, strong, nullable) NSArray<KNVUNDExpendingTableViewRelatedModel *> *children;
@property (nonatomic, weak, nullable) KNVUNDExpendingTableViewRelatedModel *parent;

//// Selection Related
@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic) BOOL isSelectable; // You could overrride thie getter if you want a certain model will never be selected
- (void)toggleSelectionStatus;

//// Expending Status Related
@property (nonatomic, readonly) BOOL isExpended;
- (void)toggleExpendedStatus;

@end
