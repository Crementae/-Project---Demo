//
//  PlaceData.h
//  ไม้ในไร่Project
//
//  Created by Adisorn Chatnaratanakun on 3/30/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface PlaceData : NSObject

@property NSString *tree_id;
@property NSString *name;
@property NSString *detail;
@property NSArray *locations;
@property NSString *scientific_name;
@property NSString *family_name;
@property NSArray *thumbnail;
@property NSArray *gallery;

@property Location *currentLocation;
@property int locationNumber;

@end
