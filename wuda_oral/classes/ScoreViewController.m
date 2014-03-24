//
//  ScoreViewController.m
//  wuda_oral
//
//  Created by jijeMac2 on 13-12-16.
//
//


//登录             LOGIN       上传参数：用户名，密码           username=? &password=?
//返回参数：errorid 1 为登录成功，2为登录失败

//忘记密码          PWD         上传参数：用户名，密码，邮箱      username=？&password=？&email=？
//返回参数：errorid ，1 为修改成功，2为修改失败

//注册用户          REGIST      上传参数：用户名，密码，邮箱      username=？&password=？&email=？
//返回参数：errorid ，1 为修改成功，2为修改失败

//上传积分          UPLOAD      上传参数：用户名，积分           username=？&integral=？
//返回参数：errorid ，1 为修改成功，2为修改失败

//积分排行          RANK        上传参数：
//返回参数：username 用户名, Integral 积分

//个人排名          INTEGRAL    上传参数：用户名                username=？
//返回参数： integral积分,rankings  排名

//商品列表          GOOD        上传参数：
/*返回参数：
 image       商品图片
 title         商品标题
 integral      商品所需积分
 introduction  商品介绍
 id           商品id
 */

//积分兑换          REDEEM      上传参数：用户名，商品ID，姓名，电话，地址  username=？&lpid=？&integral=？&name=？&phone=？&address=？
//返回参数：errorid ，1 为修改成功，2为修改失败



#import "ScoreViewController.h"
#import "ScoreRankCell.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIViewController+HUD.h"
@interface ScoreViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *userName;//接收用户名
    int push;
}
@property (nonatomic,retain) NSMutableArray *articles ;
@property (nonatomic,retain) NSDictionary *score;

@property(nonatomic,strong)ASIHTTPRequest *request;

@end

@implementation ScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [self initScoreView];
    self.label_fraction.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:50.0f];
    self.label_fraction.text = [NSString stringWithFormat:@"%d 分",[self.totleScore intValue]];
    self.btn_back.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    self.btn_start.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:15.0f];
    self.btn_share.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    
    self.label_rank_title.font =[UIFont fontWithName:@"DFPHaiBaoW12" size:18.0f];
    self.label_rank_rank.font =[UIFont fontWithName:@"DFPHaiBaoW12" size:14.0f];
    self.label_rank_point.font =[UIFont fontWithName:@"DFPHaiBaoW12" size:14.0f];
    self.tableView.bounces = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (IS_IPHONE_5) {
        self.scoreScrollView.frame = CGRectMake(0, 30, 320, 385);
    }
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    userName = myDelegate.userLogin;
    
    [self UserLogin];
    
    [self initData];
    
}

/*
 判断是否登录
 */
-(void)UserLogin
{
    if (userName == NULL) {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"您还没有登录，请点击确定登录。" key:1];
        alertView.clickDelegate = self;
        [alertView show];
    }
    else
    {
        [self dateURLScore];
        if ([self.totleScore intValue] != 0) {//积分为0时不上传积分
            [self scoreDatePush];
        }
    }
}

/*
 开始上传积分
 */

-(void)scoreDatePush
{
    NSString *score = [NSString stringWithFormat:@"%d",[self.totleScore intValue]];
    NSString *date  = [NSString stringWithFormat:@"%@%@%@%@%@&lang=en",UPLOAD,USERNAME,userName,INTEGRALS,score];
    date = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//转换字符编码
    NSURL *dateURL = [[NSURL alloc]initWithString:date];
    MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
    request.key = 2;
    [request setDelegate:self];
    [request startAsynchronous];
}

//检测积分是否上传成功
-(void)scoreDate
{
    NSString *errorid = [NSString stringWithFormat:@"%@",[self.score objectForKey:@"errorid"]];
    if ([errorid isEqualToString:@"1"])
    {
        NSLog(@"----score--149-积分上传成功");
    }
    else
    {
        CustomAlertView * alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"上传积分失败!" key:3];
        alertView.clickDelegate =self;
        [alertView show];
    }
}

/*
 拉取积分排名
 */
-(void)dateURLScore
{
    NSString *date  = [NSString stringWithFormat:@"%@%@%@&lang=en",INTEGRAL,USERNAME,userName];
    date = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//转换字符编码
    NSURL *dateURL = [[NSURL alloc]initWithString:date];
    MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
    request.key = 3;
    [request setDelegate:self];
    [request startAsynchronous];
}


