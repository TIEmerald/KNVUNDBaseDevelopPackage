//
//  KNVUNDExpendingTableViewRelatedModel.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 23/2/18.
//

#import "KNVUNDBaseModel.h"

//#import "KNVUNDETVRelatedBasicTableViewCell.h"

@class KNVUNDExpendingTableViewRelatedModel;

@protocol KNVUNDETVRelatedModelDelegate <NSObject>

@property (nonatomic, strong, nonnull) NSMutableArray <KNVUNDExpendingTableViewRelatedModel *> *displayingModels;

/// Table View Updating Related
- (void)reloadCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths;
- (void)insertCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths;
- (void)deleteCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths;

@end

@interface KNVUNDExpendingTableViewRelatedModel : KNVUNDBaseModel

/// Classe Level
//// Table View Related
+ (Class _Nonnull)relatedTableViewCell; /// You need to override this method for each type of Model, to let Helper know which Table Cell we need to use.

/// Object Level
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
@property (nonatomic) BOOL isExpendable; // You could overrride thie getter if you want a certain model will never be expended
- (void)toggleExpendedStatus;
/////// Support Methods
- (NSArray *)getDisplayingDescendants;

@end
