//
//  UGLinkLabel.h
//

#import <UIKit/UIKit.h>

@protocol UGLinkLabelDelegate <NSObject>

-(void)didClickedOnLink:(NSString *)aLink;

@end

@interface UGLinkLabel : UILabel

- (void)buildLinkViewFromString:(NSString *)localizedString forLinks:(NSDictionary *)aLinksDict;

@property (nonatomic, weak) IBOutlet id<UGLinkLabelDelegate> delegate;
@property (nonatomic, strong) IBInspectable UIColor *otherTextColor;
@end
