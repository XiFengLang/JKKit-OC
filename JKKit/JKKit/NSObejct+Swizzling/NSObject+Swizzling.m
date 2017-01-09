//
//  NSObject+Swizzling.m
//  JKMethodSwizzling
//
//  Created by 蒋鹏 on 17/1/3.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//
//  Runtime Method Swizzling 使用小结   简书[http://www.jianshu.com/p/437fd9d399a3]
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>



@implementation NSObject (Swizzling)

void JK_ExchangeInstanceMethod(SEL originalSEL, SEL objectSEL, Class objectClass) {
    // 方法调换，实则调换2个方法实现，即调换IMP（方法以函数指针来表示，IMP指向方法实现）
    Method originalMethod = class_getInstanceMethod(objectClass, originalSEL);
    Method replaceMethod = class_getInstanceMethod(objectClass, objectSEL);
    

    if (originalMethod == NULL || replaceMethod == NULL) {
#ifdef JKLog
        JKLog(@"\n.\tWarning! JK_ExchangeInstanceMethod 失败!  [%@及其SuperClasses] 均未实现方法 [%@]\n.",objectClass,originalMethod == NULL ? NSStringFromSelector(originalSEL) : NSStringFromSelector(objectSEL));
#else
        NSLog(@"\n.\tWarning! JK_ExchangeInstanceMethod 失败!  [%@及其SuperClasses] 均未实现方法 [%@]\n.",objectClass,originalMethod == NULL ? NSStringFromSelector(originalSEL) : NSStringFromSelector(objectSEL));
#endif
        return;
    }
    
    // 将customMethod实现添加到objectClass中，并且将originalSEL指向新添加的customMethod。
    BOOL add = class_addMethod(objectClass, originalSEL, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    
    if (add) {
        // 添加成功，再将objectSEL指向原有的originalMethod，实现交换
        // 当前类或者父类没有实现originalSEL会执行这一步
        class_replaceMethod(objectClass, objectSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        
    } else {
        // 已经实现customMethod，对systemMethod和customMethod的实现指针IMP进行交换
        method_exchangeImplementations(originalMethod, replaceMethod);
    }
    
    
    
/**<  
 继承关系如：ViewController -> BaseViewController ->  UIViewController
 用作测试的originalSEL：@selector(viewWillAppear:)
 
 1.对ViewController进行ExchangeInstanceMethod，objectSEL：@selector(edf_viewWillAppear:)，\
    而且ViewController和父类BaseViewController都【没有实现viewWillAppear】,\
    add = YES;
 
 2.对UIViewController基类进行ExchangeInstanceMethod，objectSEL：@selector(jk_viewWillAppear:)，\
    add = NO。
 
 3.在操作2的基础上，如果在任何手动创建的类.m的(+ load)方法中执行操作1【不实现viewWillAppear:】,\
    add = YES，对于ViewController只会执行@selector(edf_viewWillAppear:),不会执行@selector(jk_viewWillAppear:),其他控制器则会执行@selector(jk_viewWillAppear:)。
 
 4.在操作2的基础上，如果在任何手动创建的类.m除【(+ load)以外】的方法中执行操作1【不实现viewWillAppear:】,\
    add = YES，对于ViewController既执行@selector(edf_viewWillAppear:)又执行@selector(jk_viewWillAppear:),其他控制器则会执行@selector(jk_viewWillAppear:)。
 
 5.在操作2的基础上，如果在任何手动创建的类.m的(+ load)方法中执行操作1，但是ViewController或者父类BaseViewController正常【实现了viewWillAppear:方法】,\
    add = NO，对于ViewController既执行@selector(edf_viewWillAppear:)又执行@selector(jk_viewWillAppear:),其他控制器则会执行@selector(jk_viewWillAppear:),和操作4结果差不多。
 
 初步得出的结论是 当前类或者父类没有实现originalSEL（UIViewController排除在外），add = YES，并且执行class_addMethod前后的class_getInstanceMethod(objectClass, originalSEL)的指针地址不一样。\
 add = NO的时候，class_addMethod前后的class_getInstanceMethod(objectClass, originalSEL)的指针地址一样
 */

}



void JK_ExchangeClassMethod(SEL originalSEL, SEL objectSEL, Class objectClass) {
    // 方法调换，实则调换2个方法实现，即调换IMP（方法以函数指针来表示，IMP指向方法实现）
    Method originalMethod = class_getClassMethod(objectClass, originalSEL);
    Method replaceMethod = class_getClassMethod(objectClass, objectSEL);
    
    
    if (originalMethod == NULL || replaceMethod == NULL) {
#ifdef JKLog
        JKLog(@"\n.\tWarning! JK_ExchangeClassMethod 失败!  [%@及其SuperClasses] 均未实现方法 [%@]\n.",objectClass,originalMethod == NULL ? NSStringFromSelector(originalSEL) : NSStringFromSelector(objectSEL));
#else
        NSLog(@"\n.\tWarning! JK_ExchangeClassMethod 失败!  [%@及其SuperClasses] 均未实现方法 [%@]\n.",objectClass,originalMethod == NULL ? NSStringFromSelector(originalSEL) : NSStringFromSelector(objectSEL));
#endif
        return;
    }
    
    /// 交换实例方法的写法在这失效了，所以直接进行了method_exchangeImplementations，待研究
    method_exchangeImplementations(originalMethod, replaceMethod);
}






@end




@implementation UIViewController (Swizzling)

+ (void)load {
    
    /**<
     dispatch_once: 如果子类中调用了[super load]，父类的Load就会调用2次，所以加上dispatch_once以防万一。
     DEBUG: 有些Swizzling只是为了调试，发布版本并不需要
     
     */
    
#ifdef DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JK_ExchangeInstanceMethod(@selector(viewWillAppear:), @selector(jk_viewWillAppear:), self);
    });
#endif
}


