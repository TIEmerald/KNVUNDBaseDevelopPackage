//
//  UNDPopOverListExampleTableViewCell.m
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by UNDaniel on 2021/1/15.
//  Copyright © 2021 niyejunze.j@gmail.com. All rights reserved.
//

#import "UNDPopOverListExampleTableViewCell.h"

///  Models
#import "UNDPopOverListItemModel.h"

/// Views
#import "UNDPopOverListView.h"

@interface UNDPopOverListExampleTableViewCell() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UNDPopOverListView *popOverListView;

@end

@implementation UNDPopOverListExampleTableViewCell

+ (NSString *)cellIdentifier {
    return @"UNDPopOverListExampleTableViewCell";
}

#pragma mark - UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.inputTextField = [UITextField new];
        self.inputTextField.translatesAutoresizingMaskIntoConstraints = false;
        self.inputTextField.borderStyle = UITextBorderStyleBezel;
        self.inputTextField.delegate = self;
        [self.contentView addSubview:self.inputTextField];
        
        NSDictionary *viewInfo = @{@"textfield": self.inputTextField};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[textfield]-(20)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewInfo]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[textfield]-(20)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewInfo]];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([self.delegate respondsToSelector:@selector(popoverListPresentingView)]) {
        UIView *preserntingView = [self.delegate popoverListPresentingView];
        NSMutableArray *resultList = [NSMutableArray new];
        NSArray *originalArray = [NSArray new];
        if ([self.delegate respondsToSelector:@selector(fetchingOriginArray)]) {
            originalArray = [self.delegate fetchingOriginArray];
        }
        for (NSString *item in originalArray) {
            NSRange boldRange = [item rangeOfString:newString];
            if (boldRange.location != NSNotFound) {
                NSMutableAttributedString *tempString = [[NSMutableAttributedString alloc] initWithString:item];
                [tempString addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Helvetica-Bold" size:17.0] range:boldRange];
                UNDPopOverListItemModel *listItem = [[UNDPopOverListItemModel alloc] initWithAttributeString:tempString];
                listItem.cachedData = item;
                [resultList addObject:listItem];
            }
        }
        if (self.popOverListView.superview != nil) {
            [self.popOverListView updateList:resultList];
        } else {
            __weak typeof(self) weakSelf = self;
            self.popOverListView = [[UNDPopOverListView alloc] initWithList:resultList
                                                                 sourceRect:[self.contentView convertRect:textField.frame
                                                                                                   toView:preserntingView]
                                                             arrowDirection:UNDPopOverListViewArrowDirectionTop
                                                     andSelectionLogicBlock:^(NSString *_Nonnull item) {
                textField.text = item;
                [weakSelf.popOverListView removeFromSuperview];
                weakSelf.popOverListView = nil;
            }];
            [preserntingView addSubview:self.popOverListView];
        }
    }
    return true;
}

@end
