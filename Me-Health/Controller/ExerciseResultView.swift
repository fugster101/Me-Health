import UIKit
import MapKit
import SwifterSwift

class ExerciseResultView: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var elapsedTimeResult: UILabel!
    
    @IBOutlet weak var elpsedStepsResult: UILabel!
    
    @IBOutlet weak var elapsedDistanceResult: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var timefrompreviousView:String = ""
    var stepsfrompreviousView:String = ""
    var distancefrompreviousview:String = ""
    
    var startingCordinates:CLLocationCoordinate2D?
    var endingCordinates:CLLocationCoordinate2D?
    
    var startingPlacmark:MKPlacemark?
    var endingPlacmark:MKPlacemark?
    
    var startingItem:MKMapItem?
    var endingItem:MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        let camera = MKMapCamera()
        camera.pitch = 0.0
        camera.altitude = 1000.0
        mapView.setCamera(camera, animated: true)
        
        startingPlacmark = MKPlacemark(coordinate: startingCordinates!)
        endingPlacmark = MKPlacemark(coordinate: endingCordinates!)
        
        startingItem = MKMapItem(placemark: startingPlacmark!)
        endingItem = MKMapItem(placemark: endingPlacmark!)
        
        let destinationRequest = MKDirectionsRequest()
        destinationRequest.source = startingItem
        destinationRequest.destination = endingItem
        destinationRequest.transportType = .any
        
        let mapDirections = MKDirections(request: destinationRequest)
        mapDirections.calculate { (response, error) in
            guard let response = response else {
                if let error = error{
                    print(error)
                }
                return
            }
            let route = response.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        }
        
        
        
        elapsedTimeResult.text = timefrompreviousView
        elpsedStepsResult.text = stepsfrompreviousView
        elapsedDistanceResult.text = distancefrompreviousview
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.black
        render.lineWidth = 3.0
        return render
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.default
    }
}
