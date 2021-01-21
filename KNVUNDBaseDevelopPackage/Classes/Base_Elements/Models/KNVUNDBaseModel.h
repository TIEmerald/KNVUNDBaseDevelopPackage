//
//  KNVUNDBaseModel.h
//  Expecta
//
//  Created by Erjian Ni on 8/12/17.
//

#import <Foundation/Foundation.h>

// Categories
#import "NSObject+KNVUNDEqualityChecking.h"
#import "NSObject+KNVUNDLogRelated.h"

@interface KNVUNDBaseModel : NSObject

@property (nonatomic, strong, nonnull) NSString *debugDescriptionIndentString;

#pragma mark - Properties Related
+ (NSDictionary *_Nonnull)propertyDescriptions;

@end
