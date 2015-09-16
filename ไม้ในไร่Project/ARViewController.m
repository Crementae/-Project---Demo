//
//  ARViewController.m
//  ไม้ในไร่Project
//
//  Created by Adisorn Chatnaratanakun on 3/13/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "ARViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DataUtil.h"
#import "PlaceData.h"
#import "Location.h"
#import "MarkerView.h"
#import "AllSeasonTreeDetails.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


const int kInfoViewTag = 1001;

@interface ARViewController () <MarkerViewDelegate>
@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *detectLocation;

- (void)addGeoLocationtoArray:(NSMutableArray*)locArray withLatitude:(float)latitude Longitude:(float)longitude usingName:(NSString*)label;


@end

@implementation ARViewController

NSArray *data;
NSMutableArray *arData;

@synthesize arView;
@synthesize rightBarButton;

@synthesize radiusLevel1Btn;
@synthesize radiusLevel2Btn;
@synthesize radiusLevel3Btn;

@synthesize stateRadiusL1View;
@synthesize stateRadiusL2View;
@synthesize stateRadiusL3View;


-(BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:(@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(Back:)];
    [newBackButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    
    self.navigationItem.rightBarButtonItem = nil;
    
    // Load data
    //[self loadData];
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *lang = [languages objectAtIndex:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    NSBundle *localBundle = [NSBundle bundleWithPath:path];
    
    [radiusLevel1Btn setTitle: NSLocalizedStringFromTableInBundle(@"ar_r_level_1", nil, localBundle, nil) forState:UIControlStateNormal];
    [radiusLevel2Btn setTitle: NSLocalizedStringFromTableInBundle(@"ar_r_level_2", nil, localBundle, nil) forState:UIControlStateNormal];
    [radiusLevel3Btn setTitle: NSLocalizedStringFromTableInBundle(@"ar_r_level_3", nil, localBundle, nil) forState:UIControlStateNormal];
    
    
    // Do any additional setup after loading the view from its nib.
    if ([ARKit deviceSupportsAR]) {
        
        //if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self arView] parentViewController:self withDelgate:self];
        //}
        
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        
        [self enableMyLocation];
        
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [_locationManager startUpdatingLocation];
        
        _arController.radarRange = 100;
        [_arController setMinimumScaleFactor:0.5];
        [_arController setMaximumScaleDistance:_arController.radarRange];
        [_arController setScaleViewsBasedOnDistance:YES];
        [_arController setRotateViewsBasedOnPerspective:YES];
        [_arController setDebugMode:NO];
        
        stateRadiusL1View.hidden = false;
        stateRadiusL2View.hidden = true;
        stateRadiusL3View.hidden = true;
    }
    else
        [self notSupportView];
    
}
-(void)LoadData{

    
    if (![self connected]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Not Found" message:@"Please check your network setting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        // Load data
        DataUtil * util = [[DataUtil alloc] init];
        arData = [[NSMutableArray alloc] init];
        data = util.getData;
        arData = data;
    }
    
    
    
    
    
    NSMutableArray *temp = [NSMutableArray array];
    int index = 0;
    for(PlaceData *place in data){
        
        /*if(![place.tree_id isEqualToString:@"109"]){
         continue;
         }*/
        
        for(Location *location in place.locations){
            PlaceData *obj = [[PlaceData alloc] init];
            obj.name = place.name;
            obj.locations = place.locations;
            obj.tree_id = place.tree_id;
            obj.detail = place.detail;
            obj.scientific_name = place.scientific_name;
            obj.family_name = place.family_name;
            obj.gallery = place.gallery;
            obj.currentLocation = location;
            NSLog(@"%@ %@ %@ %@",place.name, location.lat, location.lng, location.alt);
            [temp addObject:obj];
            index++;
        }
    }
    
    /*
     PlaceData *testObj = [[PlaceData alloc] init];
     testObj.tree_id = @"1";
     testObj.name = @"Test 1";
     testObj.detail = @"Desc..";
     testObj.family_name = @"Test Fam";
     testObj.scientific_name = @"Test Sci";
     testObj.gallery = [NSArray array];
     
     Location *testLocation = [[Location alloc] init];
     testLocation.lat = @"20.022483";
     testLocation.lng = @"99.871668";
     testLocation.alt = @"395"; //1296ft // 395m
     
     testObj.currentLocation = testLocation;
     [temp addObject:testObj];
     */
    arData = [temp copy];
    
}

-(void)Back:(UIBarButtonItem *) sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload
{
    [self setArView:nil];
    [super viewDidUnload];
    
    if (_arController != nil){
        //[_arController stopListening];
        //[_arController unloadAV];
        _arController = nil;
    }
    
    if(_locationManager != nil)
        _locationManager = nil;
    
    NSLog(@"DidUnload");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self LoadData];
    [self generateGeoLocations];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_arController removeAllCoordinate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)generateGeoLocations {
    [self setGeoLocations:[NSMutableArray arrayWithCapacity:[arData count]]];
    
    //float myAlt = _detectLocation.altitude;
    
    int index = 0;
    for(PlaceData *place in arData) {
        // calculate location in range
        
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([place.currentLocation.lat doubleValue], [place.currentLocation.lng doubleValue]) altitude:[place.currentLocation.alt doubleValue] horizontalAccuracy:300 verticalAccuracy:300 timestamp:[NSDate date]];
        
        //CLLocation *testLocation = [[CLLocation alloc] initWithLatitude: [place.currentLocation.lat doubleValue] longitude:[place.currentLocation.lng doubleValue]];
        
        //CLLocationDistance distance = [testLocation distanceFromLocation:_detectLocation];
        
        //NSString *dis = [[NSString init] initWithFormat:@"%f",distance];
        
        /*if(distance > 0){
         NSLog(@"=============>TEST1:%f",distance);
         index++;
         continue;
         }else{
         NSLog(@"=============>TEST2:%f",distance);
         }*/
        
        NSString *indexStr = [NSString stringWithFormat:@"%d",index];
        
        ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:location locationTitle:indexStr];
        index++;
        
        [coordinate calibrateUsingOrigin:_detectLocation];
        
       //MarkerView *markerView = [[MarkerView alloc] initForCoordinate:coordinate withDelgate:self withData:place withX: 0 withY: 0];
        
        //NSLog(@"Marker view %@", markerView);
        
        //[coordinate setDisplayView:markerView];
        [_arController addCoordinate:coordinate];
        [_geoLocations addObject:coordinate];
    }
}

