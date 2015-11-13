//
//  Model.h
//  XMLDemo
//
//  Created by qingyun on 15/11/13.
//  Copyright (c) 2015年 Sky-jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *price;

@end
