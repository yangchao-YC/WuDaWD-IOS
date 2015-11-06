//
//  LoginViewController.m
//  wuda_oral
//
//  Created by 杨超 on 14-1-17.
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


//注册信息      MESSAGE
//String url = MESSAGE + 性别 + "&old="+年龄+"&position="+职业 +"&lang=en";


#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "UIViewController+HUD.h"
#import "MyASIHTTPRequest.h"
@interface LoginViewController ()
{
    int status ;  //区分是登录，注册，找回密码
    BOOL check ;
}

@property (nonatomic,retain) NSDictionary *articles ;
@property(nonatomic,strong)ASIHTTPRequest *request;
@property (nonatomic,strong)NSArray *wordArray;

@end

@implementation LoginViewController
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
   
   
    check = false;
    
    Lable_ForgetPwd = [[RTLabel alloc]initWithFrame:CGRectMake(230, 210, 42, 20)];
    Lable_ForgetPwd.textColor = [UIColor whiteColor];
    UIFont *Font_ForgetPwd = [UIFont fontWithName:@"ARIAL" size:10.0f];
    Lable_ForgetPwd.font = Font_ForgetPwd;
    
    [self.view addSubview:Lable_ForgetPwd];
    
    NSString *ForgetPwd = @"<u color=white>忘记密码</u>";
    Lable_ForgetPwd.text = ForgetPwd;
    
    Lable_ForgetPwd.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:9.0f];
    
    ForgetPwdBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    ForgetPwdBtn.frame = CGRectMake(230, 210, 42, 20);
    [ForgetPwdBtn addTarget:self action:@selector(pwdClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ForgetPwdBtn];
    
    
    
    //绑定委托
    self.Text_Pwd.delegate = self;
    self.Text_Regist_email.delegate = self;
    self.Text_Regist_name.delegate = self;
    self.Text_Regist_pwd1.delegate = self;
    self.Text_Regist_pwd2.delegate = self;
    self.Text_name.delegate = self;
    
    
    self.Text_Pwd.backgroundColor = [UIColor clearColor];
    self.Text_Regist_email.backgroundColor = [UIColor clearColor];
    self.Text_Regist_name.backgroundColor = [UIColor clearColor];
    self.Text_Regist_pwd1.backgroundColor = [UIColor clearColor];
    self.Text_Regist_pwd2.backgroundColor = [UIColor clearColor];
    self.Text_name.backgroundColor = [UIColor clearColor];
  //  self.Text_name.hidden = YES;
    
    
    //设置提示文字颜色
    UIColor *color = [UIColor whiteColor];
    self.Text_Pwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.Text_Regist_email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮箱" attributes:@{NSForegroundColorAttributeName: color}];
    self.Text_Regist_name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName: color}];
    self.Text_Regist_pwd1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.Text_Regist_pwd2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.Text_name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.Text_Pwd setSecureTextEntry:YES];//设置密码框
    [self.Text_Regist_pwd1 setSecureTextEntry:YES];//设置密码框
    [self.Text_Regist_pwd2 setSecureTextEntry:YES];//设置密码框
    
    
    self.Text_Pwd.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Text_Regist_email.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Text_Regist_name.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Text_Regist_pwd1.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Text_Regist_pwd2.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Text_name.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    
   
    
    self.Text_Age.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Text_sex.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Text_Word.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    
    self.two_ok_Btn.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.two_zhuce_Btn.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    
    self.Btn_jump.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    
    self.Text_Age.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"年龄" attributes:@{NSForegroundColorAttributeName: color}];
    self.Text_sex.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"性别" attributes:@{NSForegroundColorAttributeName: color}];
    self.Text_Word.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"职业" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    self.Button_Pwd.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Button_Login.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Button_Regist.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Button_Regist_regist.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    
    //点击键盘外区域关闭键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    
    NSArray *wordArray = [[NSArray alloc]initWithObjects:@"小学生",@"初中生",@"大学生",@"研究生",@"服务业",@"企业",@"公务员/事业单位",@"医疗卫生",@"教育",@"其他", nil];
    self.wordArray = wordArray;
    
    self.Label_UserName.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Label_Age.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Label_Email.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Label_Sex.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Label_Word.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Btn_Cut.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [user stringForKey:@"user"];
    
    if(userName.length !=0)//上次登陆成功则将登录框信息填充
    {
        Lable_ForgetPwd.hidden = YES;
        self.View_Login.hidden = YES;
        self.View_My.hidden = NO;
        
        self.Label_UserName.text = [NSString stringWithFormat:@"用户名:%@",userName];
        
        
       NSString *date = [NSString stringWithFormat:@"%@%@&lang=en",GETMESSAGE,userName];
        
        NSLog(@"%@",date);
        
        date = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *dateURL = [NSURL URLWithString:date];
        MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
        request.key = 2;
        request.delegate = self;
        [request startAsynchronous];
        
    }
    
    
    
    
}

