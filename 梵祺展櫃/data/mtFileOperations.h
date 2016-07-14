//
//  myPlist.h
//  梵祺展櫃
//
//  Created by hlen on 16/5/13.
//  Copyright © 2016年 mmt&sf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mtFileOperations : NSObject
//获得document文件路径，名字方便记忆

+(NSString *) DocumentPath:(NSString *)filename;

//拷贝文件到沙盒

+(int) CopyFileToDocument:(NSString*)FileName;



@end
