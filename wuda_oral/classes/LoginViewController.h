//
//  LoginViewController.h
//  wuda_oral
//
//  Created by 杨超 on 14-1-17.
//
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CustomAlertView.h"
#import "ASIHTTPRequest.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,CustomAlertViewDelegate,ASIHTTPRequestDelegate>
{
    IBOutlet RTLabel *Lable_ForgetPwd;
    IBOutlet UIButton *ForgetPwdBtn;
}




@property (weak, nonatomic) IBOutlet UITextField *Text_name;//登录用户名输入
@property (weak, nonatomic) IBOutlet UITextField *Text_Pwd;//登录密码输入框
@property (weak, nonatomic) IBOutlet UIButton *Button_Login;//登录登录按钮
@property (weak, nonatomic) IBOutlet UIButton *Button_Regist;//登录注册按钮

@property (weak, nonatomic) IBOutlet UITextField *Text_Regist_name;//注册用户名输入框
@property (weak, nonatomic) IBOutlet UITextField *Text_Regist_pwd1;//注册第一次密码
@property (weak, nonatomic) IBOutlet UITextField *Text_Regist_pwd2;//注册第二次密码
@property (weak, nonatomic) IBOutlet UITextField *Text_Regist_email;//注册邮箱

@property (weak, nonatomic) IBOutlet UIButton *Button_Regist_regist;//注册新用户注册按钮
@property (weak, nonatomic) IBOutlet UIView *View_Login;//登录VIEW
@property (weak, nonatomic) IBOutlet UIView *View_Regist;//注册VIEW

@property (weak, nonatomic) IBOutlet UIImageView *Image_Regist_imageBg;//注册背景与找回密码背景图片
@property (weak, nonatomic) IBOutlet UIButton *Button_Pwd;//找回密码确定按钮
@property (strong, nonatomic) NSNumber *totleScore;
@end
