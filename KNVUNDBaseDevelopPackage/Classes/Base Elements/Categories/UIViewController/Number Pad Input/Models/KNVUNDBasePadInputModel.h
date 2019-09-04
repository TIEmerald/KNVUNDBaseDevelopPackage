//
//  KNVUNDNumberPadInputHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 1/9/19.
//

#import "KNVUNDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

// This is the Number Pad Button Type we supported.
typedef enum : NSUInteger {
    KNVUNDBasePadIMButtonTag_Type_Append = 6001, // This type of button we will append the title of your button to displayed String
    KNVUNDBasePadIMButtonTag_Type_Delete = 6002, // This Delete button, we will remove the last digit of displayed String
    KNVUNDBasePadIMButtonTag_Type_Accumulate_Value = 6003, // This type of button we will accumulate the amount of your button's title to current displayed string
    KNVUNDBasePadIMButtonTag_Type_Decimal_Dot = 6004 // In some case they might use different separator as decimal dot other than "."
} KNVUNDBasePadIMButtonTagType;

@protocol KNVUNDBasePadInputModelDisplayUIProtocol <NSObject>

@optional
- (void)setAttributedText:(NSAttributedString *)attributedText; /// We are reserving Attribute Text
- (void)setText:(NSString *)text;

@end

@interface KNVUNDBasePadInputModel : KNVUNDBaseModel

@property (weak, nonatomic) id <KNVUNDBasePadInputModelDisplayUIProtocol> displayingUI;  /// Where you want to show up displayingString
@property (nonatomic) BOOL shouldResetValueForFirstInput;  /// By Default it's NO
@property (strong, nonatomic) NSLocale *usingLocale;  /// By Default it's [NSLocale currentLocale]

@property (strong, nonatomic) NSString *displayingString;  /// The string we are displaying.
@property (strong, nonatomic) NSString *rawString;   ///  The string we are

#pragma mark - General Method
- (void)tapedInputPadButton:(UIButton *)inputPadButton;

@end

NS_ASSUME_NONNULL_END
