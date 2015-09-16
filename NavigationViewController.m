//
//  NavigationViewController.m
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/12/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "NavigationViewController.h"
#import "MapViewController.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ARViewController.h"



@interface NavigationViewController ()

@end

@implementation NavigationViewController{
    NSArray *menu;
    CLLocationManager *locationManager;
}


@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    // 3gSetting
    // offlineSetting
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    menu = @[@"first"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [menu count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row ==  1){
        //MapViewController *controller = [[MapViewController alloc] init];
        
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        MapViewController *controller = (MapViewController *)[sb instantiateViewControllerWithIdentifier:@"Map"];
        
        UINavigationController *navController = (UINavigationController*)self.revealViewController.frontViewController;
        
        [navController pushViewController:controller animated:YES];
        
        [self.revealViewController revealToggleAnimated:YES];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *lang = [languages objectAtIndex:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    NSBundle *localBundle = [NSBundle bundleWithPath:path];
    
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    
    NSString *sidebarName = @"";
    
    switch (indexPath.row) {
        case 0:{
               sidebarName = @"sidebar_map_label";
            break;
        }
        
       
        default:
            break;
    }
    
    
    titleLabel.text = NSLocalizedStringFromTableInBundle(sidebarName, nil, localBundle, nil);
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue isKindOfClass:[SWRevealViewControllerSegue class]]){
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc){
            
            UINavigationController *navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated: NO];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}


@end
