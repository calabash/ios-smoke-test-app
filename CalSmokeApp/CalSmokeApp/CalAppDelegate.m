#import "CalAppDelegate.h"
#import "CalControlsController.h"
#import "CalCollectionViewController.h"
#import "CalDragDropController.h"
#import "CalTabBarController.h"
#import "CalViewsThatScrollController.h"
#import "CalGestureListController.h"
#import "CalDatePickerController.h"
#import "MBFingerTipWindow.h"

#if LOAD_CALABASH_DYLIB
#import <dlfcn.h>
#endif

typedef struct {
  NSInteger code;
  CGFloat visibility;
  NSUInteger decibels;
} LPSmokeAlarm;

@interface CalAppDelegate ()

@property(strong, nonatomic) CalDragDropController *dragAndDropController;
@property(strong, nonatomic) CalViewsThatScrollController *viewsThatScrollController;
@property(strong, nonatomic) UINavigationController *gesturesNavigationController;
@property(strong, nonatomic) UINavigationController *scrollNavigationController;

@end

@implementation CalAppDelegate

@synthesize tabBarController = _tabBarController;

#if LOAD_CALABASH_DYLIB
- (void) loadCalabashDylib {
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *dylibPath;
  dylibPath = [bundle pathForResource:@"libCalabashDynFAT" ofType:@"dylib"];

  NSLog(@"Attempting to load Calabash dylib: '%@'", dylibPath);
  void *dylib = NULL;
  dylib = dlopen([dylibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);

  if (dylib == NULL) {
    char *error = dlerror();
    NSString *message = @"Could not load the Calabash dylib.";
    NSLog(@"%@: %s", message, error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calabash"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  }
}
#endif


#pragma mark - Calabash Backdoors


// Calabash backdoors
- (void) backdoorThatReturnsVoid { NSLog(@"Method that returns void"); }
- (BOOL) backdoorYES { return YES; }
- (BOOL) backdoorNO { return NO; }
- (int) backdoorInt { return (int)-17; }
- (unsigned int) backdoorUInt { return (unsigned int)17; }
- (NSInteger) backdoorNSInteger { return (NSInteger)-17; }
- (NSUInteger) backdoorNSUInteger { return (NSUInteger)17; }
- (short) backdoorShort { return (short)-1; }
- (unsigned short) backdoorUShort { return (unsigned short)1; }
- (float) backdoorFloat { return (float)0.314; }
- (double) backdoorDouble { return (double)54.46; }
- (CGFloat) backdoorCGFloat { return (CGFloat)54.46; }
- (char *) backdoorCharStar { return "char *"; }
- (const char *) backdoorConstCharStar { return (const char *)"const char *"; }
- (char) backdoorChar { return 'c'; }
- (unsigned char) backdoorUChar { return (unsigned char)'C'; }
- (long) backdoorLong { return (long)-42; }
- (unsigned long) backdoorULong { return (unsigned long)42; }
- (long long) backdoorLongLong { return (long long)-43; }
- (unsigned long long) backdoorULongLong { return (unsigned long long)43; }
- (CGPoint) backdoorPoint { return CGPointZero; }
- (CGSize) backdoorSize { return CGSizeZero; }
- (CGRect) backdoorRect { return CGRectZero; }

- (LPSmokeAlarm) backdoorSmokeAlarm {
  LPSmokeAlarm alarm;
  alarm.code = -1;
  alarm.visibility = 0.5;
  alarm.decibels = 10;
  return alarm;
}

// There is Objective-C encoding for long double
// Calling backdoor will raise an exception
// Xcode 7 update: looks like "D" is the long double encoding
- (long double) backdoorLDouble { return (long double)54.46; }

- (NSArray *) backdoorArray { return @[@"a", @"b", @(3)]; }
- (NSString *) backdoorString { return @"string"; }
- (NSDate *) backdoorDate { return [NSDate date]; }
- (NSNumber *) backdoorNumber { return @(11); }
- (NSString *) backdoorWithString:(NSString *) arg { return arg; }

- (NSDictionary *) backdoorDictionary {
  return
  @{
    @"a" : @(0),
    @"b" : @(1),
    @"c" : [NSNull null]
    };
}

- (NSArray *) backdoorWithString:(NSString *) string
                           array:(NSArray *) array {
  return @[string, array];
}

- (NSDictionary *) backdoorWithString:(NSString *) string
                                array:(NSArray *) array
                           dictionary:(NSDictionary *) dictionary {
  return
  @{
    @"string" : string,
    @"array" : array,
    @"dictionary" : dictionary
    };
}

- (BOOL) backdoorWithBOOL_YES:(BOOL) arg { return arg == YES; }
- (BOOL) backdoorWithBOOL_NO:(BOOL) arg { return arg == NO; }
- (BOOL) backdoorWithBool_true:(bool) arg { return arg == true; }
- (BOOL) backdoorWithBool_false:(bool) arg { return arg == false; }
- (BOOL) backdoorWithNSInteger:(NSInteger) arg { return arg == -17; }
- (BOOL) backdoorWithNSUInteger:(NSUInteger) arg { return arg == 17; }
- (BOOL) backdoorWithShort:(short) arg { return arg == -1; }
- (BOOL) backdoorWithUShort:(unsigned short) arg { return arg == 1; }
- (BOOL) backdoorWithCGFloat:(CGFloat) arg {
  return arg < 54.47 && arg > 54.45;
}
- (BOOL) backdoorWithDouble:(double) arg {
  return arg < 54.47 && arg > 54.45;
}
- (BOOL) backdoorWithFloat:(float) arg {
  return arg < 0.3141 && arg > 0.3140;
}
- (BOOL) backdoorWithChar:(char) arg { return arg == 'c'; }
- (BOOL) backdoorWithUChar:(unsigned char) arg { return arg == 'C'; }
- (BOOL) backdoorWithLong:(long) arg { return arg == -42; }
- (BOOL) backdoorWithULong:(unsigned long) arg { return arg == 42; }
- (BOOL) backdoorWithLongLong:(long long) arg { return arg == -43; }
- (BOOL) backdoorWithULongLong:(unsigned long long) arg { return arg == 43; }

- (BOOL) backdoorWithArgCharStar:(char *) arg {
  NSString *argObjC = [NSString stringWithCString:(const char *)arg
                                         encoding:NSASCIIStringEncoding];
  return [argObjC isEqualToString:@"char *"];
}

- (BOOL) backdoorWithArgConstCharStar:(const char *) arg {
  NSString *argObjC = [NSString stringWithCString:arg
                                         encoding:NSASCIIStringEncoding];
  return [argObjC isEqualToString:@"const char *"];
}

- (BOOL) backdoorWithArgCGPoint:(CGPoint) arg {
  return arg.x == 1 && arg.y == 2;
}

- (BOOL) backdoorWithArgCGRect:(CGRect) arg {
  return arg.origin.x == 1 && arg.origin.y == 2 && arg.size.width == 3 && arg.size.height == 4;
}

- (BOOL) backdoorWithArgClass:(Class) arg {
  NSString *arrayClassName = NSStringFromClass([NSArray class]);
  NSString *argClassname = NSStringFromClass(arg);
  return [arrayClassName isEqualToString:argClassname];
}

- (BOOL) backdoorWithArgSelf:(id) arg {
  NSString *selfClass = NSStringFromClass([self class]);
  NSString *argClass = NSStringFromClass([arg class]);
  return [selfClass isEqualToString:argClass];
}

- (BOOL) backdoorWithArgNil:(id) arg {
  return !arg;
}

#pragma mark - Unhandled Argument Types

- (void) backdoorWithArgVoidStar:(void *) arg { };
- (void) backdoorWithFloatStar:(float *) arg { };
- (BOOL) backdoorWithArgObjectStarStar:(NSError *__autoreleasing*) arg { return NO; }
- (void) backdoorWithArgSelector:(SEL) arg { }
- (void) backdoorWithArgPrimativeArray:(int []) arg { }
- (void) backdoorWithArgStruct:(LPSmokeAlarm) arg { }

- (NSString *) JSONStringWithArray:(NSArray *) aArray {
  NSData *data = [NSJSONSerialization dataWithJSONObject:aArray
                                                 options:0
                                                   error:nil];
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return string;
}

- (NSString *) JSONStringWithDictionary:(NSDictionary *) aDictionary {
  NSData *data = [NSJSONSerialization dataWithJSONObject:aDictionary
                                                 options:0
                                                   error:nil];
  NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return string;
}


// backdoor
- (NSString *) stringForDefaultsDictionary:(NSString *) aIgnore {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults synchronize];
  NSDictionary *dictionary = [defaults dictionaryRepresentation];
  return [self JSONStringWithDictionary:dictionary];
}

// backdoor
- (NSString *)simulatorPreferencesPath:(NSString *) aIgnore {
  static NSString *path = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *plistRootPath = nil, *relativePlistPath = nil;
    NSString *plistName = [NSString stringWithFormat:@"%@.plist", [[NSBundle mainBundle] bundleIdentifier]];

    // 1. get into the simulator's app support directory by fetching the sandboxed Library's path

    NSArray *userLibDirURLs = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];

    NSURL *userDirURL = [userLibDirURLs lastObject];
    NSString *userDirectoryPath = [userDirURL path];

    // 2. get out of our application directory, back to the root support directory for this system version
    if ([userDirectoryPath rangeOfString:@"CoreSimulator"].location == NSNotFound) {
      plistRootPath = [userDirectoryPath substringToIndex:([userDirectoryPath rangeOfString:@"Applications"].location)];
    } else {
      NSRange range = [userDirectoryPath rangeOfString:@"data"];
      plistRootPath = [userDirectoryPath substringToIndex:range.location + range.length];
    }

    // 3. locate, relative to here, /Library/Preferences/[bundle ID].plist
    relativePlistPath = [NSString stringWithFormat:@"Library/Preferences/%@", plistName];

    // 4. and unescape spaces, if necessary (i.e. in the simulator)
    NSString *unsanitizedPlistPath = [plistRootPath stringByAppendingPathComponent:relativePlistPath];
    path = [[unsanitizedPlistPath stringByRemovingPercentEncoding] copy];
  });
  NSLog(@"sim pref path = %@", path);
  return path;
}

