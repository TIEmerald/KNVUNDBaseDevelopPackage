//
//  KNVUNDViewController.m
//  KNVUNDBaseDevelopPackage
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDViewController.h"

// Helpers
#import "KNVUNDButtonsSelectionHelper.h"
#import "KNVUNDImageRelatedTool.h"

@interface KNVUNDViewController () {
    KNVUNDButtonsSelectionHelper *_buttonsSelectionHelper;
}

@end

@implementation KNVUNDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    KNVUNDButtonsSelectionButton *buttonOne = [self generateSelectionButton];
    [buttonOne setTitle:@"Button One"
               forState:UIControlStateNormal];
    buttonOne.frame = CGRectMake(20, 20, 100, 40);
    [self.view addSubview:buttonOne];
    
    KNVUNDButtonsSelectionButton *buttonTwo = [self generateSelectionButton];
    [buttonTwo setTitle:@"Button Two"
               forState:UIControlStateNormal];
    buttonTwo.frame = CGRectMake(140, 20, 100, 40);
    [self.view addSubview:buttonTwo];
    
    KNVUNDButtonsSelectionButton *buttonThree = [self generateSelectionButton];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Support Methods
- (KNVUNDButtonsSelectionButton *)generateSelectionButton
{
    KNVUNDButtonsSelectionButton *returnButton = [KNVUNDButtonsSelectionButton new];
    
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
