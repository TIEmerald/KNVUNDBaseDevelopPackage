//
//  KNVUNDETVRelatedTagButtonCell.m
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by Erjian Ni on 23/3/18.
//  Copyright © 2018 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDETVRelatedTagButtonCell.h"

// Models
#import "KNVUNDETVRelatedTagButtonModel.h"

// Tools
#import "KNVUNDImageRelatedTool.h"

@interface KNVUNDETVRelatedTagButtonCell()

@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@property (readonly) KNVUNDETVRelatedTagButtonModel *covertedAssociatedModel;

@end

@implementation KNVUNDETVRelatedTagButtonCell

#pragma mark - KNVUNDETVRelatedBasicTableViewCell
#pragma mark KNVUNDBasic
#pragma mark Class Methods
+ (NSString *)nibName
{
    return @"KNVUNDETVRelatedTagButtonCell";
}

+ (NSString *)cellIdentifierName
{
    return @"KNVUNDETVRelatedTagButtonCell";
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

#pragma mark Methods for Override
- (void)setupExpendedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    
}

- (void)setupGeneralUIBasedOnModelWithFirstTimeCheck:(BOOL)isFirstTime
{
    [super setupGeneralUIBasedOnModelWithFirstTimeCheck:isFirstTime];
    if (isFirstTime) {
        self.tagButton.userInteractionEnabled = NO;
        [self.tagButton setTitle:[self.covertedAssociatedModel associatedString]
                        forState:UIControlStateNormal];
        [self.tagButton setTitleColor:[UIColor blackColor]
                             forState:UIControlStateNormal];
        [self.tagButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateSelected];
        [self.tagButton setBackgroundImage:[KNVUNDImageRelatedTool generateImageWithColor:[UIColor clearColor]]
                                  forState:UIControlStateNormal];
        [self.tagButton setBackgroundImage:[KNVUNDImageRelatedTool generateImageWithColor:[UIColor blueColor]]
                                  forState:UIControlStateSelected];
    }
}

- (void)setupSelectedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    [super setupSelectedStatusUIWithFirstTimeCheck:isFirstTime];
    self.tagButton.selected = self.covertedAssociatedModel.isSelected;
    if (self.covertedAssociatedModel.isSelected) {
        [self.covertedAssociatedModel tapTagButton];
    }
}

- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel
{
    if ([associatdModel isKindOfClass:[KNVUNDETVRelatedTagButtonModel class]]) {
        [super setupCellWitKNVUNDWithModel:associatdModel];
    }
}

#pragma mark - Getters & Setters
#pragma mark - Getters
- (KNVUNDETVRelatedTagButtonModel *)covertedAssociatedModel
{
    return (KNVUNDETVRelatedTagButtonModel *)self.relatedModel;
}

//#pragma mark - Support Methods
//- (void)replaceSubView:(UIView *)subView withAnotherView:(UIView *)anotherView
//{
//    UIView *superView = subView.superview;
//    if (superView && anotherView) {
//        /// Step One, Add another View into Sub View.
//        [superView addSubview:anotherView];
//
//        /// Step Two, Update self Constraint the new view.
//        for (NSLayoutConstraint *constraint in subView.constraints) {
//            NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:(constraint.firstItem == subView) ? anotherView : constraint.firstItem
//                                                                             attribute:constraint.firstAttribute
//                                                                             relatedBy:constraint.relation
//                                                                                toItem:(constraint.secondItem == subView) ? anotherView : constraint.secondItem
//                                                                             attribute:constraint.secondAttribute
//                                                                            multiplier:constraint.multiplier
//                                                                              constant:constraint.constant];
//            [anotherView addConstraint:newConstraint];
//        }
//
//        /// Step Three, Update the containning in super view
//        for (NSLayoutConstraint *constraint in superView.constraints) {
//            if (constraint.firstItem == subView) {
//                NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:anotherView
//                                                                                 attribute:constraint.firstAttribute
//                                                                                 relatedBy:constraint.relation
//                                                                                    toItem:constraint.secondItem
//                                                                                 attribute:constraint.secondAttribute
//                                                                                multiplier:constraint.multiplier
//                                                                                  constant:constraint.constant];
//                [superView removeConstraint:newConstraint];
//                [superView addConstraint:newConstraint];
//            }
//
//            if (constraint.secondItem == subView) {
//                NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
//                                                                                 attribute:constraint.firstAttribute
//                                                                                 relatedBy:constraint.relation
//                                                                                    toItem:anotherView
//                                                                                 attribute:constraint.secondAttribute
//                                                                                multiplier:constraint.multiplier
//                                                                                  constant:constraint.constant];
//                [superView removeConstraint:newConstraint];
//                [superView addConstraint:newConstraint];
//            }
//        }
//
//        /// Step Four, Remove the target View
//        [subView removeFromSuperview];
//
//        /// Step Five, Set up Layout
//        [subView layoutIfNeeded];
//    }
//}

@end
