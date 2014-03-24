//
//  AnswerCell.h
//  wuda_oral
//
//  Created by jijeMac2 on 13-12-16.
//
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet UILabel *label_index;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_selected;
@property (weak, nonatomic) IBOutlet UIImageView *image_index;

@end
