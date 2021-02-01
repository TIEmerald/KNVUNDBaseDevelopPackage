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
typedef UIView *_Nonnull(^UNDPopOverListLoadingViewBlock)(void);

@interface UNDPopOverListViewConfiguration : NSObject

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat arrowWidth;
@property (nonatomic) CGFloat defaultCellHeight;
@property (nonatomic) CGFloat arrowPointRatio;

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGColorRef borderColor;

@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) CGFloat shadowRadius;
@property (nonatomic) CGFloat shadowOpacity;
@property (nonatomic) CGColorRef shadowColor;

@property (nonatomic) UIEdgeInsets margin;
@property (nonatomic) UIEdgeInsets padding;

@property (nonatomic) int maxmumDisplayCell; // Default is 5

@property (nonatomic) UNDPopOverListViewArrowDirection arrowDirection;
@property (nonatomic) UNDPopOverListLoadingViewBlock loadingViewGenerator; // If loading view generator is provided, we will show up loading view with defaultCellHeight inside the pop over list loading view

@end

@interface UNDPopOverListView : UIView

#pragma mark - Init

/*!
 * @brief This is a default init method of LAAPopOverListView, while you create LAAPopOverListView from this method, pls remember to add LAAPopOverListView into parent view manually. You could customise the pop over view by using different configuration model
 * @param list The of items you want to show up in PopOverListView, pls notice that these items should response to LAAPopOverListItemModelProtocol, you could use our Default Model LAAPopOverListItemModel or your customized models.
 * @param sourceRect The rect LAAPopOverListView is pointing to, the frame of this created LAAPopOverListView is based on this Rect.
 * @param configuration Configuration decides how is the PopOverList View generally looks like.
 * @param selectionLogic The callback while user selected any items from the pop over list view.
 */
- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceRect:(CGRect)sourceRect configuration:(UNDPopOverListViewConfiguration *)configuration andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;

/*!
 * @brief This is a default init method of LAAPopOverListView, which is using the default configuration, while you create LAAPopOverListView from this method, pls remember to add LAAPopOverListView into parent view manually.
 * @param list The of items you want to show up in PopOverListView, pls notice that these items should response to LAAPopOverListItemModelProtocol, you could use our Default Model LAAPopOverListItemModel or your customized models.
 * @param sourceRect The rect LAAPopOverListView is pointing to, the frame of this created LAAPopOverListView is based on this Rect.
 * @param arrowDirect In which direction should LAAPopOverListView show up.
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
// This method will decide arrowDirection automatically based on the sourceView and preserntingView
- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceView:(UIView *)sourceView presentingView:(UIView *)presentingView andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;
// Compare to the init above, this method provide the ability to customise pop over view.
- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceView:(UIView *)sourceView presentingView:(UIView *)presentingView configuration:(UNDPopOverListViewConfiguration *)configuration andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;

// Just inited a nil list. Pls be aware that Loading View related methods only works while configuration.loadingViewGenerator is valid.
- (instancetype)initLoadingViewWithSourceView:(UIView *)sourceView presentingView:(UIView *)presentingView configuration:(UNDPopOverListViewConfiguration *)configuration andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;

#pragma mark - General Methods
/*!
 * @brief Call this method to update the content of PopOverListView
 * @param newList The new list PopOverListView want to present.
 */
- (void)updateList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)newList;
// Update list as well as selection logic block
- (void)updateList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)newList andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic;

// Pls be aware that Loading View related methods only works while configuration.loadingViewGenerator is valid.
- (void)showUpLoadingView;

@end

NS_ASSUME_NONNULL_END
