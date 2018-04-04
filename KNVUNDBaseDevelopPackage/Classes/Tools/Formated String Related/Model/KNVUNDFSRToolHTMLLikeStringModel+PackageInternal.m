//
//  KNVUNDFSRToolHTMLLikeStringModel+PackageInternal.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 31/1/18.
//

#import "KNVUNDFSRToolHTMLLikeStringModel+PackageInternal.h"

@implementation KNVUNDFSRToolHTMLLikeStringModel (PackageInternal)

#pragma mark - Constants
char const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start = '<';
char const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End = '>';
char const KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier = '/';

char const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start = '[';
char const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End = ']';

char const KNVUNDFSRToolHTMLLikeStringModel_Additional_Attributes_Property_Equal = '=';


#pragma mark - Validators
- (BOOL)isFormatType
{
    return self.type == KNVUNDFSRToolHTMLLikeStringModel_Type_Format;
}

- (BOOL)isPlaceholderType
{
    return self.type == KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder;
}


@end