- (NSString *) stringForPathToDocumentsDirectory {
  NSArray *dirPaths =
  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                      NSUserDomainMask,
                                      YES);
  return dirPaths[0];
}


- (NSString *) stringForPathToLibraryDirectoryForUserp:(BOOL) forUser {
  NSSearchPathDomainMask mask;
  if (forUser == YES) {
    mask = NSUserDomainMask;
  } else {
    mask = NSLocalDomainMask;
  }
  NSArray *dirPaths =
  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                      mask,
                                      YES);
  return dirPaths[0];
}

// backdoor
- (NSString *) stringForPathToSandboxDirectory:(NSString *) aSandboxDirectory {
  NSArray *allowed = @[@"tmp", @"Documents", @"Library"];
  NSUInteger idx = [allowed indexOfObject:aSandboxDirectory];
  if (idx == NSNotFound) {
    NSLog(@"expected '%@' to be one of '%@'", aSandboxDirectory, allowed);
    return nil;
  }
  NSString *path = nil;
  if ([aSandboxDirectory isEqualToString:@"Documents"]) {
    path = [self stringForPathToDocumentsDirectory];
  } else if ([aSandboxDirectory isEqualToString:@"Library"]) {
    path = [self stringForPathToLibraryDirectoryForUserp:YES];
  } else {
    NSString *libPath = [self stringForPathToLibraryDirectoryForUserp:YES];
    NSString *containingDir = [libPath stringByDeletingLastPathComponent];
    path = [containingDir stringByAppendingPathComponent:@"tmp"];
  }

  NSLog(@"path = %@", path);
  return path;
}

