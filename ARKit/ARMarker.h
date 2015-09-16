//
//  ARMarker.h
//  MFUGreenery
//
//  Created by Puy on 11/8/2557 BE.
//  Copyright (c) 2557 Mae Fah Luang University. All rights reserved.
//

@class ARGeoCoordinate;
#import <UIKit/UIKit.h>

@interface ARMarker : UIView

@property (nonatomic,retain) ARGeoCoordinate *coordinateInfo;
- (void)forceRedraw;

@end
