//
//  PointsMallViewController.h
//  wuda_oral
//
//  Created by jijeMac2 on 13-12-16.
//
//

#import <UIKit/UIKit.h>
#import "PointsAlertView.h"
#import "CustomAlertView.h"
#import "MyASIHTTPRequest.h"
#import "ASIHTTPRequest.h"
@interface PointsMallViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PointsAlertViewDelegate,ASIHTTPRequestDelegate,CustomAlertViewDelegate>
- (IBAction)pointsMallBack:(id)sender;
- (IBAction)buy:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UILabel *Label_Score;
@property (weak, nonatomic) IBOutlet UILabel *Label_1;
@property (weak, nonatomic) IBOutlet UIButton *Button_Back;


@end
