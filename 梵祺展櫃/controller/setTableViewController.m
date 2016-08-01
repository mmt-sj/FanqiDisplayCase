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
@property(nonatomic,strong)driverListModel *deviceModel;
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
    self.deviceModel=model;
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
/**
 *  设置tableview可编辑
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//实现Cell可上下移动，调换位置，需要实现UiTableViewDelegate中如下方法：

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //发生移动所要执行的动作
    [self.deviceModel moveDeviceRowAtIndexPath:sourceIndexPath.row toIndexPath:destinationIndexPath.row];
    self.driverListArray=[self.deviceModel getDriverListArray];
    [self.tableView reloadData];
    [tableView setEditing:NO animated:YES];
}//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [tableView setEditing:NO animated:YES];
        //在这里进行删除的操作
        [self.deviceModel removeDriver:indexPath.row];
        self.driverListArray= [self.deviceModel getDriverListArray];//重新获取数据
        
        [self.tableView reloadData];
    
        #warning 删除操作//删除将要删除的删除
    }
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
//在下面方法中添加 cell.showsReorderControl =YES;
//使Cell显示移动按钮
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
        
        //设置cell显示移动按钮
        cell.showsReorderControl=YES;
        //箭头显示
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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

-(void)viewWillAppear:(BOOL)animated
{
    [self initData];
    [self.tableView reloadData];
    driverListModel *sa=self.driverListArray[3];
    NSLog(@"sasasasa%@",sa.driverName);
    
}
/**
 *  添加长按手势
 */
-(void)addGesture
{
    
}
@end
