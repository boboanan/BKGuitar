//
//  BKImageShowController.m
//  BKTabBarView
//
//  Created by 锄禾日当午 on 15/8/16.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "BKImageShowController.h"
#import "BKTool.h"

@interface BKImageShowController ()

//照片scrollView
@property (nonatomic, weak)UIScrollView *scrollView;
@end

@implementation BKImageShowController

-(UIScrollView *)scrollView
{
    if(_scrollView == nil){
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏
    [self setNav];
    
}

//初始化
-(instancetype)initWithImagesArray:(NSArray *)images index:(NSInteger)index
{
    self = [super init];
    if (self) {
        [self setUpScrollViewWithImagesArray:images index:index];
    }
    return self;
}

+(instancetype)controllerInitWithImagesArray:(NSArray *)images index:(NSInteger)index
{
    return [[self alloc] initWithImagesArray:images index:index];
}

//初始化scrollView
-(void)setUpScrollViewWithImagesArray:(NSArray *)images index:(NSInteger)index
{
    
    CGFloat scrollW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollH = [UIScreen mainScreen].bounds.size.height;
    //创建一个scrollView，现实所有新特性图片
    self.scrollView.frame = CGRectMake(0, 0, scrollW, scrollH);
    
    for(int i = 0; i < images.count; i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        imageView.image = images[i];
        [self.scrollView addSubview:imageView];
       
    }
    [self.scrollView setContentOffset:CGPointMake(index * scrollW,0) animated:NO];
    //设置scollView的其他属性
    //如果想要某个方向不能滚动，这个方向尺寸数值传0即可
    self.scrollView.contentSize = CGSizeMake(images.count * scrollW, 0);
    self.scrollView.bounces = NO;//去除弹簧效果
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    

}

//设置导航栏
-(void)setNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancell)];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.width = 200;
    titleView.height = 44;
    titleView.textAlignment = NSTextAlignmentCenter;
    //自动换行
    titleView.numberOfLines = 0;
    titleView.text = @"照片 ";
    
    
    self.navigationItem.titleView = titleView;
}

-(void)cancell
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