- (NSArray *) arrayForFilesInSandboxDirectory:(NSString *) aSandboxDirectory {
  NSString *path = [self stringForPathToSandboxDirectory:aSandboxDirectory];
  if (!path) { return nil; }
  NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                                   error:NULL];
  return directoryContents;
}

// backdoor
- (NSString *) addFileToSandboxDirectory:(NSString *) aJSONDictionary {
  NSData *argData = [aJSONDictionary dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *details = [NSJSONSerialization JSONObjectWithData:argData options:0 error:NULL];

  NSString *directory = details[@"directory"];
  if (!directory) {
    NSLog(@"Expected value for key 'directory' in %@", details);
    return nil;
  }
  NSString *filename = details[@"filename"];
  if (!filename) {
    NSLog(@"Expected value for key 'filename' in %@", details);
    return nil;
  }

  NSString *directoryPath = [self stringForPathToSandboxDirectory:directory];
  if (!directoryPath) { return nil; }

  NSString *path = [directoryPath stringByAppendingPathComponent:filename];
  NSString *contents = @"Boo!";
  NSData *fileData = [contents dataUsingEncoding:NSUTF8StringEncoding];
  [fileData writeToFile:path atomically:YES];
  return filename;
}

// backdoor
- (NSString *) animateOrangeViewOnDragAndDropController:(NSString *)seconds {
  [self.dragAndDropController animateOrangeViewForSeconds:[seconds doubleValue]];
  return @"YES";
}

// Causes an app crash
- (void) backdoorWithVoidReturn:(NSString *) argument {
  NSLog(@"received backdoor with argument: %@", argument);
}

// Special case.  This method can never be called because the server will
// always append ':' to the selector name.
// This behavior is deprecated in 0.15.0 and is scheduled for change.
- (NSString *) backdoorWithNoArgument {
  NSLog(@"received backdoor with no argument");
  return @"true";
}

// Causes an app crash
- (BOOL) doesStateMatchStringArgument:(NSString *) argument {
  NSString *state = @"argument";
  return [argument isEqualToString:state];
}

- (NSNumber *) numberFromString:(NSString *) argument {
  return @(argument.length);
}

- (NSArray *) arrayByInsertingString:(NSString *) argument {
  return @[argument];
}

- (NSDictionary *) dictionaryByInsertingString:(NSString *) argument {
  return @{@"argument" : argument};
}

- (NSString *) stringByEncodingLengthOfDictionary:(NSDictionary *) argument {
  return [NSString stringWithFormat:@"%@", @(argument.count)];
}

- (NSNumber *) numberWithCountOfArray:(NSArray *) argument {
  return @(argument.count);
}

- (NSString *) stringByReturningString:(NSString *) argument {
  return argument;
}

// Invalid - argument cannot be a primitive
- (NSString *) stringByEncodingBOOL:(BOOL) argument {
  return [NSString stringWithFormat:@"%@", @(argument)];
}

// Invalid - argument cannot be a primitive
- (NSString *) stringByEncodingNSUInteger:(NSUInteger) argument {
  return [NSString stringWithFormat:@"%@", @(argument)];
}

- (NSString *) stringByEncodingNumber:(NSNumber *) argument {
  return [NSString stringWithFormat:@"%@", argument];
}

- (NSString *) showNetworkIndicator:(NSString *) ignored {
  UIApplication *shared = [UIApplication sharedApplication];
  [shared setNetworkActivityIndicatorVisible:YES];
  return [shared isNetworkActivityIndicatorVisible] ? @"YES" : @"NO";
}

- (NSString *) stopNetworkIndicator:(NSString *) ignored {
  UIApplication *shared = [UIApplication sharedApplication];
  [shared setNetworkActivityIndicatorVisible:NO];
  return [shared isNetworkActivityIndicatorVisible] ? @"NO" : @"YES";
}

- (NSString *) startNetworkIndicatorForNSeconds:(NSNumber *) seconds {
  UIApplication *shared = [UIApplication sharedApplication];
  [shared setNetworkActivityIndicatorVisible:YES];

  NSTimeInterval delay = (NSTimeInterval)[seconds doubleValue];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self stopNetworkIndicator:nil];
  });
  return [shared isNetworkActivityIndicatorVisible] ? @"YES" : @"NO";
}

