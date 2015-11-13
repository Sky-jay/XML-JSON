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

@end

@implementation ViewController

#define baseurl @"http://www.kuaidi100.com/query?"

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)queryAction:(UIButton *)sender {
    //创建URL
    NSString *queryStr = [NSString stringWithFormat:@"type=%@&postid=%@",_companyTextField.text,_waybillTextField.text];
    NSString *string = [baseurl stringByAppendingString:queryStr];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:string] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            id object = [data objectFromJSONData];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSLog(@"--字典-->%@",object)
                ;            }
        }
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
