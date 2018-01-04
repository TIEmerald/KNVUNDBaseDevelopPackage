//
//  KNVUNDBaseModel.m
//  Expecta
//
//  Created by Erjian Ni on 8/12/17.
//

#import "KNVUNDBaseModel.h"

#import <objc/runtime.h>

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
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSString *attributeString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        [returnDict setObject:attributeString
                       forKey:propertyName];
    }
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
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSString *attributeString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        
        /// Property Attributs Example
        //// Documentation: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
//        Printing description of propertyDict:
//        {
//            additionalAttribute = "T@\"NSDictionary\",&,N";
//            contentValue = "T@\"NSString\",&,N,V_contentValue";
//            location = "TQ,N,V_location";
//            propertyName = "T@\"NSString\",&,N,V_propertyName";
//            type = "TQ,N,V_type";
//        }
        
        NSArray *attributes = [attributeString componentsSeparatedByString:@","];
        BOOL isObject = [attributes[1] isEqual:@"&"];
        
        id selfPropertyValue = [self valueForKey:(NSString *)propertyName];
        id objectPropertyValue = [object valueForKey:(NSString *)propertyName];
        
        if (!isObject && selfPropertyValue == objectPropertyValue) {
            continue;
        } else if (isObject && [selfPropertyValue respondsToSelector:@selector(isEqual:)] && [selfPropertyValue isEqual:objectPropertyValue]){
            continue;
        }
        return NO;
    }
    return YES;
}

@end
