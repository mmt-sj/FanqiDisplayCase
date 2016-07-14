//
//  driverList.m
//  梵祺展櫃
//
//  Created by hlen on 16/4/19.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "driverListModel.h"
#import "mtFileOperations.h"
@interface driverListModel()

@property(nonatomic,strong)NSMutableArray * driverList;

@end

@implementation driverListModel

//初始化字典
-(driverListModel *)initWithDic:(NSDictionary *)dic
{
    if([super init])
    {
        self.driverType=[dic objectForKey:@"driverType"];
        self.driverIP=[dic objectForKey:@"driverIP"];
        self.driverName=[dic objectForKey:@"driverName"];
    }
    return self;
}

//获取数据的方法
-(NSMutableArray *)getDriverListArray
{
    //NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"drvierList" ofType:@"plist"];
    NSString *plistPath=[mtFileOperations DocumentPath:@"drvierList.plist"];
    NSMutableDictionary *muDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSMutableArray *muArray=[[NSMutableArray alloc]init];
    //NSMutableArray *myArray=[muDict objectForKey:@"driver"];
   // NSLog(@"myArray MOdel   %@",myArray);
    for(NSDictionary *dict in [muDict objectForKey:@"driver"])
    {
        driverListModel * driverList=[[driverListModel alloc]initWithDic:dict];
        [muArray addObject:driverList];
    }
    self.driverList=muArray;
    return muArray;
}

/**
 *  添加设备
 *
 *  @param driverID   设备id ﹣1代表自動選擇序列
 *  @param driverName 设备名称
 *  @param driverIP   设备ip
 *  @param driverType 设备类型
 *
 *  @return 返回是否设置成功
 */
//修改设备
-(BOOL)modifyDriver:(NSInteger)deviceID deviceName:(NSString*)name deviceIP:(NSString *)ip
{
    NSString *plistPath=[mtFileOperations DocumentPath:@"drvierList.plist"];
    NSMutableDictionary *muDict=[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSMutableArray *tempArray=[muDict objectForKey:@"driver"];
    
    if(deviceID==-1)
    {
        
        for (NSMutableDictionary *temp in tempArray) {
            if([[temp objectForKey:@"driverIP"] isEqualToString:ip])
            {
                return NO;
            }
        }
        NSInteger index=0;
        
        for (NSMutableDictionary *temp in tempArray) {
            index++;
            
            if([[temp objectForKey:@"driverIP"] length]<7)
            {
                deviceID=index-1;
                break;
            }
            
        }
    }
    NSMutableDictionary *tempDict=[tempArray objectAtIndex:deviceID];
    [tempDict setValue:name   forKey:@"driverName"];
    [tempDict setValue:ip     forKey:@"driverIP"];

    
    [tempArray removeObjectAtIndex:deviceID];
    [tempArray insertObject:tempDict atIndex:deviceID];

    [muDict setValue:tempArray forKey:@"driver"];
    [muDict writeToFile:plistPath atomically:YES];

    
    [self refreshDriverList];
    return YES;
}
-(BOOL)addDriver:(int)driverID driverName:(NSString *)name driverIP:(NSString *)ip
      driverType:(NSString *)type
{
    
    [self refreshDriverList];
    return YES;
}
//移除设备
-(BOOL)removeDriver:(int)driverID
{
    
    [self refreshDriverList];
    return YES;
}

//由于数据在修改plist之后 缓存数据会发生改变 所以在用户修改数据之后 请调用该方法
//
-(void)refreshDriverList
{
    [self.driverList removeAllObjects];
    self.driverList=[self getDriverListArray];
}

@end
