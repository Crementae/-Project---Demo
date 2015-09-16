//
//  PlaceLoader.m
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 3/20/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//
#import "PlaceLoader.h"

//1
#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSJSONSerialization.h>
#import "UIKit/UIKit.h"


//2
NSString *const apiURL = @"https://console.developers.google.com/project/1031669991619/apiui/credential?authuser=0";
NSString *const apiKey = @"AIzaSyBxtrf631Z8DkD-4oT08HKY658ST4K8Q8g";

//3
@interface PlaceLoader()

@property (nonatomic, strong) SuccessHandler successHandler;
@property (nonatomic, strong) ErrorHandler errorHandler;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation PlaceLoader + (PlaceLoader *)sharedInstance{
    //1
    static PlaceLoader * instance = nil;
    static dispatch_once_t onceToken;
    
    //2
    dispatch_once(&onceToken, ^{
        instance = [[PlaceLoader alloc] init];
    });
    
    //3
    return instance;
}
- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    //1
    _responseData = nil;
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    //2
    CLLocationDegrees latitude = [location coordinate].latitude;
    CLLocationDegrees longitude = [location coordinate].longitude;
    
    //3
    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    [uri appendFormat:@"nearbysearch/json?location=%f,%f&radius=%d&sensor=true&types=establishment&key=%@", latitude, longitude, radius, apiKey];
    
    //4
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    //5
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:@"GET"];
    
    //6
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //7
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Starting connection: %@ for request: %@", connection, request);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(!_responseData) {
        _responseData = [NSMutableData dataWithData:data];
    } else {
        [_responseData appendData:data];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    id object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
    
    if(_successHandler) {
        _successHandler(object);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(_errorHandler) {
        _errorHandler(error);
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
