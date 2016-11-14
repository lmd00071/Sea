//
//  AppDelegate.h
//  SeaSwallowClassRoom
//
//  Created by 李明丹 on 16/1/18.
//  Copyright © 2016年 李明丹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTTPServer;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    HTTPServer *httpServer;
}

@property (strong, nonatomic) UIWindow *window;


@end

