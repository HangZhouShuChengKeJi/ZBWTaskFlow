//
//  ZBWCocurrentTaskGroup.m
//  ZBWTaskFlow
//
//  Created by Bowen on 2017/11/21.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import "ZBWConcurrentTaskGroup.h"

@interface ZBWConcurrentTaskGroup()

@property (nonatomic) dispatch_queue_t  concurrentQueue;

@end

@implementation ZBWConcurrentTaskGroup

- (void)runWithData:(id)userInfo {
    dispatch_async(self.dispathQueue, ^{
        [super runWithData:userInfo];
        
        __weak typeof(self) weakSelf = self;
        if (weakSelf.taskList.count == 0) {
            // 完成结束
            self.status = ZBWTaskStatus_Finished;
            self.finishBlock ? self.finishBlock(YES, userInfo, self) : nil;
            return;
        }
        
        for (ZBWTask *task in weakSelf.taskList) {
            task.finishBlock = ^(BOOL isFinished, id userInfo, ZBWTask *task) {
                if (!weakSelf) {
                    return;
                }
                [weakSelf doSubTaskFinish:task isFinished:isFinished userInfo:userInfo];
            };
            dispatch_async(self.concurrentQueue, ^{
                [task runWithData:userInfo];
            });
        }
    });
}

- (void)doSubTaskFinish:(ZBWTask *)task isFinished:(BOOL)isFinished userInfo:(id)userInfo {
    dispatch_async(self.dispathQueue, ^{
        if (self.status != ZBWTaskStatus_Running) {
            return;
        }
        if (isFinished) {
            self.finishedCount++;
        }
        else {
            self.status = ZBWTaskStatus_Error;
            self.finishBlock ? self.finishBlock(NO, userInfo, self) : nil;
            return;
        }
        
        if (self.finishedCount == self.taskList.count) {
            self.status = ZBWTaskStatus_Finished;
            self.finishBlock ? self.finishBlock(YES, userInfo, self) : nil;
        }
    });
}

- (dispatch_queue_t)concurrentQueue {
    if (!_concurrentQueue) {
        _concurrentQueue = dispatch_queue_create("com.taskflow.concurrentTaskGroup", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrentQueue;
}

@end
