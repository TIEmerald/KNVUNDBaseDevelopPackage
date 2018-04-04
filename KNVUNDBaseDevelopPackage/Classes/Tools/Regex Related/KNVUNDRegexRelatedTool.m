//
//  KNVUNDRegexReleatedTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 4/4/18.
//

#import "KNVUNDRegexReleatedTool.h"

@implementation KNVUNDRegexRelatedTool

#pragma mark - Constants
NSString * const KNVUNDRegexRelatedTool_Pattern_Alphabets = @"[A-z]*";
NSString * const KNVUNDRegexRelatedTool_Pattern_Numbers = @"[0-9]*";
NSString * const KNVUNDRegexRelatedTool_Pattern_Email = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
NSString * const KNVUNDRegexRelatedTool_Pattern_Name = @"^[a-z]+$";
NSString * const KNVUNDRegexRelatedTool_Pattern_IPv4Address = @"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
NSString * const KNVUNDRegexRelatedTool_Pattern_VoucherCode = @"^[A-Z0-9a-z]*$";

#pragma mark - Checks Registration
+ (BOOL)checkYear:(NSString *)yearStr
{
    if(![self checkOnlyContainDecimalDigit:yearStr]){
        return NO;
    }
    
    NSInteger day = yearStr.integerValue;
    if(day >= 1 && day <= 9999)
        return YES;
    
    return NO;
}

+ (BOOL)checkMonth:(NSString *)monthStr
{
    if(![self checkOnlyContainDecimalDigit:monthStr]){
        return NO;
    }
    
    NSInteger month = monthStr.integerValue;
    if(month >= 1 && month <= 12)
        return YES;
    
    return NO;
}

+ (BOOL)checkDay:(NSString *)dayStr
{
    return [self checkDay:dayStr withMaximumDay:31];
}

+ (BOOL)checkDay:(NSString *)dayStr withMonth:(NSString *)monthStr andYear:(NSString *)yearStr{
    
    if (![self checkMonth:monthStr]) {
        return NO;
    }
    
    NSString *stringForMonth = [@"1/" stringByAppendingString:[monthStr stringByAppendingString:@"/"]]; // The final formate should be dd/MM/(yyyy) if yearStr didn't existed, we will set the year to a leap year.
    
    if ([self checkYear:yearStr]) {
        stringForMonth = [stringForMonth stringByAppendingString:yearStr];
    }else{
        stringForMonth = [stringForMonth stringByAppendingString:@"2004"];
    }
    
    NSDateFormatter *mmYYYYformater = [NSDateFormatter new];
    [mmYYYYformater setDateFormat:@"d/M/yyyy"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[mmYYYYformater dateFromString:stringForMonth]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    return [self checkDay:dayStr withMaximumDay:(int)numberOfDaysInMonth];
}

+ (BOOL)checkOnlyContainDecimalDigit:(NSString *)aString{
    return [self validateString:aString onlyContainsNSCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound && matchRange.length != 0)
        didValidate = YES;
    
    return didValidate;
}

#pragma mark - Private Methods
+ (BOOL)validateString:(NSString *)string onlyContainsNSCharacterSet:(NSCharacterSet *)characters{
    NSCharacterSet* notDigits = [characters invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)checkDay:(NSString *)dayStr withMaximumDay:(int)maxDay{
    if(![self checkOnlyContainDecimalDigit:dayStr]){
        return NO;
    }
    
    NSInteger day = dayStr.integerValue;
    if(day >= 1 && day <= maxDay)
        return YES;
    
    return NO;
}

@end
