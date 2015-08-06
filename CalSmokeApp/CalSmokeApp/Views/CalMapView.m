#import "CalMapView.h"
#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>

static CLLocationDegrees const CalLosAngelesLatitude = 34.050;
static CLLocationDegrees const CalLosAngelesLongitude = -118.25;

@interface MKMapView (Calabash)
- (CLLocationCoordinate2D) setCenterToLat:(double) lat lon:(double) lon;
@end

@implementation MKMapView (Calabash)

- (CLLocationCoordinate2D) setCenterToLat:(double) lat lon:(double) lon {
  CLLocationCoordinate2D coordinate = (CLLocationCoordinate2D) {lat, lon};
  [self setCenterCoordinate:coordinate animated:NO];
  return coordinate;
}
@end

@interface CalMapView (Calabash)
- (NSDictionary *) JSONRepresentationOfCurrentLocation;
@end

@implementation CalMapView (Calabash)

- (NSDictionary *) JSONRepresentationOfCurrentLocation {
  CLLocation *location = self.lastLocation;
  if (!location) { return nil; }

  CLLocationCoordinate2D coordinate = location.coordinate;
  NSDictionary *dict = @{@"latitude" : @(coordinate.latitude),
                         @"longitude" : @(coordinate.longitude)};
  return dict;
}

@end

@interface CalMapView () <CLLocationManagerDelegate>
@property(nonatomic) BOOL firstLocationUpdate;
@property NSMutableDictionary *markers;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation* lastLocation;
@end

@implementation CalMapView

- (void) awakeFromNib {

  self.markers = [[NSMutableDictionary alloc] init];

  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.distanceFilter = kCLDistanceFilterNone;


  SEL authorizationSelector = @selector(requestWhenInUseAuthorization);
  if ([self.locationManager respondsToSelector:authorizationSelector]) {
    [self.locationManager requestWhenInUseAuthorization];
  } else {
    if ([CLLocationManager locationServicesEnabled]) {
      [self.locationManager startUpdatingLocation];
      self.showsUserLocation = YES;
    }
  }

  //Initialize map pane on Los Angeles lat/lon
  CLLocationDegrees longitude = CalLosAngelesLongitude;
  CLLocationDegrees latitude = CalLosAngelesLatitude;
  CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(latitude, longitude);
  MKCoordinateRegion initialRegion = MKCoordinateRegionMakeWithDistance(startCoord, 10000.0, 10000.0);
  self.centerCoordinate = startCoord;
  [self setRegion:initialRegion];
  self.accessibilityIdentifier = @"map";

}

#pragma mark - CLLocationManager Delegate methods

// This method is called whenever the application’s ability to use location
// services changes. Changes can occur because the user allowed or denied the
// use of location services for your application or for the system as a whole.
//
// If the authorization status is already known when you call the
// requestWhenInUseAuthorization or requestAlwaysAuthorization method, the
// location manager does not report the current authorization status to this
// method. The location manager only reports changes to the authorization
// status. For example, it calls this method when the status changes from
// kCLAuthorizationStatusNotDetermined to kCLAuthorizationStatusAuthorizedWhenInUse.
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  CLAuthorizationStatus notDetermined = kCLAuthorizationStatusNotDetermined;
  CLAuthorizationStatus denied = kCLAuthorizationStatusDenied;
  NSLog(@"did change location authorization status: %@", @(status));

  if (status != notDetermined && status != denied) {
    [manager startUpdatingLocation];
    self.showsUserLocation = YES;
  } else {
    if (status == notDetermined) {
      NSLog(@"CoreLocation authorization is not determined");
    } else {
      NSLog(@"CoreLocation authorization is not denied");
    }
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
  CLLocation *myLocation = [locations lastObject];
  self.lastLocation = myLocation;

  if (!self.firstLocationUpdate) {
    // If the first location update has not yet been recieved,
    // then jump to that location.
    NSLog(@"My location is: %f, %f",
          myLocation.coordinate.latitude,
          myLocation.coordinate.longitude);
    self.firstLocationUpdate = YES;
    self.centerCoordinate = myLocation.coordinate;
  }
}

@end
