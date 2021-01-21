//
//  KNVUNDPagingRelatedHelper.h
//  Expecta
//
//  Created by Erjian Ni on 27/7/18.
//

#import "KNVUNDBaseModel.h"

@protocol KNVUNDPagingRelatedHelperDelegate <NSObject>

// You need to implement the logic about how to get the array or more array for the current array
// Please
- (void)addNewOrMoreArrayWithLastFetchingObject:(id)lastFetching offset:(NSInteger)offset limit:(NSInteger)limit andInsertIntoArrayBlock:(void(^)(NSArray *resultArray, BOOL couldLoadMore, BOOL shouldReloadDisplaying))insertIntoArrayBlock;

// You need to implement the logic a bout how to reload the displaying UI after we update the result array.
- (void)reloadDisplaying;

@end


@interface KNVUNDPagingRelatedHelper : KNVUNDBaseModel

@property (nonatomic) NSInteger pageLimit;
@property (readonly) NSArray *currentPagingArray;
@property (readonly) BOOL couldLoadMore;
@property (weak, nonatomic) id<KNVUNDPagingRelatedHelperDelegate> delegate;

#pragma mark - Set Up Methods
- (void)setUpPaginRelatedHelperWithDelegate:(id<KNVUNDPagingRelatedHelperDelegate>)delegate andPagingLimit:(NSInteger)pagingLimit;

#pragma mark - General Method
- (void)resetCurrentHelper;
- (void)showUpOneMorePage;

@end
