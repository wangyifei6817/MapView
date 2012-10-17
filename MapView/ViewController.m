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
    myMap.showsUserLocation = YES;
    //loacation
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    //设置CLLocationManager实例委托和精度
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //设置距离筛选器，表示至少移动100米才通知委托更新
    [locationManager setDistanceFilter:100.f];
    
    //启动更新请求
    //    [locationManager startUpdatingLocation];
    locations = [[NSMutableArray alloc] init];
    float latitude = 39.8127;    //维度
    float longitude = 116.2967;  //经度
    for (int i = 0; i < 10; i++) {
        
        [locations addObject:[NSString stringWithFormat:@"%f,%f", latitude + 0.01*(i%3), longitude + 0.01*i]];
        //            NSLog(@"locations:%i",locations.count);
    }
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
//    [myMap addAnnotation:pointAnnotation];
    //设置地图长按时间
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
    [myMap addGestureRecognizer:lpress];
    [lpress release];
    [myMap addOverlay:[self makePolylineWithLocations:locations]]; 
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
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{

    switch (newState) {
        case MKAnnotationViewDragStateNone:
            NSLog(@"new state: MKAnnotationViewDragStateNone");
            break;
        case MKAnnotationViewDragStateStarting:
            NSLog(@"new state: MKAnnotationViewDragStateStarting");
            break;
        case MKAnnotationViewDragStateDragging:
            NSLog(@"new state: MKAnnotationViewDragStateDragging");
            break;
        case MKAnnotationViewDragStateCanceling:
            NSLog(@"new state: MKAnnotationViewDragStateCanceling");
            break;
        case MKAnnotationViewDragStateEnding:
            NSLog(@"new state: MKAnnotationViewDragStateEnding");
            break;
            
        default:
            break;
    }
    switch (oldState) {
        case MKAnnotationViewDragStateNone:
            NSLog(@"oldState: MKAnnotationViewDragStateNone");
            break;
        case MKAnnotationViewDragStateStarting:
            NSLog(@"oldState: MKAnnotationViewDragStateStarting");
            break;
        case MKAnnotationViewDragStateDragging:
            NSLog(@"oldState: MKAnnotationViewDragStateDragging");
            break;
        case MKAnnotationViewDragStateCanceling:
            NSLog(@"oldState: MKAnnotationViewDragStateCanceling");
            break;
        case MKAnnotationViewDragStateEnding:
            NSLog(@"oldState: MKAnnotationViewDragStateEnding");
            break;
            
        default:
            break;
    }
    //能够获得标注的起始位置
    MKPointAnnotation *currentAnnotation = (MKPointAnnotation *)view.annotation;
    currentPin = currentAnnotation.title;
    NSLog(@"annotationView.annotation %f,%f",currentAnnotation.coordinate.latitude,currentAnnotation.coordinate.longitude);
    
}


/**********************************************
 函数名称 : viewForAnnotation
 函数描述 : 在地图上加入大头针，及其动画。
 输入参数 : mapView，theMapView，annotation。
 输出参数 : N/A
 返回值	: N/A
 *********************************************/
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation{
    
    //详细属性介绍看MKPinAnnotationView
    static NSString *AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView *customPinView = (MKPinAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    //初始化大头针对象
    if (!customPinView) {
        customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
        customPinView.draggable = YES;//设置大头针可以拖动
        customPinView.pinColor = MKPinAnnotationColorPurple;//设置大头针的颜色
        customPinView.animatesDrop = NO;                //坠落动画
        customPinView.canShowCallout = YES;              //显示简介详情
//        customPinView.centerOffset = CGPointMake(10, 10);//设置大头针偏移
        //添加导航按钮 设置按钮样式
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
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:@"添加足迹"
                                                     otherButtonTitles:@"分享",@"详细",@"删除", nil];
    [actionSheet setDelegate:self];
    [actionSheet showInView:self.view];
    [actionSheet release];
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

    NSLog(@"%@",currentPin);
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
    NSLog(@" map span changed or map draged");
}

//根据坐标点生成线路
- (MKPolyline *)makePolylineWithLocations:(NSMutableArray *)newLocations{
    MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D)* newLocations.count);
    for(int i = 0; i < newLocations.count; i++)
    {
        // break the string down even further to latitude and longitude fields.
        NSString* currentPointString = [newLocations objectAtIndex:i];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
        //        NSLog(@"latitude-> %f", latitude);
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        //        NSLog(@"point-> %f", point.x);
        
//        if (i == 0 || i == locations.count - 1) {//这里只添加起点和终点作为测试
            MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
            [ann setCoordinate:coordinate];
            [ann setTitle:[NSString stringWithFormat:@"纬度:%f", latitude]];
            [ann setSubtitle:[NSString stringWithFormat:@"经度:%f", longitude]];
            [myMap addAnnotation:ann];
//        }
        pointArray[i] = MKMapPointForCoordinate(coordinate);
    }

    routeLine = [MKPolyline polylineWithPoints:pointArray count:newLocations.count];
    free(pointArray);
    return routeLine;
}
#pragma mark-
#pragma CLLocationManager delegate method
//位置变化后会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //可在此处更新用户位置信息
    //    cloMapView.userLocation
    NSLog(@"oldLocation:%@", [oldLocation description]);
    NSLog(@"newLocation:%@", [newLocation description]);
    NSLog(@"distance:%f", [newLocation distanceFromLocation:oldLocation]);
    //位置变化添加新位置点
    [locations addObject:[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
    //删除进线路，更新新轨迹
    [myMap removeOverlay:routeLine];
    [myMap addOverlay:[self makePolylineWithLocations:locations]];
    
}
//画线
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    NSLog(@"return overLayView...");
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *routeLineView = [[[MKPolylineView alloc] initWithPolyline:routeLine] autorelease];
        routeLineView.strokeColor = [UIColor blueColor];
        routeLineView.fillColor = [UIColor redColor];
        routeLineView.lineWidth = 10;
        return routeLineView;
    }
    return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
