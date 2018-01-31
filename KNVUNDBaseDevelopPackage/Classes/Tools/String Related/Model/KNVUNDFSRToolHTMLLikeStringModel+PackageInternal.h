//
//  KNVUNDFSRToolHTMLLikeStringModel+PackageInternal.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 31/1/18.
//

#import "KNVUNDFSRToolHTMLLikeStringModel.h"

@interface KNVUNDFSRToolHTMLLikeStringModel (PackageInternal)

#pragma mark - Constants
extern char const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start;
extern char const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End;
extern char const KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier;

extern char const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start;
extern char const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End;

extern char const KNVUNDFSRToolHTMLLikeStringModel_Additional_Attributes_Property_Equal;

#pragma mark - Validators
- (BOOL)isFormatType;
- (BOOL)isPlaceholderType;

@end
