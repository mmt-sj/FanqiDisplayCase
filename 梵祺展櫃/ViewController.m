//
//  ViewController.m
//  梵祺展櫃
//
//  Created by hlen on 16/4/18.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "ViewController.h"
#import "driverListModel.h"
#import "loginViewController.h"
#import "mtButton.h"
#import "other/deviceString.h"

#import "AsyncSocket.h"
@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,AsyncSocketDelegate>

@property(nonatomic,strong)NSMutableArray *driverList;

@property(nonatomic,strong)NSMutableArray *nwDeviceList;

@property(nonatomic,strong)UIPickerView *pickerView;//码盘

@property(nonatomic,strong)AsyncSocket *asyncSocket;

@property(nonatomic,copy)NSString *socketHost;
@property(nonatomic,assign)UInt16 socketPort;

@property(nonatomic,strong)UIView *socketState;//灰色没有连接 绿色连接;


@property(nonatomic,strong)mtButton *btnLampA;
@property(nonatomic,strong)UIView *LampAstate;
@property(nonatomic,strong)mtButton *btnLampB;
@property(nonatomic,strong)UIView *LampBstate;
@property(nonatomic,strong)mtButton *btnLampClose;

@property(nonatomic,strong)mtButton *btnDoorOpen;
@property(nonatomic,strong)UIView *doorOpenstate;
@property(nonatomic,strong)mtButton *btnDoorStop;
@property(nonatomic,strong)UIView *doorStopstate;
@property(nonatomic,strong)mtButton *btnDoorClose;
@property(nonatomic,strong)UIView *doorClosestate;
@property(nonatomic,strong)UISwitch *lockSwitch;

@property(nonatomic,strong)UILabel *lockLabel;




@end

@implementation ViewController

{
    int LAMPASTATE;
    int LAMPBSTATE;
    int DOORSTATE;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   //self.view.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [self initData];
    [self initNav];
    [self initView];
    [self setUserInterface:NO];//设置启动后界面不能交互 解锁后 可以交互
    
    //初始化默认选择
    [self setHostAndPort:0];
    
    [self socketConnectHost];//连接服务端

}
/**
 *  <#Description#>
 *
 *  @param ip    ip以及port
 *  @param index pickerView的row
 */
