//
//  CountDownViewController.h
//  WWDCC
//
//  Created by iDevZilla on 5/10/11.
//


#import <UIKit/UIKit.h>


@interface CountDownViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIProgressView *progressBar;
    UITableView *table;
    NSDate *wwdcDate;
    NSDate *announcementDate;
}

@end
