//
//  UNDPopOverListBaseTableViewCell.m
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#import "UNDPopOverListBaseTableViewCell.h"

@interface UNDPopOverListBaseTableViewCell()

@property (nonatomic, strong) UILabel *usingTextLabel;

@end

@implementation UNDPopOverListBaseTableViewCell

#pragma mark - Constants
NSString *const UNDPopOverListBaseTableViewCellIdentifier = @"UNDPopOverListBaseTableViewCellIdentifier";

#pragma mark - UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.usingTextLabel = [UILabel new];
        self.usingTextLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:self.usingTextLabel];
        
        NSDictionary *viewInfo = @{@"label": self.usingTextLabel};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[label]-(0)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewInfo]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[label]-(0)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewInfo]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol
#pragma mark - UNDPopOverListTableViewCellProtocol
+ (NSString *)cellIdentifier
{
    return UNDPopOverListBaseTableViewCellIdentifier;
}

- (UILabel *)mainTextLabel
{
    return self.usingTextLabel;
}

@end
