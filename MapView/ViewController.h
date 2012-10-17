//
//  ViewController.h
//  MapView
//
//  Created by wangyifei on 12-10-15.
//  Copyright (c) 2012年 wangyifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>{

    MKMapView *myMap;
    int tagNum;
    NSString *currentPin;
    NSMutableArray *locations;
    MKPolyline *routeLine;
}

@end
