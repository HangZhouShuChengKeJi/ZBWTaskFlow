//
//  ZBWTask.m
//  ZBWTaskFlow
//
//  Created by Bowen on 2017/11/21.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import "ZBWTask.h"

BOOL ZBWTaskOpenLog = false;

@implementation ZBWTask

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

- (void)runWithData:(id)userInfo {
    ZBWTaskLog(@"【task=%@】开始执行任务", self.name);
    if (self.status != ZBWTaskStatus_Init) {
        ZBWTaskLog(@"【task=%@】状态[%ld]不是\"初始状态\"", self.name, (long)self.status);
        return;
    }
    self.status = ZBWTaskStatus_Running;
    self.runBlock ? self.runBlock(userInfo, self) : nil;
}

- (void)finish:(BOOL)isFinished userInfo:(id)userInfo {
    if (isFinished) {
        self.status = ZBWTaskStatus_Finished;
    } else {
        self.status = ZBWTaskStatus_Error;
    }
    self.finishBlock ? self.finishBlock(isFinished, userInfo, self) : nil;
}

- (void)cancel {
    if (self.status == ZBWTaskStatus_Running || self.status == ZBWTaskStatus_Init) {
        self.status = ZBWTaskStatus_Canceled;
    }
}


- (NSString *)description {
    return [NSString stringWithFormat:@"[task=%@] status:%ld", self.name, (long)self.status];
}

@end
