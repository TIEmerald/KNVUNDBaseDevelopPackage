//
//  KNVUNDETVRelatedBasicTableViewCell.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

#import "KNVUNDETVRelatedBasicTableViewCell.h"

// Tools
#import "KNVUNDColourRelatedTool.h"

@interface KNVUNDETVRelatedBasicTableViewCell(){
    BOOL _hasUIInitialised; // This property will tell use that if the Cell's UI has initialised or not.... If the UI has Initialised.... there are several UI updating Method won't be called anymore.
}

// Models
@property (nonatomic, weak) KNVUNDExpendingTableViewRelatedModel *currentStoredETVModel;

// IBOutlets
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *expendingButton;

@end


@implementation KNVUNDETVRelatedBasicTableViewCell

#pragma mark - Constant
NSString *const KNVUNDETVRelatedBasicTableViewCell_SelectedBackendColour = @"#7babf744";
NSString *const KNVUNDETVRelatedBasicTableViewCell_UnSelectedBackendColour = @"#eeeeee";

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

#pragma mark UITableViewDelegate Related
- (void)didSelectedCurrentCell
{
    if (_currentStoredETVModel.isSelectable) {
        [_currentStoredETVModel toggleSelectionStatus];
        [self setupSelectedStatusUI];
    }
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
}

#pragma mark - Methods for Override
- (void)setupExpendedStatusUI
{
    if (!_hasUIInitialised) {
        self.expendingButton.hidden = _currentStoredETVModel.isExpendable;
        [self.expendingButton setTitle:@"+" forState:UIControlStateNormal];
        [self.expendingButton setTitle:@"-" forState:UIControlStateSelected];
    }
    self.expendingButton.selected = _currentStoredETVModel.isExpended;
}

- (void)setupGeneralUIBasedOnModel
{
    self.titleLabel.text = _currentStoredETVModel.associatedItem;
}

- (void)setupSelectedStatusUI
{
    if (_currentStoredETVModel.isSelected) {
        self.backgroundColor = [KNVUNDColourRelatedTool colorWithHexString:KNVUNDETVRelatedBasicTableViewCell_SelectedBackendColour];
    } else {
        self.backgroundColor = [KNVUNDColourRelatedTool colorWithHexString:KNVUNDETVRelatedBasicTableViewCell_UnSelectedBackendColour];;
    }
}

#pragma mark - Gettes && Setters
#pragma mark - Setters
- (void)setCurrentStoredETVModel:(KNVUNDExpendingTableViewRelatedModel *)currentStoredETVModel
{
    _currentStoredETVModel = currentStoredETVModel;
    [self setupExpendedStatusUI];
}

#pragma mark - Set up
- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel
{
    self.currentStoredETVModel = associatdModel;
    [self updateCellUI];
}

#pragma mark - IBActions
- (IBAction)expendingButtonTapped:(UIButton *)button
{
    if (_currentStoredETVModel.isExpendable) {
        [_currentStoredETVModel toggleExpendedStatus];
        [self setupExpendedStatusUI];
    }
}

@end
