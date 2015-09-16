//
//  AllSeasonGallery.h
//  ไม้ในไร่Project
//
//  Created by Crementae on 8/19/15.
//  Copyright (c) 2015 Adisorn Chatnartanakun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlaceData.h"

@interface AllSeasonGallery : UIViewController <UIScrollViewDelegate>{
    PlaceData *data;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain) UIImage *imageView1;
@property (nonatomic, retain) UIImage *imageView2;
@property (nonatomic, retain) UIImage *imageView3;
@property (nonatomic, retain) UIImage *imageView4;
@property (nonatomic, retain) UIImage *imageView5;


@property PlaceData *data;
@property NSInteger *index;

@end
