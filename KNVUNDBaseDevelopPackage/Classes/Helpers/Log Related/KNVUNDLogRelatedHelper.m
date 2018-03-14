//
//  KNVUNDLogRelatedHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 11/1/18.
//

#import "KNVUNDLogRelatedHelper.h"

@implementation KNVUNDLogRelatedHelperContentModel

#pragma mark - Getters & Setters
#pragma mark - Getters
- (NSString *)descriptionString
{
    return _descriptionString ?: @"";
}

#pragma mark - Initial
- (instancetype)initWithDescriptionString:(NSString *_Nonnull)descriptionString andContentValue:(id _Nonnull)contentValue
{
    if (self = [self init]) {
        self.descriptionString = descriptionString;
        self.contentValue = contentValue;
    }
    return self;
}

@end

@implementation KNVUNDLogRelatedHelper {
    NSString *_tempStoredString;
}

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSString *)indentString
{
    return _indentString ?: @"";
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        _tempStoredString = @"";
    }
    return self;
}

#pragma mark - General Methods
#pragma mark - Appending
- (void)appendLogStringWithObjectArray:(NSArray<id<KNVUNDLogRelatedModelProtocol>> *)objectArray andObjectName:(NSString *_Nonnull)objectName
{
    [self appendLogStringWithTitle:[NSString stringWithFormat:@"\n\n%@ Details:", objectName]
             andCurrentIndentLevel:0];
    NSNumber *objectCounts = @(objectArray.count);
    if (objectCounts.integerValue == 0) {
        [self appendLogStringWithTitle:[NSString stringWithFormat:@"No %@.", objectName]
                 andCurrentIndentLevel:1];
    } else {
        NSMutableArray *usingArray = [NSMutableArray new];
        int indexValue = 1;
        for (id<KNVUNDLogRelatedModelProtocol> object in objectArray) {
            [usingArray addObject:[[KNVUNDLogRelatedHelperContentModel alloc] initWithDescriptionString:[NSString stringWithFormat:@"-- %@ (%@ / %@)",
                                                                                                         objectName,
                                                                                                         @(indexValue),
                                                                                                         objectCounts]
                                                                                        andContentValue:object]];
        }
        [self appendLogStringWithTitle:[NSString stringWithFormat:@"Has %@ %@s",
                                        objectCounts,
                                        objectName]
                                contentModelArrays:usingArray
                             andCurrentIndentLevel:1];
    }
}

- (void)appendLogStringWithTitle:(NSString *_Nonnull)titleString andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    [self appendLogStringWithTitle:titleString
                contentModelArrays:@[]
             andCurrentIndentLevel:currentIndentLevel];
}

- (void)appendLogStringWithTitle:(NSString *_Nonnull)titleString contentModelArrays:(NSArray *_Nonnull)contentArray andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    NSString *currentIndentString = @"";
    for (int index = 0; index < currentIndentLevel; index += 1 ) {
        currentIndentString = [currentIndentString stringByAppendingString:self.indentString];
    }
    
    NSString *returnString = [NSString stringWithFormat:@"%@%@\n",
                              currentIndentString,
                              titleString];
    
    NSString *furtherIndentString = [NSString stringWithFormat:@"%@%@",
                                     currentIndentString,
                                     self.indentString];
    
    for (KNVUNDLogRelatedHelperContentModel *contentModel in contentArray) {
        NSString *keyString = contentModel.descriptionString;
        id value = contentModel.contentValue;
        if ([value respondsToSelector:@selector(getSelfLogStringWithTitle:andIndentString:andCurrentIndentLevel:)]) {
            returnString = [returnString stringByAppendingString:[value getSelfLogStringWithTitle:keyString
                                                                                  andIndentString:self.indentString
                                                                            andCurrentIndentLevel:currentIndentLevel + 1]];
        } else {
            returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"%@%@: %@\n",
                                                                  furtherIndentString,
                                                                  keyString,
                                                                  value]];
        }
    }
    
    _tempStoredString = [_tempStoredString stringByAppendingString:returnString];
}

#pragma mark - Clearing
- (void)clearTempStoredString
{
    _tempStoredString = @"";
}

#pragma mark - Retrieving
- (NSString *_Nonnull)retrieveResultString
{
    return _tempStoredString;
}

@end