-(void)setHostAndPort:(NSInteger)index
{
    
    driverListModel *model=self.driverList[index];
    if(model.driverIP.length<5)
    {
        self.socketHost=@"";
        self.socketPort=0;
        return;
    }
    self.socketHost=[model.driverIP substringToIndex:model.driverIP.length-5];
    self.socketPort=[[model.driverIP substringFromIndex:model.driverIP.length-4] intValue];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //
    
    [self initData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData
{
    driverListModel *model=[[driverListModel alloc]init];
    self.driverList=[model getDriverListArray];
    [self.pickerView reloadAllComponents];
    
}

-(void)initNav
{
   // self.navigationController.title=@"梵祺展櫃";
    self.navigationItem.title=@"FRACHI梵祺文物設備展櫃";//设置这个页面Nav的标题
    UIBarButtonItem *setBar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStyleDone target:self action:@selector(setBarClick)];//定义一个barButton
    [setBar setAction:@selector(setBarClick)];
    self.navigationItem.leftBarButtonItem=setBar;//将定义好的barButton设置为leftBar

}
-(void)setBarClick
{
    loginViewController *login=[[loginViewController alloc]init];
    login.navigationItem.title=@"登錄";
    [self.navigationController pushViewController:login animated:YES];
}

-(void)initView
{
    CGFloat marginH=5;
    //logo
    UIImageView *logo=[[UIImageView alloc]init];
    logo.image=[UIImage imageNamed:@"log"];
    CGFloat logoW=50;
    CGFloat logoH=50;
    CGFloat logoX=SCREENWIDTH/2-logoW/2;
    CGFloat logoY=StatusAndNavbarHeight+marginH;
    logo.frame=CGRectMake(logoX, logoY, logoW, logoH);
    //[self.view addSubview:logo];
    UILabel *logoL=[[UILabel alloc]init];
    CGFloat logoLW=SCREENWIDTH;
    CGFloat logoLH=30;
    CGFloat logoLX=0;
    CGFloat logoLY=StatusAndNavbarHeight+20;
    logoL.frame=CGRectMake(logoLX, logoLY, logoLW, logoLH);
    logoL.textAlignment=NSTextAlignmentCenter;
    logoL.font=[UIFont systemFontOfSize:30 weight:10];
    logoL.text=@"F R A C H I";
    //[self.view addSubview:logoL];
    
    
    
    
    //topView
    UIView *topView=[[UIView alloc]init];
    CGFloat topViewW=SCREENWIDTH;
    CGFloat topViewH=(SCREENHEIGHT-(marginH+marginH*2)-StatusAndNavbarHeight)/4.5;
    CGFloat topViewX=0;
    CGFloat topViewY=StatusAndNavbarHeight+SCREENHEIGHT/25;//logoY+logoH+marginH*2;
    topView.frame=CGRectMake(topViewX, topViewY, topViewW, topViewH);
    [self.view addSubview:topView];
    
    //给topView加底线
    UIView *topViewLine=[[UIView alloc]initWithFrame:CGRectMake(5, topViewH-1, SCREENWIDTH-10, 1)];
    topViewLine.backgroundColor=[UIColor grayColor];
    [topView addSubview:topViewLine];
    
   
    
    //topView中的码盘
    self.pickerView=[[UIPickerView alloc]initWithFrame:CGRectZero];
    self.pickerView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.pickerView.delegate=self;//设置代理
    self.pickerView.showsSelectionIndicator=YES;//设置显示选中框
    //self.pickerView.backgroundColor=btnColor;//设置pickerview的背景颜色
    
    CGFloat topViewMarginW=15;
    CGFloat lockSwitchW=50;
    CGFloat pickerW=110;
    CGFloat noLabelW=90;
    
    //锁子
    
    CGFloat noLabelH=60;

    CGFloat noLabelY=(topViewH-noLabelH)/2-5;
    CGFloat lockSwitchH=30;
    CGFloat lockSwitchX=(SCREENWIDTH-(topViewMarginW*2+lockSwitchW+pickerW+noLabelW))/2;
    CGFloat lockSwitchY=noLabelY;
    CGFloat noLabelX=lockSwitchW+lockSwitchX+topViewMarginW;
    
    CGFloat pickerH=120;
    CGFloat pickerX=noLabelX+noLabelW+topViewMarginW;
    CGFloat pickerY=(topViewH-pickerH)/2-5;
    
    self.lockSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(lockSwitchX, lockSwitchY+2, lockSwitchW, lockSwitchH)];
    self.lockSwitch.transform=CGAffineTransformMakeScale(1.1, 1.1);
    [self.lockSwitch addTarget:self action:@selector(lockSwitch_click) forControlEvents:UIControlEventValueChanged];
    
    
    //下面的提示
    self.lockLabel=[[UILabel alloc]initWithFrame:CGRectMake(lockSwitchX-2, lockSwitchH+lockSwitchY+5, self.lockSwitch.frame.size.width+2, 20)];
    self.lockLabel.text=@"locked";
    self.lockLabel.textAlignment=NSTextAlignmentCenter;
    self.lockLabel.font=[UIFont systemFontOfSize:16 weight:5];
    [topView addSubview:self.lockLabel];
    [topView addSubview:self.lockSwitch];
    
 
    
    UILabel *noLabel=[[UILabel alloc]init];
    noLabel.text=@"編  號\r\nNumber";
    noLabel.textAlignment=NSTextAlignmentCenter;
    [noLabel setNumberOfLines:3];
    noLabel.font=[UIFont systemFontOfSize:24 weight:0];
    
  
 
//    if(getPickerViewHeight>60)
//    {
//        noLabelY=-logoY+(getPickerViewHeight-noLabelH)/2;
//    }
    noLabel.frame=CGRectMake(noLabelX, noLabelY, noLabelW, noLabelH);
    
   
 
    self.pickerView.frame=CGRectMake(pickerX, pickerY, pickerW, pickerH);
    CGFloat getPickerViewHeight=self.pickerView.frame.size.height;
    NSLog(@"pickerViewHeight is :%lf",getPickerViewHeight);
//    if(getPickerViewHeight>60)
//    {
//        self.pickerView.frame=CGRectMake(pickerX, -logoY, pickerW, getPickerViewHeight);
//    }
    NSLog(@"topview Height is :%lf",topViewH);
    [topView addSubview:self.pickerView];
    
    //topView中的NO：（label）

    [topView addSubview:noLabel];
    
    
    //在pickerview中添加socketstateView
    self.socketState=[[UIView alloc]initWithFrame:CGRectMake(pickerW-16, (pickerH-16)/2, 16, 16)];
    self.socketState.layer.cornerRadius=8;
    self.socketState.backgroundColor=[UIColor grayColor];
    self.socketState.layer.masksToBounds=YES;
    
    [self.pickerView addSubview:self.socketState];
    
    
    //centerView 里面放的是控制灯的控件
    UIView *centerView=[[UIView alloc]init];
    CGFloat centerViewW=SCREENWIDTH;
    CGFloat centerViewH=topViewH*1.5;
    CGFloat centerViewX=0;
    CGFloat centerViewY=topViewH+topViewY;
    centerView.frame=CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
    [self.view addSubview:centerView];
    
    //给centerView加底线
    UIView *centerViewLine=[[UIView alloc]initWithFrame:CGRectMake(5, centerViewH-1, SCREENWIDTH-10, 1)];
    centerViewLine.backgroundColor=[UIColor grayColor];
    [centerView addSubview:centerViewLine];
    
    //灯A
    CGFloat buttonLampW=100;
    CGFloat buttonLampH=100;
    if(SCREENWIDTH>320)
    {
        buttonLampW=120;
        buttonLampH=120;
    }
    CGFloat buttonAX=(SCREENWIDTH-buttonLampW*3)/6;
    CGFloat buttonAY=(centerViewH-buttonLampH)/2;
    CGRect buttonAFrame=CGRectMake(buttonAX, buttonAY, buttonLampW, buttonLampH);
    
    NSString *buttonFrameTile=@"燈A\r\nlight A";
    mtButton *buttonA=[mtButton touchUpOutsideCancelButtonWithType:UIButtonTypeRoundedRect frame:buttonAFrame title:buttonFrameTile titleColor:[UIColor whiteColor] backgroundColor:btnColor backgroundImage:nil andBlock:^{
        NSLog(@"灯A%@",self.socketHost);
        //操作
        //[self socketConnectHost];//连接 操作
        NSData *sendData=[self sendData:LAMPA State:LAMPOPEN];
        [self.asyncSocket writeData:sendData withTimeout:-1 tag:1];

     
        
        
    }];
    self.btnLampA=buttonA;
    [centerView addSubview:self.btnLampA];
    
    //關燈
    CGFloat buttonOffX=buttonAX*3+buttonLampW;
    CGFloat buttonOffY=buttonAY;
    CGRect buttonOffFrame=CGRectMake(buttonOffX, buttonOffY, buttonLampW, buttonLampH);
    
    NSString *buttonOffTile=@"關燈\r\nclose";
    mtButton *buttonOff=[mtButton touchUpOutsideCancelButtonWithType:UIButtonTypeRoundedRect frame:buttonOffFrame title:buttonOffTile titleColor:[UIColor whiteColor] backgroundColor:btnColor backgroundImage:nil andBlock:^{
        NSLog(@"關燈");
        
        //关灯操作
        [self.asyncSocket writeData:[self sendData:LAMPA State:LAMPCLOSE] withTimeout:1 tag:1];
        
        [self.asyncSocket writeData:[self sendData:LAMPB State:LAMPCLOSE] withTimeout:-1 tag:1];

    }];
    self.btnLampClose=buttonOff;
    [centerView addSubview:self.btnLampClose];
    
    CGFloat buttonBX=buttonOffX*2-buttonAX;
    CGFloat buttonBY=buttonAY;
    CGRect buttonBFrame=CGRectMake(buttonBX, buttonBY, buttonLampW, buttonLampH);
    
    NSString *buttonBTitle=@"燈B\r\nlight B";
    mtButton *buttonB=[mtButton touchUpOutsideCancelButtonWithType:UIButtonTypeRoundedRect frame:buttonBFrame title:buttonBTitle     titleColor:[UIColor whiteColor] backgroundColor:btnColor backgroundImage:nil andBlock:^{
        
        NSLog(@"灯B");
        NSData *sendData=[self sendData:LAMPB State:LAMPOPEN];
        [self.asyncSocket writeData:sendData withTimeout:1 tag:1];
    }];
    self.btnLampB=buttonB;
    [centerView addSubview:self.btnLampB];
    
    //bottomView 里面放的是控制门的控件
    UIView *bottomView=[[UIView alloc]init];
   // bottomView.backgroundColor=[UIColor grayColor];
    CGFloat bottomViewW=SCREENWIDTH;
    CGFloat bottomViewH=topViewH*2.5;
    CGFloat bottomViewX=0;
    CGFloat bottomViewY=centerViewY+centerViewH;
    bottomView.frame=CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    [self.view addSubview:bottomView];
    //门开
    CGFloat doorW=buttonLampW;
    CGFloat doorH=buttonLampH;
    CGFloat doorOnX=(SCREENWIDTH-doorW*3)/6;
    CGFloat doorOnY=buttonA.frame.origin.y;
    CGRect doorOnFrame=CGRectMake(doorOnX, doorOnY, doorW, doorH);
    NSString *doorOnTitle=@"開門\r\nopen";
    mtButton *doorOn=[mtButton touchUpOutsideCancelButtonWithType:UIButtonTypeRoundedRect frame:doorOnFrame title:doorOnTitle titleColor:[UIColor whiteColor] backgroundColor:btnColor backgroundImage:nil andBlock:^{
        NSLog(@"開門");
        
        NSData *sendData=[self sendData:DOOR State:DOOROPEN];
        [self.asyncSocket writeData:sendData withTimeout:-1 tag:1];

    }];
    self.btnDoorOpen=doorOn;
    [bottomView addSubview:self.btnDoorOpen];
    //门关
    CGFloat doorStopX=doorOnX*3+doorW;
    CGFloat doorStopY=doorOnY;
    CGRect doorStopFrame=CGRectMake(doorStopX, doorStopY, doorW, doorH);
    NSString *doorStopTitle=@"停止\r\nstop";
    mtButton *doorStop=[mtButton touchUpOutsideCancelButtonWithType:UIButtonTypeRoundedRect frame:doorStopFrame title:doorStopTitle titleColor:[UIColor whiteColor] backgroundColor:btnColor backgroundImage:nil andBlock:^{
        NSLog(@"停止");
        NSData *sendData=[self sendData:DOOR State:DOORSTOP];
        [self.asyncSocket writeData:sendData withTimeout:1 tag:1];

    }];
    self.btnDoorStop=doorStop;
    [bottomView addSubview:self.btnDoorStop];
    //门停
    CGFloat doorOffX=doorStopX*2-doorOnX;
    CGFloat doorOffY=doorOnY;
    CGRect doorOffFrame=CGRectMake(doorOffX, doorOffY, doorW, doorH);
    NSString *doorOffTitle=@"關門\r\nclose";
    mtButton *doorOff=[mtButton touchUpOutsideCancelButtonWithType:UIButtonTypeRoundedRect frame:doorOffFrame title:doorOffTitle titleColor:[UIColor whiteColor] backgroundColor:btnColor backgroundImage:nil andBlock:^{
        NSLog(@"關門");
        
        
        NSData *sendData=[self sendData:DOOR State:DOORCLOSE];
        [self.asyncSocket writeData:sendData withTimeout:1 tag:1];

    }];
    self.btnDoorClose=doorOff;
    
    [bottomView addSubview:self.btnDoorClose];
    
    UILabel *bj=[[UILabel alloc]init];
    bj.textAlignment=NSTextAlignmentCenter;//设置内容居中显示
    bj.text=@"南京梵祺展櫃有限公司 WS001";
    bj.textColor=[UIColor grayColor];
    bj.font=[UIFont fontWithName:@"Helvetica" size:10];
    
    CGFloat bjW=SCREENWIDTH;
    CGFloat bjH=15;
    CGFloat bjX=(SCREENWIDTH-bjW)/2;
    CGFloat bjY=SCREENHEIGHT-bjH-10;
    bj.frame=CGRectMake(bjX, bjY, bjW, bjH);
    [self.view addSubview:bj];

    
//为按钮添加状态点
    {
       
       // [self addStateViewButton:self.btnLampA stateView:self.LampAstate];
        
        self.LampAstate=[self addStateViewButton:self.btnLampA stateView:self.LampAstate];
     
        
        self.LampBstate=[self addStateViewButton:self.btnLampB stateView:self.LampBstate];
        self.doorOpenstate=[self addStateViewButton:self.btnDoorOpen stateView:self.doorOpenstate];
        self.doorStopstate=[self addStateViewButton:self.btnDoorStop stateView:self.doorStopstate];
        self.doorClosestate=[self addStateViewButton:self.btnDoorClose stateView:self.doorClosestate];
    
    }
    
}
-(UIView *)addStateViewButton:(mtButton*)button stateView:(UIView*)view
{
    view=[[UIView alloc]initWithFrame:CGRectMake((self.btnLampA.frame.size.width-12)/2, self.btnLampA.frame.size.height-14, 12, 12)];
    view.layer.cornerRadius=6;
    view.layer.masksToBounds=YES;
    //view.backgroundColor=[UIColor whiteColor];
    [button addSubview:view];
    return view;
}
//返回所要显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
//返回所要显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //有多少设备返回多少数
    NSMutableArray *tmp=[NSMutableArray array];
    int i=0;
    for (driverListModel *model in self.driverList) {
        i++;
        if(model.driverIP.length>5)//将有数据的数据模型放在一个新的数组中
        {
            
            [tmp addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    self.nwDeviceList=tmp;
    return self.nwDeviceList.count;
}
//返回当前行的内容
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.nwDeviceList[row];
    
    

}
/**
 *  当用户选择后调用这个函数
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{//设备id 为row+1 设备id计数从一开始
    
    //进行socket连接
    //获取ip以及端口
    NSInteger myRow= [self.nwDeviceList[row] integerValue];
    
    NSLog(@"我的myRowID是 %d",myRow);
    [self setHostAndPort:myRow-1];
    
    
    //断开上次连接
    [self cutOffSocket];
    self.LampAstate.backgroundColor=btnColor;
    self.LampBstate.backgroundColor=btnColor;
    self.doorOpenstate.backgroundColor=btnColor;
    self.doorStopstate.backgroundColor=btnColor;
    self.doorClosestate.backgroundColor=btnColor;
    //进行本次连接
    [self socketConnectHost];
    NSLog(@"ip is : %@,port is %d   "  ,self.socketHost,self.socketPort);
}
/**
 *  <#Description#>
 *作用: 当picker view需要给指定的component.row指定title时,调用此函数
 *  @param pickerView <#pickerView description#>
 *  @param row        <#row description#>
 *  @param component  <#component description#>
 *
 *  @return <#return value description#>
 */
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//  
//}
/**
 *  socket
 */
/**
 *  socket连接
 */
-(void)socketConnectHost
{
    @try {
        //self.socketPort=8899;
        //self.socketHost=@"192.168.199.124";
        self.asyncSocket=[[AsyncSocket alloc]initWithDelegate:self];
        NSError *error=nil;
        if([self.asyncSocket connectToHost:self.socketHost onPort:self.socketPort error:&error])
        {
            NSLog(@"error is %@",error);
        }
        else{
           // NSLog(@"连接失败");
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
}
/**
 *  socket断开
 */
-(void)cutOffSocket
{
    self.asyncSocket.userData=SocketOfflineByUser;//声明是用户主动断开
    [self.asyncSocket disconnect];//断开连接
    self.socketState.backgroundColor=[UIColor grayColor];
    NSLog(@"断开socket连接");
}

/**
 *  初始化发送的数据
 */
-(NSData *)sendData:(Byte)type State:(Byte)state
{
   // NSData *sendData=[NSData alloc]initWithBytes:(nullable const void *) length:<#(NSUInteger)#>
    Byte sendBytes[7];
    sendBytes[0]=0xFF;
    sendBytes[1]=0xA5;
    sendBytes[2]=0x03;
    sendBytes[6]=0x5A;
    sendBytes[3]=type;
    sendBytes[4]=state;
    sendBytes[5]=(Byte)(3+sendBytes[3]+sendBytes[4]);
    NSData *sendData=[[NSData alloc]initWithBytes:sendBytes length:7];
    return sendData;
}
-(void)recData:(NSData*)data
{
    Byte *bytes=(Byte *)[data bytes];
    for (int i=0; i<[data length]; i++) {
        NSLog(@"%hhu",bytes[i]);
    }
    LAMPASTATE=(int)bytes[4];
    LAMPBSTATE=(int)bytes[5];
    DOORSTATE=(int)bytes[6];
   [UIView animateWithDuration:0.2 animations:^{
       if(LAMPASTATE==0)
       {
           self.LampAstate.backgroundColor=btnColor;
           // NSLog(@"设置0");
       }
       else
       {
           self.LampAstate.backgroundColor=[UIColor greenColor];
       }
       if(LAMPBSTATE==0)
       {
           self.LampBstate.backgroundColor=btnColor;
       }
       else
       {
           self.LampBstate.backgroundColor=[UIColor greenColor];
       }
       if(DOORSTATE==0)
       {
           self.doorStopstate.backgroundColor=[UIColor greenColor];
           self.doorOpenstate.backgroundColor=btnColor;
           self.doorClosestate.backgroundColor=btnColor;
       }
       else if(DOORSTATE==1)
       {
           self.doorStopstate.backgroundColor=btnColor;
           self.doorOpenstate.backgroundColor=[UIColor greenColor];
           self.doorClosestate.backgroundColor=btnColor;
       }
       else
       {
           self.doorStopstate.backgroundColor=btnColor;
           self.doorOpenstate.backgroundColor=btnColor;
           self.doorClosestate.backgroundColor=[UIColor greenColor];
       }

   }];
 
    NSLog(@"lampAstate:%d,lampBState:%d,DoorState:%d",LAMPASTATE,LAMPBSTATE,DOORSTATE);
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"已经发送数据");
   // [self.asyncSocket readDataToLength:8 withTimeout:1 tag:0];
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"连接成33333333功");
    [UIView animateWithDuration:0.2 animations:^{
        self.socketState.backgroundColor=[UIColor greenColor];//连接成功
    }];
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"%@",data);
    //接收到的数据
    if(data.length<10)
    {
        NSLog(@"%@",data);
        [self recData:data];
    }
}
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"当前连接已经断开");
    [UIView animateWithDuration:0.2 animations:^{
        self.socketState.backgroundColor=[UIColor grayColor];
    }];
    [self socketConnectHost];
}
-(void)lockSwitch_click
{
    if(self.lockSwitch.on)
    {
        self.lockLabel.text=@"Unlock";
        [self setUserInterface:YES];
    }
    else
    {
        
        self.lockLabel.text=@"Locked";
        [self setUserInterface:NO];
    }
}
/**
 *  设置界面是否可以交互的方法
 *
 *  @param isYes <#isYes description#>
 */
-(void)setUserInterface:(BOOL)isYes
{
    self.btnLampA.userInteractionEnabled=isYes;
    self.btnLampB.userInteractionEnabled=isYes;
    self.btnLampClose.userInteractionEnabled=isYes;
    self.btnDoorOpen.userInteractionEnabled=isYes;
    self.btnDoorStop.userInteractionEnabled=isYes;
    self.btnDoorClose.userInteractionEnabled=isYes;
    self.pickerView.userInteractionEnabled=isYes;

}
@end
