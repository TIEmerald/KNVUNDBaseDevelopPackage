//
//  KNVUNDRuntimeRelatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 5/1/18.
//

#import "KNVUNDBaseModel.h"

typedef enum : NSUInteger {
    KNVUNDRuntimeRelatedTool_PropertyType_UnKnown_Type,
    KNVUNDRuntimeRelatedTool_PropertyType_Char,
    KNVUNDRuntimeRelatedTool_PropertyType_Int,
    KNVUNDRuntimeRelatedTool_PropertyType_Short,
    KNVUNDRuntimeRelatedTool_PropertyType_Long,
    KNVUNDRuntimeRelatedTool_PropertyType_Long_Long,
    KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Char,
    KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Int,
    KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Short,
    KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Long,
    KNVUNDRuntimeRelatedTool_PropertyType_Unsigned_Long_Long,
    KNVUNDRuntimeRelatedTool_PropertyType_Float,
    KNVUNDRuntimeRelatedTool_PropertyType_Double,
    KNVUNDRuntimeRelatedTool_PropertyType_Bool,
    KNVUNDRuntimeRelatedTool_PropertyType_Void,
    KNVUNDRuntimeRelatedTool_PropertyType_Character_String,
    KNVUNDRuntimeRelatedTool_PropertyType_Object,
    KNVUNDRuntimeRelatedTool_PropertyType_Class,
    KNVUNDRuntimeRelatedTool_PropertyType_Selector
} KNVUNDRuntimeRelatedTool_PropertyType;

@interface KNVUNDRRTPropertyDetailsModel : KNVUNDBaseModel

@property (nonatomic, strong, nonnull) NSString *propertyName;
@property (nonatomic, strong, nullable) NSString *typeName;
@property (nonatomic) KNVUNDRuntimeRelatedTool_PropertyType propertyType;
@property (nonatomic) BOOL isReadOnly;
@property (nonatomic, nullable) id value;

@end

@interface KNVUNDRuntimeRelatedTool : KNVUNDBaseModel

#pragma mark - Property Related Methods
+ (KNVUNDRRTPropertyDetailsModel *_Nullable)getPropertyDetailsModelFromObject:(id _Nonnull)object withPropertyName:(NSString *_Nonnull)propertyName;
+ (void)loopThroughAllPropertiesOfObject:(id _Nonnull)object withLoopBlock:(void(^_Nonnull)(KNVUNDRRTPropertyDetailsModel *_Nonnull detailsModel, BOOL *_Nullable stopLoop))loopBlock;
+ (void)loopThroughAllPropertiesOfObject:(id _Nonnull)object withAttributStringLoopBlock:(void(^_Nonnull)(NSString *_Nonnull propertyName, NSString *_Nonnull attributeString,  id _Nullable value, BOOL *_Nonnull stopLoop))loopBlock;

@end
