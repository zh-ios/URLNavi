//
//  ViewController.m
//  URLNavi
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 aladdin-holdings.com. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
@interface ViewController ()<UIActionSheetDelegate>

@property (nonatomic,copy)NSString *appName;
@property (nonatomic,copy)NSString *urlScheme;

// 百度地图用的到 (可选)
@property (nonatomic,copy)NSString *toAddress;

@end

@implementation ViewController
{
    CLLocationCoordinate2D _toLacation;
    CLLocationCoordinate2D _myLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 120, self.view.frame.size.width - 30 * 2, 60)];
    
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"URL调用导航" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(go2Navi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.title = @"调用三方导航";
    
    self.appName = @"URLNavi";
    self.urlScheme = @"URLNavi";

    self.toAddress = @"天安门";
    
    _myLocation = CLLocationCoordinate2DMake(39.266666, 115.2888888);
    _toLacation = CLLocationCoordinate2DMake(39.299999, 116.2888888);
    
}

#pragma mark -- 具体及更多地图URL及配置参见各地图api文档
- (void)go2Navi:(UIButton *)btn {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择地图"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    //这个判断其实是不需要的,肯定有苹果地图.
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        [sheet addButtonWithTitle:@"苹果地图"];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [sheet addButtonWithTitle:@"百度地图"];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [sheet addButtonWithTitle:@"高德地图"];
    }
    
    [sheet showInView:self.view];

}

#pragma mark --actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"苹果地图"]) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_toLacation addressDictionary:nil]];
        
        toLocation.name = self.toAddress;
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
    } else if ([title isEqualToString:@"高德地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",self.appName,self.urlScheme,
                                _toLacation.latitude,
                                _toLacation.longitude]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    } else if ([title isEqualToString:@"百度地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=latlng:%f,%f|name:%@&mode=driving&src=dangdang://&coord_type=gcj02",
                                _myLocation.latitude,_myLocation.longitude,
                                _toLacation.latitude,
                                _toLacation.longitude,
                                self.toAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",urlString);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


@end
