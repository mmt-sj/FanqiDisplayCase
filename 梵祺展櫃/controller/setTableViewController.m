//
//  setTableViewController.m
//  梵祺展櫃
//
//  Created by hlen on 16/4/23.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "setTableViewController.h"
#import "setPasswordViewController.h"
#import "setDriverInfoViewController.h"
#import "smartAddDeviceViewController.h"

@interface setTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *driverListArray;
@end

@implementation setTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    [self.navigationItem setTitle:@"設置"];
    
    [self.tableView setTableHeaderView:[self createHeaderView]];
    
    //获取设备信息
    [self initData];
    //添加修改密码的按钮
    UIBarButtonItem *setPasswordBarButton=[[UIBarButtonItem alloc]initWithTitle:@"修改密码" style:UIBarButtonItemStyleDone target:self action:@selector(setPasswordClick)];
    self.navigationItem.rightBarButtonItem=setPasswordBarButton;
    // Do any additional setup after loading the view.
    //

}

-(void)initData
{
    driverListModel *model=[[driverListModel alloc]init];
    self.driverListArray=[model getDriverListArray];
}
//修改密码点击事件
-(void)setPasswordClick
{
    setPasswordViewController *setPwdView=[[setPasswordViewController alloc]init];
    [self.navigationController pushViewController:setPwdView animated:YES];
    
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        driverListModel *data=self.driverListArray[indexPath.row];
    
      

        cell.textLabel.text=data.driverName;
        cell.detailTextLabel.text=data.driverIP;
 
        cell.imageView.image=[UIImage imageNamed:@"底色"];
        cell.imageView.layer.cornerRadius=20;
        cell.imageView.layer.masksToBounds=YES;
        UILabel *number=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 40 , 40)];
        number.textAlignment=NSTextAlignmentCenter;
        //[number setFont:[UIFont systemFontOfSize:12]];
        [number setFont:[UIFont systemFontOfSize:20 weight:10]];
        [number setTextColor:[UIColor whiteColor]];
        number.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        [cell.imageView addSubview:number];
        
        //箭头显示
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}
-(UIView *)createHeaderView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    [view addSubview:btn];
    btn.backgroundColor=btnColor;
    [btn setTitle:@" 智能添加設備" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btn_click) forControlEvents:UIControlEventTouchUpInside];
    //btn.layer.cornerRadius=5;
   // btn.layer.masksToBounds=YES;
    
    return view;
}
-(void)btn_click
{
    smartAddDeviceViewController *smartView=[[smartAddDeviceViewController alloc]init];
    [self.navigationController pushViewController:smartView animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    setDriverInfoViewController *setInfo=[[setDriverInfoViewController alloc]init];
    setInfo.cellRow=indexPath.row;
    [self.navigationController pushViewController:setInfo animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self initData];
    [self.tableView reloadData];
    driverListModel *sa=self.driverListArray[3];
    NSLog(@"sasasasa%@",sa.driverName);
    
}
@end
