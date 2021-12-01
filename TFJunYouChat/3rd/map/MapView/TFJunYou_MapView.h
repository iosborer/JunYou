




#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol TFJunYou_MapViewDelegate;
@interface TFJunYou_MapView : UIView

@property (nonatomic,strong)MKMapView *mapView;
@property (nonatomic,assign)double span;//default 40000

- (id)initWithDelegate:(id<TFJunYou_MapViewDelegate>)delegate;
- (void)beginLoad;
@end


@protocol TFJunYou_MapViewDelegate <NSObject>

- (NSInteger)numbersWithCalloutViewForMapView;
- (CLLocationCoordinate2D)coordinateForMapViewWithIndex:(NSInteger)index;
- (UIView *)mapViewCalloutContentViewWithIndex:(NSInteger)index;
- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSInteger)index;

@optional
- (void)calloutViewDidSelectedWithIndex:(NSInteger)index;

@end
