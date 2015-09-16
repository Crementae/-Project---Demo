//
//  NavigationViewController.h
//  ไม้ในไร่Project
//
//  Created by Adisorn Chatnaratanakun on 3/12/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end
