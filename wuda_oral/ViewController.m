//
//  ViewController.m
//  wuda_oral
//
//  Created by 李迪 on 13-12-14.
//
//

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPHONE_5) {
        self.image_bg.frame = CGRectMake(0, 40, 320, 385);
    }
    
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
    [self initDB];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointMall) name:@"pointModel" object:nil];
    self.btn_start.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:16.0f];
    self.Button_Push_Login.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
    self.Button_Push_Pints.titleLabel.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:13.0f];
}

- (void)initDB
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[DB_PATH stringByAppendingPathComponent:DB_NAME]]) {
        FMDatabase *db = [FMDatabase databaseWithPath:[DB_PATH stringByAppendingPathComponent:DB_NAME]];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wuda_oral" ofType:@"sql" ];
        NSError *error;
        NSString *sqlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSArray *sqls = [sqlStr componentsSeparatedByString:@";"];
        if ([db open])
        {
            [db beginTransaction];
            for (int i=0; i<sqls.count; i++) {
                [db executeUpdate:[sqls objectAtIndex:i]];
            }
            [db commit];
        }
    };
}

- (void)pointMall
{
    [self performSegueWithIdentifier:@"point" sender:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pointModel" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
