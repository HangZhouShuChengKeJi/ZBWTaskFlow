//
//  ZBWTask.h
//  ZBWTaskFlow
//
//  Created by Bowen on 2017/11/21.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL ZBWTaskOpenLog;

#if DEBUG
    #define ZBWTaskLog(format, ...) \
        do {\
            if (1) {\
                printf(\
                       "\n<%s : %d> %s\n%s\n \n \n",\
                       [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
                       __LINE__,\
                       __func__,\
                       [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]\
                       );\
            }\
        }while(0)
#else
    #define ZBWTaskLog(format, ...)
#endif

typedef NS_ENUM(NSInteger, ZBWTaskStatus) {
    ZBWTaskStatus_Init = 0,         // 初始
    ZBWTaskStatus_Running,          // 运行中
    ZBWTaskStatus_Finished,         // 运行完成，成功
    ZBWTaskStatus_Error,            // 运行失败
    ZBWTaskStatus_Canceled          // 取消
};

@protocol ZBWTaskProtocol <NSObject>
- (void)runWithData:(id)userInfo;

- (void)cancel;
@end

@class ZBWTask;
typedef void(^ZBWTaskDidFinishBlock)(BOOL isFinished, id userInfo, ZBWTask *task);

// 任务主体
typedef void(^ZBWTaskRunBlock)(id userInfo, ZBWTask *task);

//
@interface ZBWTask : NSObject <ZBWTaskProtocol>
@property (nonatomic, copy) NSString                *name;

@property (nonatomic, assign) ZBWTaskStatus         status;
@property (nonatomic, copy) ZBWTaskDidFinishBlock   finishBlock;
@property (nonatomic, copy) ZBWTaskRunBlock         runBlock;


- (instancetype)initWithName:(NSString *)name;

// 完成后，调用一下
- (void)finish:(BOOL)isFinished userInfo:(id)userInfo;


@end
