//
//  CustomAlertView.h
//  wuda_oral
//
//  Created by jijeMac2 on 13-12-19.
//
//
#import <UIKit/UIKit.h>
@protocol CustomAlertViewDelegate;

@interface CustomAlertView : UIView
@property(nonatomic,assign)id<CustomAlertViewDelegate> clickDelegate;

- (id)initWithView:(UIView *)view title:(NSString *)title content:(NSString *)content key:(int)key;
- (void)show;
- (void)hide;
@end
@protocol CustomAlertViewDelegate
- (void)CustomClickButton:(UIButton *)button alertView:(CustomAlertView *)alertView;
@end
