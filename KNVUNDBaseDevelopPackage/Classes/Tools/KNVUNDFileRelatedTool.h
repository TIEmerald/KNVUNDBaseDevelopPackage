//
//  KNVUNDFileRelatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 15/4/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDFileRelatedTool : KNVUNDBaseModel

#pragma mark - General Methods
+ (BOOL)compressFile:(NSString *)originalFilePath withError:(NSError **)error andLogBlock:(void(^)(NSString *logingString))logBlock;

@end
