//
//  UIViewController+KNVUNDNumberPadInput.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 1/9/19.
//

#import "UIViewController+KNVUNDNumberPadInput.h"

/// Libraries
#import <objc/runtime.h>

/// Helpers
#import "KNVUNDBasePadInputModel.h"

@interface UIViewController ()

@property (weak, nonatomic) IBOutlet UITextField *linkedDisplayTextField;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *appendTypeButtons; // The text value of the button will appended into displaying string
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *accumulateTypeButtons; // The numeric value of the button will accumulated into displayed value

@property (weak, nonatomic) IBOutlet UIButton *deleteButton; // The text value of the button will appended into displaying string
@property (weak, nonatomic) IBOutlet UIButton *decimalDotButton; // This button will control the decimal dot input

@property (readonly) KNVUNDBasePadInputModel *currentUsingInputModel;

@property (strong, nonatomic) KNVUNDBasePadInputModel *linkedDefaultInputModel;

@end

@implementation UIViewController (KNVUNDNumberPadInput)

#pragma mark - Getters && Setters
static void * UIViewController_LinkedDefaultNumberPadInputModel = &UIViewController_LinkedDefaultNumberPadInputModel;
#pragma mark - Getters
- (KNVUNDBasePadInputModel *)currentUsingInputModel
{
    return self.linkedDefaultInputModel;
}

- (KNVUNDBasePadInputModel *)linkedDefaultInputModel
{
    return objc_getAssociatedObject(self, UIViewController_LinkedDefaultNumberPadInputModel);
}

#pragma mark - Setters
- (void)setLinkedDefaultInputModel:(KNVUNDBasePadInputModel *)linkedDefaultInputModel
{
    objc_setAssociatedObject(self, UIViewController_LinkedDefaultNumberPadInputModel, linkedDefaultInputModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - General Methods
- (void)setUpNumberPadsInViewDidLoad
{
    for (UIButton * aButton in self.appendTypeButtons) {
        aButton.tag = KNVUNDBasePadIMButtonTag_Type_Append;
        [aButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton * aButton in self.accumulateTypeButtons) {
        aButton.tag = KNVUNDBasePadIMButtonTag_Type_Accumulate_Value;
        [aButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.deleteButton.tag = KNVUNDBasePadIMButtonTag_Type_Delete;
    [self.deleteButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.decimalDotButton.tag = KNVUNDBasePadIMButtonTag_Type_Decimal_Dot;
    [self.decimalDotButton addTarget:self action:@selector(numberPadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    KNVUNDBasePadInputModel *defaultInputModel = [KNVUNDBasePadInputModel new];
    defaultInputModel.displayingUI = self.linkedDisplayTextField;
    self.linkedDefaultInputModel = defaultInputModel;
}

#pragma mark - IBActions
- (IBAction)numberPadButtonDidTapped:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Button Type: %@ tapped", @(button.tag));
    [self.currentUsingInputModel tapedInputPadButton:sender];
}

@end
