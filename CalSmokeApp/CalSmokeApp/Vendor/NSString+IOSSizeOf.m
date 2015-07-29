#import "NSString+IOSSizeOf.h"

#if TARGET_OS_IPHONE

NSString *const k_ljs_ios_700 = @"7.0";

NS_INLINE BOOL ljs_is_at_least_iOS7() {
  static dispatch_once_t onceToken;
  static BOOL shared = NO;
  dispatch_once(&onceToken, ^{
    NSString *versionString = [[UIDevice currentDevice] systemVersion];
    shared = [versionString compare:k_ljs_ios_700 options:NSNumericSearch] != NSOrderedAscending;
  });

  return shared;
}

#endif

@implementation NSString (NSString_IOS_SizeOf)

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont {
  return [self sizeOfStringWithFont:aFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont constrainedToSize:(CGSize) aSize {
	return [self sizeOfStringWithFont:aFont constrainedToSize:aSize lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont constrainedToSize:(CGSize) aSize lineBreakMode:(NSLineBreakMode) aLineBreakMode {

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
  if (ljs_is_at_least_iOS7()) {
    NSLog(@"Xcode 5 - iOS 7: using layout manager");
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:aSize];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:aFont range:NSMakeRange(0, self.length)];
    [textContainer setLineBreakMode:aLineBreakMode];
    [textContainer setLineFragmentPadding:0.0];
    (void)[layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager usedRectForTextContainer:textContainer].size;
  } else {
    NSLog(@"Xcode 5 - iOS < 7: using constrained to size");
    return [self sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:aLineBreakMode];
  }
#else
  NSLog(@"Xcode 4.6: using constrained to size");
  return [self sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:aLineBreakMode];
#endif
  
}

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont
                    minFontSize:(CGFloat) aMinSize
                 actualFontSize:(CGFloat *) aActualFontSize
                       forWidth:(CGFloat) aWidth
                  lineBreakMode:(NSLineBreakMode) aLineBreakMode {

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
  if (ljs_is_at_least_iOS7()) {
    CGFloat currentFontSize = aFont.pointSize;
    CGSize targetSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGSize currentSize = CGSizeZero;
    
    CGFloat lineHeight = CGFLOAT_MAX;
    
    do {
      UIFont *currentFont = [aFont fontWithSize:currentFontSize];
      NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:self];
      NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:targetSize];
      NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
      [layoutManager addTextContainer:textContainer];
      [textStorage addLayoutManager:layoutManager];
      [textStorage addAttribute:NSFontAttributeName value:currentFont range:NSMakeRange(0, self.length)];
      [textContainer setLineBreakMode:aLineBreakMode];
      [textContainer setLineFragmentPadding:0.0];
      (void)[layoutManager glyphRangeForTextContainer:textContainer];
      
      currentSize = [layoutManager usedRectForTextContainer:textContainer].size;
      if (lineHeight == CGFLOAT_MAX) {  lineHeight = currentSize.height; }
      
      if (currentFontSize - 1.0f < aMinSize) {  break; }
      currentFontSize -= 1.0f;
    
      NSLog(@"size = %@", NSStringFromCGSize(currentSize));
    } while (currentSize.width > aWidth);
    *aActualFontSize = currentFontSize;
    return CGSizeMake(currentSize.width, lineHeight);
  } else {
    return [self sizeWithFont:aFont
                  minFontSize:aMinSize
               actualFontSize:aActualFontSize
                     forWidth:aWidth
                lineBreakMode:aLineBreakMode];
  }
#else
  return [self sizeWithFont:aFont
                minFontSize:aMinSize
             actualFontSize:aActualFontSize
                   forWidth:aWidth
              lineBreakMode:aLineBreakMode];
#endif
}

@end
