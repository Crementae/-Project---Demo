//
//  AllSeasonTreeDetails.m
//  ไม้ในไร่Project
//
//  Created by Crementae on 8/19/15.
//  Copyright (c) 2015 Adisorn Chatnartanakun. All rights reserved.
//

#import "AllSeasonTreeDetails.h"
#import "PlaceData.h"
#import "AllSeasonGallery.h"
#import "Reachability.h"
#import "PreferencesManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "UIImageView+WebCache.h"



@interface AllSeasonTreeDetails ()

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scientificNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;


- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end


@implementation AllSeasonTreeDetails{
    PreferencesManager *appPrefs;
}

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

@synthesize data;


@synthesize image1 = _image1;
@synthesize image2 = _image2;
@synthesize image3 = _image3;
@synthesize image4 = _image4;
@synthesize image5 = _image5;

@synthesize imageView1 = _imageView1;
@synthesize imageView2 = _imageView2;
@synthesize imageView3 = _imageView3;
@synthesize imageView4 = _imageView4;
@synthesize imageView5 = _imageView5;



-(BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}




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
        
        newPageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:newPageView];
        
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
        
        UITapGestureRecognizer *SingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionHandleTapOnImageView:)];
        [SingleTap setNumberOfTapsRequired:1];
        
        [newPageView addGestureRecognizer:SingleTap];
        
        
            
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:(@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(Back:)];
    [newBackButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = newBackButton;
   
    
    
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
    
    

   
    
    
    
    
    

    if (![self connected]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Not Found" message:@"Please check your network setting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        
    
    
    
    // Add image into slide image
    if([data.gallery count] == 1){
        /*
        // 1
        // Set preloading image
        
        _image1 = [UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"];
        _imageView1 = [[UIImageView alloc] initWithImage:_image1];
         self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image, nil];
        NSLog(@"DatanDefault is %@",_imageView1.image);
        
        
        
        // get a dispatch queue
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            // Load image from server
            NSURL *urlToPicture1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[0]]];

            NSData *imageData1 = [NSData dataWithContentsOfURL:urlToPicture1 options:0 error:nil];
             _image1 = [UIImage imageWithData:imageData1];
            
            
            
            // This will set the image when loading is finished
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               
                _imageView1 = [[UIImageView alloc] initWithImage:_image1];
               
                
                self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image, nil];
                
                
               NSLog(@"DataGallary is %@",data.gallery[0]);
                NSLog(@"DataPageImage is %@",_pageImages);
                NSLog(@"DatasImageView is %@",_imageView1.image);
            
                
            });
            
        });
    */
        
        _imageView1 = [[UIImageView alloc] init];
        
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[0]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image, nil];

        /*
        // Load image from server
        NSURL *urlToPicture1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[0]]];
        NSData * imageData1 = [NSData dataWithContentsOfURL:urlToPicture1];
        _image1 = [UIImage imageWithData:imageData1];
        _imageView1 = [[UIImageView alloc] initWithImage:_image1];
        
      self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image, nil];
        
        */
        
        
    }else if([data.gallery count] == 2){
        
        // Load image from server
        _imageView1 = [[UIImageView alloc] init];
        
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[0]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]options:SDWebImageHighPriority];
        
        _imageView2 = [[UIImageView alloc] init];
        
        [_imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[1]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]options:SDWebImageHighPriority];
        [_imageView2 setNeedsLayout];
        
        
        // Add image to page
        
        self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image,_imageView2.image, nil];
        
        
        
        
        
    }else if([data.gallery count] == 3){
        
        // Load image from server
        _imageView1 = [[UIImageView alloc] init];
        
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[0]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        _imageView2 = [[UIImageView alloc] init];
        
        [_imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[1]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        
        _imageView3 = [[UIImageView alloc] init];
        
        [_imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[2]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        
        // Add image to page
        
        self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image,_imageView2.image,_imageView3.image, nil];
        
        
    }else if([data.gallery count] == 4){
        
        // Load image from server
        _imageView1 = [[UIImageView alloc] init];
        
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[0]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        _imageView2 = [[UIImageView alloc] init];
        
        [_imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[1]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        
        _imageView3 = [[UIImageView alloc] init];
        
        [_imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[2]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        _imageView4 = [[UIImageView alloc] init];
        
        [_imageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[3]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        
        
        // ADD Image to page
        self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image,_imageView2.image,_imageView3.image,_imageView4.image, nil];
        
    }else if([data.gallery count] == 5){
        
        // Load image from server
        
        _imageView1 = [[UIImageView alloc] init];
        
        [_imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[0]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        _imageView2 = [[UIImageView alloc] init];
        
        [_imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[1]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        
        _imageView3 = [[UIImageView alloc] init];
        
        [_imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[2]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        _imageView4 = [[UIImageView alloc] init];
        
        [_imageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[3]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        _imageView5 = [[UIImageView alloc] init];
        
        [_imageView5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", data.gallery[4]]]placeholderImage:[UIImage imageNamed:@"tumblr_nbp4bxmm081sypldqo1_100.gif"]];
        
        //Add image to page
        
        
        self.pageImages = [[NSMutableArray alloc] initWithObjects:_imageView1.image,_imageView2.image,_imageView3.image,_imageView4.image,_imageView5.image, nil];
        
    }
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
    
}
/*
- (void)loadImage:(UIImageView*)baseImage with:(NSString *)dataId ofNumber:(int) galleryNumber ifNilLoadPath:(NSString*)defaultPath{
    
    
    

    
    NSURL *urlToPicture = [NSURL URLWithString:[NSString stringWithFormat:data.gallery, dataId,galleryNumber]];
    // get a dispatch queue
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:urlToPicture options:0 error:nil];
        // This will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            baseImage.image = [[UIImage alloc] initWithData:imgData];
            if(baseImage.image == nil){
                baseImage.image = [UIImage imageNamed: defaultPath];
            }
            //dispatch_release(concurrentQueue);
        });
    });
    
}
 */

-(void)actionHandleTapOnImageView:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main"                                                 bundle:nil];
    AllSeasonGallery *view = (AllSeasonGallery *)[sb instantiateViewControllerWithIdentifier:@"AllSeasonGalleryView"];
    view.data = data;
    view.imageView1 = _imageView1.image;
    view.imageView2 = _imageView2.image;
    view.imageView3 = _imageView3.image;
    view.imageView4 = _imageView4.image;
    view.imageView5 = _imageView5.image;
    view.index = (imageView.tag - 1);
    
    //NSLog(@"Hello");
    
    //view.index = 0;
    //
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)facebookClick:(id)sender {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *lang = [languages objectAtIndex:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    NSBundle *localBundle = [NSBundle bundleWithPath:path];
    
    if (status != ReachableViaWWAN && status != ReachableViaWiFi)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"msg_no_net_title", nil, localBundle, nil)
                                                        message:NSLocalizedStringFromTableInBundle(@"msg_no_net_msg", nil, localBundle, nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"msg_no_net_ok", nil, localBundle, nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self postFacebook];
}

- (void) postFacebook{
    NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"http://bga.mfu.ac.th/?mode=fb&id=%@",data.tree_id]];
    NSURL *urlToPicture = [NSURL URLWithString:[NSString stringWithFormat:@"http://bga.mfu.ac.th/image/facebook/%@.jpg", data.tree_id]];
    //NSLog(@"%@",urlToPicture);
    
    NSString *locationStr = @"";
    if([data.locations count] > 0){
        Location *location = data.locations[0];
        locationStr = [NSString stringWithFormat:@"%@,%@",location.lat,location.lng];
    }
    FBLinkShareParams *params = [[FBLinkShareParams alloc] initWithLink:urlToShare
                                                                   name:data.name
                                                                caption:nil
                                                            description:[NSString stringWithFormat:@"%@ %@",data.detail, locationStr]
                                                                picture:urlToPicture];
    
    BOOL isSuccessful = NO;
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        FBAppCall *appCall = [FBDialogs presentShareDialogWithParams:params
                                                         clientState:nil
                                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                 if (error) {
                                                                     NSLog(@"Error: %@", error.description);
                                                                 } else {
                                                                     NSLog(@"Success!");
                                                                 }
                                                             }];
        isSuccessful = (appCall  != nil);
    }
    if (!isSuccessful && [FBDialogs canPresentOSIntegratedShareDialogWithSession:[FBSession activeSession]]){
        // Next try to post using Facebook's iOS6 integration
        isSuccessful = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                initialText:[NSString stringWithFormat:@"%@ %@",data.name,data.description]
                                                                      image:urlToPicture
                                                                        url:urlToShare
                                                                    handler:nil];
    }
    if (!isSuccessful) {
        [self performPublishAction:^{
            NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", self.loggedInUser.first_name, [NSDate date]];
            
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            
            connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
            | FBRequestConnectionErrorBehaviorAlertUser
            | FBRequestConnectionErrorBehaviorRetry;
            
            [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                 completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                     [self showAlert:message result:result error:error];
                     self.fbButton.enabled = YES;
                 }];
            [connection start];
            
            self.fbButton.enabled = NO;
        }];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // For simplicity, we will use any error message provided by the SDK,
        // but you may consider inspecting the fberrorShouldNotifyUser or
        // fberrorCategory to provide better recourse to users. See the Scrumptious
        // sample for more examples on error handling.
        if (error.fberrorUserMessage) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end