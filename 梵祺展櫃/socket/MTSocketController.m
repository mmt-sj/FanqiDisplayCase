//
//  MTSocketController.m
//  梵祺展櫃

//单类模式
//  Created by hlen on 16/7/28.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import "MTSocketController.h"

@interface MTSocketController()<AsyncSocketDelegate>

@end

@implementation MTSocketController
{
    AsyncSocket *_asyncSocket;
}

static MTSocketController *mTSocketController=nil;

/**
 *  单类模式方法
 */
+(instancetype)sharedMTSocketController{
    if(mTSocketController==nil){
        mTSocketController=[[MTSocketController alloc]init];
    }
    return mTSocketController;
}
/**
 *  由于alloc init每当使用一次就是创建一个新的对象 所以需要对该方法进行重写 
 可以始终只创建一个对象
 *
 *  @param zone <#zone description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if(mTSocketController==nil){
        mTSocketController=[super allocWithZone:zone];
    }
    return mTSocketController;
}
/**
 *  进行socket连接
 *
 *  @param ip   ip地址
 *  @param port 端口号
 *
 *  @return
 */
-(BOOL)connectSocketIP:(NSString*)ip port:(UInt16)port
{
    //
    @try {
        _asyncSocket=[[AsyncSocket alloc]initWithDelegate:self];
        NSError *err;
        if([_asyncSocket connectToHost:ip onPort:port error:&err])
        {
            //连接成功
            return YES;
        }else
        {
            return NO;
        }
    } @catch (NSException *exception) {
        return false;
        NSLog(@"%@",exception);
    } }
/**
 *  断开连接
 */
-(void)cutOffSocket
{

    [_asyncSocket disconnect];//断开连接

    NSLog(@"断开socket连接");
}
/**
 *  初始化发送的数据
 *  并发送数据
 */
-( void)sendData:(Byte)type State:(Byte)state
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
    [_asyncSocket writeData:sendData withTimeout:1 tag:1];
}

/**
 *  对接收到的数据进行格式化
 */
-(void)recData:(NSData*)data
{
    Byte *bytes=(Byte *)[data bytes];
    for (int i=0; i<[data length]; i++) {
        NSLog(@"%hhu",bytes[i]);
    }
    self.LAMPASTATE=(int)bytes[5];
    self.LAMPBSTATE=(int)bytes[4];
     self.DOORSTATE=(int)bytes[6];
    
    NSLog(@"lampAstate:%d,lampBState:%d,DoorState:%d",_LAMPASTATE,_LAMPBSTATE,_DOORSTATE);
}
/**
 *  发送数据后接收到的数据
 *  @param sock <#sock description#>
 *  @param data <#data description#>
 *  @param tag  <#tag description#>
 */
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if(data.length<10)
    {
        [self recData:data];
    }
}


@end
