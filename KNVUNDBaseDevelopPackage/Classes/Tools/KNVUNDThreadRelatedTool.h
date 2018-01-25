//
//  KNVUNDThreadRelatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 15/12/17.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDThreadRelatedTool : KNVUNDBaseModel

#pragma mark - Main Queue Related
/*!
 * @brief This method will perform the block you passed by in main queue --- for something like UI updating.
 * @param block The block you want to perform in main queue
 */
+ (void)performBlockInMainQueue:(void(^ _Nullable )(void))block;

+ (void)performBlockNotInMainQueue:(void(^_Nullable)(void))block;

@end
