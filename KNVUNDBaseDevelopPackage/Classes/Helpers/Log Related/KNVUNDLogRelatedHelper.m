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
    [self appendLogStringWithObjectArray:objectArray
                           andObjectName:objectName
                   andCurrentIndentLevel:0];
}

- (void)appendLogStringWithObjectArray:(NSArray<id<KNVUNDLogRelatedModelProtocol>> *)objectArray andObjectName:(NSString *_Nonnull)objectName andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    [self appendLogStringWithBlock:^{
        NSNumber *objectCounts = @(objectArray.count);
        if (objectCounts.integerValue == 0) {
            [self appendLogStringWithTitle:[NSString stringWithFormat:@"No %@.", objectName]
                     andCurrentIndentLevel:currentIndentLevel + 1];
        } else {
            NSMutableArray *usingArray = [NSMutableArray new];
            int indexValue = 1;
            for (id<KNVUNDLogRelatedModelProtocol> object in objectArray) {
                [usingArray addObject:[[KNVUNDLogRelatedHelperContentModel alloc] initWithDescriptionString:[NSString stringWithFormat:@"-- %@ (%@ / %@)",
                                                                                                             objectName,
                                                                                                             @(indexValue),
                                                                                                             objectCounts]
                                                                                            andContentValue:object]];
                indexValue += 1;
            }
            [self appendLogStringWithTitle:[NSString stringWithFormat:@"Has %@ %@s",
                                            objectCounts,
                                            objectName]
                        contentModelArrays:usingArray
                     andCurrentIndentLevel:currentIndentLevel + 1];
        }
    } andObjectName:objectName andCurrentIndentLevel:currentIndentLevel];
}

- (void)appendLogStringWithObject:(id<KNVUNDLogRelatedModelProtocol>)logObject andObjectName:(NSString *_Nonnull)objectName
{
    [self appendLogStringWithObject:logObject
                      andObjectName:objectName
              andCurrentIndentLevel:0];
}

- (void)appendLogStringWithObject:(id<KNVUNDLogRelatedModelProtocol>)logObject andObjectName:(NSString *_Nonnull)objectName andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    [self appendLogStringWithBlock:^{
        if ([logObject respondsToSelector:@selector(getSelfLogStringWithTitle:andIndentString:andCurrentIndentLevel:)]) {
            [self appendLogString:[logObject getSelfLogStringWithTitle:@""
                                                       andIndentString:self.indentString
                                                 andCurrentIndentLevel:currentIndentLevel + 1]];
        } else {
            [self appendLogString:[NSString stringWithFormat:@"No %@",
                                   objectName]
            andCurrentIndentLevel:currentIndentLevel + 1];
        }
    } andObjectName:objectName andCurrentIndentLevel:currentIndentLevel];
}

- (void)appendLogStringWithTitle:(NSString *_Nonnull)titleString contentModelArrays:(NSArray *_Nonnull)contentArray andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    NSString *currentIndentString = [self getIndentStringWithCurrentIndentLevel:currentIndentLevel];
    
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
    [self appendLogString:returnString];
}

- (void)appendLogString:(NSString *)logString
{
    [self appendLogString:logString
    andCurrentIndentLevel:0];
}

- (void)appendLogString:(NSString *)logString andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    _tempStoredString = [_tempStoredString stringByAppendingString:[NSString stringWithFormat:@"%@%@",
                                                                    [self getIndentStringWithCurrentIndentLevel:currentIndentLevel],
                                                                    logString]];
}

#pragma mark Support Methods
- (void)appendLogStringWithBlock:(void(^)(void))logStringBlock andObjectName:(NSString *_Nonnull)objectName andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    [self appendLogStringWithTitle:[NSString stringWithFormat:@"\n\n%@ Details:", objectName]
             andCurrentIndentLevel:currentIndentLevel];
    if (logStringBlock) {
        logStringBlock();
    }
}

- (NSString *)getIndentStringWithCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    NSString *currentIndentString = @"";
    for (int index = 0; index < currentIndentLevel; index += 1 ) {
        currentIndentString = [currentIndentString stringByAppendingString:self.indentString];
    }
    return currentIndentString;
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

#pragma mark - Deprecated Methods
- (void)appendLogStringWithTitle:(NSString *_Nonnull)titleString andCurrentIndentLevel:(NSUInteger)currentIndentLevel
{
    [self appendLogStringWithTitle:titleString
                contentModelArrays:@[]
             andCurrentIndentLevel:currentIndentLevel];
}

@end
