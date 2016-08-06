//
//  AppDelegate.m
//  梵祺展櫃
//
//  Created by hlen on 16/4/18.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "mtFileOperations.h"
#import <AVFoundation/AVFoundation.h>
#import "driverListModel.h"
#import "MTSocketController.h"
#import "deviceString.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSTimer *_timer;
    NSInteger _count;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //文件copy
    [mtFileOperations CopyFileToDocument:@"login.plist"];
    [mtFileOperations CopyFileToDocument:@"drvierList.plist"];
    NSLog(@"%@",[mtFileOperations DocumentPath:@"ldrvierList.plist"]);
    
    //将状态栏字体改为白色 结合plist使用
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController* vc=[[ViewController alloc]init];
    
    UINavigationController* nav=[[UINavigationController alloc]initWithRootViewController:vc];
    [nav.navigationBar setBarTintColor:[UIColor colorWithRed:39/255.0 green:40/255.0 blue:41/255.0 alpha:1.0]];//设置navBar的背景颜色
    [nav.navigationBar setTintColor:[UIColor whiteColor]];//设置返回按钮的颜色
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  }];//设置nav标题的颜色
    
    self.window.rootViewController=nav;//设置根视图为nav
    
    
    
        //可后台运行的设置
    NSError *setCategoryErr=nil;
    NSError *activetionErr=nil;
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance]setActive:YES error:&activetionErr];
    //添加定时器
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myTimer) userInfo:nil repeats:YES];
    
    [self.window makeKeyAndVisible]; //设置显示
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //永久后台
    UIApplication *app=[UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask=[app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(bgTask!=UIBackgroundTaskInvalid)
            {
                bgTask=UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(bgTask!=UIBackgroundTaskInvalid)
        {
            bgTask=UIBackgroundTaskInvalid;
        }
    });
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];

    _count=0;
}
-(void)myTimer
{
    _count++;
    NSLog(@"正在后台运行%ld",(long)_count);
    if(_count>=300)
    {
        //发送停止命令
        [self setDeviceDoorStop];
        [_timer setFireDate:[NSDate distantFuture]];//停止计时器
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //回来后
    [_timer setFireDate:[NSDate distantFuture]];//
    
    NSLog(@"后台运行结束%ld",(long)_count);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 *  2016年07月28日23:03:39
 *  后台运行一段时间后 所有设备的门设置到处于停的状态
 */
-(void)setDeviceDoorStop
{
    MTSocketController *mtScoket=[[MTSocketController alloc]init];
     driverListModel *model=[[driverListModel alloc]init];
    NSMutableArray *muArray=[model getDriverListArray];
    for(int i=0;i<3;i++)
    {
    for (driverListModel *tempModel in muArray) {
        if(tempModel.driverIP.length>5){
            [mtScoket cutOffSocket];
            [mtScoket connectSocketIP:[tempModel.driverIP substringToIndex:tempModel.driverIP.length-5] port:[[tempModel.driverIP substringFromIndex:tempModel.driverIP.length-4] intValue]];
            [mtScoket sendData:DOOR State:(DOORSTOP)];
            NSLog(@"stop门的指令已经发送");
        }
    }
    }
}
@end
