//
//  ViewController.m
//  obj_c_app
//
//  Created by Mary Gerina on 11/26/18.
//  Copyright © 2018 Mary Gerina. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    globalVariable = @"use and change value where you want. It's really fascinating";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(IBAction)actionBtnTaaped:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = [btn tag];
    
    switch (tag) {
        case 0:
            [[AppDelegate delegate] initialseTimerNotificationData];
            break;
            
        default:
            break;
    }
    
}


@end
