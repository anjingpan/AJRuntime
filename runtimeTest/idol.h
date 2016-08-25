//
//  idol.h
//  runtimeTest
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "family.h"

@interface idol : NSObject
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *honour;
@property (nonatomic, strong) family *family;

- (void)addIdol: (NSString *)name;

- (void)addAge: (NSInteger)age;

+ (void)initWithName :(NSString *)name;
@end
