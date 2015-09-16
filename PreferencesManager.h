//
//  PreferencesManager.h
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 4/21/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferencesManager : NSObject{
    NSMutableDictionary *prefsDict;
    NSString *prefsFilePath;
}

@property (nonatomic,retain) NSMutableDictionary *prefsDict;
@property (nonatomic,retain) NSString *prefsFilePath;

+ (PreferencesManager *)sharedInstance;
- (void)savePrefs;

- (BOOL)enableRotation;
- (void)setEnableRotation:(BOOL)enabled;
- (BOOL)enableOnlineMode;
- (void)setEnableOnlineMode:(BOOL)enabled;
- (BOOL)enable3g;
- (void)setEnable3g:(BOOL)enabled;
- (BOOL)enableMapType1;
- (void)setEnableMapType1:(BOOL)enabled;

@end