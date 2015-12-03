//
//  ViewController.h
//  KVC与KVODemo
//
//  Created by Lemon on 15/12/3.
//  Copyright © 2015年 LemonXia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPerson.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) MyPerson *testPerson;


- (IBAction)onBtnTest:(id)sender;
@end

