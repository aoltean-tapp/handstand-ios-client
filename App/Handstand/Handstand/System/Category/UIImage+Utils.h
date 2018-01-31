//
//  UIImage+Utils.h
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (UIImage *) renderAtSize:(const CGSize) size;
- (UIImage *) maskWithImage:(const UIImage *) maskImage;
- (UIImage *) maskWithColor:(UIColor *) color;
- (UIImage*) maskimagewithMask:(const UIImage *)maskImage;
- (UIImage*)scaleToSize:(CGSize)size;

@end
