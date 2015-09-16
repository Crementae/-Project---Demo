//
//  AllSeasonViewController.m
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/13/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "AllSeasonViewController.h"
#import "AllSeasonTreeDetails.h"
#import "SWRevealViewController.h"
#import "DataUtil.h"
#import "PlaceData.h"
#import "Location.h"
#import "Reachability.h"
#import "PreferencesManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "UIImageView+WebCache.h"




@interface AllSeasonViewController ()

@end

@implementation AllSeasonViewController{
    NSArray *tableData;
    PreferencesManager *appPrefs;
}

@synthesize tableView;
@synthesize detailView;
@synthesize TitleField;



-(BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)viewDidLoad {
    
    

    
  
    [super viewDidLoad];
    
    if (![self connected]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Not Found" message:@"Please check your network setting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
    
  
        

    //Load data
    DataUtil *util = [[DataUtil alloc] init];
    tableData = util.getData;
    appPrefs = [PreferencesManager sharedInstance];
    }
    
  
    

  
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
   
     
}

-(void)viewWillAppear:(BOOL)animated{
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *lang = [languages objectAtIndex:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    NSBundle *localBundle = [NSBundle bundleWithPath:path];
    
    
    TitleField.text = NSLocalizedStringFromTableInBundle(@"title_all_tree", nil, localBundle, nil);
    TitleField.font = [UIFont fontWithName:@"Anchan" size:27];
    TitleField.textColor = [UIColor whiteColor];
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(34/255.0) green:(139/255.0) blue:(34/255.0) alpha:1.0]];
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
  
    
    
    cell.tag = indexPath.row;
    [cell setOpaque:NO];
    [cell setBackgroundColor: [UIColor clearColor]];
    
    PlaceData *data = [tableData objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *sciNameLabel = (UILabel *)[cell viewWithTag:200];
    UIImageView *thumbnailImageView = (UIImageView *)[cell viewWithTag:300];
    nameLabel.text = data.name;
    sciNameLabel.text = data.scientific_name;
    
    
    
    [thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.thumbnail]] placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]options: SDWebImageDelayPlaceholder];
    
    return cell;
    
}







- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    PlaceData *data = [tableData objectAtIndex:indexPath.row];
    
    //if([data.gallery count] == 1){
    self.detailView = (AllSeasonTreeDetails *)[sb instantiateViewControllerWithIdentifier:@"AllSeasonView"];
    //}
    self.detailView.data = [tableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.detailView animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