-(void)CustomClickButton:(UIButton *)button alertView:(CustomAlertView *)alertView
{
    NSInteger tag = button.tag;
    
    [alertView hide];
     if (tag == 0) {
    push = 1;
    [self performSegueWithIdentifier:@"login" sender:[NSNumber numberWithInt:[self.totleScore intValue]]];
    
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (push == 1) {
        UIViewController *destinationController = segue.destinationViewController;
        [destinationController setValue:sender forKey:@"totleScore"];
        
    }
}

- (void)initData
{
    /*
     self.scoreArray = [NSMutableArray array];
     NSDictionary *dic = @{@"name": @"张家朝",@"score":@"8900"};
     [self.scoreArray addObject:dic];
     
     dic = @{@"name": @"王可",@"score":@"8000"};
     [self.scoreArray addObject:dic];
     
     dic = @{@"name": @"杨超",@"score":@"5900"};
     [self.scoreArray addObject:dic];
     
     dic = @{@"name": @"蔡波",@"score":@"1700"};
     [self.scoreArray addObject:dic];
     
     dic = @{@"name": @"毕福剑",@"score":@"690"};
     [self.scoreArray addObject:dic];
     
     dic = @{@"name": @"朱军",@"score":@"500"};
     [self.scoreArray addObject:dic];
     
     dic = @{@"name": @"杨钰莹",@"score":@"300"};
     [self.scoreArray addObject:dic];
     */
    
    [self showHUDInfo:@"正在加载数据..."];
    
    NSString *date  = RANK;
    NSURL *dateURL = [[NSURL alloc]initWithString:date];
    MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
    request.key = 1;
    [request setDelegate:self];
    [request startAsynchronous];
    
}



-(void)requestFinished:(ASIHTTPRequest *)request
{
    [self removeHUDInfo];
    
    MyASIHTTPRequest *myhttp = (MyASIHTTPRequest *)request;
    NSError *error;
    id rs = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
    
    switch (myhttp.key) {
        case 1:
            self.articles = rs;
            [self.tableView reloadData];
            break;
        case 2:
            self.score = rs;// 接收是否上传成功
            [self scoreDate];
            break;
        case 3:
            self.score = rs;
            self.label_rank_rank.text = [NSString stringWithFormat:@"您的积分排名:第%@名",[self.score objectForKey:@"rankings"]];
            break;
        default:
            break;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self removeHUDInfo];
    
    NSLog(@"出错");
    CustomAlertView * alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"连接失败" key:3];
    alertView.clickDelegate =self;
    [alertView show];
}

