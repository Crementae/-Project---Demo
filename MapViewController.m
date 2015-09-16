//
//  MapViewController.m
//  ไม้ในไร่Project
//
//  Created by Adisorn Chatnaratanakun on 3/13/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "MapViewController.h"
#import "GoogleMaps/GoogleMaps.h"
#import "PlaceLoader.h"
#import <CoreLocation/CoreLocation.h>
#import "Place.h"
#import "PlaceData.h"
#import "PreferencesManager.h"
#import "AllSeasonTreeDetails.h"
#import "DataUtil.h"
#import "Reachability.h"

#import "AllSeasonViewController.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"







@interface MapViewController ()<CLLocationManagerDelegate, GMSMapViewDelegate>


@property(strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;

@end

@implementation MapViewController{
    PreferencesManager *appPrefs;
     NSArray *tableData;
}
@synthesize mapView;
@synthesize TitleField;


-(BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:(@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(AllTree:)];
    [newBackButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    appPrefs = [PreferencesManager sharedInstance];
    
    // Do any additional setup after loading the view.
    //20.045127,99.89485
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:19.902967
                                                            longitude:99.794456
                                                                 zoom:16];
    
    mapView.camera = camera;
    mapView.delegate = self;
    
    [self enableMyLocation];
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    mapView.settings.compassButton = YES;
    

    
    if (![self connected]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Not Found" message:@"Please check your network setting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        //Load data
        DataUtil *util = [[DataUtil alloc] init];
        tableData = util.getData;
    }
    
    
    
    
}

-(void)AllTree:(UIBarButtonItem *) sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main"
                                                 bundle:nil];
    AllSeasonViewController *AllView= (AllSeasonViewController *)[sb instantiateViewControllerWithIdentifier:@"AllSeasonList"];
    AllView.data = data;
    
    //mapView.data = [tableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:AllView animated:YES];
    
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
    
   
    [mapView clear];
    for(PlaceData *data in tableData){
        NSString *markerPath = [NSString stringWithFormat:@"PinAll.png"];
        
        int number = 1;
        for(Location *location in data.locations){
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([location.lat floatValue], [location.lng floatValue]);
            
            NSString *code = [[NSString alloc] initWithFormat:@"%@-%d",data.name,number];
            
            marker.title = code;
            marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
            marker.map = mapView;
            marker.icon = [UIImage imageNamed:markerPath];
            number++;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Rather than setting -myLocationEnabled to YES directly,
// call this method:

- (void)enableMyLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined)
        [self requestLocationAuthorization];
    else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
        return; // we weren't allowed to show the user's location so don't enable
    else{
        NSLog(@"enable location");
        [self.mapView setMyLocationEnabled:YES];
    }
}

// Ask the CLLocationManager for location authorization,
// and be sure to retain the manager somewhere on the class

- (void)requestLocationAuthorization
{
    _locationAuthorizationManager = [[CLLocationManager alloc] init];
    _locationAuthorizationManager.delegate = self;
    
    [_locationAuthorizationManager requestAlwaysAuthorization];
}

// Handle the authorization callback. This is usually
// called on a background thread so go back to main.

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"request location");
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSelectorOnMainThread:@selector(enableMyLocation) withObject:nil waitUntilDone:[NSThread isMainThread]];
    
        _locationAuthorizationManager.delegate = nil;
        _locationAuthorizationManager = nil;
    }
}

-(PlaceData *) findDataByMarker:(GMSMarker *)marker{
    PlaceData *currentMarker = nil;
    
    for(PlaceData *data in tableData){
        NSArray *code = [marker.title componentsSeparatedByString: @"-"];
        
        if([code[0] isEqualToString:data.name]){
            currentMarker = data;
            currentMarker.locationNumber = [code[1] intValue];
            break;
        }
    }

    return currentMarker;
}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    PlaceData *currentMarker = [self findDataByMarker:marker];
    
    UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 261, 95)];
    
    // Create background image
    UIImageView *dialogBackground = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"MapDialog.png"]];
    [dialogView addSubview:dialogBackground];
    
  
    
    
  // NSLog(@"URL %@", currentMarker.thumbnail);
    //NSLog(@"thumbnail %@",thumbnail);
   UIImageView * thumbnail = [[UIImageView alloc] init];
    NSURL *urlToPicture1 = [NSURL URLWithString:currentMarker.thumbnail];
    [thumbnail sd_setImageWithURL:urlToPicture1 placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached completed:^(UIImage * image, NSError * error,SDImageCacheType cachedType, NSURL * imageURL){
        
        
        if(image){
        
            
            
            NSLog(@"Complete = %d, error = %@",cachedType, error);
            
            
        }
    }];
   
    
    CGRect tmpFrame = thumbnail.frame;
    tmpFrame.origin.x = 15;
    tmpFrame.origin.y = 14;
    tmpFrame.size.width = 55;
    tmpFrame.size.height = 55;
    thumbnail.frame = tmpFrame;
    thumbnail.contentMode = UIViewContentModeScaleToFill;
    
    [dialogView addSubview:thumbnail];
    
    

    
    
    // Create title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(74, 20, 147, 25)];
    title.text = currentMarker.name;
    title.font = [UIFont fontWithName:@"cordiau" size:22];
    [dialogView addSubview:title];
    
    // Create description
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(74, 40, 147, 21)];
    description.text = currentMarker.scientific_name;
    description.font = [UIFont fontWithName:@"cordiau" size:18];
    description.textColor = [UIColor grayColor];
    [dialogView addSubview:description];
    
    return dialogView;
}


-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    PlaceData *data = [self findDataByMarker:marker];
    AllSeasonTreeDetails *detailView = [[AllSeasonTreeDetails alloc] init];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    
    
        detailView = (AllSeasonTreeDetails *)[sb instantiateViewControllerWithIdentifier:@"AllSeasonView"];
   
    
    detailView.data = data;
    [self.navigationController pushViewController:detailView animated:YES];
}




- (IBAction)setMap:(id)sender {
    
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
            
        case 0:
        {
            mapView.mapType = kGMSTypeNormal;
            break;
        }
            
        case 1:
        {
            mapView.mapType = kGMSTypeSatellite;
            break;
        }
            
        case 2:
        {
            mapView.mapType = kGMSTypeHybrid;
            break;
        }
    }
}


-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
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
