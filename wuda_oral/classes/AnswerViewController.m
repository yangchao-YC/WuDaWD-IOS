//
//  AnswerViewController.m
//  wuda_oral
//
//  Created by 李迪 on 13-12-14.
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
 introduction  商品介绍
 id           商品id
 */

//积分兑换          REDEEM      上传参数：用户名，商品ID，姓名，电话，地址  username=？&lpid=？&integral=？&name=？&phone=？&address=？
//返回参数：errorid ，1 为修改成功，2为修改失败
#import "AnswerViewController.h"
#import "AnswerCell.h"
#import "FMDatabase.h"
#import "CustomAlertView.h"
@interface AnswerViewController ()<UITableViewDataSource,UITableViewDelegate,CustomAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *questionsArray;
@property(nonatomic,assign)int questionIndex;
@property(nonatomic,assign)int rightCount;
@end

@implementation AnswerViewController

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
    
    self.label_topic.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:15.0f];
    self.label_index.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:15.0f];
    self.answerTableView.bounces = NO;
    self.btn_confirm.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    if (IS_IPHONE_5) {
        self.image_answes.frame = CGRectMake(0, 0, 320, 568);
        self.image_answes.image = [UIImage imageNamed:@"answer_tag5.png"];
        self.label_index.frame = CGRectMake(25, 85, 100, 21);
        self.answerTableView.frame = CGRectMake(25, 318, 260, 125);
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initData];
    [self.answerTableView reloadData];
}

- (NSArray *)genertateRandomNumberStartNum:(int)startNum endNum:(int)endNum count:(int)count
{
    if (startNum > endNum) {
        return nil;
    }
    
    if (abs(endNum - startNum) < count) {
        return nil;
    }
    
    NSMutableArray * data = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i ++) {
        int x = (int)(startNum + (arc4random() % (endNum - startNum + 1)));
        //NSLog(@"x:%d",x);
        NSNumber * number = [NSNumber numberWithInt:x];
        if (![data containsObject:number]) {
            [data addObject:number];
        }else{
            i = i - 1; //发现有重复则-1
        }
    }
    
    //NSLog(@"data:%@",data);
    return (NSArray *)data;
}

- (void)initData
{
    self.questionIndex = 0;
    self.rightCount = 0;
    self.questionsArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:[DB_PATH stringByAppendingPathComponent:DB_NAME]];
    NSString *sqlStr = @"SELECT * FROM question ORDER BY RANDOM() limit 100";
    if ([db open])
    {
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            NSString *topic = [rs stringForColumn:@"topic"];
            NSString *rightAnswer = [rs stringForColumn:@"answer_a"];
            NSArray *wrongAnswers = @[[rs stringForColumn:@"answer_b"],
                                      [rs stringForColumn:@"answer_c"],
                                      [rs stringForColumn:@"answer_d"],
                                      [rs stringForColumn:@"answer_e"],
                                      [rs stringForColumn:@"answer_f"]
                                      ];
            
            NSMutableArray *answers = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
            
            int rightAnswerIndex = arc4random() % 4;
            [answers replaceObjectAtIndex:rightAnswerIndex withObject:rightAnswer];
            NSArray *wrongAnswerIndexs = [self genertateRandomNumberStartNum:0 endNum:4 count:3];
            
            int index = 0;
            for (int i=0; i<answers.count; i++) {
                if (i==rightAnswerIndex) {
                    continue;
                }
                else
                {
                    int wrongAnswerIndex = [[wrongAnswerIndexs objectAtIndex:index] intValue];
                    [answers replaceObjectAtIndex:i withObject:[wrongAnswers objectAtIndex:wrongAnswerIndex]];
                    index++;
                }
                
            }
            
            NSDictionary *dic = @{@"topic": topic,@"answers":answers,@"rightAnswerIndex":[NSNumber numberWithInt:rightAnswerIndex]};
            
            [self.questionsArray addObject:dic];
        }
        
    }
    
    NSDictionary *dic = [self.questionsArray objectAtIndex:self.questionIndex];
    self.label_topic.text = [dic objectForKey:@"topic"];
    self.label_index.text = [NSString stringWithFormat:@"%d/%d",self.questionIndex+1,self.questionsArray.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *answer_cell_id = @"answer_cell_id";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:answer_cell_id];
    
    NSDictionary *dic = [self.questionsArray objectAtIndex:self.questionIndex];
    NSArray *answers = [dic objectForKey:@"answers"];
    
    cell.label_content.text = [answers objectAtIndex:indexPath.row];
    cell.label_content.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:12.0f];
    switch (indexPath.row) {
        case 0:
            cell.label_index.text = @"A:";
            cell.image_index.image = [UIImage imageNamed:@"a.png"];
            
            break;
        case 1:
            cell.label_index.text = @"B:";
            cell.image_index.image = [UIImage imageNamed:@"b.png"];
            break;
        case 2:
            cell.label_index.text = @"C:";
            cell.image_index.image = [UIImage imageNamed:@"c.png"];
            break;
        case 3:
            cell.label_index.text = @"D:";
            cell.image_index.image = [UIImage imageNamed:@"d.png"];
            break;
        default:
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCell *cell = (AnswerCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.btn_confirm setTitle:[NSString stringWithFormat:@"%@ 确定",cell.label_index.text] forState:UIControlStateNormal];
    cell.imageView_selected.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCell *cell = (AnswerCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imageView_selected.hidden = YES;
}

- (IBAction)exitAnswer:(id)sender {
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithView:self.view
                                                                 title:@"退出游戏"
                                                               content:@"您是否真的要退出游戏，这样可能获得不了更多的积分哟！"
                                                                   key:1];
    alertView.clickDelegate = self;
    [alertView show];
    
}

