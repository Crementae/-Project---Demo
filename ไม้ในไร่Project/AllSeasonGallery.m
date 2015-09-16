//
//  AllSeasonGallery.m
//  ไม้ในไร่Project
//
//  Created by Crementae on 8/19/15.
//  Copyright (c) 2015 Adisorn Chatnartanakun. All rights reserved.
//

#import "AllSeasonGallery.h"
#import "PlaceData.h"

@interface AllSeasonGallery ()

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end

@implementation AllSeasonGallery

@synthesize data;

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

@synthesize imageView1 = _imageView1;
@synthesize imageView2 = _imageView2;
@synthesize imageView3 = _imageView3;
@synthesize imageView4 = _imageView4;
@synthesize imageView5 = _imageView5;


@synthesize index;

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
    // Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
    // Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}
- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        
        // 2
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        self.scrollView.pagingEnabled = YES;
        
        
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        //Fit the Screen
        //newPageView.contentMode = UIViewContentModeScaleToFill;
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        //test
        newPageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}




#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:(@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(Back:)];
    [newBackButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = newBackButton;
  
    // Do any additional setup after loading the view.
    if([data.gallery count] == 1){
        
        self.pageImages = [NSMutableArray arrayWithObjects:
                           _imageView1,
                           nil];
        
    }else if([data.gallery count] == 2){
        
        self.pageImages = [NSMutableArray arrayWithObjects:
                           _imageView1,
                           _imageView2,
                           nil];
        
    }else if([data.gallery count] == 3){
        
        self.pageImages = [NSMutableArray arrayWithObjects:
                           _imageView1,
                           _imageView2,
                           _imageView3,
                           nil];
        
    }else if([data.gallery count] == 4){
        
        self.pageImages = [NSMutableArray arrayWithObjects:
                           _imageView1,
                           _imageView2,
                           _imageView3,
                           _imageView4,
                           nil];
    }else if([data.gallery count] == 5){
        
        self.pageImages = [NSMutableArray arrayWithObjects:
                           _imageView1,
                           _imageView2,
                           _imageView3,
                           _imageView4,
                           _imageView5,
                           nil];
        
        
    }
    NSInteger pageCount = self.pageImages.count;
    
    // 2
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // 3
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

-(void)Back:(UIBarButtonItem *) sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // 5
    [self loadVisiblePages];
    
    //NSInteger pageIndex = *(index);
    
    //    CGFloat pageWidth = self.scrollView.frame.size.width;
    //    NSInteger pageScrollWidth = (NSInteger)floor(pageWidth * [[NSNumber numberWithInteger:index] floatValue]);
    //
    //    [_scrollView setContentOffset:CGPointMake(pageScrollWidth, 0) animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControl = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end