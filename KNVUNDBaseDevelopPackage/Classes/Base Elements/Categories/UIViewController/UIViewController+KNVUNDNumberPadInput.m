//
//  UIViewController+KNVUNDNumberPadInput.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 1/9/19.
//

#import "UIViewController+KNVUNDNumberPadInput.h"

/// Helpers
#import "KNVUNDNumberPadInputHelper.h"

@interface UIViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *appendTypeButtons; // The text value of the button will appended into displaying string
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *accumulateTypeButtons; // The numeric value of the button will accumulated into displayed value

@property (weak, nonatomic) IBOutlet UIButton *deleteButton; // The text value of the button will appended into displaying string
@property (weak, nonatomic) IBOutlet UIButton *decimalDotButton; // This button will control the decimal dot input

@end

@implementation UIViewController (KNVUNDNumberPadInput)

//#pragma mark - Getters && Setters
//static void * UIViewController_AppendTypeButtons = &UIViewController_AppendTypeButtons;

#pragma mark - Getters
//- (NSArray *)getAppendTypeButtons
//{
//    return objc_getAssociatedObject(self, UIViewController_AppendTypeButtons);
//}

//#pragma mark - Setters
//- (void)setAppendTypeButtons:(NSArray *)appendTypeButtons
//{
//    objc_setAssociatedObject(self, UIViewController_AppendTypeButtons, appendTypeButtons, OBJC_ASSOCIATION_ASSIGN);
//}

#pragma mark - General Methods
- (void)setUpNumberPadsInViewDidLoad
{
    for (UIButton * aButton in self.appendTypeButtons) {
        aButton.tag = KNVUNDNumberPadIHButtonTag_Type_Append;
        [aButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton * aButton in self.accumulateTypeButtons) {
        aButton.tag = KNVUNDNumberPadIHButtonTag_Type_Accumulate_Integer;
        [aButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.deleteButton.tag = KNVUNDNumberPadIHButtonTag_Type_Delete;
    [self.deleteButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.decimalDotButton.tag = KNVUNDNumberPadIHButtonTag_Type_Decimal_Dot;
    [self.decimalDotButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - IBActions
- (IBAction)numberPadButtonDidTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Button Type: %@ tapped", @(button.tag));
    switch (button.tag) {
//        case KNVNumberPadIHButtonTag_Type_Append:
//        case KNVNumberPadIHButtonTag_Type_Delete:
//        case KNVNumberPadIHButtonTag_Type_Accumulate_Integer:
//        case KNVNumberPadIHButtonTag_Type_Decimal_Dot:
//            [_numberPadHelper tapedNumberPadButton:button];
            break;
        default:
            break;
    }
}

@end
