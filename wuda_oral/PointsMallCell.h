//
//  PointsMallCell.h
//  wuda_oral
//
//  Created by 杨超 on 14-1-13.
//
//

#import <UIKit/UIKit.h>

@interface PointsMallCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Points_Image;
@property (weak, nonatomic) IBOutlet UILabel *Points_Label_Title;
@property (weak, nonatomic) IBOutlet UILabel *Points_Label_Score;
@property (weak, nonatomic) IBOutlet UILabel *Points_Label_Content;
@property (weak, nonatomic) IBOutlet UIView *Points_Image_Line_BG;
@property (weak, nonatomic) IBOutlet UILabel *Label_id;
@property (weak, nonatomic) IBOutlet UIButton *Points_Button_Redeem;

@end
