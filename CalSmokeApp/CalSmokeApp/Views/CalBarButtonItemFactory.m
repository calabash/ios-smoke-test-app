#import "CalBarButtonItemFactory.h"
#import "NSString+IOSSizeOf.h"
#import "LjsLabelAttributes.h"

@interface CalBarButtonItemFactory ()

- (UIImage *) imageForBackCheveronWithColor:(UIColor *) aColor
                                 barMetrics:(UIBarMetrics) aMetrics;
+ (UIColor *) colorForViewBackground;
- (UITapGestureRecognizer *) tapGestureRecognizerWithTarget:(id) aTarget
                                                     action:(SEL) aAction;
- (UIView *) viewForBackButton;
- (UIImageView *) imageViewForBackButtonWithCheveronColor:(UIColor *) aColor;

@end


@implementation CalBarButtonItemFactory

#pragma mark - Public API: Localized Back Button Titles

+ (NSString *) stringLocalizedBack {
  return NSLocalizedString(@"Back",
                           @"Title of navigation bar button; touching sends you to the previous view");
}

+ (NSString *) stringLocalizedHome {
  return NSLocalizedString(@"Home",
                           @"Title of navigation bar button; touching sends you to the previous view");
}

+ (NSString *) stringLocalizedMap {
  return NSLocalizedString(@"Map",
                           @"Title of navigation bar button; touching sends you to the previous view");
}

#pragma mark - Public API: Colors

// the default iOS 7+ blue color
+ (UIColor *) colorForDefaultBlue {
  static UIColor *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [UIColor colorWithRed:0/255.0f
                             green:122/255.0f
                              blue:245/255.0f
                             alpha:1.0f];
  });
  return shared;
}

#pragma mark - Public API: Back Buttons

- (UIBarButtonItem *) barButtonItemBackWithTarget:(id) aTarget
                                           action:(SEL) aAction {
  return [self barButtonItemBackWithTarget:aTarget
                                    action:aAction
                                     color:[CalBarButtonItemFactory colorForDefaultBlue]];
}

- (UIBarButtonItem *) barButtonItemBackWithTarget:(id) aTarget
                                           action:(SEL) aAction
                                            color:(UIColor *) aColor {

  UIView *view = [self viewForBackButton];
  UITapGestureRecognizer *tgr = [self tapGestureRecognizerWithTarget:aTarget
                                                              action:aAction];
  [view addGestureRecognizer:tgr];

  UIImageView *chevronImage = [self imageViewForBackButtonWithCheveronColor:aColor];
  [view addSubview:chevronImage];

  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];

  return item;
}

- (UIBarButtonItem *) barButtonItemBackWithTarget:(id)aTarget
                                           action:(SEL)aAction
                                            color:(UIColor *)aColor
                                        titleFont:(UIFont *) aFont
                                   localizedTitle:(NSString *) aLocalizedTile {
  UIView *view = [self viewForBackButton];
  UITapGestureRecognizer *tgr = [self tapGestureRecognizerWithTarget:aTarget
                                                              action:aAction];
  [view addGestureRecognizer:tgr];

  UIImageView *chevronImage = [self imageViewForBackButtonWithCheveronColor:aColor];
  [view addSubview:chevronImage];

  UIColor *highlightColor = [aColor colorWithAlphaComponent:0.5f];

  CGFloat labelX = 10;
  CGFloat labelWidth = view.frame.size.width - labelX;
  LjsLabelAttributes *attrs = [[LjsLabelAttributes alloc]
                               initWithString:aLocalizedTile
                               font:aFont
                               labelWidth:labelWidth
                               linebreakMode:NSLineBreakByClipping
                               minFontSize:10];
  CGFloat labelH = attrs.labelHeight;
  CGFloat y = (view.frame.size.height/2) - (labelH/2) - 1;
  CGRect labelFrame = CGRectMake(labelX, y, labelWidth, labelH);
  UILabel *label = [attrs labelWithFrame:labelFrame
                               alignment:NSTextAlignmentLeft
                               textColor:aColor
                          highlightColor:highlightColor
                         backgroundColor:[CalBarButtonItemFactory colorForViewBackground]];
  label.accessibilityIdentifier = @"back item label";
  [view addSubview:label];

  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];

  return item;
}

