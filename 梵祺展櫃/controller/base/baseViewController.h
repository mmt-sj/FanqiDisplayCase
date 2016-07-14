//
//  baseViewController.h
//  梵祺展櫃
//
//  Created by hlen on 16/4/18.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mtFileOperations.h"
#import "XHToast.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽度

#define StatusAndNavbarHeight 62

#define btnColor [UIColor colorWithRed:76/255.0 green:71/255.0 blue:68/255.0 alpha:1.0]

@interface baseViewController : UIViewController

-(void)alertFunc:(NSString *)title Message:(NSString *)msg actionTitle:(NSString *)actionTitle function:(void(^)())func;
-(void)alert:(NSString *)title Message:(NSString *)msg actionTitle:(NSString *)actionTitle;
@end
