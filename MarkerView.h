//
//  MarkerView.h
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 4/22/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ARMarker.h"
#import "ARKit.h"
#import "PlaceData.h"

@class ARGeoCoordinate;
@protocol MarkerViewDelegate;

@interface MarkerView : ARMarker

- (id)initForCoordinate:(ARGeoCoordinate *)coordinate withDelgate:(id<ARMarkerDelegate>) aDelegate withData:(PlaceData*) data withX:(float)x withY:(float)y;

@property (nonatomic, assign) id<ARMarkerDelegate> delegate;
@property (nonatomic, retain) UILabel *lblDistance;
@property (nonatomic, retain) UILabel *lblTitle;

@end

@protocol MarkerViewDelegate <NSObject>

- (void)didTouchMarkerView:(MarkerView *)markerView;
@end