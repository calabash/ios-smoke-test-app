#import "CalTabBarController.h"

@implementation CalTabBarController

#pragma mark - Orientation / Rotation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
  return [self.selectedViewController supportedInterfaceOrientations];
}

- (BOOL) shouldAutorotate {
  return [self.selectedViewController shouldAutorotate];
}

@end
