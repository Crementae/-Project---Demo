//
//  ViewController.m
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/12/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"


@interface ViewController ()


@end

@implementation ViewController{
   
}



- (void)viewDidLoad {
    
    
  
    
    [super viewDidLoad];

    

    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
