//
//  PlaceLoader.h
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/20/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//



#import <Foundation/Foundation.h>


//1
@class CLLocation;

//2
typedef void (^SuccessHandler)(NSDictionary *responseDict);
typedef void(^ErrorHandler) (NSError *error);

@interface PlaceLoader : NSObject

//3
+ (PlaceLoader *)sharedInstance;

//4
- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHandler:
(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

@end