#import "CalTabBarController.h"

@implementation CalTabBarController

#pragma mark - Orientation / Rotation

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}
#else
- (NSUInteger) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}
#endif


- (BOOL) shouldAutorotate {
  return YES;
}

@end
