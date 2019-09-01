//
//  KNVUNDNumberPadInputHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 1/9/19.
//

#import "KNVUNDBaseModel.h"


// This is the Number Pad Button Type we supported.
typedef enum : NSUInteger {
    KNVUNDNumberPadIHButtonTag_Type_Append = 6001, // This type of button we will append the title of your button to displayed String
    KNVUNDNumberPadIHButtonTag_Type_Delete = 6002, // This Delete button, we will remove the last digit of displayed String
    KNVUNDNumberPadIHButtonTag_Type_Accumulate_Integer = 6003, // This type of button we will accumulate the amount of your button's title to current displayed string
    KNVUNDNumberPadIHButtonTag_Type_Decimal_Dot = 6004 // In some case they might use different separator as decimal dot other than "."
} KNVUNDNumberPadIHButtonTagType;

NS_ASSUME_NONNULL_BEGIN

@interface KNVUNDNumberPadInputHelper : KNVUNDBaseModel

@end

NS_ASSUME_NONNULL_END
