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

/// Setting Related
- (BOOL)isSettingSingleSelection;

/// Table View Updating Related
- (void)reloadCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths shouldReloadCell:(BOOL)shouldReloadCell;
- (void)insertCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths;
- (void)deleteCellsAtIndexPaths:(NSArray *_Nonnull)indexPaths;

@end

@protocol KNVUNDExpendingTableViewRelatedModelCellDelegate <NSObject>

@end

typedef void(^KNVUNDETVRelatedModelBooleanStatusChangedBlock)(BOOL newStatusBoolean);

@interface KNVUNDExpendingTableViewRelatedModel : KNVUNDBaseModel

#pragma mark - Overrided Methods
#pragma mark - Class Methods
+ (Class _Nonnull)relatedTableViewCell; /// You need to override this method for each type of Model, to let Helper know which Table Cell we need to use.
#pragma mark - Instance Methods
- (void)isSelectedSatatusChangedTo:(BOOL)isSelected NS_REQUIRES_SUPER;
- (void)isExpendedSatatusChangedTo:(BOOL)isExpended NS_REQUIRES_SUPER;

#pragma mark - General Methods
/// Object Level
@property (nonatomic, strong, nonnull) id associatedItem;
@property (weak) id<KNVUNDETVRelatedModelDelegate> delegate;
@property (weak) id<KNVUNDExpendingTableViewRelatedModelCellDelegate> relatedCellDelegate;/// This delegate always link to the associated cell object.

//// Hirearchy Related properties
@property (nonatomic, readonly) NSUInteger modelDepthLevel; /// This value is set from parent
@property (nonatomic, strong, nullable) NSArray<KNVUNDExpendingTableViewRelatedModel *> *children;
@property (nonatomic, weak, nullable) KNVUNDExpendingTableViewRelatedModel *parent;

//// Selection Related
@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic) BOOL isSelectable; // You could overrride thie getter if you want a certain model will never be selected
@property (nonatomic) BOOL shouldReloadCellWhenSelectionStatusChanged; // Set this value to YES if you want to call [TableView reloadRowsAtIndexPaths:...] to reload this Model's related cell... otherwise, we will just call [UITableViewCell updateCellUI] instead. .... For example, if you want to change the height of the cell.
/*!
 * @brief Please call this method if you want to have any reaction based on Selection Status Changed.
 */
- (void)setSelectionStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)selectionStatusOnChangeBlock;
- (void)toggleSelectionStatus;

//// Expending Status Related
@property (nonatomic, readonly) BOOL isExpended;
@property (nonatomic) BOOL isExpendable; // You could overrride thie getter if you want a certain model will never be expended
/*!
 * @brief Please call this method if you want to have any reaction based on Expending Status Changed.
 */
- (void)setExpendingStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock _Nullable)expendingStatusOnChangeBlock;
- (void)toggleExpendedStatus;
/////// Support Methods
- (NSArray *_Nonnull)getDisplayingDescendants;

//// Log Related
- (NSString *_Nonnull)logDescription;

//// Support Methods
- (void)reloadTheCellForSelf;

@end