#pragma mark - UIApplicationDelegate

- (UIWindow *)window {
  if (!_window) {
    MBFingerTipWindow *ftWindow = [[MBFingerTipWindow alloc]
                                   initWithFrame:[[UIScreen mainScreen] bounds]];

    ftWindow.alwaysShowTouches = [[[NSProcessInfo processInfo] arguments] containsObject:@"FINGERTIPS"];
    _window = ftWindow;
  }
  return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  CalControlsController *controlsController =
  [[CalControlsController alloc]
  initWithNibName:NSStringFromClass([CalControlsController class])
   bundle:nil];

  UIViewController *gesturesListController =
  [[CalGestureListController alloc]
  initWithNibName:NSStringFromClass([CalGestureListController class])
   bundle:nil];

  self.gesturesNavigationController =
  [[UINavigationController alloc]
   initWithRootViewController:gesturesListController];

  UIImage *gesturesImage = [UIImage imageNamed:@"tab-bar-gestures"];
  UIImage *gesturesSelected = [UIImage imageNamed:@"tab-bar-gestures-selected"];
  NSString *gesturesTitle = NSLocalizedString(@"Gestures",
                                              @"Title of tab bar page where gestures can be performed");
  self.gesturesNavigationController.tabBarItem = [[UITabBarItem alloc]
                                                  initWithTitle:gesturesTitle
                                                  image:gesturesImage
                                                  selectedImage:gesturesSelected];

  self.viewsThatScrollController =
  [[CalViewsThatScrollController alloc]
   initWithNibName:(NSStringFromClass([CalViewsThatScrollController class]))
   bundle:nil];

  self.scrollNavigationController =
  [[UINavigationController alloc]
   initWithRootViewController:self.viewsThatScrollController];

  NSString *scrollingTitle =
  NSLocalizedString(@"Scrolls", @"Title of tab bar item for views that scroll".);

  UIImage *scrollingImage = [UIImage imageNamed:@"tab-bar-scrolling"];
  UIImage *scrollingSelected = [UIImage imageNamed:@"tab-bar-scrolling-selected"];

  UITabBarItem *scrollTabItem = [[UITabBarItem alloc]
                                 initWithTitle:scrollingTitle
                                 image:scrollingImage
                                 selectedImage:scrollingSelected];
  self.scrollNavigationController.tabBarItem = scrollTabItem;

  self.dragAndDropController =
  [[CalDragDropController alloc]
   initWithNibName:NSStringFromClass([CalDragDropController class])
   bundle:nil];

  CalDatePickerController *dateController =
  [[CalDatePickerController alloc]
  initWithNibName:NSStringFromClass([CalDatePickerController class])
   bundle:nil];

  self.tabBarController = [CalTabBarController new];

  SEL transSel = NSSelectorFromString(@"translucent");

  if ([self.tabBarController.tabBar respondsToSelector:transSel]) {
    self.tabBarController.tabBar.translucent = NO;
  }

  self.tabBarController.viewControllers = @[controlsController,
                                            self.gesturesNavigationController,
                                            self.scrollNavigationController,
                                            self.dragAndDropController,
                                            dateController];


  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];

#if LOAD_CALABASH_DYLIB
  [self loadCalabashDylib];
#endif
  return YES;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (UIInterfaceOrientationMask) application:(UIApplication *)application
   supportedInterfaceOrientationsForWindow:(UIWindow *)window {
#else
- (NSUInteger) application:(UIApplication *)application
supportedInterfaceOrientationsForWindow:(UIWindow *)window {
#endif
  UIViewController *presented = self.tabBarController.selectedViewController;
  if (presented == self.dragAndDropController ||
      presented == self.scrollNavigationController ||
      presented == self.gesturesNavigationController) {
    return UIInterfaceOrientationMaskAll;
  } else {
    return UIInterfaceOrientationMaskPortrait;
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state.
   This can occur for certain types of temporary interruptions (such as an
   incoming phone call or SMS message) or when the user quits the application
   and it begins the transition to the background state. Use this method to
   pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
   Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate
   timers, and store enough application state information to restore your
   application to its current state in case it is terminated later. If your
   application supports background execution, this method is called instead of
   applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of the transition from the background to the inactive state;
   here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application
   was inactive. If the application was previously in the background, optionally
   refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate. Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end
