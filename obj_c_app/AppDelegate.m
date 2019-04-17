//
//  AppDelegate.m
//  obj_c_app
//
//  Created by Mary Gerina on 11/26/18.
//  Copyright © 2018 Mary Gerina. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "NotificationService.h"

NSString *const pushNotificationCategoryIdent = @"Actionable";
NSString *const pushNotificationFirstActionIdent = @"First_Action";
NSString *const pushNotificationSecondActionIdent = @"Second_Action";

@interface AppDelegate (){
    NSString *devceToken;
    UNUserNotificationCenter *center;
}

@end

NSString * globalVariable;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerForLocalNotification];
    
    UILocalNotification *launchNote = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (launchNote) {
        
        NSLog(@":%@", launchNote.userInfo);
        
        
    }
    return YES;
}

-(void)registerForLocalNotification{
    center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate:self];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *  settings) {
        
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined || settings.authorizationStatus == UNAuthorizationStatusDenied) {
            
            [center requestAuthorizationWithOptions:UNAuthorizationOptionSound + UNAuthorizationOptionBadge + UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *  error) {
                if (!granted) {
                    NSLog(@"something went wrong");
                }
                else
                {
                    
                }
            }];
        }
    }];
    
}

-(void)initialseTimerNotificationData{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Rich Notificaions";
    content.subtitle = @"implemented in iOS 10";
    content.body = @"This also includes support for Multiple Targets. It's a fascinating thing.";
    content.sound = [UNNotificationSound defaultSound];
    content.accessibilityHint = @"NotificationCategory1";
    
    NSURL *imgUrl = [[NSBundle mainBundle] URLForResource:@"notification" withExtension:@"png"];
    NSError *attachmentError = nil;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:imgUrl options:@{UNNotificationAttachmentOptionsTypeHintKey: @"PNG"} error:&attachmentError];
    content.attachments = @[attachment];
    
    [self addNotificationAction];
    
    content.categoryIdentifier = @"NotificationCategory1";
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    NSDateComponents *componenets = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond + NSCalendarUnitNanosecond fromDate:date];
    
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:componenets repeats:false];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Timer" content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (error) {
            NSLog(@":%@", error.localizedDescription);
        }
        
    }];
}


-(void)addNotificationAction{
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Delete" title:@"Delete" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *openAction = [UNNotificationAction actionWithIdentifier:@"Open" title:@"Open" options:UNNotificationActionOptionForeground];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"NotificationCategory1" actions:@[deleteAction, openAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    NSSet *Categories = [NSSet setWithObject:category];
    
    [center setNotificationCategories: Categories];
    
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    
    NSLog(@":%@", response.notification.request.content.categoryIdentifier);
    
    if ([response.notification.request.content.categoryIdentifier isEqualToString:@"NotificationCategory1"]) {
        NSLog(@":%@", response.actionIdentifier);
        if (response.actionIdentifier == UNNotificationDismissActionIdentifier) {
            NSLog(@"action");
        }
        else if ([response.actionIdentifier  isEqual: @"Delete"]){
            
            NSLog(@"Delete");
        }
        else if ([response.actionIdentifier isEqual: @"Open"]){
            NSLog(@"open");
        }
    }
    
    completionHandler();
    
}

- (void)registerForRemoteNotification
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }];
    }
    else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error here : %@", error);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    devceToken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"Device Token = %@",devceToken);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)removeNotifications{
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
}


-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"info: %@", userInfo);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        
    }
    
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        NSLog( @"INACTIVE" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
    {
        NSLog( @"BACKGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    else
    {
        NSLog( @"FOREGROUND" );
        completionHandler( UIBackgroundFetchResultNewData );
    }
    
}

+(AppDelegate *)delegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
