//
//  AnswerViewController.h
//  wuda_oral
//
//  Created by 李迪 on 13-12-14.
//
//

#import <UIKit/UIKit.h>

@interface AnswerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label_topic;
@property (strong, nonatomic) IBOutlet UITableView *answerTableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_confirm;
@property (weak, nonatomic) IBOutlet UILabel *label_index;
@property (weak, nonatomic) IBOutlet UIImageView *image_answes;




- (IBAction)exitAnswer:(id)sender;
- (IBAction)confirmAnswer:(id)sender;

@end
