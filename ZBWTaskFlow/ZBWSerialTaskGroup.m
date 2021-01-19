//
//  ZBWBlockTaskGroup.m
//  ZBWTaskFlow
//
//  Created by Bowen on 2017/11/21.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import "ZBWSerialTaskGroup.h"

@interface ZBWSerialTaskGroup ()

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ZBWSerialTaskGroup

- (void)runWithData:(id)userInfo {
    dispatch_async(self.dispathQueue, ^{
        [super runWithData:userInfo];
        self.currentIndex = -1;
        
        if (self.taskList.count == 0) {
            // 完成结束
            self.status = ZBWTaskStatus_Finished;
            self.finishBlock ? self.finishBlock(YES, userInfo, self) : nil;
            return;
        }
        [self runNextTask:userInfo];
    });
}

- (void)runNextTask:(id)userInfo {
    dispatch_async(self.dispathQueue, ^{
        ZBWTask *nextTask = [self nextTask];
        if (!nextTask) {
            // 完成结束
            self.status = ZBWTaskStatus_Finished;
            self.finishBlock ? self.finishBlock(YES, userInfo, self) : nil;
            return;
        }
        __weak ZBWSerialTaskGroup *weakSelf = self;
        nextTask.finishBlock = ^(BOOL isFinished, id userInfo, ZBWTask *task) {
            if (!weakSelf) {
                return;
            }
            if (isFinished) {
                [weakSelf runNextTask:userInfo];
            } else {
                // 失败结束
                dispatch_async(weakSelf.dispathQueue, ^{
                    weakSelf.status = ZBWTaskStatus_Error;
                    weakSelf.finishBlock ? weakSelf.finishBlock(NO, userInfo, weakSelf) : nil;
                });
            }
        };
        [nextTask runWithData:userInfo];
    });
}

- (ZBWTask *)nextTask{
    _currentIndex++;
    if (_currentIndex >= self.taskList.count) {
        return nil;
    }
    return [self.taskList objectAtIndex:_currentIndex];
}

@end
