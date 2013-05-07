//
//  WWDCCAppDelegate.m
//  WWDCC
//
//  Created by iDevZilla on 5/10/11.
//

#import "WWDCCAppDelegate.h"
#import "CountDownViewController.h"

@implementation WWDCCAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    CountDownViewController *countdownController = [[CountDownViewController alloc] init];
    countdownController.title = @"Countdown";
    countdownNavigation = [[UINavigationController alloc] initWithRootViewController:countdownController];

    countdownNavigation.navigationBar.barStyle = UIBarStyleBlackOpaque;    
    
    [self.window addSubview:countdownNavigation.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end
