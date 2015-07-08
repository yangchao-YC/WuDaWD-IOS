//
//  AppDelegate.m
//  wuda_oral
//
//  Created by 李迪 on 13-12-14.
//
//

#import "AppDelegate.h"

#import "UMSocial.h"

#import "WXApiObject.h"
#import "UMSocialWechatHandler.h"

@implementation AppDelegate

@synthesize userLogin;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [UMSocialData setAppKey:@"52e8a77156240ba07808a38a"];

   // [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:@"http://www.whuss.com/"];
    
    [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.whuss.com/"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
