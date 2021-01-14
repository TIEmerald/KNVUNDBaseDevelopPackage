//
//  UNDPopOverListItemModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#import "UNDPopOverListItemModel.h"

// Cell
#import "UNDPopOverListBaseTableViewCell.h"

@interface UNDPopOverListItemModel()

@property (nonatomic, strong) NSAttributedString *displayString;

@end

@implementation UNDPopOverListItemModel

#pragma mark - Init
- (instancetype)initWithAttributeString:(NSAttributedString *)displayString {
    if (self = [self init]) {
        self.displayString = displayString;
    }
    return self;
}

#pragma mark - UNDPopOverListItemModelProtocol
- (Class<UNDPopOverListTableViewCellProtocol>)relatedCellClass {
    return [UNDPopOverListBaseTableViewCell class];
}

- (void)updateDisplayUIFromCell:(UITableViewCell<UNDPopOverListTableViewCellProtocol> *)aCell {
    aCell.mainTextLabel.attributedText = self.displayString;
}

@end
