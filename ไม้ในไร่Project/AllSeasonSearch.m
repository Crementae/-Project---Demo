//
//  AllSeasonSearch.m
//  ไม้ในไร่Project
//
//  Created by Crementae on 8/19/15.
//  Copyright (c) 2015 Adisorn Chatnartanakun. All rights reserved.
//

#import "AllSeasonSearch.h"
#import "AllSeasonTreeDetails.h"
#import "SWRevealViewController.h"
#import "DataUtil.h"
#import "PlaceData.h"
#import "Location.h"
#import "Reachability.h"
#import "PreferencesManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "UIImageView+WebCache.h"



@interface AllSeasonSearch ()

@end

@implementation AllSeasonSearch{
    
    NSArray *tableData;
    NSArray *tempTableData;
    CGRect tableViewFrame;
    PreferencesManager *appPrefs;
    
}

@synthesize tableView;
@synthesize detailView;
@synthesize searchField;
@synthesize TitleField;



-(BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
- (void)viewDidLoad {
    
    

    [super viewDidLoad];
    
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:(@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(Back:)];
    [newBackButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = newBackButton;
   

    if (![self connected]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Not Found" message:@"Please check your network setting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        //Load data
        DataUtil *util = [[DataUtil alloc] init];
        tableData = util.getData;
        tempTableData = tableData;
        appPrefs = [PreferencesManager sharedInstance];
    }

    
    self.searchField.delegate = self;
    
}

-(void)Back:(UIBarButtonItem *) sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y - 45, tableView.frame.size.width, tableView.frame.size.height + 45);
    //NSLog(@"ViewDidAppear");
}
-(void)viewWillAppear:(BOOL)animated{
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *lang = [languages objectAtIndex:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    NSBundle *localBundle = [NSBundle bundleWithPath:path];
    
    
    TitleField.text = NSLocalizedStringFromTableInBundle(@"title_all_tree", nil, localBundle, nil);
    TitleField.font = [UIFont fontWithName:@"Anchan" size:27];
    TitleField.textColor = [UIColor whiteColor];
    [searchField setPlaceholder: NSLocalizedStringFromTableInBundle(@"search_hint", nil, localBundle, nil)];
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(34/255.0) green:(139/255.0) blue:(34/255.0) alpha:1.0]];
    [self.tableView reloadData];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tempTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.tag = indexPath.row;
    [cell setOpaque:NO];
    [cell setBackgroundColor: [UIColor clearColor]];
    
    
    
    PlaceData *data = [tempTableData objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *sciNameLabel = (UILabel *)[cell viewWithTag:200];
    UIImageView *thumbnailImageView = (UIImageView *)[cell viewWithTag:300];
    nameLabel.text = data.name;
    sciNameLabel.text = data.scientific_name;
    
  
   
     [thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.thumbnail]] placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
    
    
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
    self.detailView.data = [tempTableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.detailView animated:YES];
}


-(void)updateTableView:(BOOL)isSearch{
    if(isSearch == false){ // Up
        tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height);
    }else if(isSearch == true){ // Down
        tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y + 45, tableViewFrame.size.width, tableViewFrame.size.height - 45);
    }
}

- (IBAction)filterTree:(id)sender {
    if(searchField.text.length == 0){
        tempTableData = tableData;
    }else{
        NSMutableArray *temp = [NSMutableArray arrayWithArray:tableData];
        NSString *keyword = [NSString stringWithFormat:@"*%@*",searchField.text];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@",keyword];
        tempTableData = [NSMutableArray arrayWithArray:[temp filteredArrayUsingPredicate:predicate]];
    }
    //[self updateTableView:true];
    [tableView reloadData];
    //[searchField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end