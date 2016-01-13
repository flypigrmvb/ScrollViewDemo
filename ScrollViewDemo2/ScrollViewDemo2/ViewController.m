//
//  ViewController.m
//  ScrollViewDemo2
//
//  Created by zytt on 16/1/12.
//  Copyright © 2016年 zyt. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *picsScrollView;

@property (nonatomic, strong) NSMutableArray *adShowImageArr;///<显示的数据

@property (nonatomic, strong) NSMutableArray *picShowImageArr;
@property (nonatomic, assign) int picCurIndex;
@property (nonatomic, strong) NSDictionary* showPaneDict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 原始数据
    NSArray* images = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    
    NSArray* webImages = @[@"http://www.adkungfu.com/attachment/userfiles/image/LYenewsletter/Newsletter116/Gold_Pencil.jpg",
                           @"http://kfzimg.kongfz.com/G01/M00/79/C9/o4YBAFQPGv2AXOJCAAIdUXz0jZ4439_b.jpg",
                           @"http://www.258sd.com/images/201103/1300679682863558318.JPG",
                           @"http://img.frbiz.com/nimg/bc/bc/2ee6d361e759332d7bab4df68bc4-0x0-1/4_channel_mobile_viewing_nvr_kits_p2p_wifi_four_720p_ip_cameras.jpg",
                           @"http://c767204.r4.cf2.rackcdn.com/b9b79c21-da1e-4e13-b044-9f650333ad4f.jpeg",
                           @"http://www.cardesigner.com.cn/upload_files/article/65/1_20130103220148_0fk7d.jpg",
                           @"http://img.25pp.com/uploadfile/soft/images/2015/0606/20150606103214951.jpg",
                           @"http://pic2.nipic.com/20090427/2458792_160812092_2.jpg",
                           @"http://f.hiphotos.baidu.com/zhidao/pic/item/562c11dfa9ec8a13966753cff303918fa0ecc0a4.jpg"];
    
    // 第一种方式实现的循环滚动
    [self setupAdScrollView:webImages];
    
    // 第二种方式实现的循环滚动
    [self setupPicsScrollView:webImages];
}

-(void)setupAdScrollView:(NSArray*)images{
    // 在原始数据基础上添加头尾数据
    NSMutableArray* tempImages = [NSMutableArray array];
    [tempImages addObject:[images lastObject]];
    [tempImages addObjectsFromArray:images];
    [tempImages addObject:[images firstObject]];
    
    images = tempImages;
    _adShowImageArr = tempImages;
    
    _adScrollView.pagingEnabled = YES;
    _adScrollView.delegate = self;
    _adScrollView.showsHorizontalScrollIndicator = NO;
    _adScrollView.showsVerticalScrollIndicator = NO;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i<images.count; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(width*i, 0, width, 160);
        // imageView.image = [UIImage imageNamed:images[i]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        [_adScrollView addSubview:imageView];
    }
    
    _adScrollView.contentSize = CGSizeMake(images.count*width, 160);
    
    // 跳转到第一张的位置
    _adScrollView.contentOffset = CGPointMake(width, 0);

}

/**
 *  使用三张图达到滚动效果
 */
-(void)setupPicsScrollView:(NSArray*)images {
    
    // 数据
    _picShowImageArr = [images mutableCopy];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIImageView* lImageView = [[UIImageView alloc] init];
    lImageView.frame = CGRectMake(0, 0, width, 160);
    
    UIImageView* cImageView = [[UIImageView alloc] init];
    cImageView.frame = CGRectMake(width, 0, width, 160);
    
    UIImageView* rImageView = [[UIImageView alloc] init];
    rImageView.frame = CGRectMake(width*2, 0, width, 160);
    
    NSDictionary* showPaneDict = @{@"L":lImageView,
                           @"C":cImageView,
                           @"R":rImageView};
    self.showPaneDict = showPaneDict;
    
    // UI
    _picsScrollView.pagingEnabled = YES;
    _picsScrollView.delegate = self;
    _picsScrollView.showsHorizontalScrollIndicator = NO;
    _picsScrollView.showsVerticalScrollIndicator = NO;
    
    [_picsScrollView addSubview:lImageView];
    [_picsScrollView addSubview:cImageView];
    [_picsScrollView addSubview:rImageView];

    _picsScrollView.contentSize = CGSizeMake(_picShowImageArr.count*width, 160);
    // 跳转到第一张的位置
    _picsScrollView.contentOffset = CGPointMake(width, 0);
    
    // 初始化设置
    [self setupPics];
}

/**
 *  设置一组图片
 */
-(void)setupPics{
    
    NSString* lImage;
    NSString* cImage;
    NSString* rImage;
    
    // 头部
    if (_picCurIndex == 0) {
        // 计算右边的值，左边的值是最后一个
        if (_picShowImageArr.count == 1) {
            rImage = [_picShowImageArr firstObject];
        }else {
            rImage = _picShowImageArr[_picCurIndex+1];
        }
        lImage = [_picShowImageArr lastObject];
        cImage = _picShowImageArr[_picCurIndex];
    }
    // 尾部
    else if (_picCurIndex == _picShowImageArr.count - 1){
        // 计算左边的值，右边的值是第一个
        if (_picShowImageArr.count == 1) {
            lImage = [_picShowImageArr firstObject];
        }else {
            lImage = _picShowImageArr[_picCurIndex-1];
        }
        rImage = [_picShowImageArr firstObject];
        cImage = _picShowImageArr[_picCurIndex];
    }
    // 中间
    else {
        // 正常计算左右两边的值
        lImage = _picShowImageArr[_picCurIndex-1];
        rImage = _picShowImageArr[_picCurIndex+1];
        cImage = _picShowImageArr[_picCurIndex];
    }
    
    // 设置显示图片
    UIImageView* lImageView = _showPaneDict[@"L"];
    UIImageView* cImageView = _showPaneDict[@"C"];
    UIImageView* rImageView = _showPaneDict[@"R"];
    
    [lImageView sd_setImageWithURL:[NSURL URLWithString:lImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [cImageView sd_setImageWithURL:[NSURL URLWithString:cImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [rImageView sd_setImageWithURL:[NSURL URLWithString:rImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
//    
//    lImageView.image = [UIImage imageNamed:lImage];
//    cImageView.image = [UIImage imageNamed:cImage];
//    rImageView.image = [UIImage imageNamed:rImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _adScrollView) {
        // 第一种方式
        CGFloat x = scrollView.contentOffset.x;
        NSLog(@"contentOffset.x:%f", x);
        
        CGFloat width = scrollView.frame.size.width;
        
        if (x<=0) {
            // 跳到最后一张
            [scrollView setContentOffset:CGPointMake((_adShowImageArr.count - 2)*width, 0) animated:NO];
        }else if(x>=(_adShowImageArr.count - 1)*width){
            // 跳到第一张
            [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        }
        
        
    }else if(scrollView == _picsScrollView) {
        // 第二种方式
        
    }
}

/**
 *  第二种方式，使用三张达到循环滚动的效果
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView == _picsScrollView) {
        // 第二种方式
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat x = scrollView.contentOffset.x;
        NSLog(@"scrollViewDidEndDecelerating  contentOffset.x:%f", x);
        
        int tempIndex = _picCurIndex + x/width - 1;
        if (tempIndex <0) {
            tempIndex = _picShowImageArr.count - 1;
        }
        if (tempIndex>=_picShowImageArr.count) {
            tempIndex = 0;
        }
        if (tempIndex != _picCurIndex) {
            _picCurIndex = tempIndex;
            [self setupPics];
            [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        }
    }
}

@end
