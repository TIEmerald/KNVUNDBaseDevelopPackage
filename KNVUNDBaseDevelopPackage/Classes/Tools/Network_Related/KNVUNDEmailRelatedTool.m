//
//  KNVUNDEmailRelatedTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 10/1/18.
//

#import "KNVUNDEmailRelatedTool.h"

/// Third Party
#import <skpsmtpmessage/SKPSMTPMessage.h>

@interface KNVUNDERTModel()<SKPSMTPMessageDelegate>

@end

@implementation KNVUNDERTModel

#pragma mark - Initial
- (instancetype _Nonnull)initWithFromEmail:(NSString *_Nonnull)fromEmail fromEmailLoginName:(NSString *_Nonnull)loginName fromEmailLoginPassword:(NSString *_Nonnull)loginPassword relayHost:(NSString *_Nonnull)relayHost toEmail:(NSString *_Nonnull)toEmail subject:(NSString *_Nonnull)subject andMessageBody:(NSString *_Nonnull)messageBody
{
    if (self = [super init]) {
        self.fromEmail = fromEmail;
        self.fromEmailLogin = loginName;
        self.fromEmailPassword = loginPassword;
        self.relayHost = relayHost;
        self.toEmail = toEmail;
        self.subject = subject;
        self.messageBody = messageBody;
    }
    return self;
}

#pragma mark - Converting
- (SKPSMTPMessage *)generateSMTPMessageFromSelf
{
    SKPSMTPMessage *returnMesaage = [[SKPSMTPMessage alloc] init];
    returnMesaage.fromEmail = self.fromEmail;
    returnMesaage.toEmail = self.toEmail;
    returnMesaage.relayHost = self.relayHost;
    returnMesaage.ccEmail = self.ccEmails.firstObject;
    returnMesaage.bccEmail = self.bccEmails.firstObject;
    returnMesaage.login = self.fromEmailLogin;
    returnMesaage.pass = self.fromEmailPassword;
    returnMesaage.subject = self.subject;
    returnMesaage.requiresAuth = YES;
    returnMesaage.wantsSecure = YES;
//    returnMesaage.delegate = self; No... We cannot set self to delegate... because when delegate be called, self have already released.....
    
    NSMutableArray *passingParts = [NSMutableArray new];
    // Now creating plain text email message
    NSDictionary *plainMsg = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey, self.messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    [passingParts addObject:plainMsg];
    
    for (NSData *attachedData in self.attachedDatas) {
        NSDictionary *fileMsg = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx- unix-mode=0644;\r\n\tname=\"filename.JPG\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"filename.JPG\"",kSKPSMTPPartContentDispositionKey,[attachedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        [passingParts addObject:fileMsg];
    }
    returnMesaage.parts = passingParts;
    return returnMesaage;
}

#pragma mark - Delegates
#pragma mark - SKPSMTPMessageDelegate
-(void)messageSent:(SKPSMTPMessage *)message
{
    [self performConsoleLogWithLogStringFormat:@"Successfully Sent Email to %@ -- %@",
     self.toEmail,
     self.subject];
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    [self performConsoleLogWithLogStringFormat:@"Failed to Send Email to %@ -- %@. Error: %@",
     self.toEmail,
     self.subject,
     error.description];
}

@end

@implementation KNVUNDEmailRelatedTool

+ (BOOL)sendEmailWithModel:(KNVUNDERTModel *_Nonnull)emailSendingModel
{
    @try {
        return [[emailSendingModel generateSMTPMessageFromSelf] send];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

@end
