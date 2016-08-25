//
//  idol+height.m
//  runtimeTest
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "idol+height.h"
#import <objc/runtime.h>

const char *key = "idol";
@interface idol ()

@end
@implementation idol (height)

- (void)setHeight:(CGFloat)height{
    NSNumber *heightNum = [NSNumber numberWithFloat:height];
    objc_setAssociatedObject(self, key, heightNum, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)height{
    NSNumber *num = objc_getAssociatedObject(self, key);
    return [num floatValue];
}

@end
