//
//  UNDPopOverListItemModel.h
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#import <Foundation/Foundation.h>

// Protocols
#import "UNDPopOverListItemModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UNDPopOverListItemModel : NSObject <UNDPopOverListItemModelProtocol>

@property (nonatomic) BOOL isSelectable;
@property (nonatomic, strong) id cachedData;

- (instancetype)initWithAttributeString:(NSAttributedString *)displayString;

@end

NS_ASSUME_NONNULL_END
