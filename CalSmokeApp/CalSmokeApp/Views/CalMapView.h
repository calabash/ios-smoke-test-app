#import <MapKit/MapKit.h>

@interface CalMapView : MKMapView <CLLocationManagerDelegate>

- (CLLocation *) lastLocation;

@end
