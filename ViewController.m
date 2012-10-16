//
//  ViewController.m
//  MapView
//
//  Created by wangyifei on 12-10-15.
//  Copyright (c) 2012年 wangyifei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor redColor]];
    myMap = [[MKMapView alloc]initWithFrame:self.view.bounds];
    myMap.delegate = self;
    //设置经纬度
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude  = 39.943593;
    theCoordinate.longitude = 116.326466;
    //设置跨度
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.01;
    theSpan.longitudeDelta=0.01;
    //设置显示区域
    MKCoordinateRegion theRegion;
    theRegion.center=theCoordinate;
    theRegion.span=theSpan;
    //这事地图类型
    [myMap setMapType:MKMapTypeStandard];
    [myMap setRegion:theRegion animated:YES];
    //设置大头针
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = theCoordinate;
    [myMap addAnnotation:pointAnnotation];
    //设置地图长按时间
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
    [myMap addGestureRecognizer:lpress];
    [lpress release];
    [self.view addSubview:myMap];
    [myMap release];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        tagNum++;
        //取地图上的长按的点坐标
        CGPoint touchPoint = [gestureRecognizer locationInView:myMap];
        //将点坐标转换为经纬度坐标
        CLLocationCoordinate2D touchMapCoordinate =
        [myMap convertPoint:touchPoint toCoordinateFromView:myMap];
        NSLog(@"%@",NSStringFromCGPoint(touchPoint));
        NSLog(@"%f   %f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
        //初始化详情弹出框对象
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        //位置
        pointAnnotation.coordinate = touchMapCoordinate;
        //显示标题
        pointAnnotation.title = [NSString stringWithFormat:@"位置%d",tagNum];
        [myMap addAnnotation:pointAnnotation];
        [pointAnnotation release];
    }
}
/**********************************************
 函数名称 : viewForAnnotation
 函数描述 : 在地图上加入大头针，及其动画。
 输入参数 : mapView，theMapView，annotation。
 输出参数 : N/A
 返回值	: N/A
 *********************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation{
    /*
     定义中用到的标注属性
     image 标注图片
     pinColor 颜色//MKPinAnnotationColorRed ,MKPinAnnotationColorGreen,MKPinAnnotationColorPurple
     canShowCallout／／是否弹出
     animatesDrop／／落下动画
     centerOffset／／大头针偏移量
     annotationView.calloutOffset／／标注偏移量
     rightCalloutAccessoryView／／右边点击按钮
     leftCalloutAccessoryView／／左边点击按钮
     */
    static NSString *AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView *customPinView = (MKPinAnnotationView *)[mV
                                                                 dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    //初始化大头针对象
    if (!customPinView) {
        customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
        
        customPinView.pinColor = MKPinAnnotationColorPurple;//设置大头针的颜色
        customPinView.animatesDrop = YES;                //坠落动画
        customPinView.canShowCallout = YES;              //显示详情
        
        //添加导航按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
    }else{
        customPinView.annotation = annotation;
    }
    return customPinView;
}

- (void)showDetails:(UIButton*)sender
{
    NSLog(@"showDetails");
}

/**********************************************
 函数名称 : didSelectAnnotationView
 函数描述 : 点击大头针时调用此方法
 输入参数 : mapView，view。
 输出参数 : N/A
 返回值	: N/A
 *********************************************/
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //点击大头针时，取出其详情信息
    MKPointAnnotation *currentAnnotation = (MKPointAnnotation *)view.annotation;
    currentPin = currentAnnotation.title;
}
//拖动地图，改变地图比例时调用此方法
/**********************************************
 函数名称 : regionWillChangeAnimated
 函数描述 : 拖动地图，改变地图比例时调用此方法
 输入参数 : mapView，animated。
 输出参数 : N/A
 返回值	: N/A
 *********************************************/
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