- (void)initScoreView
{
    /*
     UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 385.0f)];
     UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:viewLeft.frame];
     backgroundImageView.image = [UIImage imageNamed:@"score_tag.png"];
     [viewLeft addSubview:backgroundImageView];
     
     ///
     UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 90.0f, 100.0f, 30.0f)];
     label1.text = @"您的成绩:";
     label1.font = [UIFont boldSystemFontOfSize:15.0f];
     label1.textColor = [UIColor whiteColor];
     [viewLeft addSubview:label1];
     
     UILabel *labelScore = [[UILabel alloc] initWithFrame:CGRectMake(0, 120.0f, 320.0f, 70.0f)];
     labelScore.text = [NSString stringWithFormat:@"%d 分",[self.totleScore intValue]];
     labelScore.font = [UIFont boldSystemFontOfSize:45.0f];
     labelScore.textColor = [UIColor whiteColor];
     labelScore.textAlignment = NSTextAlignmentCenter;
     [viewLeft addSubview:labelScore];
     
     UIImageView *redLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 190.0f, 320.0f, 90.0f)];
     redLineImageView.image = [UIImage imageNamed:@"score_tag_redline.png"];
     [viewLeft addSubview:redLineImageView];
     
     UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200.0f, 320.0f, 30.0f)];
     label2.text = @"恭喜您已成为健康达人!";
     label2.font = [UIFont boldSystemFontOfSize:15.0f];
     label2.textColor = [UIColor whiteColor];
     label2.textAlignment = NSTextAlignmentCenter;
     [viewLeft addSubview:label2];
     
     
     UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 245.0f, 100.0f, 10.0f)];
     label3.text = @"此次可获积分为:";
     label3.font = [UIFont boldSystemFontOfSize:9.0f];
     label3.textColor = [UIColor whiteColor];
     label3.textAlignment = NSTextAlignmentRight;
     [viewLeft addSubview:label3];
     
     UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 256.0f, 100.0f, 10.0f)];
     label4.text = @"累积总积分为:";
     label4.font = [UIFont boldSystemFontOfSize:9.0f];
     label4.textColor = [UIColor whiteColor];
     label4.textAlignment = NSTextAlignmentRight;
     [viewLeft addSubview:label4];
     
     
     UILabel *labelCurrentScore = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 245.0f, 100.0f, 10.0f)];
     labelCurrentScore.text = @"690健康币";
     labelCurrentScore.font = [UIFont boldSystemFontOfSize:9.0f];
     labelCurrentScore.textColor = [UIColor whiteColor];
     [viewLeft addSubview:labelCurrentScore];
     
     UILabel *labelTotleScore = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 256.0f, 100.0f, 10.0f)];
     labelTotleScore.text = @"1700健康币";
     labelTotleScore.font = [UIFont boldSystemFontOfSize:9.0f];
     labelTotleScore.textColor = [UIColor whiteColor];
     [viewLeft addSubview:labelTotleScore];
     
     
     UIImageView *giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(137.5f, 270.0f, 45.0f, 45.0f)];
     giftImageView.image = [UIImage imageNamed:@"score_gift.png"];
     [viewLeft addSubview:giftImageView];
     
     UILabel *labelGift = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, 285.0f, 100.0f, 40.0f)];
     labelGift.text = @"   健康币可到积分 \n 商城兑换丰厚礼品";
     labelGift.font = [UIFont boldSystemFontOfSize:10.0f];
     labelGift.numberOfLines = 2;
     labelGift.textColor = [UIColor redColor];
     labelGift.textAlignment = NSTextAlignmentCenter;
     [viewLeft addSubview:labelGift];
     ///
     [self.scoreScrollView addSubview:viewLeft];
     
     
     UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(320.0f, 0, 320.0f, 385.0f)];
     backgroundImageView = [[UIImageView alloc] initWithFrame:viewLeft.frame];
     backgroundImageView.image = [UIImage imageNamed:@"score_tag.png"];
     [viewRight addSubview:backgroundImageView];
     ///
     UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80.0f, 320.0f, 30.0f)];
     label5.text = @"积分排行榜";
     label5.font = [UIFont boldSystemFontOfSize:25.0f];
     label5.textColor = [UIColor whiteColor];
     label5.textAlignment = NSTextAlignmentCenter;
     [viewRight addSubview:label5];
     
     UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 110.0f, 320.0f, 30.0f)];
     label6.text = @"您的积分排名: 第4名";
     label6.font = [UIFont boldSystemFontOfSize:18.0f];
     label6.textColor = [UIColor whiteColor];
     label6.textAlignment = NSTextAlignmentCenter;
     [viewRight addSubview:label6];
     
     UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 280.0f, 320.0f, 30.0f)];
     label7.text = @"还需要加油哟!";
     label7.font = [UIFont boldSystemFontOfSize:20.0f];
     label7.textColor = [UIColor whiteColor];
     label7.textAlignment = NSTextAlignmentCenter;
     [viewRight addSubview:label7];
     
     self.rankingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140.0f, 320.0f, 140.0f) style:UITableViewStylePlain];
     self.rankingTableView.dataSource = self;
     self.rankingTableView.delegate = self;
     self.rankingTableView.backgroundColor = [UIColor clearColor];
     self.rankingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     
     [viewRight addSubview:self.rankingTableView];
     [self.rankingTableView reloadData];
     ///
     [self.scoreScrollView addSubview:viewRight];
     
     //self.scoreScrollView.contentSize = CGSizeMake(640.0f, 385.0f);
     self.scoreScrollView.contentSize = CGSizeMake(320.0f, 385.0f);
     self.scoreScrollView.pagingEnabled = YES;
     self.scoreScrollView.bounces = NO;
     
     self.scorePageControl.currentPage = 0;
     
     */
    self.scoreScrollView.contentSize = CGSizeMake(640.0f, 385.0f);
    self.scoreScrollView.pagingEnabled = YES;
    self.scoreScrollView.bounces = NO;
    self.scorePageControl.currentPage = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *score = @"score_cell_id";
    ScoreRankCell *cell = [tableView dequeueReusableCellWithIdentifier:score];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉点击时蓝色高亮
    cell.label_Name.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:9.0f];
    cell.label_score.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:9.0f];
    // cell.label_jifen.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:8.0f];
    NSDictionary *dic = [self.articles objectAtIndex:indexPath.row];
    
    cell.label_Name.text = [dic objectForKey:@"username"];
    cell.label_score.text = [NSString stringWithFormat:@"%@  积分",[dic objectForKey:@"integral"]];
    
    cell.backgroundColor = [UIColor clearColor];
    
    if ([cell.label_Name.text isEqualToString:userName]) {
        cell.image_Left.hidden = NO;
        cell.image_right.hidden = NO;
        cell.label_Name.textColor = [UIColor colorWithRed:225.0f/225.0f green:223/225.0f blue:118/225.0f alpha:1];
        cell.label_score.textColor = [UIColor colorWithRed:225.0f/225.0f green:223/225.0f blue:118/225.0f alpha:1];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.scorePageControl.currentPage = page;
}


-(IBAction)btnClick:(UIButton *)sender
{
    switch (sender.tag ) {
        case 1:
         [self share:[self Screenshot]];
        default:
            break;
    }
}


//截图
-(UIImage *)Screenshot
{
    // UIGraphicsBeginImageContext(CGSizeMake(320, 480));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 480), YES, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(void)share:(UIImage *)image
{
    // NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"哎呀”口腔问答采用问答的游戏方式，配以幽默诙谐的背景和卡通元素，以通俗易懂的问答形式向广大用户推介了口腔各种常见病的医疗保健知识。http://www.whuss.com/"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK jpegImageWithImage:image quality:0.5]//[ShareSDK imageWithPath:imagePath]
                                                title:@"哎呀口腔问答"
                                                  url:@"http://www.whuss.com/"
                                          description:@"哎呀”口腔问答采用问答的游戏方式，配以幽默诙谐的背景和卡通元素，以通俗易懂的问答形式向广大用户推介了口腔各种常见病的医疗保健知识。"
                                            mediaType:SSPublishContentMediaTypeNews];//分享类型：文本，图片，视频，微信使用
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitScoreView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)playAgain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
