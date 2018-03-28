//
//  KNVUNDETVRelatedTagButtonModel.m
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by Erjian Ni on 23/3/18.
//  Copyright © 2018 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDETVRelatedTagButtonModel.h"

// View
#import "KNVUNDETVRelatedTagButtonCell.h"

@implementation KNVUNDETVRelatedTagButtonModel

#pragma mark - KNVUNDExpendingTableViewRelatedModel
#pragma mark - Class Methods
+ (Class _Nonnull)relatedTableViewCell
{
    return [KNVUNDETVRelatedTagButtonCell class];
}

#pragma mark - Getters & Setters
#pragma mark - General Method
- (NSString *)associatedString
{
    if ([self.associatedItem isKindOfClass:[NSString class]]) {
        return (NSString *)self.associatedItem;
    } else {
        return @"";
    }
}

@end
