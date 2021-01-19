//
//  ZBWTaskGroup.m
//  ZBWTaskFlow
//
//  Created by Bowen on 2017/11/21.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import "ZBWTaskGroup.h"

@implementation ZBWTaskGroup

- (void)addTask:(ZBWTask *)task {
    dispatch_async(self.dispathQueue, ^{
        if (!self.taskList) {
            self.taskList = [NSMutableArray arrayWithCapacity:3];
        }
        if ([self.taskList containsObject:task]) {
            NSString *errorStr = [NSString stringWithFormat:@"ZBWTaskGroup 不能重复添加task[%@]", [task description]];
            NSAssert(NO, errorStr);
        }
        if (self.status != ZBWTaskStatus_Init) {
            return;
        }
        
        [self.taskList addObject:task];
    });
}

- (dispatch_queue_t)dispathQueue {
    if (!_dispathQueue) {
        _dispathQueue = dispatch_get_main_queue();
    }
    return _dispathQueue;
}

- (NSString *)description {
    NSString *str = [NSString stringWithFormat:@"[TaskGroup=%@] taskList.count=%lu, finished=%ld", self.name, (unsigned long)self.taskList.count, (long)self.finishedCount];
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@【【\n", str];
    for (ZBWTask *task in self.taskList) {
        [desc appendString:task.description];
        [desc appendString:@"\n"];
    }
    [desc appendString:@"】】"];
    return [desc copy];
}

@end
