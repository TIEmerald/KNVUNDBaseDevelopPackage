//
//  KNVUNDViewController.m
//  KNVUNDBaseDevelopPackage
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDViewController.h"

// Pods
#import <LinqToObjectiveC/LinqToObjectiveC.h>

// Models
#import "KNVUNDETVRelatedTagButtonModel.h"
#import "UNDPopOverListItemModel.h"

// Views
#import "KNVUNDETVRelatedTagButtonCell.h"
#import "UNDPopOverListView.h"

// Helpers
#import "KNVUNDButtonsSelectionHelper.h"
#import "KNVUNDExpendingTableViewRelatedHelper.h"

// Tools
#import "KNVUNDImageRelatedTool.h"

@interface KNVUNDViewController () <KNVUNDETVRelatedTagButtonModelDelegate, UITextFieldDelegate> {
    KNVUNDButtonsSelectionHelper *_buttonsSelectionHelper;
    
    KNVUNDExpendingTableViewRelatedHelper *_expendingTableViewHelper;
    KNVUNDButtonsSelectionHelper *_etvButtonsSelectionHelper;
    
    NSArray *_cachedStringArray;
}

@property (weak, nonatomic) IBOutlet UITextField *testingTextField;
@property (weak, nonatomic) IBOutlet UITableView *testingTableView;

@property (strong, nonatomic) UNDPopOverListView *popOverListView;

@end

