//
//  CustomAlertView.m
//  wuda_oral
//
//  Created by jijeMac2 on 13-12-19.
//
//

#import "CustomAlertView.h"

@interface CustomAlertView()
@property(nonatomic,strong)UIView *bg_view;
@end

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithView:(UIView *)view title:(NSString *)title content:(NSString *)content key:(int)key
{
    self = [self initWithFrame:view.frame];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
    
    self.bg_view = [[UIView alloc] init];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"alert_bg.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    [self.bg_view addSubview:backgroundImageView];
    
    CGFloat y = (view.frame.size.height - backgroundImage.size.height) / 2;
    CGFloat x = (view.frame.size.width - backgroundImage.size.width) / 2;
    self.bg_view.frame = CGRectMake(x, y, backgroundImage.size.width, backgroundImage.size.height);
    [self addSubview:self.bg_view];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35.0f, backgroundImage.size.width, 20.0f)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:15.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bg_view addSubview:titleLabel];
    if (key == 1)
    {
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 55.0f, backgroundImage.size.width - 80.0f, 30.0f)];
    contentLabel.text = content;
    contentLabel.numberOfLines = 2;
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.bg_view addSubview:contentLabel];
    
        //确定退出
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(155.0f, 90.0f, 75.0f, 25.0f);
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue.png"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn setTitle:@"确定" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    [exitBtn setAdjustsImageWhenHighlighted:NO];
    exitBtn.tag = 0;
    [self.bg_view addSubview:exitBtn];
        
    
    
    //继续游戏
    UIButton *goonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goonBtn.frame = CGRectMake(55.0f, 90.0f, 75.0f, 25.0f);
    [goonBtn setBackgroundImage:[UIImage imageNamed:@"btn_green.png"] forState:UIControlStateNormal];
    [goonBtn setAdjustsImageWhenHighlighted:NO];
    [goonBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [goonBtn setTitle:@"继续" forState:UIControlStateNormal];
    goonBtn.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    goonBtn.tag = 1;
    [self.bg_view addSubview:goonBtn];
    
    }
    else if (key == 3)
    {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 55.0f, backgroundImage.size.width - 80.0f, 30.0f)];
        contentLabel.text = content;
        contentLabel.numberOfLines = 2;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.bg_view addSubview:contentLabel];
        
        //确定
        UIButton *goonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goonBtn.frame = CGRectMake((backgroundImage.size.width/2)-37.0f, 90.0f, 75.0f, 25.0f);
        [goonBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue.png"] forState:UIControlStateNormal];
        [goonBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [goonBtn setTitle:@"确定" forState:UIControlStateNormal];
        [goonBtn setAdjustsImageWhenHighlighted:NO];
        goonBtn.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
        goonBtn.tag = 1;
        [self.bg_view addSubview:goonBtn];

    }
    else
    {
        //确定
        UIButton *goonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goonBtn.frame = CGRectMake((backgroundImage.size.width/2)-37.0f, 90.0f, 75.0f, 25.0f);
        [goonBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue.png"] forState:UIControlStateNormal];
        [goonBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [goonBtn setTitle:@"确定" forState:UIControlStateNormal];
        [goonBtn setAdjustsImageWhenHighlighted:NO];
        goonBtn.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
        goonBtn.tag = 1;
        [self.bg_view addSubview:goonBtn];
    }
    
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    [self.clickDelegate CustomClickButton:btn alertView:self];
}

- (void)show
{
    self.bg_view.clipsToBounds = YES;
    
    CGAffineTransform newTransform = CGAffineTransformScale(self.bg_view.transform, 0.1, 0.1);
    [self.bg_view setTransform:newTransform];
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self];
    
    [UIView beginAnimations:@"imageViewBig" context:nil];
    [UIView setAnimationDuration:.3f];
    newTransform = CGAffineTransformConcat(self.bg_view.transform,  CGAffineTransformInvert(self.bg_view.transform));
    [self.bg_view setTransform:newTransform];
    [UIView commitAnimations];
}

- (void)hide
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
