//
//  setPasswordVIewControllerViewController.m
//  梵祺展櫃
//
//  Created by hlen on 16/4/25.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "setPasswordViewController.h"

@interface setPasswordViewController ()

@property(nonatomic,strong)UITextField *password1;

@end

@implementation setPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc]initWithTitle:@"确认修改" style:UIBarButtonItemStyleDone target:self action:@selector(barClick)];
    self.navigationItem.rightBarButtonItem=barItem;
    
    //密码输入框
    self.password1=[[UITextField alloc]initWithFrame:CGRectMake(10,StatusAndNavbarHeight+10, SCREENWIDTH-20, 30)];
    self.password1.clearButtonMode=UITextFieldViewModeAlways;
    self.password1.borderStyle=UITextBorderStyleRoundedRect;
    [self.password1 becomeFirstResponder];
    [self.view addSubview:self.password1];
    // Do any additional setup after loading the view.
}
//确认修改点击事件
-(void)barClick
{
    //修改密码
   
        if(self.password1.text.length>=6)
        {
             //密码修改成功
            [self setPassword];
        }
        else
        {
   
            [self alert:@"提示" Message:@"請輸入大於6位的密碼" actionTitle:@"確定" ];
        }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setPassword
{//修改plist文件
    //NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *path=[pathArray objectAtIndex:0];
    //NSString *filePath=[path stringByAppendingPathComponent:@"login.plist"];
    NSString *filePath=[mtFileOperations DocumentPath:@"login.plist"];
    NSLog(@"工程 document+文件路径名称%@",filePath);
    NSMutableDictionary *muDict=[[[NSMutableDictionary alloc]initWithContentsOfFile:filePath]mutableCopy];
    [muDict setObject:self.password1.text forKey:@"password"];
    [muDict writeToFile:filePath atomically:YES];
        //
    [self alertFunc:@"提示" Message:@"密碼修改成功" actionTitle:@"確定" function:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //获取项目下的沙盒document路径
 
    
    
    
}

@end
