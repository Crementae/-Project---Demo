//
//  AllSeasonTreeDetails.h
//  ไม้ในไร่Project
//
//  Created by Crementae on 8/19/15.
//  Copyright (c) 2015 Adisorn Chatnartanakun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/Uikit.h"
#import <FacebookSDK/FacebookSDK.h>


@class PlaceData;
@interface AllSeasonTreeDetails :  UIViewController <UIScrollViewDelegate>{
    PlaceData *data;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property PlaceData *data;

@property (nonatomic, retain)  UIImageView *imageView1;
@property (nonatomic, retain)  UIImageView *imageView2;
@property (nonatomic, retain)  UIImageView *imageView3;
@property (nonatomic, retain)  UIImageView *imageView4;
@property (nonatomic, retain)  UIImageView *imageView5;

@property (nonatomic, retain) UIImage *image1;
@property (nonatomic, retain) UIImage *image2;
@property (nonatomic, retain) UIImage *image3;
@property (nonatomic, retain) UIImage *image4;
@property (nonatomic, retain) UIImage *image5;

@property (strong, nonatomic) IBOutlet UIButton *fbButton;


@end