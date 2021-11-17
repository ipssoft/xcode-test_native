//
//  CityMKMapView.swift
//  test_native
//
//  Created by ihor on 06.11.2021.
//

import SwiftUI
import MapKit

struct CityMKMapView: UIViewRepresentable{
    @Binding var showingMap: Bool
    @Binding var region: MKCoordinateRegion

    var circle = MKPointAnnotation()
    let mkMapView = MKMapView()

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CityMKMapView>) -> MKMapView {
        mkMapView.delegate = context.coordinator
        mkMapView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<CityMKMapView>) {
        context.coordinator.setAnnotation(region: self.region)
        uiView.setRegion(self.region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate{
        var parent: CityMKMapView
        var gRecognizer = UITapGestureRecognizer()
        
        init(_ parent: CityMKMapView){
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(Coordinator.tapAction(_:)))
            self.gRecognizer.delegate = self
            self.parent.mkMapView.addGestureRecognizer(gRecognizer)
        }
        
        @objc func tapAction(_ sender : UITapGestureRecognizer){
            let location = gRecognizer.location(in: self.parent.mkMapView)
            self.parent.region.center = self.parent.mkMapView.convert(location, toCoordinateFrom: self.parent.mkMapView)

            self.parent.mkMapView.setRegion(self.parent.region, animated: true)
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)->MKAnnotationView?{
            let identifier = "City"

            var annotationView = self.parent.mkMapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }else{
                annotationView?.annotation = annotation
            }
            let config = UIImage.SymbolConfiguration(scale: .large)
            var image = UIImage(systemName: "circle.fill")
            image = image?.withRenderingMode(.alwaysTemplate)
            image = image?.withConfiguration(config)
            image = image?.withTintColor(.red)
            let size = CGSize(width: 40, height: 40)

            annotationView?.image = UIGraphicsImageRenderer(size: size).image{
                _ in image?.draw(in: CGRect(origin: .zero, size: size))
            }
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            return annotationView
        }
        func setAnnotation(region: MKCoordinateRegion){
            self.parent.mkMapView.removeAnnotation(self.parent.circle)
            self.parent.circle = MKPointAnnotation(__coordinate: region.center)
            self.parent.mkMapView.addAnnotation(self.parent.circle)
        }
        func mapViewDidFinishRenderingMap (_ mapView: MKMapView, fullyRendered fullyRender: Bool) {
            print("Change region")
            if fullyRender{
                setAnnotation(region: self.parent.region)
            }
        }
    }
}
