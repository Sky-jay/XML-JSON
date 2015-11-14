//
//  ViewController.m
//  JSONDemo
//
//  Created by qingyun on 15/11/13.
//  Copyright (c) 2015年 Sky-jay. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *waybillTextField;
@property (weak, nonatomic) IBOutlet UILabel *companyShow;
@property (weak, nonatomic) IBOutlet UILabel *waybillShow;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation ViewController

#define baseurl @"http://www.kuaidi100.com/query?"
#define tempurl @"http://www.kuaidi100.com/query?type=zhongtong&postid=370771577426"

- (void)viewDidLoad {
    [super viewDidLoad];
    _companyShow.backgroundColor = [UIColor whiteColor];
    _waybillShow.backgroundColor = [UIColor whiteColor];
    _companyShow.layer.cornerRadius = 5;
    _companyShow.clipsToBounds = YES;
    _waybillShow.layer.cornerRadius = 5;
    _waybillShow.clipsToBounds = YES;
}

- (IBAction)queryAction:(UIButton *)sender {
    //创建URL
    NSString *queryStr = [NSString stringWithFormat:@"type=%@&postid=%@",_companyTextField.text,_waybillTextField.text];
    NSString *string = [baseurl stringByAppendingString:queryStr];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:tempurl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            id object = [data objectFromJSONData];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSLog(@"--字典-->%@",object);
                _dict = object;
            }
        }
    }];
    [task resume];
    [self infoShow];
}

- (void)infoShow
{
    NSLog(@"%@",_dict);
    _companyShow.text = _dict[@"com"];
    _waybillShow.text = _dict[@"nu"];
    if (_dict[@"data"]) {
        _textView.text = _dict[@"data"];
    }else{
        _textView.text = _dict[@"message"];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