#pragma mark - Public API: Buttons with Titles

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)aTitle
                                  titleColor:(UIColor *)aTitleColor
                                       font:(UIFont *)aFont
                                      target:(id)aTarget
                                      action:(SEL)aAction
                                 accessLabel:(NSString *)aAccessLabel
                                    accessId:(NSString *)aAccessId
                                    position:(WtBarButtonPosition)aPosition {

  CGFloat naturalFontSize = [aFont pointSize];
  CGFloat discoveredFontSize = 0.0;
  CGSize size =  [aTitle sizeOfStringWithFont:aFont
                                  minFontSize:10
                               actualFontSize:&discoveredFontSize
                                     forWidth:80
                                lineBreakMode:NSLineBreakByClipping];

  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height + 8)];
  [button setBackgroundColor:[UIColor clearColor]];

  button.showsTouchWhenHighlighted = YES;
  [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];

  [button setTitle:aTitle forState:UIControlStateNormal];

  [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];

  [button setTitleColor:aTitleColor forState:UIControlStateNormal];
  [button setTitleColor:aTitleColor forState:UIControlStateHighlighted];


  CGFloat topInset = ((naturalFontSize - discoveredFontSize) / 2.0f);

  if (aPosition == WtBarButtonPositionRight) {
    button.titleEdgeInsets = UIEdgeInsetsMake(topInset, 0, 0, -16);
  } else {
    button.titleEdgeInsets = UIEdgeInsetsMake(topInset, -16, 0, 0);
  }

  button.titleLabel.font = [aFont fontWithSize:discoveredFontSize];

  button.accessibilityIdentifier = aAccessId;

  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  buttonItem.accessibilityLabel = aAccessLabel;
  return buttonItem;
}


#pragma mark - Private API

- (UIView *) viewForBackButton {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 36)];
  view.backgroundColor = [UIColor clearColor];
  view.accessibilityIdentifier = @"back item";
  return view;
}

- (UIImageView *) imageViewForBackButtonWithCheveronColor:(UIColor *) aColor {
  UIImage *image = [self imageForBackCheveronWithColor:aColor barMetrics:UIBarMetricsDefault];
  CGSize size = image.size;
  UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(-12, 2, size.width, size.height)];
  iv.image = image;
  iv.accessibilityIdentifier = @"back item cheveron";
  return iv;
}

- (UITapGestureRecognizer *) tapGestureRecognizerWithTarget:(id) aTarget
                                                     action:(SEL) aAction {
  UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                 initWithTarget:aTarget action:aAction];
  tgr.numberOfTouchesRequired = 1;
  tgr.numberOfTapsRequired = 1;
  return tgr;
}

- (UIImage *) imageForBackCheveronWithColor:(UIColor *) aColor
                                 barMetrics:(UIBarMetrics) aMetrics {
  CGSize size = aMetrics == UIBarMetricsDefault ? CGSizeMake(50, 30) : CGSizeMake(60, 23);
  UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetStrokeColorWithColor(context, aColor.CGColor);
  CGContextSetLineWidth(context, 3.1f);

  static CGFloat const k_tip_x = 6;
  static CGFloat const k_wing_x = 14.5;
  static CGFloat const k_wing_y_offset = 6;

  CGRect rect = CGRectMake(0, 0, size.width, size.height);
  CGPoint tip = CGPointMake(k_tip_x, CGRectGetMidY(rect));
  CGPoint top = CGPointMake(k_wing_x, CGRectGetMinY(rect) + k_wing_y_offset);
  CGPoint bottom = CGPointMake(k_wing_x, CGRectGetMaxY(rect) - k_wing_y_offset);
  CGContextMoveToPoint(context, top.x, top.y);
  CGContextAddLineToPoint(context, tip.x, tip.y);
  CGContextAddLineToPoint(context, bottom.x, bottom.y);
  CGContextStrokePath(context);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  // avoid tiling by stretching from the right-hand side only
  UIEdgeInsets insets = UIEdgeInsetsMake(k_wing_y_offset + 1, k_wing_x + 1,
                                         k_wing_y_offset + 1, 1);
  return [image resizableImageWithCapInsets:insets
                               resizingMode:UIImageResizingModeStretch];
}

// useful for debugging layouts.  in the calabash target, normally clear
// backgrounds will be tinted pink to show the view frame.
+ (UIColor *) colorForViewBackground {
  static UIColor *color_shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    color_shared = [UIColor colorWithRed:255/255.0f
                                   green:0.0f
                                    blue:0.0f
                                   alpha:0.04f];
  });
  return color_shared;
}

@end
