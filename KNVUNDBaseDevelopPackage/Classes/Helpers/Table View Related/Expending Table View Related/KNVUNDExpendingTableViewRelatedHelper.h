//
//  KNVUNDExpendingTableViewRelatedHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#import "KNVUNDBaseModel.h"

/// Models
#import "KNVUNDExpendingTableViewRelatedModel.h"

@interface KNVUNDExpendingTableViewRelatedHelper : KNVUNDBaseModel

@property (nonatomic) BOOL isSingleSelection;
@property (nonatomic) BOOL isDisableTableViewAnimation; 

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSArray *)getDisplayingModelsWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator;
- (KNVUNDExpendingTableViewRelatedModel *)getFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator;
- (NSUInteger)getIndexOfFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator;

#pragma mark - Setters
- (void)setUpAssociatedTableView:(UITableView *)associatedTableView;
- (void)setUpRelatedViewController:(UIViewController *)viewController;
- (void)setSupportedModelClasses:(NSArray *)supportedModelClasses;

#pragma mark - Set Up
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses andRelatedTableView:(UITableView *)relatedTableView;
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses relatedViewController:(UIViewController *)viewController andRelatedTableView:(UITableView *)relatedTableView;

#pragma mark - General Methods
- (void)updateTableWithRootModelArray:(NSArray *)rootModelArray;
/// Returns the Displaying Models array which has been inserted into current displaying Array.
- (NSArray *)insertOneMoreRootModel:(KNVUNDExpendingTableViewRelatedModel *)insertingModel atIndex:(NSUInteger)index shouldMarkAsSelected:(BOOL)shouldMarkAsSelected;
- (void)insertOneMoreRootModel:(KNVUNDExpendingTableViewRelatedModel *)insertingModel isInTheTop:(BOOL)isInTheTop shouldMarkAsSelected:(BOOL)shouldMarkAsSelected;
- (void)deleteFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator;
- (void)deleteOneDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *)deletingModel;
- (void)reloadFirstDisplayingModelWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator;

@end
