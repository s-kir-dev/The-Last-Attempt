//
//  PlaceViewController.swift
//  TestApp
//
//  Created by Kirill Sysoev on 20.05.2025.
//

import UIKit

class PlaceViewController: UIViewController {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var beenButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    var place: Place = Places.locations[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeImage.image = UIImage(named: place.image)
        beenButton.addTarget(self, action: #selector(beenButtonTapped), for: .touchUpInside)
        
        mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        
        if beenPlaces.contains(place) {
            beenButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        } else {
            beenButton.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
        }
    }
    

    @objc func beenButtonTapped() {
        db.child("places").child(self.place.name).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any], var visitors = value["visitors"] as? Int else { return }
            
            if beenPlaces.contains(self.place) {
                visitors -= 1
                beenPlaces.remove(at: beenPlaces.firstIndex(of: self.place)!)
                self.beenButton.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
            } else {
                visitors += 1
                beenPlaces.append(self.place)
                self.beenButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            }
            
            db.child("places").child(self.place.name).updateChildValues(["visitors": visitors])
        })
        uploadBeenPlaces()
    }
    
    @objc func mapButtonTapped() {
        let appURL = URL(string: "yandexmaps://maps.yandex.ru/text=\(place.name)")!
        let webURL = URL(string: "https://yandex.ru/maps/?text=\(place.name)")!
        let google = URL(string: "https://www.google.com/search?q=\(place.name) Минск")!
        if UIApplication.shared.canOpenURL(google) {
            UIApplication.shared.open(google)
        } else {
            UIApplication.shared.open(webURL)
        }
    }

}