@implementation KNVUNDViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [self setupTagButtons];
    [self setUpExpendableTable];
    
    self.testingTextField.delegate = self;
    _cachedStringArray = @[@"Test One - Four Seasons Hotel Jakarta, JI. Daan Mogo Something I don't know",
                           @"Test Two - JI. Daan Mogot Dalam kali Duri, RT. 10/ RW. 1 Something I don't know",
                           @"Test Three - JI. Daan Mogot Selatan Sekretaris, RT.3/RW.2 Something I don't know",
                           @"Test Four - JI. Daan Mogot Utara, Gang 0, RT.6 / RW.3 Something I don't know",
                           @"Five - JI. Daan Mogot Utara Kali Kelawang, RT.5/RW.3 Something I don't know",
                           @"Test Six - JI. Daan Mogot Karle Jods Ce RT. 2/ RW. 7 Something I don't know",
                           @"Seven - JI. Daan Mogot Edurs Puffur, RT. 10/ RW. 1 Something I don't know",
                           @"Test Eight - JI. Daan Mogot Dalam kali Duri, RT. 10/ RW. 1 Something I don't know"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Support Methods
- (void)setupTagButtons
{
    UIButton *buttonOne = [self generateSelectionButton];
    [buttonOne setTitle:@"Button One"
               forState:UIControlStateNormal];
    [buttonOne setUpWithSelectedFunction:^(UIButton * _Nonnull relatedButton) {
        [self displayBannerMessageWithBannerType:KNVUNDBaseVCBannerMessageType_Notify
                                           title:@"Test Banner Title"
                                      andMessage:@"Test Banner Message"];
    } andDeSelectedFunction:^(UIButton * _Nonnull relatedButton) {
        
    }];
    buttonOne.frame = CGRectMake(20, 20, 100, 40);
    [self.view addSubview:buttonOne];
    
    UIButton *buttonTwo = [self generateSelectionButton];
    [buttonTwo setTitle:@"Button Two"
               forState:UIControlStateNormal];
    buttonTwo.frame = CGRectMake(140, 20, 100, 40);
    [self.view addSubview:buttonTwo];
    
    UIButton *buttonThree = [self generateSelectionButton];
    [buttonThree setTitle:@"Button Three"
                 forState:UIControlStateNormal];
    buttonThree.frame = CGRectMake(260, 20, 100, 40);
    [self.view addSubview:buttonThree];
    
    _buttonsSelectionHelper = [KNVUNDButtonsSelectionHelper new];
    [_buttonsSelectionHelper setupWithHelperButtonsArray:@[buttonOne, buttonTwo, buttonThree]
                                     withSelectedButtons:nil];
    _buttonsSelectionHelper.isSingleSelection = YES;
    _buttonsSelectionHelper.isForceSelection = YES;
}

- (void)setUpExpendableTable
{
    KNVUNDExpendingTableViewRelatedModel *parentOne =  [KNVUNDExpendingTableViewRelatedModel new];
    parentOne.associatedItem = @"Parent One";
    KNVUNDETVRelatedTagButtonModel *childOneForParentOne =  [KNVUNDETVRelatedTagButtonModel new];
    childOneForParentOne.associatedItem = @"Child One for Parent One";
    childOneForParentOne.tagButtonDelegate = self;
    KNVUNDETVRelatedTagButtonModel *childTwoForParentOne =  [KNVUNDETVRelatedTagButtonModel new];
    childTwoForParentOne.associatedItem = @"Child Two for Parent One";
    childTwoForParentOne.tagButtonDelegate = self;
    parentOne.children = @[childOneForParentOne, childTwoForParentOne];
    
    KNVUNDExpendingTableViewRelatedModel *parentTwo =  [KNVUNDExpendingTableViewRelatedModel new];
    parentTwo.associatedItem = @"Parent Two";
    
    _expendingTableViewHelper = [KNVUNDExpendingTableViewRelatedHelper new];
    _expendingTableViewHelper.isSingleSelection = YES;
    [_expendingTableViewHelper setUpWithRootModelArray:@[parentOne, parentTwo]
                                 supportedModelClasses:@[[KNVUNDExpendingTableViewRelatedModel class],
                                                         [KNVUNDETVRelatedTagButtonModel class]]
                                   andRelatedTableView:self.testingTableView];
    
    NSArray *usingButtons = [parentOne.children linq_select:^UIButton *(KNVUNDETVRelatedTagButtonModel *item) {
        return item.associatedTagButton;
    }];
    _etvButtonsSelectionHelper = [KNVUNDButtonsSelectionHelper new];
    [_etvButtonsSelectionHelper setupWithHelperButtonsArray:usingButtons
                                        withSelectedButtons:nil];
    _etvButtonsSelectionHelper.isSingleSelection = YES;
    _etvButtonsSelectionHelper.isForceSelection = YES;
}

#pragma mark - Delegates
#pragma mark - KNVUNDETVRelatedTagButtonModelDelegate
- (void)tagButtonSelectedWithModel:(KNVUNDETVTagButtonRelatedBaseModel *)relatedModel
{
    [self displayBannerMessageWithBannerType:KNVUNDBaseVCBannerMessageType_Notify
                                       title:[NSString stringWithFormat:@"Tag Button %@ Tapped", [(KNVUNDETVRelatedTagButtonModel *)relatedModel associatedString]]
                                  andMessage:@"Banner Message"];
}

- (void)tagButtonDeSelectedWithModel:(KNVUNDETVTagButtonRelatedBaseModel *)relatedModel
{
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableArray *resultList = [NSMutableArray new];
    for (NSString *item in _cachedStringArray) {
        NSRange boldRange = [item rangeOfString:newString];
        if (boldRange.location != NSNotFound) {
            NSMutableAttributedString *tempString = [[NSMutableAttributedString alloc] initWithString:item];
            [tempString addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"Helvetica-Bold" size:17.0] range:boldRange];
            [resultList addObject:[[UNDPopOverListItemModel alloc] initWithAttributeString:tempString]];
        }
    }
    if (self.popOverListView.superview != nil) {
        [self.popOverListView updateList:resultList];
    } else {
        self.popOverListView = [[UNDPopOverListView alloc] initWithList:resultList
                                                             sourceRect:textField.frame
                                                         arrowDirection:UNDPopOverListViewArrowDirectionTop
                                                 andSelectionLogicBlock:^(id _Nonnull item) {
            
        }];
        [self.view addSubview:self.popOverListView];
    }
    return true;
}

#pragma mark - Support Methods
- (UIButton *)generateSelectionButton
{
    UIButton *returnButton = [UIButton new];
    
    [returnButton setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateSelected];
    [returnButton setBackgroundImage:[KNVUNDImageRelatedTool generateImageWithColor:[UIColor clearColor]]
                            forState:UIControlStateNormal];
    [returnButton setBackgroundImage:[KNVUNDImageRelatedTool generateImageWithColor:[UIColor blueColor]]
                            forState:UIControlStateSelected];
    
    returnButton.userInteractionEnabled = YES;
    returnButton.enabled = YES;
    
    return returnButton;
}

@end
