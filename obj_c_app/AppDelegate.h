#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

extern NSString * globalVariable;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate *)delegate;
-(void)initialseTimerNotificationData;

@end
