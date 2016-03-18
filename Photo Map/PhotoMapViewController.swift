//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView1: MKMapView!
	
	var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView1.delegate = self
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
            MKCoordinateSpanMake(0.1, 0.1))
        mapView1.setRegion(sfRegion, animated: false)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func onPhotoButton(sender: AnyObject) {
		let vc = UIImagePickerController()
		vc.delegate = self
		vc.allowsEditing = true
		vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		
		self.presentViewController(vc, animated: true, completion: nil)

	}
	
	func imagePickerController(picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [String : AnyObject]) {
			// Get the image captured by the UIImagePickerController
			let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
			let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
			
			// Do something with the images (based on your use case)
			
			image = editedImage;
			
			// Dismiss UIImagePickerController to go back to your original view controller
			dismissViewControllerAnimated(true, completion:
				{
				self.performSegueWithIdentifier("tagSegue", sender: nil)
				})
	}
   
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = image
        
        return annotationView
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        navigationController?.popToViewController(self, animated: true)
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(latitude as Double, longitude as Double)
        annotation.coordinate = locationCoordinate
        annotation.title = "Picture!"
        mapView1.addAnnotation(annotation)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tagSegue" {
            var sentView = segue.destinationViewController as! LocationsViewController
            sentView.delegate = self
            
        }
        
    }
}
