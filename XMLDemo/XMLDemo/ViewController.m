//
//  ViewController.m
//  XMLDemo
//
//  Created by qingyun on 15/11/13.
//  Copyright (c) 2015年 Sky-jay. All rights reserved.
//


/*
 GDataXMLNode第三方库添加方法：
 1、添加头文件搜索路径: Build Settings-－>Header Search Paths-－>"/usr/include/libxml2"
 2、用非ARC的方式编译GDataXMLNode.m文件: -fno-objc-arc
 3、链接libxml2.dylib该动态库: Build Phases－->Link Binary With Libraries-－>"libxml2.dylib"
 */


#import "ViewController.h"
#import "Model.h"
#import "GDataXMLNode.h"

@interface ViewController ()<NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *bookArray;
@property (nonatomic, strong) NSMutableArray *domBookArray;
@property (nonatomic, strong) Model *model;
@property (nonatomic, strong) NSString *tempString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubview];
}

//添加button
- (void)addSubview
{
    //添加SAX方法button
    UIButton *saxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saxBtn.frame = CGRectMake(100, 100, 175, 50);
    saxBtn.backgroundColor = [UIColor blueColor];
    [saxBtn setTitle:@"SAX" forState:UIControlStateNormal];
    [saxBtn addTarget:self action:@selector(saxBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saxBtn];
    //添加DOM方法button
    UIButton *domBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    domBtn.frame = CGRectMake(100, 200, 175, 50);
    domBtn.backgroundColor = [UIColor blueColor];
    [domBtn setTitle:@"DOM" forState:UIControlStateNormal];
    [domBtn addTarget:self action:@selector(domBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:domBtn];
}

#pragma mark - SAX方法解析XML
//button的点击事件实现
- (void)saxBtnAction
{
    //找到XML文件路径path
    NSString *xmlpath = [[NSBundle mainBundle] pathForResource:@"bookstore" ofType:@"xml"];
    //通过路径创建URL
    NSURL *xmlURL = [NSURL fileURLWithPath:xmlpath];
    
    //创建解析对象
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:xmlURL];
    //设置委托
    xmlParser.delegate = self;
    
    //开始解析 判断解析是否成功
    if (![xmlParser parse]) {
        NSLog(@"解析失败！");
    }
}

#pragma mark - NSXMLParserDelegate
//初始化存储对象数组
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //给bookArray分配内存空间
    _bookArray = [NSMutableArray array];
}

//解析开始标签的调用，初始化模型，将元素的属性存储到模型
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"book"])
    {
        //初始化模型
        _model = [Model new];
        _model.category = attributeDict[@"category"];
    }
    else if ([elementName isEqualToString:@"title"])
    {
        _model.lang = attributeDict[@"lang"];
    }
}

//找到内容，内容暂存在中间变量
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //内容赋值给中间变量
    _tempString = string;
}

//解析结束标签调用，给模型元素赋值
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"book"]) {
        [_bookArray addObject:_model];
    }else if (![elementName isEqualToString:@"bookstore"]){
        NSLog(@"--KEY>>%@--VALUE>>%@",elementName,_tempString);
        //KVC
        [_model setValue:_tempString forKey:elementName];
    }
}

//文档解析结束调用，输出结果个数
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"==Finish>>%ld",_bookArray.count);
}

//解析失败时调用
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"失败！");
}


#pragma mark - DOM方法解析XML

- (void)domBtnAction
{
    //获取XML文件路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    //将XML文件内容转换成Data数据
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    //将Data数据转换成DOM树对象
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:&error];
    //取出根元素
    GDataXMLElement *rootElement = [document rootElement];
    //取出book元素
    NSArray *domArray = [rootElement elementsForName:@"book"];
    
    _domBookArray = [NSMutableArray array];
    
    //元素转换成Model
    for (GDataXMLElement *element in domArray) {
        _model = [Model new];
        //取出属性
        _model.category = [[element attributeForName:@"category"] stringValue];
        //取出元素 title
        GDataXMLElement *titleElement = [element elementsForName:@"title"][0];
        //取出title及其属性lang
        _model.lang = [[titleElement attributeForName:@"lang"] stringValue];
        _model.title = [titleElement stringValue];
        //取出author
        GDataXMLElement *authorElement = [element elementsForName:@"author"][0];
        _model.author = [authorElement stringValue];
        //取出year
        _model.year = [[element elementsForName:@"year"][0] stringValue];
        //取出price
        _model.price = [[element elementsForName:@"price"][0] stringValue];
        //将Model添加到domBookArray
        [_domBookArray addObject:_model];
    }
    //打印结果
    NSLog(@"--DOM-->%ld",_domBookArray.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
