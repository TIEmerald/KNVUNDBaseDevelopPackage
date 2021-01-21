//
//  KNVUNDPagingRelatedHelper.m
//  Expecta
//
//  Created by Erjian Ni on 27/7/18.
//

#import "KNVUNDPagingRelatedHelper.h"

@interface KNVUNDPagingRelatedHelper(){
    BOOL _couldLoadMore;
    NSMutableArray *_currentResultArray;
}

@end

@implementation KNVUNDPagingRelatedHelper

#pragma mark - Constants
NSInteger const KNVUNDPagingRelatedHelper_DefaultPagingLimit = 20;

#pragma mark - Getters & Setters
#pragma mark Getters
- (NSInteger)pageLimit
{
    if (!_pageLimit) {
        return KNVUNDPagingRelatedHelper_DefaultPagingLimit;
    }
    return _pageLimit;
}

- (NSArray *)currentPagingArray
{
    return _currentResultArray;
}

#pragma mark - Set Up Methods
- (void)setUpPaginRelatedHelperWithDelegate:(id<KNVUNDPagingRelatedHelperDelegate>)delegate andPagingLimit:(NSInteger)pagingLimit
{
    _currentResultArray = [NSMutableArray new];
    self.delegate = delegate;
    self.pageLimit = pagingLimit;
    [self resetCurrentHelper];
}

#pragma mark - General Method
- (void)resetCurrentHelper
{
    [_currentResultArray removeAllObjects];
    _couldLoadMore = YES;
    [self performOneMoreSearch];
}

- (void)showUpOneMorePage
{
    if (_couldLoadMore) {
        [self performOneMoreSearch];
    }
}

#pragma mark - Support Methods
- (void)performOneMoreSearch
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if ([self.delegate respondsToSelector:@selector(addNewOrMoreArrayWithLastFetchingObject:offset:limit:andInsertIntoArrayBlock:)]) {
            [self.delegate addNewOrMoreArrayWithLastFetchingObject:_currentResultArray.lastObject
                                                            offset:[_currentResultArray count]
                                                             limit:self.pageLimit
                                           andInsertIntoArrayBlock:^(NSArray *resultArray, BOOL couldLoadMore, BOOL shouldReloadDisplaying) {
                                               _couldLoadMore = couldLoadMore;
                                               [_currentResultArray addObjectsFromArray:resultArray];
                                               if (shouldReloadDisplaying && [self.delegate respondsToSelector:@selector(reloadDisplaying)]) {
                                                   [self.delegate reloadDisplaying];
                                               }
                                           }];
        }
    });
}

@end
