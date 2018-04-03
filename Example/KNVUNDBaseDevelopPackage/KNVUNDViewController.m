//
//  KNVUNDViewController.m
//  KNVUNDBaseDevelopPackage
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDViewController.h"

// Models
#import "KNVUNDETVRelatedTagButtonModel.h"

// Views
#import "KNVUNDETVRelatedTagButtonCell.h"

// Helpers
#import "KNVUNDButtonsSelectionHelper.h"
#import "KNVUNDExpendingTableViewRelatedHelper.h"

// Tools
#import "KNVUNDImageRelatedTool.h"

@interface KNVUNDViewController () <KNVUNDETVRelatedTagButtonModelDelegate> {
    KNVUNDButtonsSelectionHelper *_buttonsSelectionHelper;
    
    KNVUNDExpendingTableViewRelatedHelper *_expendingTableViewHelper;
    KNVUNDButtonsSelectionHelper *_etvButtonsSelectionHelper;
}

@property (weak, nonatomic) IBOutlet UITableView *testingTableView;

@end

@implementation KNVUNDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupTagButtons];
    [self setUpExpendableTable];
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
    
    _etvButtonsSelectionHelper = [KNVUNDButtonsSelectionHelper new];
    childOneForParentOne.relatedButtonSelectionHelper = _etvButtonsSelectionHelper;
    childTwoForParentOne.relatedButtonSelectionHelper = _etvButtonsSelectionHelper;
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
