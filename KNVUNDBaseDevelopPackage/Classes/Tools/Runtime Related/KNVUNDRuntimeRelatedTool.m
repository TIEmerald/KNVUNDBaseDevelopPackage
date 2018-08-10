//
//  KNVUNDRuntimeRelatedTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 5/1/18.
//

#import "KNVUNDRuntimeRelatedTool.h"

#import <objc/runtime.h>
#import <LinqToObjectiveC/LinqToObjectiveC.h>

@interface KNVUNDRRTPropertyDetailsModel()

@end

@implementation KNVUNDRRTPropertyDetailsModel

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ (%@) --- %@",
            self.propertyName,
            self.typeName,
            self.value];
}

@end

@implementation KNVUNDRuntimeRelatedTool

#pragma mark - Property Related Methodss
+ (void)loopThroughAllPropertiesOfObject:(id)object withLoopBlock:(void(^)(KNVUNDRRTPropertyDetailsModel *_Nonnull detailsModel, BOOL *stopLoop))loopBlock
{
    [self loopThroughAllPropertiesOfObject:object
               withAttributStringLoopBlock:^(NSString * _Nonnull propertyName, NSString * _Nonnull attributeString, id  _Nullable value, BOOL * _Nonnull stopLoop) {
                   NSString *typeName;
                   NSArray *attributes = [attributeString componentsSeparatedByString:@","];
                   KNVUNDRuntimeRelatedTool_PropertyType propertyType = [self getPropertyTypeFromPropertyAttributeString:attributes[0]
                                                                                                        withDetailedName:&typeName];
                   if (loopBlock) {
                       KNVUNDRRTPropertyDetailsModel *usingDetailsModel = [KNVUNDRRTPropertyDetailsModel new];
                       usingDetailsModel.propertyName = propertyName;
                       usingDetailsModel.propertyType = propertyType;
                       usingDetailsModel.typeName = typeName;
                       usingDetailsModel.value = value;
                       [self updatePropertyDetailsModel:usingDetailsModel
                                   withAttributeStrings:attributes];
                       loopBlock(usingDetailsModel,
                                 stopLoop);
                   }
                   
               }];
}

+ (void)loopThroughAllPropertiesOfObject:(id _Nonnull)object withAttributStringLoopBlock:(void(^_Nonnull)(NSString *_Nonnull propertyName, NSString *_Nonnull attributeString,  id _Nullable value, BOOL *_Nonnull stopLoop))loopBlock
{
    unsigned int outCount, i;
    BOOL stopLoop = NO;
    
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i < outCount; i++) {
        if (stopLoop) {
            break;
        }
        
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSString *attributeString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        id objectPropertyValue = [object valueForKey:(NSString *)propertyName];
        
        if (loopBlock) {
            loopBlock(propertyName,
                      attributeString,
                      objectPropertyValue,
                      &stopLoop);
        }
    }
    free(properties);
}

#pragma mark Support Methods
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

char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Char = 'c';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Int = 'i';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Short = 's';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Long = 'l';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Long_Long = 'q';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Char = 'C';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Int = 'I';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Short = 'S';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Long = 'L';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Long_Long = 'Q';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Float = 'f';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Double = 'd';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Bool = 'B';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Void = 'v';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Character_String = '*';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Ojbect = '@';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Class = '#';
char const KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Selector = ':';

+ (KNVUNDRuntimeRelatedTool_PropertyType)getPropertyTypeFromPropertyAttributeString:(NSString *)propertyAttributeString withDetailedName:(NSString **)detailedName
{
    @try{
        char identifierChar = [propertyAttributeString characterAtIndex:1];
        NSString *detailedSubString = [propertyAttributeString substringFromIndex:2];
        NSRange supportinRange;
        switch (identifierChar) {
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Char:
                return KNVUNDRuntimeRelatedTool_PropertyType_Char;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Int:
                return KNVUNDRuntimeRelatedTool_PropertyType_Int;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Short:
                return KNVUNDRuntimeRelatedTool_PropertyType_Short;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Long:
                return KNVUNDRuntimeRelatedTool_PropertyType_Long;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Long_Long:
                return KNVUNDRuntimeRelatedTool_PropertyType_Long_Long;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Char:
                return KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Char;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Int:
                return KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Int;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Short:
                return KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Short;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Long:
                return KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Long;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Unsigned_Long_Long:
                return KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Long_Long;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Float:
                return KNVUNDRuntimeRelatedTool_PropertyType_Float;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Double:
                return KNVUNDRuntimeRelatedTool_PropertyType_Double;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Bool:
                return KNVUNDRuntimeRelatedTool_PropertyType_Bool;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Void:
                return KNVUNDRuntimeRelatedTool_PropertyType_Void;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Character_String:
                return KNVUNDRuntimeRelatedTool_PropertyType_Character_String;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Class:
                return KNVUNDRuntimeRelatedTool_PropertyType_Class;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Selector:
                return KNVUNDRuntimeRelatedTool_PropertyType_Selector;
            case KNVUNDRuntimeRelatedTool_PropertyAttributeIdentifier_Ojbect:
                supportinRange = [detailedSubString rangeOfString:@"<"]; /// We will remove the Proptocols....
                if (supportinRange.location != NSNotFound) {
                    detailedSubString = [detailedSubString substringToIndex:supportinRange.location];
                }
                *detailedName = [detailedSubString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
                return KNVUNDRuntimeRelatedTool_PropertyType_Object;
            default:
                return KNVUNDRuntimeRelatedTool_PropertyType_UnKnown_Type;
        }
    } @catch (NSException *expection) {
        return KNVUNDRuntimeRelatedTool_PropertyType_UnKnown_Type;
    }
}

// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW1
+ (void)updatePropertyDetailsModel:(KNVUNDRRTPropertyDetailsModel *)propertyDetailsModel withAttributeStrings:(NSArray *)attributeStrings
{
    propertyDetailsModel.isReadOnly = [attributeStrings linq_any:^BOOL(NSString *item) {
        return [item isEqualToString:@"R"];
    }];
}

@end