- (void)notSupportView
{
    UILabel *errorLabel = [[UILabel alloc] init];
    [errorLabel setNumberOfLines:0];
    [errorLabel setText: @"Augmented Reality is not supported on this device"];
    [errorLabel setFrame: arView.frame];
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    
    [arView addSubview:errorLabel];
}

- (void)enableMyLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined)
        [self requestLocationAuthorization];
    else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
        return; // we weren't allowed to show the user's location so don't enable
    else{
        NSLog(@"enable location");
        //[_mapView setMyLocationEnabled:YES];
    }
}
// Ask the CLLocationManager for location authorization,
// and be sure to retain the manager somewhere on the class

- (void)requestLocationAuthorization
{
    [_locationManager requestAlwaysAuthorization];
}

// Handle the authorization callback. This is usually
// called on a background thread so go back to main.

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"request location");
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSelectorOnMainThread:@selector(enableMyLocation) withObject:nil waitUntilDone:[NSThread isMainThread]];
        
        //_locationManager.delegate = nil;
        //_locationManager = nil;
    }
}

-(NSMutableArray *)geoLocations {
    if(!_geoLocations) {
        [self generateGeoLocations];
    }
    return _geoLocations;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *lastLocation = [locations lastObject];
    _detectLocation = lastLocation;
    //lastLocation.alt
    
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    
    NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
    if(accuracy < 100.0) {
        [manager stopUpdatingLocation];
    }
}

-(void) locationClicked:(ARGeoCoordinate *) coordinate {
    if (coordinate != nil) {
        // Get value
        int index = [[coordinate title] integerValue];
        
        PlaceData *place = arData[index];
        
        NSLog(@"%@ index: %d", place.name, index);
        AllSeasonTreeDetails *detailView = nil;
        
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        
        detailView = (AllSeasonTreeDetails *)[sb instantiateViewControllerWithIdentifier:@"AllSeasonView"];
        detailView.data = place;
        
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

-(void) didTapMarker:(ARGeoCoordinate *) coordinate {
    NSLog(@"delegate worked click on %@", [coordinate title]);
    [self locationClicked:coordinate];
    
}

-(void) didUpdateHeading:(CLHeading *)newHeading {
    //   NSLog(@"Heading Updated");
    
}
-(void) didUpdateLocation:(CLLocation *)newLocation {
    NSLog(@"Location Updated");
    
    //_detectLocation = newLocation;
    //[self generateGeoLocations];
    //[_arController setCenterLocation:newLocation];
}
-(void) didUpdateOrientation:(UIDeviceOrientation) orientation {
    //NSLog(@"Orientation Updated");
    
    if (orientation == UIDeviceOrientationPortrait)
        NSLog(@"Protrait");
}

- (IBAction)changeRadarRangeLevel1:(id)sender {
    _arController.radarRange = 100;
    
    stateRadiusL1View.hidden = false;
    stateRadiusL2View.hidden = true;
    stateRadiusL3View.hidden = true;
    
    [_arController setMaximumScaleDistance:_arController.radarRange];
    [_arController setCenterLocation:_detectLocation];
}
- (IBAction)changeRadarRangeLevel2:(id)sender {
    _arController.radarRange = 200;
    
    stateRadiusL1View.hidden = true;
    stateRadiusL2View.hidden = false;
    stateRadiusL3View.hidden = true;
    
    [_arController setMaximumScaleDistance:_arController.radarRange];
    [_arController setCenterLocation:_detectLocation];
}
- (IBAction)changeRadarRangeLevel3:(id)sender {
    _arController.radarRange = 500;
    
    stateRadiusL1View.hidden = true;
    stateRadiusL2View.hidden = true;
    stateRadiusL3View.hidden = false;
    
    [_arController setMaximumScaleDistance:_arController.radarRange];
    [_arController setCenterLocation:_detectLocation];
}

@end
