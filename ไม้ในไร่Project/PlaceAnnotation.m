//
//  PlaceAnnotation.m
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/20/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "PlaceAnnotation.h"
#import "Place.h"

@interface PlaceAnnotation ()
@property (nonatomic, strong) Place *place;
@end

@implementation PlaceAnnotation

- (id)initWithPlace:(Place *)place {
    if((self = [super init])) {
        _place = place;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return [_place location].coordinate;
}

- (NSString *)title {
    return [_place placeName];
}

@end