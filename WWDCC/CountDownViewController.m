//
//  CountDownViewController.m
//  WWDCC
//
//  Created by iDevZilla on 5/10/11.
//


#import "CountDownViewController.h"

#define WWDC_YEAR 2013
#define WWDC_MONTH 6
#define WWDC_DAY 10
#define WWDC_HOUR 10
#define WWDC_MINUTE 00
#define WWDC_SECOND 00

#define WWDC_ANNOUNCEMENT_DAY 24
#define WWDC_ANNOUNCEMENT_MONTH 4

#define SECTION_0_TITLE @"WWDC %i Countdown"
#define SECTION_1_TITLE @"Progress"

#define SECTION_0_FOOTER @"Assuming opening time: %i/%i/%i 10:00AM PST"
#define SECTION_1_FOOTER @"Difference between WWDC %i announcement and opening day"

#define COUNTDOWN_SECTION_ROWS_NUMBER 5

#define PST @"US/Pacific"

@interface CountDownViewController()

- (void)updateLabels;

@end

@implementation CountDownViewController

#pragma mark - Initialization Methods

- (id)init {
    self = [super init];
    if (self) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:WWDC_YEAR];
        [comps setMonth:WWDC_MONTH];
        [comps setDay:WWDC_DAY];
        [comps setHour:WWDC_HOUR];
        [comps setMinute:WWDC_MINUTE];
        [comps setSecond:WWDC_SECOND];
        
        [comps setTimeZone:[NSTimeZone timeZoneWithName:PST]];
        
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        wwdcDate = [cal dateFromComponents:comps];
        
        [comps setDay:WWDC_ANNOUNCEMENT_DAY];
        [comps setMonth:WWDC_ANNOUNCEMENT_MONTH];
        
        announcementDate = [cal dateFromComponents:comps];
        
    }
    
    return self;
}


#pragma mark - Memory Management



#pragma mark - View lifecycle

- (void)loadView {
    UIView *mainView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height - ( self.navigationController.navigationBar.frame.size.height + 20)) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;

    [mainView addSubview:table];
    
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
}

- (void)viewDidUnload {
    progressBar = nil;
    
    table = nil;
    
    [super viewDidUnload];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Internal Methods

- (void)updateLabels {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *wwdcDateComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                                                            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | 
                                                            NSTimeZoneCalendarUnit) fromDate:wwdcDate];
    [wwdcDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
        
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                                                    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | 
                                                    NSTimeZoneCalendarUnit) fromDate:wwdcDate toDate:[NSDate date] options:0];
    

    
    NSTimeInterval minValue = [wwdcDate timeIntervalSinceDate:announcementDate];
    NSTimeInterval currentInterval = [wwdcDate timeIntervalSinceDate:[NSDate date]];

    CGFloat result =  (currentInterval - minValue) / (1 - minValue);
    progressBar.progress = result;
    
    
    for (int indexCell = 0; indexCell < COUNTDOWN_SECTION_ROWS_NUMBER; indexCell++) {
        UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexCell inSection:0]];

        switch (indexCell) {
            case 0:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components month])];
                break;
            case 1:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components day])];
                break;
            case 2:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components hour])];
                break;
            case 3:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components minute])];
                break;
            case 4:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components second])];
                break;
        }
        [cell setNeedsLayout];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        numberOfRows = COUNTDOWN_SECTION_ROWS_NUMBER;
    } else {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if (indexPath.section == 0) {
        NSString *cellText = @"";
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:20];
        switch (indexPath.row) {
            case 0:
                cellText = @"Months";
                break;
            case 1:
                cellText = @"Days";
                break;
            case 2:
                cellText = @"Hours";
                break;
            case 3:
                cellText = @"Minutes";
                break;
            case 4:
                cellText = @"Seconds";
                break;
        }
        cell.textLabel.text = cellText;
    }
    else if (indexPath.section == 1) {
        progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressBar.frame = CGRectMake(0, 0, 280, 10);
        progressBar.center = cell.center;
        [cell addSubview:progressBar];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    
    if (section == 0) {
        title = [NSString stringWithFormat:SECTION_0_TITLE, WWDC_YEAR];
    } else {
        title = SECTION_1_TITLE;
        
    }
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footer = nil;
    if (section == 0) {
        footer = [NSString stringWithFormat:SECTION_0_FOOTER, WWDC_DAY, WWDC_MONTH, WWDC_YEAR];
    } else {
        footer = [NSString stringWithFormat:SECTION_1_FOOTER, WWDC_YEAR];

    }
    return footer;
}

@end
