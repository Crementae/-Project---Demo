//
//  ARViewController.h
//  ไม้ในไร่Project
//
//  Created by Adisorn Chatnaratanakun on 3/13/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ARKit.h"

@class ARViewController;

@interface ARViewController : ViewController<ARLocationDelegate, ARDelegate, ARMarkerDelegate>

-(IBAction) displayAR:(id) sender;
-(IBAction) displayARFullScreen:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *arView;

@property (nonatomic, strong) MKUserLocation *userLocation;
@property (retain, nonatomic) UIBarButtonItem *rightBarButton;
@property (strong, nonatomic) IBOutlet UIButton *radiusLevel1Btn;
@property (strong, nonatomic) IBOutlet UIButton *radiusLevel2Btn;
@property (strong, nonatomic) IBOutlet UIButton *radiusLevel3Btn;
@property (strong, nonatomic) IBOutlet UIView *stateRadiusL1View;
@property (strong, nonatomic) IBOutlet UIView *stateRadiusL2View;
@property (strong, nonatomic) IBOutlet UIView *stateRadiusL3View;

@end