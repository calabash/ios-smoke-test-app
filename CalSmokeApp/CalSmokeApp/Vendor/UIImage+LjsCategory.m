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

#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (UIImage_LjsCategory)

- (UIImage *) imageByReszingWithSize:(CGSize) aSize {
  UIImage *image = [self copy];
  UIGraphicsBeginImageContextWithOptions(aSize, 1.0, 0.0);
  [image drawInRect:CGRectMake(0,0,aSize.width,aSize.height)];
  image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (UIImage *) imageByBlendingBlurredSnapshotFromView:(UIView *) aView
                                              inRect:(CGRect) aFrame
                                                blur:(CGFloat) aBlur
                                          blendColor:(UIColor *) aBlendColor {
  UIImage *blurred = [UIImage imageByBlurringSnapshotFromView:aView inRect:aFrame blur:aBlur];
  UIImage *blendColor = [UIImage imageWithColor:aBlendColor size:aFrame.size];
  UIImage *blended = [UIImage imageByBlendingTop:blendColor bottom:blurred];
  return [blended resizableImageWithCapInsets:UIEdgeInsetsZero];
}

+ (UIImage *) imageByBlendingBlurredSnapshotFromTopViewInRect:(CGRect) aFrame
                                                         blur:(CGFloat) aBlur
                                                   blendColor:(UIColor *) aBlendColor {
  UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
  return [UIImage imageByBlendingBlurredSnapshotFromView:topController.view
                                                  inRect:aFrame
                                                    blur:aBlur
                                              blendColor:aBlendColor];
}

+ (UIImage *) imageByBlurringSnapshotFromView:(UIView *) aView inRect:(CGRect) aFrame blur:(CGFloat) aBlur {
  CGFloat x = CGRectGetMinX(aFrame);
  CGFloat y = CGRectGetMinY(aFrame);
  CGFloat h = CGRectGetHeight(aFrame);
  CGFloat w = CGRectGetWidth(aFrame);
  CGSize size = CGSizeMake(w, h);
  UIGraphicsBeginImageContext(size);
  CGContextRef c = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(c, -x, -y);
  [aView.layer renderInContext:c];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  NSData *imageData = UIImageJPEGRepresentation(image, 1);
  image = [UIImage imageWithData:imageData];
  return [image imageByBlurringWithBlur:aBlur];
}

- (UIImage *) imageByBlurringWithBlur:(CGFloat) aBlur {
  if (aBlur < 0.f || aBlur > 1.f) {  aBlur = 0.5f; }
  
  u_int32_t boxSize = (u_int32_t)(aBlur * 50);
  boxSize = boxSize - (boxSize % 2) + 1;
  
  CGImageRef img = self.CGImage;
  
  vImage_Buffer inBuffer, outBuffer;
  
  vImage_Error error;
  
  void *pixelBuffer;
  
  CGDataProviderRef inProvider = CGImageGetDataProvider(img);
  CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
  
  inBuffer.width = CGImageGetWidth(img);
  inBuffer.height = CGImageGetHeight(img);
  inBuffer.rowBytes = CGImageGetBytesPerRow(img);
  
  inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
  
  pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
  
  if (pixelBuffer == NULL) { NSLog(@"no pixel buffer!"); return nil; }
  
  outBuffer.data = pixelBuffer;
  outBuffer.width = CGImageGetWidth(img);
  outBuffer.height = CGImageGetHeight(img);
  outBuffer.rowBytes = CGImageGetBytesPerRow(img);
  
  error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
  
  if (error) { NSLog(@"JFDepthView: error from convolution '%ld'", error);  return nil;}
  
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  /*
   bitmapInfo
   Constants that specify whether the bitmap should contain an alpha channel,
   the alpha channel’s relative location in a pixel, and information about
   whether the pixel components are floating-point or integer values. The
   constants for specifying the alpha channel information are declared with
   the CGImageAlphaInfo type but can be passed to this parameter safely. You
   can also pass the other constants associated with the CGBitmapInfo type.
   */
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wenum-conversion"
  CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                           outBuffer.width,
                                           outBuffer.height,
                                           8,
                                           outBuffer.rowBytes,
                                           colorSpace,
                                           kCGImageAlphaNoneSkipLast);
#pragma clang diagnostic pop
  
  CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
  UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
  
  //clean up
  CGContextRelease(ctx);
  CGColorSpaceRelease(colorSpace);
  
  free(pixelBuffer);
  CFRelease(inBitmapData);
  
  CGImageRelease(imageRef);
  
  return [returnImage resizableImageWithCapInsets:UIEdgeInsetsZero];
}

+ (UIImage *) imageWithColor:(UIColor *) aColor size:(CGSize) aSize {
  CGRect rect = CGRectMake(0, 0, aSize.width, aSize.height);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, aColor.CGColor);
  CGContextFillRect(context, rect);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return [image resizableImageWithCapInsets:UIEdgeInsetsZero];
}

+ (UIImage *) imageByBlendingTop:(UIImage *) aTop bottom:(UIImage *) aBottom {
  CGSize finalSize = aBottom.size;
  UIGraphicsBeginImageContext(finalSize);
  [aBottom drawInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
  CGSize topSize = aTop.size;
  [aTop drawInRect:CGRectMake(0, 0, topSize.width, topSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return [newImage resizableImageWithCapInsets:UIEdgeInsetsZero];
}



@end
