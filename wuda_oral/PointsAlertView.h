//
//  PointsAlertView.h
//  wuda_oral
//
//  Created by 杨超 on 14-1-22.
//
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"

@protocol PointsAlertViewDelegate;

@interface PointsAlertView : UIView<UITextFieldDelegate,CustomAlertViewDelegate,ASIHTTPRequestDelegate>

@property(nonatomic,assign)id<PointsAlertViewDelegate>clickDelegate;

-(id)initWithView:(UIView *)view key:(int)key title:(NSString *)title content:(NSString *)content image:(UIImage *)image Score:(NSString *)score ScoreSum:(NSString *)scoreSum ID:(NSString *)lid;
-(void)show;
-(void)hide;

@end
@protocol PointsAlertViewDelegate
-(void)PointsClickButton:(UIButton *)button alertView:(PointsAlertView *)alertView;

@end