//关闭键盘
- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.wordArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.wordArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.Text_Word.text = [self.wordArray objectAtIndex:row];
    self.Picker_Work.hidden = YES;
}

/*
    1:立即登录
    2:注册新用户
    3:立即注册
    4:确定（找回密码）
    9:注册信息登陆
    7:性别
    8:职业
    5:切换账号
 */

-(IBAction)BtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            [self ClickLogin];
            break;
        case 2:
            self.View_Login.hidden = YES;
            self.View_Regist.hidden = NO;
            Lable_ForgetPwd.hidden = YES;
            ForgetPwdBtn.hidden = YES;
            break;
        case 3:
            [self ClickRegist];
            break;
        case 4:
            [self ClickPwd];
            break;
        case 7:
            [self dialogSex];
            break;
        case 8:
            self.Picker_Work.hidden = NO;
            break;
        case 9:
            [self messageDate];
            break;
        case 5:
            self.View_My.hidden = YES;
            self.View_Login.hidden = NO;
            Lable_ForgetPwd.hidden = NO;
            break;
        case 10:
            [self pushView];
            break;
        default:
            break;
    }
}

-(void)dialogSex
{
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    [chooseImageSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.Text_sex.text = @"男";
            break;
        case 1:
            self.Text_sex.text = @"女";
            break;
        default:
            break;
    }
}


