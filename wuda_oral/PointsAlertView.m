//
//  PointsAlertView.m
//  wuda_oral
//
//  Created by 杨超 on 14-1-22.
//
//

#import "PointsAlertView.h"
#import "UIViewController+HUD.h"

@interface PointsAlertView ()
{
    CGFloat x;
    CGFloat y;
    NSString *ID;
    NSString *Score;
}

@property(nonatomic,strong)ASIHTTPRequest *request;
@property(nonatomic,retain)NSDictionary * articles;

@property(nonatomic,strong)UIView *bg_view;//底层view


//以下为产品介绍对话框使用控件
@property(nonatomic,strong)UIView *imageBG;//图片显示白边
@property(nonatomic,strong)UILabel *titleLabel;//设置标题
@property(nonatomic,strong)UILabel *contentLabel;//设置内容
@property(nonatomic,strong)UILabel *money1;//显示：此商品需要
@property(nonatomic,strong)UILabel *moneyLabel;//所需积分
@property(nonatomic,strong)UILabel *money2;//显示：健康币
@property(nonatomic,strong)UILabel *possessLeft;//显示：您目前拥有
@property(nonatomic,strong)UILabel *possess;//拥有积分
@property(nonatomic,strong)UILabel *possessRight;//显示：健康币
@property(nonatomic,strong)UILabel *remainLeft;//显示：兑换后您还剩下
@property(nonatomic,strong)UILabel *remain;//兑换剩余积分
@property(nonatomic,strong)UIImageView *imageView;//兑换剩余积分

@property(nonatomic,strong)UIButton *goodBtn;//蓝色按钮
@property(nonatomic,strong)UIButton *exitBtn;//绿色按钮

//以下为确定兑换使用控件
@property(nonatomic,strong)UITextField *phoneText;//电话号码
@property(nonatomic,strong)UITextField *nameText;//姓名
@property(nonatomic,strong)UITextField *siteText;//地址

@property(nonatomic,strong)UIView *phoneBG;//图片显示白边
@property(nonatomic,strong)UIView *nameBG;//图片显示白边
@property(nonatomic,strong)UIView *siteBG;//图片显示白边


@property(nonatomic,strong)UIView *BG_view;//填写地址时消耗积分的背景
@property(nonatomic,strong)UILabel *hintLabel;//提示信息


//以下为兑换成功使用控件
@property(nonatomic,strong)UIImageView *sealImageView;//图片显示白边



@end


@implementation PointsAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//积分兑换          REDEEM      上传参数：用户名，商品ID，姓名，电话，地址  username=？&lpid=？&integral=？&name=？&phone=？&address=？
//返回参数：errorid ，1 为修改成功，2为修改失败

/*
 key判断那种弹框，目前有3种
 1: 积分兑换，商品简介
 2：填写收货地址
 3：兑换成功
 */

