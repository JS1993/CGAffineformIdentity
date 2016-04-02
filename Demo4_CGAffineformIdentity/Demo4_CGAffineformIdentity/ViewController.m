//
//  ViewController.m
//  Demo4_CGAffineformIdentity
//
//  Created by  江苏 on 16/2/29.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation ViewController
-(void)relocation{
    float scaleX=self.view.frame.size.width/self.imageView.bounds.size.width;
    float scaleY=self.view.frame.size.height/self.imageView.bounds.size.height;
    float scale=scaleX<scaleY?scaleX:scaleY;
    self.imageView.transform=CGAffineTransformMakeScale(scale, scale);//前面一个scale是宽，后面是高，当宽和高缩小相同比例，即锁定宽高比
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.新建一个imageView
    self.imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Elephant.jpg"]];
    //[self.view addSubview:imageView];
    //2.将ImageView放在中间
    self.imageView.center=self.view.center;
    //3.修改transform属性，使图片锁定宽高比最大显示在视图内
    [self relocation];
    //打开用户交互(很重要)
    self.imageView.userInteractionEnabled=YES;
    //4.添加旋转手势
    UIRotationGestureRecognizer* rotationGR=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    [self.imageView addGestureRecognizer:rotationGR];
    rotationGR.delegate=self;
    //5.添加缩放手势
    UIPinchGestureRecognizer* pinchGR=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [self.imageView addGestureRecognizer:pinchGR];
    pinchGR.delegate=self;
    //6.添加移动手势
    UIPanGestureRecognizer* panGr=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:panGr];
    //panGr.delegate=self;
    //7.添加tap手势，双击回到第三步
    UITapGestureRecognizer* tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapGR.numberOfTapsRequired=2;
    [self.imageView addGestureRecognizer:tapGR];
    [self.view addSubview:self.imageView];
}
-(void)rotation:(UIRotationGestureRecognizer*)gr {
    self.imageView.transform=CGAffineTransformRotate(self.imageView.transform, gr.rotation);
    gr.rotation=0;
}
-(void)pinch:(UIPinchGestureRecognizer*)gr{
    self.imageView.transform=CGAffineTransformScale(self.imageView.transform, gr.scale, gr.scale);
    gr.scale=1;
}
-(void)pan:(UIPanGestureRecognizer*)gr{
//    CGPoint point=[gr locationInView:self.imageView];
//    self.imageView.transform=CGAffineTransformTranslate(self.imageView.transform, point.x, point.y);
//    [gr setTranslation:CGPointZero inView:self.imageView];
    CGPoint p = [gr translationInView:self.imageView];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, p.x, p.y);
    [gr setTranslation:CGPointZero inView:self.imageView];
}
-(void)tap:(UITapGestureRecognizer*)tap{
    [self relocation];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]&&[otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return YES;
    }else if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]&&[otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return YES;
    }else{
        return NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
