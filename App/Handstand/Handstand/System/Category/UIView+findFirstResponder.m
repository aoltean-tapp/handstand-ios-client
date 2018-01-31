//
//  UIView+findFirstResponder.m
//  Handstand
//
//  Created by Fareeth John on 3/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

#import "UIView+findFirstResponder.h"

@implementation UIView (findFirstResponder)

- (UIView *)findFirstResonder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *theFirstResponder = [subView findFirstResonder];
        
        if (theFirstResponder != nil) {
            return theFirstResponder;
        }
    }
    return nil;
}

@end
