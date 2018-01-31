//
//  UGLinkLabel.m
//

#import "UGLinkLabel.h"
#import "UGTapGestureRecognizer.h"
#import "Handstand-Swift.h"

@implementation UGLinkLabel

- (void)buildLinkViewFromString:(NSString *)localizedString forLinks:(NSDictionary *)aLinksDict
{   NSString *temp = @"";
    BOOL flag = 0;
    self.userInteractionEnabled = true;
    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];
    
    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }
        
        // 3. Determine what type of word this is:
        BOOL isLink = false;
        NSString *theLinkKey = @"";
        for (NSString *linkKey in aLinksDict.allKeys) {
            if ([chunk hasPrefix:linkKey]) {
                theLinkKey = linkKey;
                isLink = true;
                break;
            }
        }
        //        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        //        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        //        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
        
        //Logic for Custome message for Privacy Policy
        if([chunk isEqualToString:@"Sign me up for Reebok emails, featuring "]){
            flag = 1;
//            NSLog(@"Flag set to 1");
        }
        
//        NSLog(@"Chunk:{%@}", chunk);
        if(flag == 1){
            temp = [temp stringByAppendingString:[@" " stringByAppendingString:chunk]];
            if([chunk isEqualToString:@"Sign me up for Reebok emails, featuring "]){
                chunk = @"Sign ";
            }else if([chunk isEqualToString:@"exclusive"]){
                chunk = @"me ";
            }else if([chunk isEqualToString:@"offers,"]){
                chunk = @"up for ";
            }else if([chunk isEqualToString:@"product"]){
                chunk = @"Reebok ";
            }else if([chunk isEqualToString:@"info,"]){
                chunk = @"emails. ";
            }else if([chunk isEqualToString:@"news"]){
                chunk = @"I ";
            }else if([chunk isEqualToString:@"about"]){
                chunk = @"agree ";
            }else if([chunk isEqualToString:@"upcoming"]){
                chunk = @"that ";
            }else if([chunk isEqualToString:@"events,"]){
                chunk = @"I'm at ";
            }else if([chunk isEqualToString:@"more."]){
                chunk = @"least ";
            }else if([chunk isEqualToString:@"By signing up"]){
                chunk = @"13 ";
            }else if([chunk isEqualToString:@"I"]){
                chunk = @"year ";
            }else if([chunk isEqualToString:@"agree that I'm at"]){
                chunk = @"old";
            }else if([chunk isEqualToString:@" least "]){
                chunk = @". ";
            }else if([chunk isEqualToString:@"13 years"]){
                chunk = @"See ";
            }else if([chunk isEqualToString:@"old."]){
                chunk = @"our ";
            }else if([chunk isEqualToString:@"<pp>Privacy"]){
                chunk =@"<pp>Privacy ";
            }
            else if([chunk isEqualToString:@"<pp>Policy"] ){
                chunk = @"<pp>Policy";
            }else if([chunk isEqualToString:@" for details."] ){
                chunk = @" for details.";
            }else{
                chunk = @"";
            }
        }
        
        
        
        
        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [[UILabel alloc] init];
        label.font = self.font;
        label.text = chunk;
        label.userInteractionEnabled = isLink;
        
        if (isLink){
        label.textColor = [UIColor handstandGreen];
            //            label.highlightedTextColor = [UIColor yellowColor];
            
            // 5. Set tap gesture for this clickable text:
        UGTapGestureRecognizer *tapGesture = [[UGTapGestureRecognizer alloc] initWithTarget:self action:@selector(onLinkAction:)];
            tapGesture.link = aLinksDict[theLinkKey];
            [label addGestureRecognizer:tapGesture];
            
            // Trim the markup characters from the label:
            label.text = [label.text stringByReplacingOccurrencesOfString:theLinkKey withString:@""];
        }
        else
        {
            label.textColor = self.otherTextColor;
        }
        
        // 6. Lay out the labels so it forms a complete sentence again:
        
        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:
        
        [label sizeToFit];
        
        if (self.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line
            
            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }
        
        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);
        // Show this label:
        
//        NSLog(@"UITxt:{%@}", label.text);
        [self addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }
//    NSLog(@"String temp : %@" ,temp);
}

-(void)onLinkAction:(UGTapGestureRecognizer *)aGesture{
    if ([self.delegate respondsToSelector:@selector(didClickedOnLink:)]) {
        [self.delegate didClickedOnLink:aGesture.link];
    }
}

@end
