#import "NSString+IOSSizeOf.h"

@implementation NSString (NSString_IOS_SizeOf)

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont {
  return [self sizeOfStringWithFont:aFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont constrainedToSize:(CGSize) aSize {
	return [self sizeOfStringWithFont:aFont constrainedToSize:aSize lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont constrainedToSize:(CGSize) aSize lineBreakMode:(NSLineBreakMode) aLineBreakMode {
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
}

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont
                    minFontSize:(CGFloat) aMinSize
                 actualFontSize:(CGFloat *) aActualFontSize
                       forWidth:(CGFloat) aWidth
                  lineBreakMode:(NSLineBreakMode) aLineBreakMode {

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
    
  } while (currentSize.width > aWidth);

  *aActualFontSize = currentFontSize;
  return CGSizeMake(currentSize.width, lineHeight);
}

@end
