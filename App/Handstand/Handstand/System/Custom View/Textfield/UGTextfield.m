//
//  UGTextfield.m
//  Handstand
//
//  Created by Fareeth John on 3/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

#import "UGTextfield.h"

@implementation UGTextfield

- (void)awakeFromNib {
    [super awakeFromNib];
    //For UIToolBar Button above keynboard disable
    [self initializeTextView];
}


-(void)initializeTextView{
    
    //Keyboard tool bar
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [self setInputAccessoryView:toolbar];
}

-(void)resignKeyboard{
    [self resignFirstResponder];
}


@end
