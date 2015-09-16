//
//  PreferencesManager.m
//  ไม้ในไร่Project
//
//  Created by Patipol Jaisouk on 4/21/2558 BE.
//  Copyright (c) 2558 Adisorn Chatnartanakun. All rights reserved.
//

#import "PreferencesManager.h"

@implementation PreferencesManager

@synthesize prefsDict;
@synthesize prefsFilePath;

static PreferencesManager *sharedInstance = nil;
NSString *kPref_rotation = @"enableRotation";
NSString *kPref_online = @"onlineMode";
NSString *kPref_3g = @"enable3g";
NSString *kPref_mapType1Enable = @"mapType1Enable";

+ (PreferencesManager *)sharedInstance {
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

-(id)init {
    
    if (self = [super init]) {
        // Load or init the preferences
        [self loadPrefs];
    }
    
    return self;
}

// Load the prefs from file, if the file does not exist it is created
// and some defaults set
- (void)loadPrefs {
    
    // If the preferences file path is not yet set, ensure it is initialised
    if (prefsFilePath == nil) {
        [self initPrefsFilePath];
    }
    
    // If the preferences file exists, then load it
    if ([[NSFileManager defaultManager] fileExistsAtPath:prefsFilePath]) {
        self.prefsDict = [[NSMutableDictionary alloc]
                          initWithContentsOfFile:prefsFilePath];
    } else {
        // Initialise a new dictionary
        self.prefsDict = [[NSMutableDictionary alloc] init];
    }
    
    // Ensure defaults are set
    [self setDefaults];
}

- (void)initPrefsFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.prefsFilePath = [documentsDirectory
                          stringByAppendingPathComponent:@"appPrefs.xml"];
}

- (void)savePrefs {
    [prefsDict writeToFile:prefsFilePath atomically:YES];
}

- (void)setDefaults {
    
    if ([prefsDict objectForKey:kPref_rotation] == nil) {
        [prefsDict setObject:[NSNumber numberWithBool:YES]
                      forKey:kPref_rotation];
    }
    
    if ([prefsDict objectForKey:kPref_online] == nil) {
        [prefsDict setObject:[NSNumber numberWithBool:YES]
                      forKey:kPref_online];
    }
    
    if ([prefsDict objectForKey:kPref_3g] == nil) {
        [prefsDict setObject:[NSNumber numberWithBool:NO]
                      forKey:kPref_3g];
    }
    
    if ([prefsDict objectForKey:kPref_mapType1Enable] == nil){
        [prefsDict setObject:[NSNumber numberWithBool:YES] forKey:kPref_mapType1Enable];
    }
}

- (BOOL)enableMapType1{
    NSNumber *enabled = [prefsDict objectForKey:kPref_mapType1Enable];
    return [enabled boolValue];
}

- (void)setEnableMapType1:(BOOL)enabled{
    [prefsDict setObject:[NSNumber numberWithBool:enabled]
                  forKey:kPref_mapType1Enable];
    [self savePrefs];
}

- (BOOL)enableRotation {
    NSNumber *enabled = [prefsDict objectForKey:kPref_rotation];
    return [enabled boolValue];
}

- (void)setEnableRotation:(BOOL)enabled {
    [prefsDict setObject:[NSNumber numberWithBool:enabled]
                  forKey:kPref_rotation];
    [self savePrefs];
}

- (BOOL)enableOnlineMode {
    NSNumber *enabled = [prefsDict objectForKey:kPref_online];
    return [enabled boolValue];
}

- (void)setEnableOnlineMode:(BOOL)enabled {
    [prefsDict setObject:[NSNumber numberWithBool:enabled]
                  forKey:kPref_online];
    [self savePrefs];
}

- (BOOL)enable3g {
    NSNumber *enabled = [prefsDict objectForKey:kPref_3g];
    return [enabled boolValue];
}

- (void)setEnable3g:(BOOL)enabled {
    [prefsDict setObject:[NSNumber numberWithBool:enabled]
                  forKey:kPref_3g];
    [self savePrefs];
}

@end