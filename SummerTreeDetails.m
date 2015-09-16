//
//  SummerTreeDetails.m
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 4/16/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "SummerTreeDetails.h"
#import "MapViewController.h"
#import "PlaceData.h"

@interface SummerTreeDetails ()


@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scientificNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end
@interface MyUiTextView: UITextView{
    
}
@end
@implementation MyUiTextView

-(BOOL)canBecomeFirstResponder
{
    return NO;
}

@end

@implementation SummerTreeDetails
//เดียวลบ synthesize textview ออก
@synthesize textview;

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;


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
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleToFill;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)viewDidLoad {
    //ลบfilepathถึงปีกกาก่อน viewDidload
    NSString *filePath =[[NSBundle mainBundle]pathForResource:@"JadeVine" ofType:@"txt"];
    if(filePath){
        NSString *myText = [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
        if(myText){
            self.textview.text = myText;
        }
    }
    [super viewDidLoad];
    
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *lang = [languages objectAtIndex:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    NSBundle *localBundle = [NSBundle bundleWithPath:path];
    
    _nameLabel.text = data.name;
    _scientificNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTableInBundle(@"view_sci_name", nil, localBundle, nil), data.scientific_name];
    _familyNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTableInBundle(@"view_fam_name", nil, localBundle, nil), data.family_name ];
    
    _detailTextView.editable = false;
    _detailTextView.text = data.detail;
    
    _detailTextView.backgroundColor = [UIColor clearColor];
    


    
    // 1
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"Jade1.jpg"],
                       [UIImage imageNamed:@"Jade2.jpg"],
                       [UIImage imageNamed:@"Jade3.jpg"],
                       nil];
    
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // 5
    [self loadVisiblePages];
}

@end
