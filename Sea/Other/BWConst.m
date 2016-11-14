
#import <UIKit/UIKit.h>

//测试地址http://192.168.0.46/ZXPUBHWDNS/service/dns_service/dns_service.aspx http://192.168.0.48/ZXPUBHWDNS/service/dns_service/dns_service.aspx
//正式服务器 http://120.25.59.84/ZXPUBHWDNS/service/dns_service/dns_service.aspx
//通用网络请求地址
NSString *const BaseUrlString = @"http://120.25.59.84/ZXPUBHWDNS/service/dns_service/dns_service.aspx";

NSString *const NewBaseUrlString = @"http://120.25.72.243:8080/ZXDNS/service/dns_service/dns_service.aspx";

//from_system
NSString *const FromSystem = @"海燕微客互动平台(iOS)";

//yc_user_role
NSString *const UserRole = @"parent";

//学校id
NSString *const SchoolBaseString = @"&amp;school_id=";
NSString *SchoolId = nil;

//tabBar的高度
CGFloat const TabBarHeight = 49;

//默认间距
CGFloat const HBMargin = 10;

//默认小间距
CGFloat const HBSmallMargin = 5;

//导航条的最大y值
CGFloat const NavigationMaxY = 64;

NSString *const GeneralCsvKey = @"general_csv";

NSString *const AttrCsvKey = @"template_attr_csv";

NSString *const DataCsvKey = @"template_data_csv";

NSString *const PaperCsvKey = @"paper_csv_url";