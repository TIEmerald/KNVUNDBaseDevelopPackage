//
//  UNDPopOverListView.h
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#import <UIKit/UIKit.h>

// Protocols
#import "UNDPopOverListItemModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UNDPopOverListViewArrowDirectionBottom,
    UNDPopOverListViewArrowDirectionTop
} UNDPopOverListViewArrowDirection;

typedef void(^UNDPopOverListCellSelectionBlock)(id);

@interface UNDPopOverListView : UIView

#pragma mark - Init
- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceRect:(CGRect)sourceRect arrowDirection:(UNDPopOverListViewArrowDirection)arrowDirect andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;

#pragma mark - General Methods
- (void)updateList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)newList;

@end

NS_ASSUME_NONNULL_END
