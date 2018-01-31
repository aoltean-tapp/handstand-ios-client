//
//  UGScrollView.m
//  Handstand
//
//  Created by Fareeth John on 3/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//


#import "UGScrollView.h"

#define kKeyBoardHeight          330.0

@interface UGScrollView()

@property (nonatomic) CGFloat scrollContentOffset_Y;
@end

@implementation UGScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardBecomeActive:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardBecomeActive:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardBecomeDeactive:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardBecomeDeactive:) name:UITextViewTextDidEndEditingNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)onKeyboardBecomeActive:(NSNotification *)aNotification{
    UITextField *textfield = aNotification.object;
    CGRect theTextFrame = textfield.bounds;
    theTextFrame = [textfield convertRect:theTextFrame toView:[[[UIApplication sharedApplication] delegate] window]];
    _scrollContentOffset_Y = self.contentOffset.y;
    if (self.contentOffset.y > 0) {
        theTextFrame.origin.y = theTextFrame.origin.y+self.contentOffset.y;
    }
    CGFloat requiredOffset_Y = theTextFrame.origin.y+theTextFrame.size.height-([UIScreen mainScreen].bounds.size.height-kKeyBoardHeight);
    if (requiredOffset_Y > 0) {
        [self setContentOffset:CGPointMake(0, requiredOffset_Y) animated:true];
    }
}

-(void)onKeyboardBecomeDeactive:(NSNotification *)aNotification{
    if (self.frame.size.height < self.contentSize.height) {
        [self setContentOffset:CGPointMake(0, _scrollContentOffset_Y) animated:true];
    }
    else{
        [self setContentOffset:CGPointMake(0, 0) animated:true];
    }
}

@end
