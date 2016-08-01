//
//  driverList.h
//  梵祺展櫃
//
//  Created by hlen on 16/4/19.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface driverListModel : NSObject
@property(nonatomic,copy)NSString *driverIP;//设备ip
@property(nonatomic,copy)NSString *driverType;//设备类型 0 lamp 1 door
@property(nonatomic,copy)NSString *driverName;//设备名称


-(driverListModel *)initWithDic:(NSDictionary *)dic;

-(NSMutableArray *)getDriverListArray;

-(BOOL)modifyDriver:(NSInteger)deviceID deviceName:(NSString*)name deviceIP:(NSString *)ip;

-(BOOL)removeDriver:(NSInteger)driverID;

-(void)moveDeviceRowAtIndexPath:(NSInteger)row toIndexPath:(NSInteger)toRow;

@end
