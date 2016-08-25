//
//  ViewController.m
//  runtimeTest
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "idol.h"
#import "idol+height.h"
#import "family.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)getProperty:(id)sender {
    unsigned int count = 0;
    Ivar *allProperty = class_copyIvarList([idol class], &count);
//  获取所有属性
//    objc_property_t *allProperty = class_copyPropertyList([idol class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = allProperty[i];
        const char *PropertyName = ivar_getName(ivar);
        const char *PropertyType = ivar_getTypeEncoding(ivar);
//        objc_property_t ivar = allProperty[i];
//        const char *PropertyName = property_getName(ivar);
//        const char *PropertyType = property_getAttributes(ivar);
        NSLog(@"propertyName --%s,propertyType -- %s",PropertyName,PropertyType);
    }
    free(allProperty);
}
- (IBAction)getMethod:(id)sender {
    idol *myIdol = [[idol alloc]init];
    unsigned int count = 0;
    /**
     *  idol类也是一个对象，他是nsobject的一个实例化对象，其类方法存放在其metaclass的methodlist中，要获取idol的类方法，就要先获取idol类的metaclass。
     *  类的methodlist是实例方法，metaclass的methodlist是类对象选择器对应的类方法。
     */
//    Method *allMethod = class_copyMethodList(object_getClass([idol class]), &count);/**< 获取类的类方法*/
//    Method *allMethod = class_copyMethodList([myIdol class], &count);/**< 获取类的实例方法*/
    Method *allMethod = class_copyMethodList(objc_getMetaClass(class_getName([idol class])), &count);
//    Method *allMethod = class_copyMethodList(object_getClass(myIdol), &count);/**< 获取类的实例方法*/
//    Method *allMethod = class_copyMethodList([idol class], &count);/**< 获取类的实例方法*/
//    Method *allMethod = class_copyMethodList(object_getClass(object_getClass([idol class])), &count);/**< 获取NSObject所有方法*/
//    Method *allMethod = class_copyMethodList([NSMutableArray class], &count);/**< 获取NSMutableArray的实例方法*/
//    Method *allMethod = class_copyMethodList(object_getClass([NSMutableArray class]), &count);/**< 获取NSMutableArray类方法*/
//    Method *allMethod = class_copyMethodList(object_getClass(object_getClass([NSMutableArray class])), &count);/**< 获得NsObject的所有方法*/
//    Method *allMethod = class_copyMethodList(object_getClass(object_getClass(object_getClass([NSMutableArray class]))), &count);/**< 获取NSObject 的所有方法*/
//    Method *allMethod = class_copyMethodList([NSObject class], &count);/**< 获取的是NSObject的实例方法*/
//    Method *allMethod = class_copyMethodList(object_getClass([NSObject class]), &count);/**< 获取的是NSObeject的所有方法*/
//    Method *allMethod = class_copyMethodList([NSArray class], &count);/**< 获取NSArray的实例方法无NSMutableArray的方法*/
//    Method *allMethod = class_copyMethodList(object_getClass([NSArray class]), &count);/**< 获取NSArray的类方法*/
    for (int i = 0; i < count; i ++) {
        Method method = allMethod[i];
        SEL sel = method_getName(method);
        const char *MethodName = sel_getName(sel);
        NSLog(@"method -- %s",MethodName);
    }
    free(allMethod);
//    NSObject
}
- (IBAction)changePrivateProperty:(id)sender {
    idol *newIdol = [[idol alloc]init];
    NSLog(@"first--%@",newIdol);
    unsigned int count = 0;
    Ivar *allProperty = class_copyIvarList([idol class], &count);
    Ivar idolName = allProperty[1];
    object_setIvar(newIdol, idolName, @"wade");
    newIdol.age = 36;
    NSLog(@"second -- %@",newIdol);
    free(allProperty);
}
- (IBAction)addNewProperty:(id)sender {
    idol *myIdol = [[idol alloc]init];
    myIdol.height = 170;
    NSLog(@"%f",myIdol.height);
}
- (IBAction)addNewMethod:(id)sender {
    idol *myIdol = [[idol alloc]init];
    class_addMethod([idol class], @selector(eat), (IMP)eatFood, "v@:");/**< IMP指向方法实现的函数*/
    [myIdol performSelector:@selector(eat)];
}

void eatFood(id self, SEL _cmd){
    NSLog(@"eat food");
}
- (IBAction)exchangeMethod:(id)sender {
    Method method1 = class_getInstanceMethod([idol class], @selector(addIdol:));
    Method method2 = class_getInstanceMethod([idol class], @selector(addAge:));
    method_exchangeImplementations(method1, method2);
    idol *myIdol = [[idol alloc]init];
    [myIdol addIdol:@"ads"];
}

- (IBAction)modelInModel:(id)sender {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"idol.json" ofType:nil];
    NSData *json = [NSData dataWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    idol *newIdol = [self objectWithDict:jsonDic WithClass:[idol class]];
    NSLog(@"%@",newIdol.family.son);
}
/**
 *  将字典转为model
 *
 *  @param dic   要转换的字典
 *  @param class model 类
 *
 *  @return 赋值后的model类
 */

- (id) objectWithDict:(NSDictionary *)dic WithClass:(id)class{
    unsigned int count = 0;
    NSObject *result = [[class alloc]init];
    Ivar *ivars = class_copyIvarList(class, &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(ivar)];
        propertyName = [propertyName substringFromIndex:1];
        id value = dic[propertyName];
        if (value == nil) {
            continue;
        }
        NSString *propertyType = [NSString stringWithFormat:@"%s",ivar_getTypeEncoding(ivar)];
        if ([propertyType containsString:@"@"]) {
            //去除@“XX”;
            propertyType = [propertyType substringWithRange:NSMakeRange(2, propertyType.length - 3)];
            if (![propertyType hasPrefix:@"NS"]) {
                value = [self objectWithDict:value WithClass:NSClassFromString(propertyType)];
            }
        }
        [result setValue:value forKey:propertyName];
    }
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
