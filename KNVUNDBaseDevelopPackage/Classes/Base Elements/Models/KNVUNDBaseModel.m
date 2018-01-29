//
//  KNVUNDBaseModel.m
//  Expecta
//
//  Created by Erjian Ni on 8/12/17.
//

#import "KNVUNDBaseModel.h"

// Tools
#import "KNVUNDRuntimeRelatedTool.h"

@implementation KNVUNDBaseModel

#pragma mark - Class Methods
+ (BOOL)shouldShowClassMethodLog
{
    return NO;
}

#pragma mark - Override Methods
+ (BOOL)isDevelopMode
{
    return YES;
}

+ (void)performServerLogWithLogString:(NSString *)string
{
    
}

#pragma mark Log Related
+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    if ([self isDevelopMode] && [self shouldShowClassMethodLog]) {
        NSLog(@"%@", string);
    }
}

+ (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogString:string];
}

+ (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString
{
    NSString *usingLogString = [self getFormatedStringFromString:logString];
    [self performServerLogWithLogString: usingLogString];
    [self performConsoleLogWithLogString:usingLogString];
}

+ (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndServerLogWithLogString:string];
}

#pragma mark - Properties Related
+ (NSDictionary *)propertyDescriptions
{
    NSMutableDictionary *returnDict = [NSMutableDictionary new];
    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:[self new]
                                   withAttributStringLoopBlock:^(NSString * _Nonnull propertyName, NSString * _Nonnull attributeString, id  _Nullable value, BOOL * _Nonnull stopLoop) {
                                       [returnDict setObject:attributeString
                                                      forKey:propertyName];
                                   }];
    return returnDict;
}

#pragma mark - Support Methods
+ (NSString *)getFormatedStringFromString:(NSString *)fromString
{
    return [NSString stringWithFormat:@"[%@] %@",
            NSStringFromClass(self),
            fromString];
}

#pragma mark - Log Related
- (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    if ([KNVUNDBaseModel isDevelopMode] && self.shouldShowRelatedLog) {
        NSLog(@"%@", string);
    }
}

- (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogString:string];
}

- (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString
{
    NSString *usingLogString = [[self class] getFormatedStringFromString:logString];
    [KNVUNDBaseModel performServerLogWithLogString:usingLogString];
    [self performConsoleLogWithLogString:usingLogString];
}

- (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndServerLogWithLogString:string];
}

#pragma mark - Equality
- (BOOL)isEqual:(id)object
{
    // Step One, Check if the object you passed in is same Class or not.
    if ([object class] != [self class]) {
        return NO;
    }
    
    __block BOOL returnValue = YES;
    
    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:object
                                                 withLoopBlock:^(KNVUNDRRTPropertyDetailsModel * _Nonnull detailsModel, BOOL *stopLoop) {
                                                     KNVUNDRuntimeRelatedTool_PropertyType propertyType = detailsModel.propertyType;
                                                     NSString *propertyName = (NSString *)detailsModel.propertyName;
                                                     BOOL isObject = (propertyType == KNVUNDRuntimeRelatedTool_PropertyType_Object);
                                                     id selfPropertyValue = [self valueForKey:propertyName];
                                                     id objectPropertyValue = detailsModel.value;
                                                     
                                                     if (!isObject && selfPropertyValue == objectPropertyValue) {
                                                         return;
                                                     } else if (isObject && [selfPropertyValue respondsToSelector:@selector(isEqual:)] && [selfPropertyValue isEqual:objectPropertyValue]){
                                                         return;
                                                     }
                                                     
//                                                     id selfPropertyValueDescription = [self getDescriptionObjectOfValue:selfPropertyValue
//                                                                                                        fromPropertyType:propertyType];
//                                                     id objectPropertyValueDescription = [self getDescriptionObjectOfValue:objectPropertyValue
//                                                                                                        fromPropertyType:propertyType];
                                                     [self performConsoleLogWithLogStringFormat:@"Equally Checking Failed.....\nProperty Name: %@ \nThe value in self is: %@ \nBut the value in object is: %@",
                                                      propertyName,
                                                      selfPropertyValue,
                                                      objectPropertyValue];
                                                     
                                                     returnValue = NO;
                                                     *stopLoop = YES;
                                                 }];
    
    return returnValue;
}

//- (id)getDescriptionObjectOfValue:(id)value fromPropertyType:(KNVUNDRuntimeRelatedTool_PropertyType)propertyType
//{
//    switch (propertyType) {
//            case KNVUNDRuntimeRelatedTool_PropertyType_Int:
//            return @((int)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Short:
//            return @((short)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Long:
//            return @((long)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Long_Long:
//            return @((long long)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Int:
//            return @((unsigned int)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Short:
//            return @((unsigned short)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Long:
//            return @((unsigned long)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Long_Long:
//            return @((unsigned long long)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Double:
//            return @((double)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Bool:
//            return @((BOOL)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Char:
//            case KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Char:
//            return [NSString stringWithFormat:@"%c", (char)value];
//            case KNVUNDRuntimeRelatedTool_PropertyType_Character_String:
//            return [NSString stringWithUTF8String:(const char *)value];
//            case KNVUNDRuntimeRelatedTool_PropertyType_Class:
//            return NSStringFromClass((Class)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Selector:
//            return NSStringFromSelector((SEL)value);
//            case KNVUNDRuntimeRelatedTool_PropertyType_Object:
//            return value;
//        default:
//            return @"";
//    }
//}

@end
