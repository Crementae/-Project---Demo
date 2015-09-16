//
//  PlaceAnnotation.h
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/20/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Place;

@interface PlaceAnnotation : NSObject <MKAnnotation>

- (id)initWithPlace:(Place *)place;
- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;

@end