-(id)initWithView:(UIView *)view key:(int)key title:(NSString *)title content:(NSString *)content image:(UIImage *)image Score:(NSString *)score ScoreSum:(NSString *)scoreSum ID:(NSString *)lid
{
    ID = lid;
    Score = score;
    UIColor *color = [UIColor colorWithRed:26.0f/255.0f green:110.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
    
    self = [self initWithFrame:view.frame];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
    self.bg_view = [[UIView alloc]init];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"points_alert_bg.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
    backgroundImageView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    [self.bg_view addSubview:backgroundImageView];
    
    y = (view.frame.size.height - backgroundImage.size.height)/2;
    x = (view.frame.size.width - backgroundImage.size.width)/2;
    self.bg_view.frame = CGRectMake(x, y, backgroundImage.size.width, backgroundImage.size.height);
    [self addSubview:self.bg_view];
    
    
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(33.0f, 35.0f, backgroundImage.size.width - 60.0f, 20.0f)];
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:15.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bg_view addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(33.0f, 55.0f, backgroundImage.size.width - 60.0f, 30.0f)];
    self.contentLabel.text = content;
    self.contentLabel.numberOfLines = 1;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.contentLabel];
    
    
    
    //图片背景
    self.imageBG = [[UIView alloc]initWithFrame:CGRectMake(32.0f, 84.0f, 82.0f, 82.0f)];
    self.imageBG.backgroundColor = [UIColor whiteColor];
    [self.bg_view addSubview:self.imageBG];
    
    //图片
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(33.0f, 85.0f, 80.0f, 80.0f)];
    
    self.imageView.image = image;//[UIImage imageNamed:@"icon.png"];
    [self.bg_view addSubview:self.imageView];
    
    
    //积分背景
    self.BG_view = [[UIView alloc]initWithFrame:CGRectMake(114.0f, 84.0f, 140.0f, 55.0f)];
    self.BG_view.backgroundColor = color;
    [self.bg_view addSubview:self.BG_view];
    self.BG_view.hidden = YES;
    
    //积分提示文字1
    self.money1 = [[UILabel alloc]initWithFrame:CGRectMake(117.0f, 90.0f, 50.0f, 30.0f)];
    self.money1.text = @"此商品需要";
    self.money1.numberOfLines = 1;
    self.money1.textColor = [UIColor whiteColor];
    self.money1.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:10.0f];
    self.money1.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.money1];
    
    //需消耗的积分
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(167.0f, 90.0f, 68.0f, 30.0f)];
    self.moneyLabel.text = score;
    self.moneyLabel.numberOfLines = 1;
    self.moneyLabel.textColor = [UIColor whiteColor];
    self.moneyLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.bg_view addSubview:self.moneyLabel];
    
    
    //积分提示文字2
    self.money2 = [[UILabel alloc]initWithFrame:CGRectMake(235.0f, 90.0f, 20.0f, 30.0f)];
    self.money2.text = @"积分";
    self.money2.numberOfLines = 1;
    self.money2.textColor = [UIColor whiteColor];
    self.money2.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:10.0f];
    self.money2.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.money2];
    
    //拥有积分提示文字1
    self.possessLeft = [[UILabel alloc]initWithFrame:CGRectMake(117.0f, 125.0f, 50.0f, 20.0f)];
    self.possessLeft.text = @"您目前拥有";
    self.possessLeft.numberOfLines = 1;
    self.possessLeft.textColor = [UIColor whiteColor];
    self.possessLeft.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:10.0f];
    self.possessLeft.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.possessLeft];
    
    //拥有的积分
    self.possess = [[UILabel alloc]initWithFrame:CGRectMake(167.0f, 125.0f, 68.0f, 20.0f)];
    self.possess.text = scoreSum;
    self.possess.numberOfLines = 1;
    self.possess.textColor = [UIColor whiteColor];
    self.possess.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.possess.textAlignment = NSTextAlignmentCenter;
    [self.bg_view addSubview:self.possess];
    
    //拥有积分提示文字2
    self.possessRight = [[UILabel alloc]initWithFrame:CGRectMake(235.0f, 125.0f, 20.0f, 20.0f)];
    self.possessRight.text = @"积分";
    self.possessRight.numberOfLines = 1;
    self.possessRight.textColor = [UIColor whiteColor];
    self.possessRight.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:10.0f];
    self.possessRight.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.possessRight];
    
    
    //剩下积分提示文字1
    self.remainLeft = [[UILabel alloc]initWithFrame:CGRectMake(117.0f, 140.0f, 70.0f, 20.0f)];
    self.remainLeft.text = @"兑换后您还剩下";
    self.remainLeft.numberOfLines = 1;
    self.remainLeft.textColor = [UIColor whiteColor];
    self.remainLeft.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:10.0f];
    self.remainLeft.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.remainLeft];
    
    
    //剩下的积分
    self.remain = [[UILabel alloc]initWithFrame:CGRectMake(200.0f, 140.0f, 60.0f, 20.0f)];
    int remainINT = [scoreSum intValue] - [score intValue];
    self.remain.text = [NSString stringWithFormat:@"%d",remainINT];
    self.remain.numberOfLines = 1;
    self.remain.textColor = [UIColor whiteColor];
    self.remain.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    self.remain.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.remain];
    
    
    
    
    /*
     
     以下为确定对话框需要内容
     */
    
    
    //电话号码白色背景
    self.phoneBG = [[UIView alloc]initWithFrame:CGRectMake(33.0f, 142.0f, 135.0f, 20.0f)];
    self.phoneBG.backgroundColor = [UIColor whiteColor];
    [self.bg_view addSubview:self.phoneBG];
    self.phoneBG.hidden = YES;
    
    //姓名白色背景
    self.nameBG = [[UIView alloc]initWithFrame:CGRectMake(171.0f, 142.0f, 83.0f, 20.0f)];
    self.nameBG.backgroundColor = [UIColor whiteColor];
    [self.bg_view addSubview:self.nameBG];
    self.nameBG.hidden = YES;
    //地址白色背景
    self.siteBG = [[UIView alloc]initWithFrame:CGRectMake(33.0f, 165.0f, 221.0f, 20.0f)];
    self.siteBG.backgroundColor = [UIColor whiteColor];
    [self.bg_view addSubview:self.siteBG];
    self.siteBG.hidden = YES;
    //电话输入框
    self.phoneText = [[UITextField alloc]initWithFrame:CGRectMake(35.0f, 142.0f, 137.0f, 20.0f)];
    self.phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入电话号码" attributes:@{NSForegroundColorAttributeName: color}];
    self.phoneText.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneText.textColor = color;
    self.phoneText.delegate = self;
    [self.bg_view addSubview:self.phoneText];
    self.phoneText.hidden = YES;
    
    //姓名输入框
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(173.0f, 142.0f, 84.0f, 20.0f)];
    self.nameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName: color}];
    self.nameText.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    self.nameText.textColor = color;
    self.nameText.delegate = self;
    [self.bg_view addSubview:self.nameText];
    self.nameText.hidden = YES;
    
    //地址输入框
    self.siteText = [[UITextField alloc]initWithFrame:CGRectMake(35.0f, 165.0f, 223.0f, 20.0f)];
    self.siteText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入收货地址" attributes:@{NSForegroundColorAttributeName: color}];
    self.siteText.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    self.siteText.textColor = color;
    self.siteText.delegate = self;
    [self.bg_view addSubview:self.siteText];
    self.siteText.hidden = YES;
    
    //提示信息
    self.hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(40.0f, 179.0f, 200.0f, 40.0f)];
    self.hintLabel.text = @"请务必填写正确，快递发送货品会根据以上信息进行签收！";
    self.hintLabel.numberOfLines = 2;
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:10.0f];
    self.hintLabel.textAlignment = NSTextAlignmentLeft;
    [self.bg_view addSubview:self.hintLabel];
    self.hintLabel.hidden = YES;
    
    
    //蓝色按钮
    self.goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodBtn.frame = CGRectMake(55.0f, 190.0f, 75.0f, 25.0f);
    [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue.png"] forState:UIControlStateNormal ];
    [self.goodBtn setBackgroundColor:[UIColor clearColor]];
    [self.goodBtn setAdjustsImageWhenHighlighted:NO];
    [self.goodBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.goodBtn setTitle:@"在看看" forState:UIControlStateNormal];
    self.goodBtn.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    self.goodBtn.tag = 0;
    [self.bg_view addSubview:self.goodBtn];
    
    
    //绿色按钮
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitBtn.frame = CGRectMake(155.0f, 190.0f, 75.0f, 25.0f);
    [self.exitBtn setAdjustsImageWhenHighlighted:NO];
    [self.exitBtn setBackgroundImage:[UIImage imageNamed:@"btn_green.png"] forState:UIControlStateNormal];
    [self.exitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.exitBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    self.exitBtn.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    
    self.exitBtn.tag = 1;
    [self.bg_view addSubview:self.exitBtn];
    
    
    
    
    self.sealImageView = [[UIImageView alloc]initWithFrame:CGRectMake(140.0f, 60.0f, 101.0f, 101.0f)];
    self.sealImageView.image = [UIImage imageNamed:@"seal.png"];
    [self.bg_view addSubview:self.sealImageView];
    self.sealImageView.hidden = YES;
    
    return self;
    
}

/*tag值：
 0,3,4：关闭对话框
 1：弹出确定兑换对话框
 2：调用确定兑换方法，检查输入内容，确定兑换提交数据
 */

-(void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {

        case 1:
            //调整坐标
            self.exitBtn.frame = CGRectMake(155.0f, 212.0f, 75.0f, 25.0f);
            self.goodBtn.frame = CGRectMake(55.0f, 212.0f, 75.0f, 25.0f);
            self.imageView.frame = CGRectMake(34.0f, 85.0f, 53.0f, 53.0f);
            self.imageBG.frame = CGRectMake(33.0f, 84.0f, 55.0f, 55.0f);
            self.BG_view.frame = CGRectMake(89.0f, 84.0f, 165.0f, 55.0f);
            //消耗xxx积分
            self.money1.frame = CGRectMake(140.0f, 90.0f, 20.0f, 30.0f);
            self.money1.textAlignment = NSTextAlignmentRight;
            self.money1.text = @"消耗";
            self.moneyLabel.frame = CGRectMake(162.0f, 88.0f, 68.0f, 30.0f);
            self.money2.frame = CGRectMake(230.0f, 90.0f, 20.0f, 30.0f);
            
            self.remainLeft.frame = CGRectMake(91.0f, 118.0f, 70.0f, 20.0f);
            self.remain.frame = CGRectMake(162.0f, 112.0f, 68.0f, 30.0f);
            self.remain.textAlignment = NSTextAlignmentCenter;
            
            self.possessRight.frame = CGRectMake(230.0f, 114.0f, 20.0f, 30.0f);
            
            
            //显示确定兑换控件
            
            self.nameText.hidden = NO;
            self.phoneBG.hidden = NO;
            self.nameBG.hidden = NO;
            self.siteBG.hidden = NO;
            self.phoneText.hidden = NO;
            self.nameBG.hidden = NO;
            self.siteText.hidden = NO;
            self.hintLabel.hidden = NO;
            self.BG_view.hidden = NO;
            self.possess.hidden = YES;
            self.possessLeft.hidden = YES;
            
            self.exitBtn.tag = 2;
            
            break;
            
        case 2:
            [self fillInSite];//调用确定兑换方法
            break;
            
        default:
            [self.clickDelegate PointsClickButton:btn alertView:self];
            break;
    }
    
}

//确定兑换方法

-(void)fillInSite
{
    // NSLog(@"打印电话--%@,打印姓名---%@，打印地址--%@",self.phoneText.text,self.nameText.text,self.siteText.text);
    
    NSString *phone; //= self.phoneText.text;
    NSString *name; //= self.nameText.text;
    NSString *site; //= self.siteText.text;
    
    phone = [self.phoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    name = [self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    site = [self.siteText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (phone.length == 0 && name.length == 0  && site.length == 0) {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.bg_view title:@"信息不能为空" content:nil key:2];
        alertView.clickDelegate = self;
        [alertView show];
    }
    else
    {
        [self okDate:self.titleLabel.text name:name phone:phone site:site];
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
        
        self.bg_view.frame = CGRectMake(x, y, self.bg_view.frame.size.width, self.bg_view.frame.size.height);
    }
}


//兑换商品
//积分兑换          REDEEM      上传参数：用户名，商品ID，姓名，电话，地址  username=？&lpid=？&integral=？&name=？&phone=？&address=？
//返回参数：errorid ，1 为修改成功，2为修改失败
-(void)okDate:(NSString *)title name:(NSString *)name phone:(NSString *)phone site:(NSString *)site
{
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *userLogin = myDelegate.userLogin;
    NSString *date = [NSString stringWithFormat:@"%@%@%@&lpid=%@%@%@&name=%@&phone=%@&address=%@&lang=en",REDEEM,USERNAME,userLogin,ID,INTEGRALS,Score,name,phone,site];
    
    
    date = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"--points---    %@   ---- ",date);
    NSURL *dateURL = [[NSURL alloc]initWithString:date];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:dateURL];
    [request setDelegate:self];
    [request startAsynchronous];

}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    id rs = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
    self.articles = rs;
    [self dateEND];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"出错");
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.bg_view title:@"出问题啦" content:@"数据传输失败!" key:3];
    alertView.clickDelegate = self;
    [alertView show];
}