- (void)jk_viewWillAppear:(BOOL)animated{
    [self jk_viewWillAppear:animated];
    
    NSString * className = NSStringFromClass([self class]);
    if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_"]) {
#ifdef JKLog
        JKLog(@"即将显示:%@   备注:%@",self.class,self.view.accessibilityIdentifier);
#else
        NSLog(@"即将显示:%@   备注:%@",self.class,self.view.accessibilityIdentifier);
#endif
    }
}

@end




@implementation UIImage (Swizzling)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JK_ExchangeClassMethod(@selector(imageNamed:), @selector(jk_imageNamed:), self);
    });
}


/**
 优先无缓存加载图片,imageWithContentsOfFile
 */
+ (UIImage *)jk_imageNamed:(NSString *)name{
    UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:[name hasSuffix:@"jpg"] ? nil : @"png"]];
    if (!image) {
        image = [self jk_imageNamed:name];
    }
    
    if (image == nil) {
#ifdef JKLog
        JKLog(@"\nWarning! 图片加载失败!  imageName:%@",name);
#else
        NSLog(@"\nWarning! 图片加载失败!  imageName:%@",name);
#endif
    }
    return image;
}

@end



@implementation NSDictionary (Swizzling)

+ (void)load {
#ifdef DEBUG
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            JK_ExchangeInstanceMethod(@selector(descriptionWithLocale:), @selector(jk_descriptionWithLocale:), self);
        });
#endif
}