-(void)messageDate
{
    status = 9;
    NSString *age;
    NSString *sex;
    NSString *work;
    
    age = [self.Text_Age.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sex = [self.Text_sex.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    work = [self.Text_Word.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (age.length == 0 || sex.length == 0 || work.length == 0) {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"信息不能为空" content:nil key:2];
        alertView.clickDelegate = self;
        [alertView show];
    }
    else
    {
        NSString *date ;
        if ([sex isEqualToString:@"男"]) {
            sex = @"1";
        }
        else{
            sex = @"2";
        }
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
        
        date = [NSString stringWithFormat:@"%@%@&old=%@&position=%@%@%@&lang=en",MESSAGE,sex,age,work,USERNAME,myDelegate.userLogin];
        
        
        
        NSLog(@"我是注册资料：%@",date);
        
        date = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *dateURL = [NSURL URLWithString:date];
        MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
        request.key = 3;
        request.delegate = self;
        [request startAsynchronous];
        
        
        
        /*
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
      //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager GET:date parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];*/
    }
    
}


/*数据交互
 key:值为------   1：进行登录。2：找回密码。3：注册    9：注册信息
 name:用户名
 pwd:密码
 email:邮箱
*/


-(void)date:(int)key Name:(NSString *)name Pwd:(NSString *)password  Email:(NSString *)email
{
    NSString *date ;
    status = key;//区分
   
    switch (key) {
        case 1:
            date = [NSString stringWithFormat:@"%@%@%@%@%@&lang=en",LOGIN,USERNAME,name,PASSWORD,password];
            break;
        case 2:
            date = [NSString stringWithFormat:@"%@%@%@%@%@%@%@&lang=en",PWD,USERNAME,name,PASSWORD,password,EMAIL,email];
            break;
        case 3:
            date = [NSString stringWithFormat:@"%@%@%@%@%@%@%@&lang=en",REGIST,USERNAME,name,PASSWORD,password,EMAIL,email];
            break;
        default:
            break;
    }
    date = [date stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *dateURL = [NSURL URLWithString:date];
    MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
    request.key = 1;
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    id rs = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
    
    
    MyASIHTTPRequest *MyASI = (MyASIHTTPRequest *) request;
    if (MyASI.key == 1) {
        self.articles = rs;
        [self dateEND];
    }
    else if(MyASI.key == 2)
    {
        self.articles = rs;
        [self showMessage];
    }
    
}
-(void)showMessage
{
    self.Label_Age.text = [NSString stringWithFormat:@" 年龄:%@",[self.articles objectForKey:@"old"]];
    self.Label_Email.text = [NSString stringWithFormat:@" 邮箱:%@",[self.articles objectForKey:@"email"]];
    
    if ([[self.articles objectForKey:@"sex"] isEqual:@"1"]) {
        self.Label_Sex.text = @" 性别:男";
    }
    else
    {
        self.Label_Sex.text = @" 性别:女";
    }
    self.Label_Word.text = [NSString stringWithFormat:@" 职业:%@",[self.articles objectForKey:@"position"]];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self removeHUDInfo];
    CustomAlertView * alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"连接失败" key:3];
    alertView.clickDelegate =self;
    [alertView show];
}

/*
 数据接收完毕处理
 */
-(void)dateEND
{
    [self removeHUDInfo];
    
    NSString *errorid = [NSString stringWithFormat:@"%@",[self.articles objectForKey:@"errorid"]];
    if ([errorid isEqualToString:@"1"]) {
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:self.Text_name.text forKey:@"user"];//存储账号到本地
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
        myDelegate.userLogin = self.Text_name.text;
        if (status == 3) {
            [self Message];
        }
        else
        {
            if (self.totleScore == NULL) {
                [self pushView];
            }
            else//返回积分页面
            {
                check = true;
                [self scorePush];
            }
        }
    }
    else
    {
        self.Text_name.text = NULL;
        self.Text_Pwd.text = NULL;
        CustomAlertView * alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:[self.articles objectForKey:@"error"] key:3];
        alertView.clickDelegate =self;
        [alertView show];
    }
    
}

//注册信息
-(void)Message
{
    self.View_Login.hidden = YES;
    self.View_Regist.hidden = NO;
    Lable_ForgetPwd.hidden = YES;
    ForgetPwdBtn.hidden = YES;
    self.Text_name.hidden = YES;
    self.View_Login.hidden = YES;
    self.View_Regist.hidden = YES;
    self.ageView.hidden = NO;
    
    
    
    
}



-(void)scorePush
{
    [self performSegueWithIdentifier:@"score" sender:[NSNumber numberWithInt:[self.totleScore intValue]]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.totleScore != NULL && check) {
        UIViewController *view = segue.destinationViewController;
        [view setValue:sender forKey:@"totleScore"];
    }
   
}

-(void)pushView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
 登录方法
 */

