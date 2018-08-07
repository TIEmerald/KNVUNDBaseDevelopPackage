//
//  KNVUNDETVRelatedBasicTableViewCell.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

#import "KNVUNDETVRelatedBasicTableViewCell.h"

@interface KNVUNDETVRelatedBasicTableViewCell()

// IBOutlets
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *expendingButton;

@end


@implementation KNVUNDETVRelatedBasicTableViewCell

#pragma mark - KNVUNDBasic
#pragma mark Class Methods
+ (NSString *)nibName
{
    return @"KNVUNDETVRelatedBasicTableViewCell";
}

+ (NSString *)cellIdentifierName
{
    return @"KNVUNDETVRelatedBasicTableViewCell";
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

#pragma mark Genral Method
- (void)updateCellUI
{
    [super updateCellUI];
    [self setupGeneralUIBasedOnModel];
    [self setupExpendedStatusUI];
    [self setupSelectedStatusUI];
    
}

#pragma mark - UITableViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Step One, Update Cell UI
    [self updateCellUI];
    
    // Step Two, Add Target and Action to Button.
    [self.expendingButton addTarget:self
                             action:@selector(expendingButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Methods for Override
- (void)setupExpendedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    if (isFirstTime) {
        self.expendingButton.hidden = !self.relatedModel.isExpendable;
        [self.expendingButton setTitle:@"+" forState:UIControlStateNormal];
        [self.expendingButton setTitle:@"-" forState:UIControlStateSelected];
    }
    self.expendingButton.selected = self.relatedModel.isExpended;
}

- (void)setupGeneralUIBasedOnModelWithFirstTimeCheck:(BOOL)isFirstTime
{
    self.titleLabel.text = self.relatedModel.associatedItem;
}

#pragma mark - IBActions
- (IBAction)expendingButtonTapped:(UIButton *)button
{
    if (self.relatedModel.isExpendable) {
        [self.relatedModel toggleExpendedStatus];
        [self setupExpendedStatusUI];
    }
}

@end
