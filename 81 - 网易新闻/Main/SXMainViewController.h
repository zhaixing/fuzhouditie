//
//  SXMainViewController.h


#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"
@interface SXMainViewController : UIViewController <DropDownChooseDelegate,
                                                    DropDownChooseDataSource,
                                                    NSXMLParserDelegate,
                                                    UIAlertViewDelegate>{
    UIAlertView *remoteAlertView;
                                                        
}
@property (nonatomic) NSString *contentLabel;
@end
