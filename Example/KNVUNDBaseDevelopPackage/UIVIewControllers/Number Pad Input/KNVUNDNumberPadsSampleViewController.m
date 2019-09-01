//
//  KNVUNDNumberPadsSampleViewController.m
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by Erjian Ni on 1/9/19.
//  Copyright © 2019 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDNumberPadsSampleViewController.h"

// Categories
#import "UIViewController+KNVUNDNumberPadInput.h"

@interface KNVUNDNumberPadsSampleViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *appendTypeButtons; // The text value of the button will appended into displaying string
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *accumulateTypeButtons; // The text value of the button will appended into displaying string

@property (weak, nonatomic) IBOutlet UIButton *deleteButton; // The text value of the button will appended into displaying string
@property (weak, nonatomic) IBOutlet UIButton *decimalDotButton; // This button will control the decimal dot input

@end

@implementation KNVUNDNumberPadsSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNumberPadsInViewDidLoad];
}

@end