-(void)dateEND
{
    NSString *errorid = [NSString stringWithFormat:@"%@",[self.articles objectForKey:@"errorid"]];
    if ([errorid isEqualToString:@"1"]) {
        [self ok];
    }
    else
    {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.bg_view title:@"出问题啦" content:@"没有兑换成功!" key:3];
        alertView.clickDelegate = self;
        [alertView show];
    }
}

/*兑换成功方法
 title：物品名称
 name：收件人姓名
 phone：收件人电话
 site：收件人地址
 lid:商品ID
 */
-(void)ok
{
    
    self.exitBtn.tag = 3;
    self.goodBtn.tag = 4;
    
    NSString *title = self.titleLabel.text;
    NSString *phone; //= self.phoneText.text;
    NSString *name; //= self.nameText.text;
    NSString *site; //= self.siteText.text;
    
    
    
    phone = [self.phoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    name = [self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    site = [self.siteText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UIColor *color = [UIColor colorWithRed:26.0f/255.0f green:110.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
    
    
    self.phoneText.hidden = YES;
    self.phoneBG.hidden = YES;
    self.nameText.hidden = YES;
    self.nameBG.hidden = YES;
    self.siteText.hidden = YES;
    self.siteBG.hidden = YES;
    self.contentLabel.hidden = YES;
    self.remainLeft.hidden = YES;
    self.sealImageView.hidden = NO;
    
    
    self.titleLabel.text = @"兑换成功";
    
    
    [self.exitBtn setTitle:@"继续答题" forState:UIControlStateHighlighted];
    [self.goodBtn setTitle:@" 确定" forState:UIControlStateHighlighted];
    
    [self.exitBtn setTitle:@"继续答题" forState:UIControlStateNormal];
    [self.goodBtn setTitle:@" 确定" forState:UIControlStateNormal];
    
    self.BG_view.backgroundColor = [UIColor whiteColor];
    self.BG_view.frame = CGRectMake(88.0f, 84.0f, 166.0f, 55.0f);
    
    self.hintLabel.frame = CGRectMake(40.0f, 160.0f, 200.0f, 40.0f);
    self.hintLabel.text = @"我们将在3个工作日内为您快递商品，请注意查收";
    
    //兑换的商品
    NSString * titles = [NSString stringWithFormat:@"您兑换的商品: %@",title];
    self.money1.frame = CGRectMake(95.0f, 85.0f, 155.0f, 12.0f);
    self.money1.textAlignment = NSTextAlignmentLeft;
    self.money1.text = titles;
    self.money1.textColor = color;
    self.money1.numberOfLines = 1;
    self.money1.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:9.0f];
    
    
    //收件人
    NSString * names = [NSString stringWithFormat:@"收件人: %@",name];
    self.moneyLabel.frame = CGRectMake(95.0f, 105.0f, 155.0f, 12.0f);
    self.moneyLabel.text = names;
    self.moneyLabel.textAlignment = NSTextAlignmentLeft;
    self.moneyLabel.textColor = color;
    self.moneyLabel.numberOfLines = 1;
    self.moneyLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:7.0f];
    
    //电话
    NSString * phones = [NSString stringWithFormat:@"电话: %@",phone];
    self.money2.frame = CGRectMake(95.0f, 115.0f, 155.0f, 12.0f);
    self.money2.text = phones;
    self.money2.textAlignment = NSTextAlignmentLeft;
    self.money2.textColor = color;
    self.money2.numberOfLines = 1;
    self.money2.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:7.0f];
    
    //地址
    NSString * sites = [NSString stringWithFormat:@"地址: %@",site];
    self.remain.frame = CGRectMake(95.0f, 125.0f, 155.0f, 12.0f);
    self.remain.text = sites;
    self.remain.textAlignment = NSTextAlignmentLeft;
    self.remain.textColor = color;
    self.remain.numberOfLines = 1;
    self.remain.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:7.0f];
}

