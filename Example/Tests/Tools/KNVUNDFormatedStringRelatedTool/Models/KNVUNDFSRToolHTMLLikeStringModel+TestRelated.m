//
//  KNVUNDFSRToolHTMLLikeStringModel+TestRelated.m
//  KNVUNDBaseDevelopPackage_Tests
//
//  Created by Erjian Ni on 4/1/18.
//  Copyright © 2018 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDFSRToolHTMLLikeStringModel+TestRelated.h"

@implementation KNVUNDFSRToolHTMLLikeStringModel (TestRelated)

- (BOOL)isEqual:(id)object
{
    NSString *selfDescriptionString = self.description;
    NSString *objectDescriptionString = ((KNVUNDFSRToolHTMLLikeStringModel *)object).description;
    
    if (![selfDescriptionString isEqual:objectDescriptionString]) {
        [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                         andLogStringFormat:@"Description is not Match:\nSelf Model    :%@\nExpected Model:%@",
         selfDescriptionString,
         objectDescriptionString];
        return NO;
    }
    return YES;
}

@end
