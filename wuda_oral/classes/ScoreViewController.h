//
//  ScoreViewController.h
//  wuda_oral
//
//  Created by jijeMac2 on 13-12-16.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MyASIHTTPRequest.h"
#import "CustomAlertView.h"
@interface ScoreViewController : UIViewController<ASIHTTPRequestDelegate,CustomAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scoreScrollView;
@property (weak, nonatomic) IBOutlet UILabel *label_fraction;
@property (weak, nonatomic) IBOutlet UIImageView *image_bg;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UIButton *btn_start;
@property (weak, nonatomic) IBOutlet UIButton *btn_points;
@property (weak, nonatomic) IBOutlet UIButton *btn_share;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPageControl *scorePageControl;
@property (weak, nonatomic) IBOutlet UILabel *label_rank_title;
@property (weak, nonatomic) IBOutlet UILabel *label_rank_rank;
@property (weak, nonatomic) IBOutlet UILabel *label_rank_point;
@property (strong, nonatomic) NSNumber *totleScore;
- (IBAction)exitScoreView:(id)sender;
- (IBAction)playAgain:(id)sender;
@end
