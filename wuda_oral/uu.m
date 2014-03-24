//
//  uu.m
//  wuda_oral
//
//  Created by 杨超 on 14-1-23.
//
//

#import "uu.h"
@interface uu()
@end


@implementation uu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)initWithView:(UIView *)view title:(NSString *)title content:(NSString *)content key:(int)key //image:(UIImage *)image
{
    
    self = [self initWithFrame:view.frame];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
    
   
    [self addSubview:self.view];
    
    self.contentLabel.text = title;

    self.contentLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];

    
    self.exitBtn.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    [self.exitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.exitBtn.tag = 0;

    
    return self;
    
}

-(void)btnClick:(UIButton *)btn
{
    [self.uuclickDelegate uuClickButton:btn alertView:self];
}


-(void)show
{
    
    self.view.clipsToBounds = YES;
    CGAffineTransform newTransform = CGAffineTransformScale(self.view.transform, 0.1, 0.1);
    [[[[UIApplication sharedApplication]windows]objectAtIndex:0]addSubview:self];
    [UIView beginAnimations:@"imageViewBig" context:nil];
    [UIView setAnimationDuration:.3f];
    newTransform = CGAffineTransformConcat(self.view.transform,  CGAffineTransformInvert(self.view.transform));
    [self.view setTransform:newTransform];
    [UIView commitAnimations];
}

-(void)hide
{
    [self removeFromSuperview];
}

@end
