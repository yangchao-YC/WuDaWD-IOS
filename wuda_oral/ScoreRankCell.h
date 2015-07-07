//
//  ScoreRankCell.h
//  wuda_oral
//
//  Created by 杨超 on 14-1-27.
//
//

#import <UIKit/UIKit.h>

@interface ScoreRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_Left;
@property (weak, nonatomic) IBOutlet UILabel *label_Name;
@property (weak, nonatomic) IBOutlet UILabel *label_score;
@property (weak, nonatomic) IBOutlet UIImageView *image_right;
@property (weak, nonatomic) IBOutlet UILabel *label_jifen;

@end
