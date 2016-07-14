//
//  smartAddDeviceViewController.m
//  梵祺展櫃
//
//  Created by hlen on 16/6/21.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "smartAddDeviceViewController.h"
#import "driverListModel.h"

@interface smartAddDeviceViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITextField *tf_ssid;
@property(nonatomic,strong)UITextField  *tf_password;
@property(nonatomic,strong)UIButton *btn_start;
@property(nonatomic,strong)UISwitch *sh_select;
@end

@implementation smartAddDeviceViewController{

    HFSmartLink * smtlk;
    BOOL isconnecting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self createView];
    
    smtlk = [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = true;
    smtlk.waitTimers = 30;
    isconnecting=false;
    self.sh_select.on=smtlk.isConfigOneDevice;
    [self showWifiSsid];
    self.tf_password.text=[self getPwdBySsid:self.tf_ssid.text];
    self.tf_password.delegate=self;
    self.tf_ssid.delegate=self;
    
    //self.progress.progress = 0.0;

}
-(void)showWifiSsid
{
    BOOL wifiOK=FALSE;
    NSDictionary *ifs;
    NSString *ssid;
    UIAlertView *alert;
    if(!wifiOK)
    {
        ifs=[self fetchSsidInfo];
        ssid=[ifs objectForKey:@"SSID"];
        if(ssid!=nil)
        {
            wifiOK=TRUE;
            self.tf_ssid.text=ssid;
        }
        else
        {
            alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"請連接Wi-Fi"] delegate:self cancelButtonTitle:@"關閉" otherButtonTitles: nil];
            alert.delegate=self;
            [alert show];
        }
    }
    
}
-(id)fetchSsidInfo{
    NSArray *ifs=(__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"supported interfaces:%@",ifs);
    id info=nil;
    for (NSString *ifnam  in ifs) {
        info=(__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@=>%@",ifnam,info);
        if(info&&[info count]){
            break;
        }
        
    }
    return  info;
}
-(NSString *)getPwdBySsid:(NSString *)ssid
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [def objectForKey:ssid];
}
-(void)savePassword
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:self.tf_password.text forKey:self.tf_ssid.text];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createView{
    CGFloat tf_W=SCREENWIDTH-60;
    CGFloat tf_H=30;
    CGFloat tf_X=(SCREENWIDTH-tf_W)/2;
    CGFloat tf_Y=StatusAndNavbarHeight+20;
    
    self.tf_ssid=[[UITextField alloc]initWithFrame:CGRectMake(tf_X, tf_Y, tf_W, tf_H)];
    [self.tf_ssid setBorderStyle:UITextBorderStyleRoundedRect];
    [self.tf_ssid setTextAlignment:NSTextAlignmentLeft];
    UILabel *ssid=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    ssid.text=@" SSID:";
    ssid.textColor=[UIColor grayColor];
    [self.tf_ssid setLeftView:ssid];
    self.tf_ssid.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:self.tf_ssid];
    self.tf_ssid.placeholder=@"請將手機連接到路由器";
    
    self.tf_password=[[UITextField alloc]initWithFrame:CGRectMake(tf_X, tf_Y+tf_H+10, tf_W, tf_H)];
    [self.tf_password setBorderStyle:UITextBorderStyleRoundedRect];
    [self.tf_password setTextAlignment:NSTextAlignmentLeft];
    UILabel *password=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    password.text=@" 密 碼:";
    password.textColor=[UIColor grayColor];
    [self.tf_password setLeftView:password];
    self.tf_password.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:self.tf_password];
    self.tf_password.placeholder=@"請輸入路由器密碼";
    
    //switch text
    UILabel *shText=[[UILabel alloc]initWithFrame:CGRectMake(tf_X, self.tf_password.frame.origin.y+tf_H+10, 180, 30)];
    [self.view addSubview:shText];
    shText.text=@"配置單個設備";
    
    //switch
    self.sh_select=[[UISwitch alloc]initWithFrame:CGRectMake(tf_X+tf_W-50, self.tf_password.frame.origin.y+tf_H+10, 60, 30)];
    [self.view addSubview:self.sh_select];
    //self.sh_select.on=YES;
    [self.sh_select addTarget:self action:@selector(sh_select_action) forControlEvents:UIControlEventValueChanged];
    //配置按钮
    self.btn_start=[[UIButton alloc]initWithFrame:CGRectMake(tf_X, self.sh_select.frame.origin.y+tf_H+20,tf_W , tf_H+10)];
    self.btn_start.backgroundColor=btnColor;
    [self.btn_start setTitle:@"開始配置" forState:UIControlStateNormal];
    self.btn_start.layer.cornerRadius=5;
    self.btn_start.layer.masksToBounds=YES;
    [self.view addSubview:self.btn_start];
    [self.btn_start addTarget:self action:@selector(btn_start_click) forControlEvents:UIControlEventTouchUpInside];
    self.btn_start.tag=0;
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)sh_select_action
{
    if(self.sh_select.on){
        smtlk.isConfigOneDevice = true;
    }else{
        smtlk.isConfigOneDevice = false;
    }
}
-(void)btn_start_click{
    
    NSString* ssidStr=self.tf_ssid.text;
    NSString* pswdStr=self.tf_password.text;
    
    if(!isconnecting)
    {
        isconnecting=true;
        [self connectStartInterface];
        [smtlk startWithSSID:ssidStr Key:pswdStr withV3x:true processblock:^(NSInteger process) {
            //進度條
        } successBlock:^(HFSmartLinkDeviceInfo *dev) {
            [self alert:@"" Message:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] actionTitle:@"ok"];
            //將ip存儲到plist中
#warning 存储到plist中
            [self saveToPlistIP:dev.ip];
        } failBlock:^(NSString *failmsg) {
            [self alert:nil Message:@"error" actionTitle:@"ok"];
        } endBlock:^(NSDictionary *deviceDic) {
            isconnecting=false;
            [self connectStopInterface];
            [self savePassword];
        }];
        //[self.btn_start setTitle:@"正在配置中..." forState:UIControlStateNormal];
    }
    else{
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {//停止
            if(isOk)//停止成功
            {
                isconnecting=false;
                [self connectStopInterface];
                [self alert:nil Message:stopMsg actionTitle:@"ok"];
            }
            else//停止失敗
            {
                [self alert:nil Message:stopMsg actionTitle:@"error"];
            }
        }];
    }

    
}
-(void)saveToPlistIP:(NSString*)ip
{
    /**
     *  此处对数据进行修改
     */
//    driverListModel *model=[[driverListModel alloc]init];
//    NSString *ipAndPort=[NSString stringWithFormat:@"%@:%@",self.ipTextField.text,self.portTextField.text];
//    if(self.ipTextField.text.length>5)
//    {
//        [model modifyDriver:self.cellRow deviceName:self.nameTextField.text deviceIP:ipAndPort];
//    }
//    [self alertFunc:@"提示" Message:@"操作成功" actionTitle:@"确定" function:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    return;
    driverListModel *model=[[driverListModel alloc]init];
    NSString *ipAndPort=[NSString stringWithFormat:@"%@:8899",ip];
    if(ip.length>=7)
    {
        //进行数据检测
        
        if(![model modifyDriver:-1 deviceName:@"通過智能方式添加的設備" deviceIP:ipAndPort]){
//            [self alert:nil Message:[NSString stringWithFormat:@"IP已經存在%@",ipAndPort] actionTitle:@"error"];
//            NSLog(@"已經存在");
            [XHToast showCenterWithText:[NSString stringWithFormat:@"該設備IP已經存在%@",ipAndPort]];
        }
    }


}
-(void)connectStartInterface
{
    self.tf_password.userInteractionEnabled=NO;
    self.tf_ssid.userInteractionEnabled=NO;
    self.sh_select.userInteractionEnabled=NO;
    [self.btn_start setTitle:@"正在配置中..." forState:UIControlStateNormal];
}
-(void)connectStopInterface
{
    

    self.tf_password.userInteractionEnabled=YES;
    self.tf_ssid.userInteractionEnabled=YES;
    self.sh_select.userInteractionEnabled=YES;
     [self.btn_start setTitle:@"開始配置" forState:UIControlStateNormal];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {//停止
        if(isOk)//停止成功
        {
            isconnecting=false;
            [self connectStopInterface];
            //[self alert:nil Message:stopMsg actionTitle:@"ok"];
            NSLog(@"停止成功");
        }
        else//停止失敗
        {
            //[self alert:nil Message:stopMsg actionTitle:@"error"];
            NSLog(@"停止失敗");
        }
    }];

}

@end