- (NSString *)jk_descriptionWithLocale:(id)locale {
    if (self == nil || self.allKeys.count == 0) {
        return [self jk_descriptionWithLocale:locale];
    } else {
        @try {
            NSError * error = nil;
            NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
            if (error) {
                return [self jk_descriptionWithLocale:locale];
            } else {
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
        } @catch (NSException *exception) {
            return [self jk_descriptionWithLocale:locale];
        }
    }
}

@end


@implementation NSArray (Swizzling)

//+ (void)load {
//#ifdef DEBUG
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            JK_ExchangeInstanceMethod(@selector(descriptionWithLocale:), @selector(jk_descriptionWithLocale:), self);
//        });
//#endif
//}
//
//
//- (NSString *)jk_descriptionWithLocale:(id)locale {
//    if (self == nil || self.count == 0) {
//        return [self jk_descriptionWithLocale:locale];
//    } else {
//        @try {
//            NSError * error = nil;
//            NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
//            if (error) {
//                return [self jk_descriptionWithLocale:locale];
//            } else {
//                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            }
//        } @catch (NSException *exception) {
//            return [self jk_descriptionWithLocale:locale];
//        }
//    }
//}




@end


@implementation NSArray (SafeSwizzling)
static const char * kArrayClass = "__NSArrayI";

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JK_ExchangeInstanceMethod(@selector(objectAtIndex:), @selector(jk_objectAtIndexI:), objc_getClass(kArrayClass));
    });
}

- (id)jk_objectAtIndexI:(NSUInteger)index {
    if (index < self.count) {
        return [self jk_objectAtIndexI:index];
    } else {
#ifdef JKLog
        JKLog(@"数组查询越界,return <null>。 --[NSArray objectAtIndex:]-- index=%zd   array.count=%zd",index,self.count);
#else
        NSLog(@"数组查询越界,return <null>。 --[NSArray objectAtIndex:]-- index=%zd   array.count=%zd",index,self.count);
#endif
        
        return [NSNull null];
    }
}
@end


@implementation NSMutableArray (SafeSwizzling)
static const char * kMutArrayClass = "__NSArrayM";

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JK_ExchangeInstanceMethod(@selector(insertObject:atIndex:), @selector(jk_insertObject:atIndex:), objc_getClass(kMutArrayClass));
        JK_ExchangeInstanceMethod(@selector(objectAtIndex:), @selector(jk_objectAtIndexM:), objc_getClass(kMutArrayClass));
    });
}

- (void)jk_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
#ifdef JKLog
        JKLog(@"数组插值越界 --[NSMutableArray insertObject: atIndex:]-- object=%@   index=%zd      array.count=%zd",anObject,index,self.count);
#else 
        NSLog(@"数组插值越界 --[NSMutableArray insertObject: atIndex:]-- object=%@   index=%zd      array.count=%zd",anObject,index,self.count);
#endif
    } else if (anObject && ![anObject isKindOfClass:[NSNull class]]) {
        [self jk_insertObject:anObject atIndex:index];
    } else if (anObject != nil) {
        [self jk_insertObject:anObject atIndex:index];
    } else {
#ifdef JKLog
        JKLog(@"传入空值Nil --[NSMutableArray insertObject: atIndex:]-- object=%@   index=%zd",anObject,index);
#else
        NSLog(@"传入空值Nil --[NSMutableArray insertObject: atIndex:]-- object=%@   index=%zd",anObject,index);
#endif
    }
}

- (id)jk_objectAtIndexM:(NSUInteger)index {
    if (index < self.count) {
        return [self jk_objectAtIndexM:index];
    } else {
#ifdef JKLog
        JKLog(@"数组查询越界,return <null>。  --[NSMutableArray objectAtIndex:]-- index=%zd   array.count=%zd",index,self.count);
#else
        NSLog(@"数组查询越界,return <null>。 --[NSMutableArray objectAtIndex:]-- index=%zd   array.count=%zd",index,self.count);
#endif
        return [NSNull null];
    }
}


@end



@implementation NSMutableDictionary (SafeSwizzling)
static const char * kMutDictClass = "__NSDictionaryM";
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JK_ExchangeInstanceMethod(@selector(setObject:forKey:), @selector(jk_setObject:forKey:), objc_getClass(kMutDictClass));
    });
}
- (void)jk_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self jk_setObject:anObject forKey:aKey];
    } else {
#ifdef JKLog
        JKLog(@"传入空值Nil --[NSMutableDictionary setObject: forKey:]-- object=%@   key=%@",anObject,aKey);
#else
        NSLog(@"传入空值Nil --[NSMutableDictionary setObject: forKey:]-- object=%@   key=%@",anObject,aKey);
#endif
    }
}
@end