- (void)CustomClickButton:(UIButton *)button alertView:(CustomAlertView *)alertView
{
    NSInteger tag = button.tag;
    
    [alertView hide];
    if (tag == 0) {
        [self performSegueWithIdentifier:@"score" sender:[NSNumber numberWithInt:self.rightCount]];
    }

    
}

- (IBAction)confirmAnswer:(id)sender {
    NSArray *selectedRows = [self.answerTableView indexPathsForSelectedRows];
    if (!selectedRows || !selectedRows.count) return;
    for (NSIndexPath *indexPath in selectedRows) {
        
        [self.answerTableView deselectRowAtIndexPath:indexPath animated:NO];
        
        AnswerCell *cell = (AnswerCell *)[self.answerTableView cellForRowAtIndexPath:indexPath];
        cell.imageView_selected.hidden = YES;
        
        int index = [[[self.questionsArray objectAtIndex:self.questionIndex] objectForKey:@"rightAnswerIndex"] intValue];
        //判断对错
        if (index == indexPath.row) {
            self.rightCount += 1;
            [self judge:0];
        }
        else
        {
            [self judge:1];
        }
    }
    
    if (self.questionIndex == self.questionsArray.count - 1) {
        [self performSegueWithIdentifier:@"score" sender:[NSNumber numberWithInt:self.rightCount]];
    }
    else
    {
        self.questionIndex = self.questionIndex + 1;
        [self.btn_confirm setTitle:@"请选择" forState:UIControlStateNormal];
        self.label_index.text = [NSString stringWithFormat:@"%d/%d",self.questionIndex+1,self.questionsArray.count];
        
        NSDictionary *dic = [self.questionsArray objectAtIndex:self.questionIndex];
        self.label_topic.text = [dic objectForKey:@"topic"];
        [self.answerTableView reloadData];
    }
    
}

-(void)judge:(int)key
{
    if (key == 0) {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"恭喜您答对了" content:nil key:2];
        alertView.clickDelegate = self;
        [alertView show];
    }
    else
    {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"很遗憾您答错了" content:nil key:2];
        alertView.clickDelegate = self;
        [alertView show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destinationController = segue.destinationViewController;
    //if ([destinationController respondsToSelector:@selector(setTotleScore:)]) {
        [destinationController setValue:sender forKey:@"totleScore"];
    //}
}
@end
