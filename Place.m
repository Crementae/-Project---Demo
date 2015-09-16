//
//  Place.m
//  ไม้ในไร่Project
//
//  Created by Adisorn Chatnaratanakun on 3/20/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address {
    if((self = [super init])) {
        _location = location;
        _reference = reference;
        _placeName = name;
        _address = address;
    }
    return self;
}

@end
