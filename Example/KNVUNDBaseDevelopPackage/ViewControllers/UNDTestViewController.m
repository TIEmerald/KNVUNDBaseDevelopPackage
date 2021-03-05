//
//  UNDTestViewController.m
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by UNDaniel on 2021/3/5.
//  Copyright © 2021 niyejunze.j@gmail.com. All rights reserved.
//

#import "UNDTestViewController.h"

// Tools
#import "KNVUNDImageRelatedTool.h"

@interface UNDTestViewController ()

@end

@implementation UNDTestViewController

@synthesize sstConfigModel;

- (instancetype)init {
    if (self = [super init]) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width
                                               , 380.0);
        UNDSideSlideTransitioningConfigModel *config = [UNDSideSlideTransitioningConfigModel new];
        config.shouldDismissWhileClickBackground = YES;
        self.sstConfigModel = config;
        self.definesPresentationContext = true;
    }
    return self;
}


- (instancetype)initWithBackgroundColor:(UIColor *)backGroundColor {
    if (self = [self init]) {
        self.view.backgroundColor = backGroundColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTestButtonOne];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@", self.navigationController);
}

- (void)setUpTestButtonOne {
    UIButton *buttonOne = [self generateSelectionButton];
    [buttonOne setTitle:@"Button One"
               forState:UIControlStateNormal];
    [buttonOne addTarget:self action:@selector(testButtonOneAction:) forControlEvents:UIControlEventTouchUpInside];
    buttonOne.frame = CGRectMake(20, 20, 100, 40);
    [self.view addSubview:buttonOne];
    
    UIButton *buttonBack = [self generateSelectionButton];
    [buttonBack setTitle:@"Back"
               forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(testButtonBackAction:) forControlEvents:UIControlEventTouchUpInside];
    buttonBack.frame = CGRectMake(260, 20, 100, 40);
    [self.view addSubview:buttonBack];

}

- (IBAction)testButtonOneAction:(id)sender {
    UNDTestViewController *newViewController = [[UNDTestViewController alloc] initWithBackgroundColor:[UIColor redColor]];
    newViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:newViewController animated:true completion:nil];
}

- (IBAction)testButtonBackAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
