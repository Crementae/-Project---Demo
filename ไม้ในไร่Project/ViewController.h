//
//  ViewController.h
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/12/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceData;

    @interface ViewController : UIViewController <UIScrollViewDelegate>{
        PlaceData * data;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property PlaceData *data;
@property (strong, nonatomic)IBOutlet UITextField *TitleField;





@end

