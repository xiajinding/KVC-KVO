//
//  ViewController.m
//  KVC与KVODemo
//
//  Created by Lemon on 15/12/3.
//  Copyright © 2015年 LemonXia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self testKVC];
    [self testKVO];
}

/**
 *  KVC，即是指 NSKeyValueCoding，一个非正式的Protocol，提供一种机制来间接访问对象的属性。而不是通过调用Setter、Getter方法访问。KVO 就是基于 KVC 实现的关键技术之一。
 */
- (void)testKVC {
    /**
      当myPerson实例化后，常规来说是无法访问这个对象的_height属性的，不过通过KVC我们做到了，代码就是testKVC这个函数。
     */
    _testPerson = [[MyPerson alloc]init];
    NSLog(@"testPerson init height = %@",[_testPerson valueForKey:@"height"]);
    [_testPerson setValue:[NSNumber numberWithInt:180] forKey:@"height"];
    NSLog(@"testPerson init height = %@",[_testPerson valueForKey:@"height"]);
    /**
     *  打印结果
     2015-12-03 14:28:01.128 KVC与KVODemo[42429:6297341] testPerson init hright = 0
     2015-12-03 14:28:01.128 KVC与KVODemo[42429:6297341] testPerson init hright = 180
     
     */
    
    /**
     *     KVC的常用方法：
     
     - (id)valueForKey:(NSString *)key; -(void)setValue:(id)value forKey:(NSString *)key;
     
     valueForKey的方法根据key的值读取对象的属性，setValue:forKey:是根据key的值来写对象的属性。
     
     注意：
     
     （1）. key的值必须正确，如果拼写错误，会出现异常
     
     （2）. 当key的值是没有定义的，valueForUndefinedKey:这个方法会被调用，如果你自己写了这个方法，key的值出错就会调用到这里来
     
     （3）. 因为类key反复嵌套，所以有个keyPath的概念，keyPath就是用.号来把一个一个key链接起来，这样就可以根据这个路径访问下去
     
     （4）. NSArray／NSSet等都支持KVC
     */
}

- (void)testKVO {
    /**
     在testKVO这个方法里面，我们注册了testPerson这个对象height属性的观察，这样当testPerson的height属性变化时， 会得到通知。在这个方法中还通过NSKeyValueObservingOptionNew这个参数要求把新值在dictionary中传递过来
     */
    _testPerson = [[MyPerson alloc]init];
    [_testPerson addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    /**
     *  重写了observeValueForKeyPath:ofObject:change:context:方法，这个方法里的change这个NSDictionary对象包含了相应的值。
     需要强调的是KVO的回调要被调用，属性必须是通过KVC的方法来修改的，如果是调用类的其他方法来修改属性，这个观察者是不会得到通知的
     */
    if ([keyPath isEqualToString:@"height"]) {
        NSLog(@"height is changed! new =%@",[change valueForKey:NSKeyValueChangeNewKey]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
}
- (IBAction)onBtnTest:(id)sender {
    int h = [[_testPerson valueForKey:@"height"] intValue];
    [_testPerson setValue:[NSNumber numberWithInt:h+1] forKey:@"height"];
    NSLog(@"person height=%@", [_testPerson valueForKey:@"height"]);
}
- (void)dealloc
{
    [_testPerson removeObserver:self forKeyPath:@"height" context:nil];
}
@end
