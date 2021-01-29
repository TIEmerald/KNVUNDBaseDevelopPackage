//
//  UNDPopOverListItemModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#import "UNDPopOverListItemModel.h"

// Cell
#import "UNDPopOverListBaseTableViewCell.h"

@interface UNDPopOverListItemModel() {
    id _cachedData;
}

@property (nonatomic, strong) NSAttributedString *displayString;

@end

@implementation UNDPopOverListItemModel

#pragma mark - Accessors
#pragma mark - Setters
- (void)setCachedData:(id)cachedData {
    _cachedData = cachedData;
    self.isSelectable = true; // by default if model has cached data, it will become selectable.
}

#pragma mark - Init
- (instancetype)initWithAttributeString:(NSAttributedString *)displayString {
    if (self = [self init]) {
        self.displayString = displayString;
    }
    return self;
}

#pragma mark - UNDPopOverListItemModelProtocol
- (BOOL)isSelectable {
    return _isSelectable;
}

- (id)cachedData {
    return _cachedData;
}

- (Class<UNDPopOverListTableViewCellProtocol>)relatedCellClass {
    return [UNDPopOverListBaseTableViewCell class];
}

- (void)updateDisplayUIFromCell:(UITableViewCell<UNDPopOverListTableViewCellProtocol> *)aCell {
    aCell.mainTextLabel.attributedText = self.displayString;
}

@end
