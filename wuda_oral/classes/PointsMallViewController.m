//
//  PointsMallViewController.m
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
//返回参数： integral积分,ranking  排名

//商品列表          GOOD        上传参数：
/*返回参数：
 image       商品图片
 title         商品标题
 integral      商品所需积分
 introtext  商品介绍
 id           商品id
 */

//积分兑换          REDEEM      上传参数：用户名，商品ID，姓名，电话，地址  username=？&lpid=？&integral=？&name=？&phone=？&address=？
//返回参数：errorid ，1 为修改成功，2为修改失败



/*
 商品列表页面流程：
 1：获取登录帐号同时拉取列表，刷新列表
 
 2：未登陆情况弹出提示框，提示是否登录，确定	则跳转至login登录页面，取消则关闭对话框。
 登录则拉取积分数据显示
 
 3：点击按钮，判断是否登录，
 未登陆则弹出对话框，
 登录则判断当前积分是否满足兑换积分，不满足则弹框提示，满足则进行兑换弹框
 
 4：兑换完毕后委托事件通知列表兑换成功，刷新积分
 */


#import "PointsMallViewController.h"
#import "PointsMallCell.h"
#import "UIImageView+My.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIViewController+HUD.h"
@interface PointsMallViewController ()
{
    NSString *userName;
}

@property (nonatomic,retain) NSMutableArray *articles ;
@property(nonatomic,strong)ASIHTTPRequest *request;
@property(nonatomic,retain)NSDictionary * ScoreDIC;

@end

@implementation PointsMallViewController

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
    [self.TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.TableView.bounces = NO;
    self.TableView.backgroundColor = [UIColor colorWithRed:24.0f/255.0f green:36.0f/255.0f blue:57.0f/255.0f alpha:1];
    self.Button_Back.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:18.0f];
    self.Label_Score.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:24.0f];
    self.Label_1.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:15.0f];
    [self userCheck];
    [self dateURLTable];
}

//获取登录帐号
-(void)userCheck
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    userName = myDelegate.userLogin;
}

//拉取列表数据
-(void)dateURLTable
{
    [self showHUDInfo:@"正在加载数据"];
    
    NSString *date  = GOOD;
    NSURL *dateURL = [[NSURL alloc]initWithString:date];
    MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
    request.key = 1;
    [request setDelegate:self];
    [request startAsynchronous];
}
//拉取积分
-(void)dateURLScore
{
    NSString *date  = [NSString stringWithFormat:@"%@%@%@&lang=en",INTEGRAL,USERNAME,userName];
    date = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *dateURL = [[NSURL alloc]initWithString:date];
    MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
    request.key = 2;
    [request setDelegate:self];
    [request startAsynchronous];

    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [self removeHUDInfo];
    
    NSError *error;
    id rs = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
    
    
    MyASIHTTPRequest *MyASI = (MyASIHTTPRequest *) request;
    
    /*
     MyASI.key值：
     1：列表数据
     2：积分
     */
    switch (MyASI.key) {
        case 1:
            self.articles = rs;
            [self.TableView reloadData];
            if (userName == NULL) {
                [self LoginNo];
            }
            else
            {
                [self dateURLScore];
            }
            break;
        case 2:
            self.ScoreDIC = rs;
            self.Label_Score.text = [self.ScoreDIC objectForKey:@"integral"];
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

//未登陆提示框
-(void)LoginNo
{
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"您还没有登录，请点击确定登录。" key:1];
    alertView.clickDelegate = self;
    [alertView show];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *answer_cell_id = @"points_cell_id";
    PointsMallCell *cell = [tableView dequeueReusableCellWithIdentifier:answer_cell_id];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉点击时蓝色高亮
    
    NSDictionary * dic = [self.articles objectAtIndex:indexPath.row];
    
    cell.Points_Label_Title.text = [dic objectForKey:@"title"];
    cell.Points_Label_Score.text = [dic objectForKey:@"integral"];
    cell.Points_Label_Content.text = [dic objectForKey:@"introtext"];
    cell.Label_id.text = [dic objectForKey:@"id"];
    cell.Points_Image_Line_BG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_line.png"]];
    cell.Points_Button_Redeem.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:10.0f];
    [cell.Points_Image setImageByKeyAndURL:[dic objectForKey:@"imgurl"] withURL:[dic objectForKey:@"imgurl"]];
    
    return cell;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count ;//设置显示行数
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;//设置为只有一个模块
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}//设置模块内cell的高度


//设置cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//设置cell上面按钮的点击事件
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (userName == NULL) {
        [self LoginNo];
    }
    else
    {
        PointsMallCell *cell =(PointsMallCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.Label_Score.text intValue] -  [cell.Points_Label_Score.text intValue] >=0) {
            PointsAlertView *alertView = [[PointsAlertView alloc]initWithView:self.view key:1 title:cell.Points_Label_Title.text content:cell.Points_Label_Content.text image:cell.Points_Image.image Score:cell.Points_Label_Score.text ScoreSum:self.Label_Score.text ID:cell.Label_id.text];
            alertView.clickDelegate = self;
            [alertView show];
        }
        else
        {
            CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"您的积分不够" content:nil key:2];
            alertView.clickDelegate = self;
            [alertView show];
        }
    }
}

-(void)PointsClickButton:(UIButton *)button alertView:(PointsAlertView *)alertView
{
    [alertView hide];
     NSLog(@"%d",button.tag);

    switch (button.tag) {
        case 3:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 4:
            [self showHUDInfo:@"正在刷新!"];
            [self dateURLScore];
            break;
        default:
            break;
    }
}

-(void)CustomClickButton:(UIButton *)button alertView:(CustomAlertView *)alertView
{
    [alertView hide];
    
    if (button.tag == 0) {
        //LoginViewController *login = [[LoginViewController alloc]init];
        // [self.navigationController pushViewController:login animated:YES];
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

-(IBAction)tableBtnClick:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];//把触摸的事件放到集合里
    UITouch *touch = [touches anyObject];//把事件放到触摸的对象里
    
    CGPoint currentTouchPosition = [touch locationInView:self.TableView];//把触发的这个点转成二位坐标
    NSIndexPath *indexPath = [self.TableView indexPathForRowAtPoint:currentTouchPosition];//匹配坐标点
    if (indexPath != nil) {
        [self tableView:self.TableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pointsMallBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)buy:(id)sender {
}
@end
