//
//  UIViewController+MailComposer.m
//  PopU
//
//  Created by zhao wei on 13-11-14.
//  Copyright (c) 2013年 Pinssible. All rights reserved.
//

#import "UIViewController+MailComposer.h"
#import "GlobalValue.h"
#import "GiftClient.h"
#import "ASPlistHelper.h"


#import "GiftEventLogHelper.h"

#define SUPPORT_EMAIL       @"support@histitch.com"

@implementation UIViewController (MailComposer)

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    if (error) {
        
        

    }else{
        
        

    }
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMessageWithSubject:(NSString *)subject toAddress:(NSString *)address
{
    NSString *model = [[UIDevice currentDevice] name];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserID];
    if (userId.length <= 0) {
        userId = @"NewUser";
    }
    
    NSString *contactMessageBody = @"\n\n\n\n\n User ID: %@\n App ID: %@\n App Name : %@\n App Version : %@\n OS Name : %@\n OS Version : %@\n Device Model : %@\n Device Resolution : %f*%f\n PID : %@\n SID : %@\n";
    NSString *mailMessageBody = [NSString stringWithFormat:contactMessageBody, userId, [NSBundle mainBundle].bundleIdentifier, [ASPlistHelper appDisplayName], appVersion, systemName, systemVersion, model, screenSize.width, screenSize.height, [GlobalValue currentVendorID], [GlobalValue currentIDFA]];
    NSString *mailSubject = subject;
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if (!mailViewController)
    {
        return;
    }
    if ([MFMailComposeViewController canSendMail])
    {
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObjects:address, nil]];
        [mailViewController setSubject:mailSubject];
        [mailViewController setMessageBody:mailMessageBody isHTML:NO];
        mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentViewController:mailViewController animated:YES completion:nil];
        });
    }else {
        
        

    }
}

- (void)sendMessageWithSubJect:(NSString *)subject additionalContent:(NSString *)content toAddress:(NSString *)address {
    NSString *mailContent = content ? content : @"";
    NSString *model = [[UIDevice currentDevice] name];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    NSString *userId = [[GiftClient sharedClient] isLoggedIn] ? [GiftClient sharedClient].currentUser.user_id : @"Anonymous";
    NSString *contactMessageBody = @"\n\n\n\n%@\n User ID: %@\n App ID: %@\n App Name : %@\n App Version : %@\n OS Name : %@\n OS Version : %@\n Device Model : %@\n Device Resolution : %f*%f\n PID : %@\n SID : %@\n";
    NSString *mailMessageBody = [NSString stringWithFormat:contactMessageBody, mailContent, userId, [NSBundle mainBundle].bundleIdentifier, [ASPlistHelper appDisplayName], appVersion, systemName, systemVersion, model, screenSize.width, screenSize.height, [GlobalValue currentVendorID], [GlobalValue currentIDFA]];
    NSString *mailSubject = subject;
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if (!mailViewController)
    {
        return;
    }
    if ([MFMailComposeViewController canSendMail])
    {
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObjects:address, nil]];
        [mailViewController setSubject:mailSubject];
        [mailViewController setMessageBody:mailMessageBody isHTML:NO];
        mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentViewController:mailViewController animated:YES completion:nil];
        });
    }
}

- (void)sendContactMessageWithSubject:(NSString *)subject additionalContent:(NSString *)content {
    [self sendMessageWithSubJect:subject additionalContent:content toAddress:SUPPORT_EMAIL];
}

- (void)sendContactMessageWithSubject:(NSString *)subject
{
    [self sendMessageWithSubject:subject toAddress:SUPPORT_EMAIL];
}


@end
