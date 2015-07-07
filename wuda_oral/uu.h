//
//  uu.h
//  wuda_oral
//
//  Created by 杨超 on 14-1-23.
//
//

#import <UIKit/UIKit.h>

@protocol uuAlertViewDelegate;

@interface uu : UIView


@property(nonatomic,assign)id<uuAlertViewDelegate>uuclickDelegate;

-(id)initWithView:(UIView *)view title:(NSString *)title content:(NSString *)content key:(int)key;
-(void)show;
-(void)hide;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@end
@protocol uuAlertViewDelegate
-(void)uuClickButton:(UIButton *)button alertView:(uu *)alertView;

@end