-(void)show
{
    self.bg_view.clipsToBounds = YES;
    CGAffineTransform newTransform = CGAffineTransformScale(self.bg_view.transform, 0.1, 0.1);
    [[[[UIApplication sharedApplication]windows]objectAtIndex:0]addSubview:self];
    [UIView beginAnimations:@"imageViewBig" context:nil];
    [UIView setAnimationDuration:.3f];
    
    
    
    newTransform = CGAffineTransformConcat(self.bg_view.transform,  CGAffineTransformInvert(self.bg_view.transform));
    [self.bg_view setTransform:newTransform];
    [UIView commitAnimations];
}

-(void)hide
{
    [self removeFromSuperview];
}


//开始编辑输入框的时候，软键盘出现，执行此事件

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y +32 - (self.bg_view.frame.size.height - 120.0);
    //NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0) {
        self.bg_view.frame = CGRectMake(x, -offset+40 + ALERT_POINTS, self.bg_view.frame.size.width, self.bg_view.frame.size.height);
    }
    
    [UIView commitAnimations];
}


//当用户按下return键或者按回车键，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.bg_view.frame = CGRectMake(x, y, self.bg_view.frame.size.width, self.bg_view.frame.size.height);
    return YES;
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (textField ==self.siteText) {
    //        self.bg_view.frame = CGRectMake(x, y, self.bg_view.frame.size.width, self.bg_view.frame.size.height);
    //    }
    
}


-(void)CustomClickButton:(UIButton *)button alertView:(CustomAlertView *)alertView
{
    [alertView hide];
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
