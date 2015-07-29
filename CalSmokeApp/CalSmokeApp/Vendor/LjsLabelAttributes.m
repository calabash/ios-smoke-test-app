// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsLabelAttributes.h"
#import "NSString+IOSSizeOf.h"
#import "UIView+Positioning.h"

@interface LjsLabelAttributes ()

@property (nonatomic, assign, readonly) NSUInteger num_lines_computed;

+ (NSUInteger) computeNumLinesWithLabelHeight:(CGFloat) aLabelH
                                   lineHeight:(CGFloat) aLineH;

@end

@implementation LjsLabelAttributes

@synthesize linebreakMode = _linebreakMode;
@synthesize font = _font;
@synthesize lineHeight = _lineHeight;
@synthesize labelHeight = _labelHeight;
@synthesize labelWidth = _labelWidth;
@synthesize num_lines_computed = _num_lines_computed;
@synthesize string = _string;
@synthesize maxNumberOfLines = _maxNumberOfLines;


+ (NSUInteger) computeNumLinesWithLabelHeight:(CGFloat) aLabelH
                                   lineHeight:(CGFloat) aLineH {
  // avoid div by zero errors
  if (aLineH < 0) { return 0; }
  return (NSUInteger) (ceil(ceil(aLabelH) / ceil(aLineH)));
}

- (NSUInteger) numberOfLines {
  return _maxNumberOfLines != 0 ? _maxNumberOfLines : _num_lines_computed;
}

- (id) initWithString:(NSString *) aString
                 font:(UIFont *) aFont
           labelWidth:(CGFloat) aLabelWidth {
  self = [super init];
  if (self != nil) {
    _linebreakMode = NSLineBreakByWordWrapping;
    _font = aFont;
    CGSize oneLineSize = [aString sizeOfStringWithFont:aFont];
    _lineHeight = oneLineSize.height;
    
    CGSize max = CGSizeMake(aLabelWidth, CGFLOAT_MAX);
    CGSize labelSize = [aString sizeOfStringWithFont:aFont
                                   constrainedToSize:max
                                       lineBreakMode:NSLineBreakByWordWrapping];
    _labelHeight = labelSize.height;
    _num_lines_computed = [LjsLabelAttributes computeNumLinesWithLabelHeight:_labelHeight
                                                                  lineHeight:_lineHeight];
    _string = aString;
    _labelWidth = aLabelWidth;
    _maxNumberOfLines = 0;
  }
  return self;
}

- (id) initWithString:(NSString *) aString
                 font:(UIFont *) aFont
           labelWidth:(CGFloat) aLabelWidth
        linebreakMode:(NSLineBreakMode)aLinebreakMode
          minFontSize:(CGFloat)aMinFontSize {
  self = [super init];
  if (self != nil) {
    
    CGFloat discovered = 0;
    
    CGSize size = [aString sizeOfStringWithFont:aFont
                                    minFontSize:aMinFontSize
                                 actualFontSize:&discovered
                                       forWidth:aLabelWidth
                                  lineBreakMode:aLinebreakMode];
    
    

    /**** LOOKS LIKE A BUG ******
    self.lineHeight = size.height;
     ****************************/
    
    _font = [UIFont fontWithName:aFont.fontName size:discovered];
    CGSize oneLine = [aString sizeOfStringWithFont:aFont];
    _lineHeight = oneLine.height;
    
    _linebreakMode = aLinebreakMode;
    _labelHeight = size.height;
    _labelWidth = size.width;
    _num_lines_computed = [LjsLabelAttributes computeNumLinesWithLabelHeight:_labelHeight
                                                                  lineHeight:_lineHeight];
    
    _string = aString;
    _labelWidth = aLabelWidth;
    _maxNumberOfLines = 0;
  }
  return self;
}

- (void) applyAttributesToLabel:(UILabel *) aLabel
      shouldApplyWidthAndHeight:(BOOL) aShouldApplyWidthAndHeight {
  aLabel.font = _font;
  aLabel.text = _string;
  aLabel.lineBreakMode = _linebreakMode;
  aLabel.numberOfLines = _maxNumberOfLines;
  if (aShouldApplyWidthAndHeight == YES) {
    aLabel.height = _labelHeight;
    aLabel.width = _labelWidth;
  }
}


- (void) applyAttributesToLabel:(UILabel *) aLabel
            applyWidthAndHeight:(BOOL) aShouldApplyWidthAndHeight
              centerToViewWithH:(CGFloat) aHeight {
  [self applyAttributesToLabel:aLabel shouldApplyWidthAndHeight:aShouldApplyWidthAndHeight];
  CGFloat y = (aHeight/2) - (_labelHeight/2);
  aLabel.y = y;
}



- (UILabel *) labelWithFrame:(CGRect) aFrame
                   alignment:(NSTextAlignment) aAlignemnt
                    textColor:(UIColor *) aTextColor
              highlightColor:(UIColor *) aHighlightColorOrNil
             backgroundColor:(UIColor *) aBackgroundColor {
  UIColor *bkgC = aBackgroundColor == nil ? [UIColor clearColor] : aBackgroundColor;
  UILabel *label = [[UILabel alloc] initWithFrame:aFrame];
  label.text = _string;
  label.font = _font;
  label.textAlignment = aAlignemnt;
  label.textColor = aTextColor;
  label.highlightedTextColor = aHighlightColorOrNil ? aHighlightColorOrNil : aTextColor;
  label.backgroundColor = bkgC;
  label.lineBreakMode = _linebreakMode;
  label.numberOfLines = _maxNumberOfLines;

  return label;
}



- (NSString *) description {
  return [NSString stringWithFormat:@"#<LjsLabelAttributes line: %@ height: %@ lines: (%@, %@) width: %@>",
          @(_lineHeight), @(_labelHeight), @(_num_lines_computed),
          @(_maxNumberOfLines), @(_labelWidth)];
}

//text label = {{10, 8}, {153, 22}}
//details label = {{10, 30}, {282, 18}}
+ (CGSize) sizeOfDetailsCellTitleLabel {
  return CGSizeMake(153, 22);
}

+ (CGSize) sizeOfDetailsCellDetailsLabel {
  return CGSizeMake(282, 18);
}

+ (CGFloat) heightOfDetailsCellTitleLabel {
  return [LjsLabelAttributes sizeOfDetailsCellTitleLabel].height;
}

+ (CGFloat) widthOfDetailsCellTitleLabel {
  return [LjsLabelAttributes sizeOfDetailsCellTitleLabel].width;
}

+ (CGFloat) heightOfDetailsCellDetailsLabel {
  return [LjsLabelAttributes sizeOfDetailsCellDetailsLabel].width;
}

+ (CGFloat) widthOfDetailsCellDetailsLabel {
  return [LjsLabelAttributes sizeOfDetailsCellDetailsLabel].width;
}

+ (CGRect) frameForDetailsCellTitleLabelWithX:(CGFloat) aX {
  CGSize size = [LjsLabelAttributes sizeOfDetailsCellTitleLabel];
  CGFloat w = MIN(size.width + aX, 316);
  CGFloat h = size.height;
  return CGRectMake(aX, 8, w, h);
}

+ (CGRect) frameForDetailsCellDetailsLabelWithX:(CGFloat) aX {
  CGSize size = [LjsLabelAttributes sizeOfDetailsCellDetailsLabel];
  CGFloat w = MIN(size.width + aX, 316);
  CGFloat h = size.height;
  return CGRectMake(aX, 30, w, h);
}

@end










