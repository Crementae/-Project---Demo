//
//  SummerTreeDetails.h
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 4/16/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/Uikit.h"


@class PlaceData;
@interface SummerTreeDetails :  UIViewController <UIScrollViewDelegate>{
    PlaceData *data;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property PlaceData *data;
//เดียวลบ Uitextview
@property (weak, nonatomic) IBOutlet UITextView *textview;


@end