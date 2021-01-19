//
//  ZBWTaskGroup.h
//  ZBWTaskFlow
//
//  Created by Bowen on 2017/11/21.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import "ZBWTask.h"

/*
 *  ZBWTaskGroup 任务组
 *
*/
@interface ZBWTaskGroup : ZBWTask
// 执行队列, 默认是dispatch_get_main_queue()
@property (nonatomic) dispatch_queue_t  dispathQueue;

// 任务队列
@property (nonatomic) NSMutableArray    *taskList;

@property (nonatomic) NSInteger         finishedCount;

- (void)addTask:(ZBWTask *)task;

@end
