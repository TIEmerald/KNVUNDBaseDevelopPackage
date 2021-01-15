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
/*!
 * @brief This is the default init method of UNDPopOverListView, while you create UNDPopOverListView from this method, pls remember to add UNDPopOverListView into parent view manually.
 * @param list The of items you want to show up in PopOverListView, pls notice that these items should response to UNDPopOverListItemModelProtocol, you could use our Default Model UNDPopOverListItemModel or your customized models.
 * @param sourceRect The rect UNDPopOverListView is pointing to, the frame of this created UNDPopOverListView is based on this Rect.
 * @param arrowDirect In which direction should UNDPopOverListView show up.
 * @param selectionLogic The callback while user selected any items from the pop over list view.
 */
- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceRect:(CGRect)sourceRect arrowDirection:(UNDPopOverListViewArrowDirection)arrowDirect andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;

/*!
 * @brief This is init will handle how to add UNDPopOverListView into presentingView for you.
 * @param list The of items you want to show up in PopOverListView, pls notice that these items should response to UNDPopOverListItemModelProtocol, you could use our Default Model UNDPopOverListItemModel or your customized models.
 * @param sourceView The view UNDPopOverListView is pointing to, pls ensure this is a subview of presentingView, otherwise you might unable to get UNDPopOverListView be presented properly..
 * @param presentingView From which view you want UNDPopOverListView be presernted, A.K.A. UNDPopOverListView's superview.
 * @param arrowDirect In which direction should UNDPopOverListView show up.
 * @param selectionLogic The callback while user selected any items from the pop over list view.
 */
- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceView:(UIView *)sourceView presentingView:(UIView *)presentingView arrowDirection:(UNDPopOverListViewArrowDirection)arrowDirect andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;

#pragma mark - General Methods
- (void)updateList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)newList;

@end

NS_ASSUME_NONNULL_END
