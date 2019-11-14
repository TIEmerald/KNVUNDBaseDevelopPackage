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

@property (nonatomic, weak) UITableView *associatedTableView;
@property (nonatomic, weak) UIViewController *relatedViewController;
@property (nonatomic, strong, nonnull) NSArray <KNVUNDExpendingTableViewRelatedModel *> *displayingModels;

/// Setting Related
- (BOOL)isSettingSingleSelection;

/// Table View Updating Related
- (void)deleteCellsWithDisplayingModelArray:(NSArray *_Nonnull)deletingDisplayingModels;
- (void)insertCellsWithDisplayingModelArray:(NSArray *_Nonnull)insertingDisplayingModels withStartIndex:(NSUInteger)startIndex;
- (void)reloadCellsWithDisplayingModelArray:(NSArray *_Nonnull)reloadingDisplayingModels shouldReloadCell:(BOOL)shouldReloadCell;
- (void)reloadChildrenCellsWithDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *_Nonnull)relatedModel
                     withChildrenUpdatingBlock:(void(^_Nonnull)(KNVUNDExpendingTableViewRelatedModel *_Nonnull relatedModel))updatingBlock
                             shouldScrollToTop:(BOOL)shouldScrollToTop;
- (void)rollToCellWithDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *_Nonnull)relatedModel
                     atScrollPoisiton:(UITableViewScrollPosition)position;

@end

@protocol KNVUNDExpendingTableViewRelatedModelCellDelegate <NSObject>

@end

typedef void(^KNVUNDETVRelatedModelBooleanStatusChangedBlock)(BOOL oldStatusBoolean, BOOL newStatusBoolean, BOOL isManuallyAction, BOOL couldUpdateExpendStatus);
typedef BOOL(^KNVUNDETVRelatedModelCouldBooleanStatusChangedBlock)(BOOL oldStatusBoolean, BOOL newStatusBoolean, BOOL isManuallyAction, BOOL couldUpdateExpendStatus);

@interface KNVUNDExpendingTableViewRelatedModel : KNVUNDBaseModel

/// Properties related to Style
@property (nonatomic) BOOL shouldExpendWhileSelected;
@property (nonatomic) BOOL shouldSelectedStatusBasedOnParent;
@property (nonatomic) BOOL shouldAlwaysExpended;

#pragma mark - Overrided Methods
#pragma mark - Class Methods
+ (Class _Nonnull)relatedTableViewCell; /// You need to override this method for each type of Model, to let Helper know which Table Cell we need to use.

#pragma mark - Instance Methods
- (BOOL)couldSelectedStatusChangedFrom:(BOOL)oldValue to:(BOOL)newValue isManuallyAction:(BOOL)isManuallyAction andCouldUpdateExpendStatus:(BOOL)couldUpdateExpendStatus NS_REQUIRES_SUPER;
- (void)isSelectedStatusChangedFrom:(BOOL)oldValue to:(BOOL)newValue isManuallyAction:(BOOL)isManuallyAction andCouldUpdateExpendStatus:(BOOL)couldUpdateExpendStatus NS_REQUIRES_SUPER;
- (BOOL)couldExpendedStatusChangedFrom:(BOOL)oldValue to:(BOOL)newValue NS_REQUIRES_SUPER;
- (void)isExpendedStatusChangedFrom:(BOOL)oldValue to:(BOOL)newValue NS_REQUIRES_SUPER;

#pragma mark - General Methods
/// Object Level
@property (nonatomic, strong, nonnull) id associatedItem;
@property (nonatomic, weak) id<KNVUNDETVRelatedModelDelegate> delegate;
@property (nonatomic, weak) id<KNVUNDExpendingTableViewRelatedModelCellDelegate> relatedCellDelegate;/// This delegate always link to the associated cell object.

- (void)setupModelWithSelectionStatus:(BOOL)isSelected andExpendedStatus:(BOOL)isExpended;

//// Hirearchy Related properties
@property (nonatomic, readonly) NSUInteger modelDepthLevel; /// This value is set from parent
@property (nonatomic, strong, nullable) NSArray<KNVUNDExpendingTableViewRelatedModel *> *children;
@property (nonatomic, weak, nullable) KNVUNDExpendingTableViewRelatedModel *parent;
/// Inserting new child
- (void)addOneChild:(KNVUNDExpendingTableViewRelatedModel *)child;
- (void)addOneChild:(KNVUNDExpendingTableViewRelatedModel *)child withChildIndex:(NSInteger)childIndex;
/// Removing old child
- (void)removeOneChild:(KNVUNDExpendingTableViewRelatedModel *)child;


//// Selection Related
@property (nonatomic, readonly) BOOL isSelected; /// If any one of the children isSelected, this value will return True.
@property (readonly) BOOL isCurrentModelSelected; /// This proper will ignore the selection of children....
@property (readonly) BOOL isSelfOrAnyDescendantCurrentSelected; /// This proper will ignore the selection of children....
@property (nonatomic) BOOL isSelectable; // You could overrride thie getter if you want a certain model will never be selected
@property (nonatomic, strong) NSArray *selectionStatusRelatedModels; /// Whenever self's selection status updated, all models inside this array will update, too.
@property (nonatomic) BOOL shouldReloadCellWhenSelectionStatusChanged; // Set this value to YES if you want to call [TableView reloadRowsAtIndexPaths:...] to reload this Model's related cell... otherwise, we will just call [UITableViewCell updateCellUI] instead. .... For example, if you want to change the height of the cell.
/*!
 * @brief Please call this method if you want to have any reaction based on Selection Status Changed.
 */
- (void)setSelectionStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock)selectionStatusOnChangeBlock;
- (void)toggleSelectionStatus;
- (void)toggleSelectionStatusWithIsManuallyAction:(BOOL)isManuallyAction;

//// Expending Status Related
@property (nonatomic, readonly) BOOL isExpended;
@property (nonatomic) BOOL isExpendable; // You could overrride thie getter if you want a certain model will never be expended
/*!
 * @brief Please call this method if you want to have any reaction based on Expending Status Changed.
 */
- (void)setCouldExpendingStatusChangeBlock:(KNVUNDETVRelatedModelCouldBooleanStatusChangedBlock)couldExpendingStatusChangeBlock;
- (void)setExpendingStatusOnChangeBlock:(KNVUNDETVRelatedModelBooleanStatusChangedBlock)expendingStatusOnChangeBlock;
- (void)toggleExpendedStatus;
- (BOOL)canToggleExpendedStatus;

/////// Support Methods
@property (readonly) NSIndexPath *currentDisplayingIndexPath;
@property (readonly) NSArray<KNVUNDExpendingTableViewRelatedModel *> *siblings;
- (NSArray *)getCurrentDisplayedIndexPathIncludingDecedents;
- (NSArray *_Nonnull)getDisplayingDescendants;
- (BOOL)isDescendantOf:(KNVUNDExpendingTableViewRelatedModel *)ancestor; /// Self is a descendant of self...

//// Log Related
- (NSString *_Nonnull)logDescription;

//// Support Methods
- (void)reloadTheCellForSelf;

@end
