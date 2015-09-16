//
//  MapViewController.h
//  ไม้ในไร่Project
//
//  Created by Adisorn Chatnaratanakun on 3/13/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"
#import "GoogleMaps/GoogleMaps.h"
#import "PlaceData.h"

@interface MapViewController : ViewController <GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationAuthorizationManager;
-(IBAction)setMap:(id)sender;
@property (strong, nonatomic)IBOutlet UITextField *TitleField;
-(IBAction)SummerMap:(id)sender;
-(IBAction)ColdMap:(id)sender;
-(IBAction)RecomendationMap:(id)sender;
-(IBAction)RainyMap:(id)sender;

@end
