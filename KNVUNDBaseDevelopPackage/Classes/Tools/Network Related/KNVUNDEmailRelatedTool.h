//
//  KNVUNDEmailRelatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 10/1/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDERTModel : KNVUNDBaseModel

/// If you want to send email from the from Email, Purhaps you will need to enable some secure setting in your email account.
@property (nonatomic, strong, nonnull) NSString *fromEmail;
@property (nonatomic, strong, nonnull) NSString *fromEmailLogin; ///Because we mind need the email login and password... Please don't use your important email to send Email from background.
@property (nonatomic, strong, nonnull) NSString *fromEmailPassword; ///
@property (nonatomic, strong, nonnull) NSString *relayHost;
@property (nonatomic, strong, nonnull) NSString *toEmail;
@property (nonatomic, strong, nullable) NSArray *ccEmails; // Currently, we only support the first Email;
@property (nonatomic, strong, nullable) NSArray *bccEmails; // Currently, we only support the first Email;

@property (nonatomic, strong, nonnull) NSString *subject;
@property (nonatomic, strong, nonnull) NSString *messageBody;
@property (nonatomic, strong, nullable) NSArray *attachedDatas; /// Currently, we only support ".jpg" type NSData

#pragma mark - Initial
- (instancetype _Nonnull)initWithFromEmail:(NSString *_Nonnull)fromEmail fromEmailLoginName:(NSString *_Nonnull)loginName fromEmailLoginPassword:(NSString *_Nonnull)loginPassword relayHost:(NSString *_Nonnull)relayHost toEmail:(NSString *_Nonnull)toEmail subject:(NSString *_Nonnull)subject andMessageBody:(NSString *_Nonnull)messageBody;

@end

@interface KNVUNDEmailRelatedTool : KNVUNDBaseModel

+ (BOOL)sendEmailWithModel:(KNVUNDERTModel *_Nonnull)emailSendingModel;

@end
