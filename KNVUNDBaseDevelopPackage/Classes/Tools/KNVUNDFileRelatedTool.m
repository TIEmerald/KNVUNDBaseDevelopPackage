//
//  KNVUNDFileRelatedTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 15/4/18.
//

#import "KNVUNDFileRelatedTool.h"

@implementation KNVUNDFileRelatedTool

#pragma mark - General Methods
+ (BOOL)compressFile:(NSString *)originalFilePath withError:(NSError **)error andLogBlock:(void(^)(NSString *logingString))logBlock
{
    void(^usingLogBlock)(NSString *logingString) = ^(NSString *logingString){
        [self performConsoleLogWithLogString:logingString];
        if (logBlock) {
            logBlock(logingString);
        }
    };
    
    @autoreleasepool {
        // Steps:
        //  1. Create a new file with the same fileName, but added "gzip" extension
        //  2. Open the new file for writing (output file)
        //  3. Open the given file for reading (input file)
        //  4. Setup zlib for gzip compression
        //  5. Read a chunk of the given file
        //  6. Compress the chunk
        //  7. Write the compressed chunk to the output file
        //  8. Repeat steps 5 - 7 until the input file is exhausted
        //  9. Close input and output file
        // 10. Teardown zlib
        
        usingLogBlock([NSString stringWithFormat:@"Starting Compress File:%@ into File:%@",
                       originalFilePath]);
        
        return YES;
        
    }
}

@end
