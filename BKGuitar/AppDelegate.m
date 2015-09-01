//
//  AppDelegate.m
//  BKGuitar
//
//  Created by 锄禾日当午 on 15/8/29.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "AppDelegate.h"
#import "BKMusicListController.h"
#import "BKNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BKMusicListController *musicListController = [[BKMusicListController alloc] init];
    
    BKNavigationController *nav = [[BKNavigationController alloc] initWithRootViewController:musicListController];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    return YES;
}



@end
