//
//  idol.m
//  runtimeTest
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "idol.h"
@interface idol()
@property (nonatomic, strong) NSString *name;
@end
@implementation idol
- (instancetype)init{
    self = [super init];
    if (self) {
        self.name = @"messi";
        self.age = 30;
    }
    return self;
}

- (void)addIdol:(NSString *)name{
    NSLog(@"name---%@",name);
}

- (void)addAge:(NSInteger)age{
    NSLog(@"age---%li",age);
}

+ (void)initWithName:(NSString *)name{
    NSLog(@"%@",name);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"name:%@,age:%li",self.name,self.age];
}
@end