-(void)ClickLogin
{
    NSString *loginname;
    NSString *loginpwd;
    
    loginname = [self.Text_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    loginpwd = [self.Text_Pwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if (loginname.length == 0 || loginpwd.length == 0 ) {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"用户名或密码不能为空" content:nil key:2];
          alertView.clickDelegate = self;
           [alertView show];
    }
    else
    {
        [self showHUDInfo:@"正在登录..."];
        [self date:1 Name:loginname Pwd:loginpwd Email:nil];
    }
    
    
}
/*
 注册方法
 */
-(void)ClickRegist
{
    NSString *Registname;
    NSString *Registpwd;
    NSString *RegistPwdTwo;
    NSString *RegistEmail;
    
    Registname = [self.Text_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    Registpwd = [self.Text_Regist_pwd1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    RegistPwdTwo = [self.Text_Regist_pwd2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    RegistEmail = [self.Text_Regist_email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (Registname.length == 0 || Registpwd.length == 0 || RegistPwdTwo.length == 0 || RegistEmail.length == 0 )
    {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"信息不能为空" content:nil key:3];
        alertView.clickDelegate = self;
        [alertView show];
    }
    else
    {
        if ([ Registpwd isEqualToString:RegistPwdTwo]) {
            if ([self isValidateEmail:RegistEmail]!=1) {//返回值不为1则邮箱错误
                self.Text_Regist_email.text = NULL;
                CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"邮箱格式不正确！" key:3];
                alertView.clickDelegate = self;
                [alertView show];
            }
            else
            {
                [self showHUDInfo:@"正在注册..."];
                [self date:3 Name:Registname Pwd:Registpwd Email:RegistEmail];
            }
        }
        else
        {
            self.Text_Regist_pwd1.text = NULL;
            self.Text_Regist_pwd2.text = NULL;
            CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"您两次密码输入的不一样！" key:3];
            alertView.clickDelegate = self;
            [alertView show];

        }
        
    }
    
    
}

/*
 忘记密码方法
 */
-(void)ClickPwd
{
    NSString *Pwdname;
    NSString *Pwdpwd;
    NSString *PwdPwdTwo;
    NSString *PwdEmail;
    
    Pwdname = [self.Text_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    Pwdpwd = [self.Text_Regist_pwd1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    PwdPwdTwo = [self.Text_Regist_pwd2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    PwdEmail = [self.Text_Regist_email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (Pwdname.length == 0 || Pwdpwd.length == 0 || PwdPwdTwo.length == 0 || PwdEmail.length == 0 )
    {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"信息不能为空" content:nil key:3];
        alertView.clickDelegate = self;
        [alertView show];
    }
    else
    {
        if ([ Pwdpwd isEqualToString:PwdPwdTwo]) {
            if ([self isValidateEmail:PwdEmail]!=1) {
                self.Text_Regist_email.text = NULL;
                CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"邮箱格式不正确！" key:3];                alertView.clickDelegate = self;
                [alertView show];
            }
            else
            {
                [self showHUDInfo:@"正在找回..."];
                [self date:2 Name:Pwdname Pwd:Pwdpwd Email:PwdEmail];
            }
        }
        else
        {
            self.Text_Regist_pwd1.text = NULL;
            self.Text_Regist_pwd2.text = NULL;
            CustomAlertView *alertView = [[CustomAlertView alloc]initWithView:self.view title:@"出问题啦!" content:@"您两次密码输入的不一样！" key:3];
            alertView.clickDelegate = self;
            [alertView show];
        }
    }
    
}


-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


-(void)CustomClickButton:(UIButton *)button alertView:(CustomAlertView *)alertView
{
    [alertView hide];
}
//忘记密码事件

-(IBAction)pwdClick
{
    UIColor *color = [UIColor whiteColor];
    
    self.View_Login.hidden = YES;
    self.View_Regist.hidden = NO;
    Lable_ForgetPwd.hidden = YES;
    self.Image_Regist_imageBg.image = [UIImage imageNamed:@"password"];
    self.Text_Regist_pwd1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName: color}];
    ForgetPwdBtn.hidden = YES;
    self.Button_Regist_regist.hidden = YES;
    self.Button_Pwd.hidden = NO;
    
    
}

 //开始编辑输入框的时候，软键盘出现，执行此事件

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y +32 - (self.view.frame.size.height - 216.0);
  //  NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}



//设置用户名只能输入数字并且不能大于11位字符长度
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    // Check for non-numeric characters
    if (textField == self.Text_Age) {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 3) return NO;//限制长度
        return YES;
    }
    else
    {
        return YES;
    }
}



//当用户按下return键或者按回车键，键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
