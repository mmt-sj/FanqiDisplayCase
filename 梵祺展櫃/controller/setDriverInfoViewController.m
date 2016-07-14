//
//  setDriverInfoViewController.m
//  梵祺展櫃
//
//  Created by hlen on 16/4/25.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "setDriverInfoViewController.h"
#import "driverListModel.h"
#import "mtFileOperations.h"
@interface setDriverInfoViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *numberTextField;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *ipTextField;
@property(nonatomic,strong)UIPickerView *typePickerView;
@property(nonatomic,strong)UIBarButtonItem *rightBar;

@property(nonatomic,strong)UITextField *portTextField;

@property(nonatomic,strong)NSMutableArray *driverListArray;
@end

@implementation setDriverInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"詳細信息";
    [self initView];
    [self initData];
    
    
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
-(void)initData
{
 
    driverListModel *model=[[driverListModel alloc]init];
    self.driverListArray=[model getDriverListArray];
    driverListModel *device=self.driverListArray[self.cellRow];
     self.numberTextField.text=[NSString stringWithFormat:@"%d",self.cellRow+1];
    //如果名称和ip为空 则默认此序号没有设备
    if([device.driverName isEqualToString:@""]||device.driverIP.length<5)
    {
        [self rightBarClick];
        self.rightBar.title=@"确认添加";
        self.portTextField.text=@"8899";
        [self.nameTextField becomeFirstResponder];
       
        return;
    }
    
    self.nameTextField.text=device.driverName;
    NSString* devicePort=[device.driverIP substringFromIndex:device.driverIP.length-4];
    NSString* deviceIP=[device.driverIP substringToIndex:device.driverIP.length-5];
    self.ipTextField.text=deviceIP;
    self.portTextField.text=devicePort;
    
  
}
-(void)initView
{
    //添加 rightBar
     self.rightBar=[[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarClick)];
    self.navigationItem.rightBarButtonItem=self.rightBar;
    
    //centerView
    UIView *centerView=[[UIView alloc]initWithFrame:CGRectMake(0, StatusAndNavbarHeight+SCREENHEIGHT/20, SCREENWIDTH, SCREENHEIGHT-StatusAndNavbarHeight)];
    [self.view addSubview:centerView];
    
    //编号label
    UILabel *numberLabel=[[UILabel alloc]init];
    numberLabel.text=@" 編號:";
    CGFloat numberLabelW=45;
    CGFloat numberLabelH=20;
    numberLabel.frame=CGRectMake(0, 0, numberLabelW, numberLabelH);
    numberLabel.textColor=[UIColor grayColor];

    //编号field
    self.numberTextField=[[UITextField alloc]init];
    self.numberTextField.userInteractionEnabled=NO;
    self.numberTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.numberTextField.returnKeyType=UIReturnKeyNext;
//self.numberTextField.backgroundColor=[UIColor redColor];
    //添加左边的文字
    [self.numberTextField setLeftView:numberLabel];
    self.numberTextField.leftViewMode=UITextFieldViewModeAlways;
    CGFloat numberW=240;
    CGFloat numberH=30;
    CGFloat numberX=(SCREENWIDTH-numberW)/2;
    CGFloat numberY=0;
    self.numberTextField.frame=CGRectMake(numberX, numberY, numberW, numberH);
    [centerView addSubview:self.numberTextField];
    
    //名稱 label
    UILabel *nameLabel=[[UILabel alloc]init];
    nameLabel.text=@" 名稱:";
    nameLabel.textColor=[UIColor grayColor];
    CGFloat nameLabelW=numberLabelW;
    CGFloat nameLabelH=numberLabelH;

    nameLabel.frame=CGRectMake(0, 0, nameLabelW, nameLabelH);
   // [centerView addSubview:nameLabel];
    
    //名稱 field
    self.nameTextField=[[UITextField alloc]init];
    self.nameTextField.userInteractionEnabled=NO;
    self.nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.nameTextField.returnKeyType=UIReturnKeyNext;
    self.nameTextField.delegate=self;
 //   self.nameTextField.backgroundColor=[UIColor redColor];
    [self.nameTextField setLeftView:nameLabel];
    self.nameTextField.leftViewMode=UITextFieldViewModeAlways;
    self.nameTextField.placeholder=@"請輸入設備名稱";
    
    CGFloat nameW=240;
    CGFloat nameH=30;
    CGFloat nameX=(SCREENWIDTH-nameW)/2;
    CGFloat nameY=numberY+numberH+10;
    self.nameTextField.frame=CGRectMake(nameX, nameY, nameW, nameH);
    [centerView addSubview:self.nameTextField];
    
    //ip label
    UILabel *ipLabel=[[UILabel alloc]init];
    ipLabel.text=@" IP:";
    ipLabel.textColor=[UIColor grayColor];
    ipLabel.textColor=[UIColor grayColor];
    CGFloat ipLabelW=45;
    CGFloat ipLabelH=20;
    ipLabel.frame=CGRectMake(0, 0, ipLabelW, ipLabelH);
    //[centerView addSubview:ipLabel];
    
    //ip field
    self.ipTextField=[[UITextField alloc]init];
    self.ipTextField.userInteractionEnabled=NO;
    self.ipTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.ipTextField.returnKeyType=UIReturnKeyNext;
    self.ipTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.ipTextField.leftViewMode=UITextFieldViewModeAlways;
    //self.ipTextField.backgroundColor=[UIColor redColor];
    [self.ipTextField setLeftView:ipLabel];
    self.ipTextField.leftViewMode=UITextFieldViewModeAlways;
    self.ipTextField.placeholder=@"請輸入設備IP地址";
    CGFloat ipW=240;
    CGFloat ipH=30;
    CGFloat ipX=(SCREENWIDTH-ipW)/2;
    CGFloat ipY=nameY+nameH+10;
    self.ipTextField.frame=CGRectMake(ipX, ipY, ipW, ipH);
    [centerView addSubview:self.ipTextField];
    //端口label
    UILabel *portLabel=[[UILabel alloc]init];
    portLabel.text=@" 端口:";
    portLabel.textColor=[UIColor grayColor];
    CGFloat portLabelW=45;
    CGFloat portLabelH=20;

    portLabel.frame=CGRectMake(0, 0, portLabelW, portLabelH);
   // [centerView addSubview:portLabel];
    
    //端口 textfield
    self.portTextField=[[UITextField alloc]init];
    self.portTextField.userInteractionEnabled=NO;
    self.portTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.portTextField.returnKeyType=UIReturnKeyNext;
    self.portTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.portTextField.leftViewMode=UITextFieldViewModeAlways;
    //self.ipTextField.backgroundColor=[UIColor redColor];
    [self.portTextField setLeftView:portLabel];
    self.portTextField.leftViewMode=UITextFieldViewModeAlways;
    CGFloat portW=240;
    CGFloat portH=30;
    CGFloat portX=ipX;
    CGFloat portY=ipH+ipY+10;
    self.portTextField.frame=CGRectMake(portX, portY, portW, portH);
    [centerView addSubview:self.portTextField];
    
    
    
    


}
-(void)rightBarClick
{
     if([self.rightBar.title isEqualToString: @"确认修改"]||[self.rightBar.title isEqualToString:@"确认添加"])
     {
         /**
          *  此处对数据进行修改
          */
         driverListModel *model=[[driverListModel alloc]init];
         NSString *ipAndPort=[NSString stringWithFormat:@"%@:%@",self.ipTextField.text,self.portTextField.text];
         if(self.ipTextField.text.length>5)
         {
         [model modifyDriver:self.cellRow deviceName:self.nameTextField.text deviceIP:ipAndPort];
         }
         [self alertFunc:@"提示" Message:@"操作成功" actionTitle:@"确定" function:^{
             [self.navigationController popViewControllerAnimated:YES];
         }];
         return;
     }
    [self.nameTextField becomeFirstResponder];
    self.rightBar.title=@"确认修改";
    //self.numberTextField.userInteractionEnabled=YES;
    self.ipTextField.userInteractionEnabled=YES;
    self.nameTextField.userInteractionEnabled=YES;
    self.typePickerView.userInteractionEnabled=YES;
    self.portTextField.userInteractionEnabled=YES;
   
  
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField ==self.nameTextField)
    {
        [self.ipTextField becomeFirstResponder];
    }
    if(textField==self.ipTextField)
    {
        [self.portTextField becomeFirstResponder];
    }
    return YES;
}
@end
