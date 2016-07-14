//
//  loginViewController.m
//  梵祺展櫃
//
//  Created by hlen on 16/4/22.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "loginViewController.h"
#import "setTableViewController.h"
#import "LYViewController.h"

#define TEST 1
@interface loginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *idField;
@property(nonatomic,strong)UITextField *pwdField;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
-(void)initView
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    //CGFloat marginH=5;
    
    //centerView
    UIView *centerView=[[UIView alloc]init];
    //centerView.backgroundColor=[UIColor redColor];
    CGFloat centerViewW=SCREENWIDTH;
    CGFloat centerViewH=120;
    CGFloat centerViewX=0;
    CGFloat centerViewY=(SCREENHEIGHT-StatusAndNavbarHeight-centerViewH)/2;
    centerView.frame=CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
    [self.view addSubview:centerView];
    
    //logo
    UIImageView *logo=[[UIImageView alloc]init];
    logo.image=[UIImage imageNamed:@"log"];
    CGFloat logoW=80;
    CGFloat logoH=80;
    CGFloat logoX=SCREENWIDTH/2-logoW/2;
    CGFloat logoY=centerViewY-logoH-25;
    logo.frame=CGRectMake(logoX, logoY, logoW, logoH);
    [self.view addSubview:logo];
    
    //賬號label
    UILabel *idlabel=[[UILabel alloc]init];
    idlabel.text=@" 賬號:";
    CGFloat labelW=45;
    CGFloat labelH=20;
    CGFloat idLabelX=(SCREENWIDTH-150-45-5)/2;
    CGFloat idLabelY=5;
    idlabel.frame=CGRectMake(0, 0, labelW, labelH);
    //[centerView addSubview: idlabel];
    
    //賬號field
    self.idField=[[UITextField alloc]initWithFrame:CGRectMake(idLabelX+150, idLabelY, 150, 30)];
    self.idField.borderStyle=UITextBorderStyleRoundedRect;
    self.idField.clearButtonMode=UITextFieldViewModeAlways;
    self.idField.returnKeyType=UIReturnKeyNext;
    [self.idField becomeFirstResponder];
    self.idField.keyboardType=UIKeyboardTypeASCIICapable;
    self.idField.delegate=self;
    [self.idField setLeftView:idlabel];
    self.idField.leftViewMode=UITextFieldViewModeAlways;
    CGFloat fieldW=SCREENWIDTH-60;
    CGFloat fieldH=30;
    CGFloat idFieldX=(SCREENWIDTH-fieldW)/2;
    CGFloat idFieldY=idLabelY-5;
    self.idField.frame=CGRectMake(idFieldX, idFieldY, fieldW, fieldH);
    [centerView addSubview:self.idField];
    self.idField.placeholder=@"請輸入賬號";
    
    //密碼lebel
    UILabel *pwdLabel=[[UILabel alloc]init];
    pwdLabel.text=@" 密碼:";
   // CGFloat pwdLabelX=idLabelX;
    CGFloat pwdLabelY=labelH+30;
    pwdLabel.frame=CGRectMake(0,0, labelW, labelH);
  
    
    //密碼field
    self.pwdField=[[UITextField alloc]init];
    self.pwdField.borderStyle=UITextBorderStyleRoundedRect;
    self.pwdField.clearButtonMode=UITextFieldViewModeAlways;
    self.pwdField.secureTextEntry=YES;
    self.pwdField.returnKeyType=UIReturnKeyDone;
    self.pwdField.delegate=self;
    [self.pwdField setLeftView:pwdLabel];
    self.pwdField.leftViewMode=UITextFieldViewModeAlways;
    CGFloat pwdFieldX=idFieldX;
    CGFloat pwdFieldY=pwdLabelY-5;
    self.pwdField.frame=CGRectMake(pwdFieldX, pwdFieldY, fieldW, fieldH);
    [centerView addSubview:self.pwdField];
    self.pwdField.placeholder=@"請輸入密碼";
    
    //登陸按鈕
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton.layer setCornerRadius:10.0];//设置button圆角
    [loginButton setTitle:@"登 錄" forState:UIControlStateNormal];
    loginButton.titleLabel.textColor=[UIColor whiteColor];
    [loginButton setBackgroundColor:btnColor];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat loginButtonW=fieldW;
    CGFloat loginButtonH=40;
    CGFloat loginButtonX=(centerViewW-loginButtonW)/2;
    CGFloat loginButtonY=pwdFieldY+fieldH+10;
    loginButton.layer.cornerRadius=5;
    loginButton.layer.masksToBounds=YES;
    loginButton.frame=CGRectMake(loginButtonX, loginButtonY, loginButtonW, loginButtonH);
    [centerView addSubview:loginButton];

    
}
-(void)loginButtonClick
{
    if(TEST==1)
    {
        setTableViewController *setTableView=[[setTableViewController alloc]init];
        [self.navigationController pushViewController:setTableView animated:YES];
    }
    else
    {
   // NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"login" ofType:@"plist"];
    NSString *plistPath=[mtFileOperations DocumentPath:@"login.plist"];//从沙盒中读取文件
    NSMutableDictionary *muDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *plistID=[muDict objectForKey:@"id"];
    NSString *plistPassword=[muDict objectForKey:@"password"];
    if([plistID isEqualToString:self.idField.text]==YES&&[plistPassword isEqualToString:self.pwdField.text]==YES)
    {
     //进行页面跳转
        setTableViewController *setTableView=[[setTableViewController alloc]init];
       [self.navigationController pushViewController:setTableView animated:YES];

     
    }
    else
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"賬號或密碼錯誤" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"退出");
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
 if(textField==self.idField)
 {
     [self.idField resignFirstResponder];
     [self.pwdField becomeFirstResponder];
 }
    if(textField==self.pwdField)
    {
        [self loginButtonClick];
    }
    return true;
}
@end
