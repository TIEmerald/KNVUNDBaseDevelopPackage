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

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSArray *)getDisplayingModelsWithPredicator:(BOOL(^)(KNVUNDExpendingTableViewRelatedModel *checkingModel))predicator;

#pragma mark - Setters
- (void)setUpAssociatedTableView:(UITableView *)associatedTableView;
- (void)setUpRelatedViewController:(UIViewController *)viewController;
- (void)setSupportedModelClasses:(NSArray *)supportedModelClasses;

#pragma mark - Set Up
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses andRelatedTableView:(UITableView *)relatedTableView;
- (void)setUpWithRootModelArray:(NSArray *)rootModelArray supportedModelClasses:(NSArray *)supportedModelClasses relatedViewController:(UIViewController *)viewController andRelatedTableView:(UITableView *)relatedTableView;

#pragma mark - General Methods
- (void)updateTableWithRootModelArray:(NSArray *)rootModelArray;
- (void)insertOneMoreRootModel:(KNVUNDExpendingTableViewRelatedModel *)insertingModel shouldMarkAsSelected:(BOOL)shouldMarkAsSelected;
- (void)deleteOneDisplayingModel:(KNVUNDExpendingTableViewRelatedModel *)deletingModel;

@end
