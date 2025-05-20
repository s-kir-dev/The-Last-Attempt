//
//  MainViewController.swift
//  TestApp
//
//  Created by Kirill Sysoev on 19.05.2025.
//

import UIKit
import FirebaseDatabase

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recommendedView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var seeAllButton: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    let loading = UIActivityIndicatorView(style: .large)
    
    var sortedPlaces: [Place] = Places.locations
    var popular: [Place] = []
    var selectedPlace: Place = Places.locations[0]

    override func viewDidLoad() {
        super.viewDidLoad()
            
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find things to go"
        
        
        loading.hidesWhenStopped = true
        loading.center = view.center
        view.addSubview(loading)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        recommendedView.delegate = self
        recommendedView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        setPopular()
    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
            sortedPlaces = Places.locations
        case 1:
            sortedPlaces = Places.hotels
        case 2:
            sortedPlaces = Places.food
        case 3:
            sortedPlaces = Places.adventure
        default:
            break
        }
        
        setPopular()
    }
    
    func setPopular() {
        popular = []
        let placesToFetch = sortedPlaces
        var fetchedPlaces: [Place] = []
        var fetchedCount = 0
        
        loading.startAnimating()
        collectionView.isUserInteractionEnabled = false
        
        for place in placesToFetch {
            db.child("places").child(place.name).observeSingleEvent(of: .value, with: { snaphot in
                defer {
                    fetchedCount += 1
                    if fetchedCount == placesToFetch.count {
                        self.popular = fetchedPlaces
                        self.loading.stopAnimating()
                        self.collectionView.reloadData()
                        self.collectionView.isUserInteractionEnabled = true
                    }
                }
                
                guard let value = snaphot.value as? [String: Any], let rating = value["visitors"] as? Int, rating >= 10 else { return }
                    fetchedPlaces.append(place)
            })
        }
    }
}


extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let place = popular[indexPath.item]
            print(place.name)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return popular.count
        } else {
            return recommendedPlaces.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlaceCollectionViewCell
            
            if popular.count > indexPath.row {
                cell.layer.cornerRadius = 20
                cell.name.layer.cornerRadius = cell.name.bounds.height / 2
                cell.rating.layer.cornerRadius = cell.rating.bounds.height / 2
                cell.name.clipsToBounds = true
                cell.rating.clipsToBounds = true
                
                let place = popular[indexPath.row]
                
                cell.name.text = place.name
                cell.image.image = UIImage(named: place.image)
                
                countRating(place: place, showReviews: false, completion: { rating in
                    cell.rating.text = rating
                })
                
                if favorites.contains(place) {
                    cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    cell.favoriteAction = {
                        favorites.remove(at: favorites.firstIndex(of: place)!)
                        collectionView.reloadData()
                    }
                    
                } else {
                    cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.favoriteAction = {
                        favorites.append(place)
                        collectionView.reloadData()
                    }
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecommendedCollectionViewCell
            
            let place = recommendedPlaces[indexPath.row]
            
            cell.layer.cornerRadius = 20
            cell.image.layer.cornerRadius = 20
            cell.image.clipsToBounds = true
            
            cell.image.image = UIImage(named: place.image)
            cell.name.text = place.name
            cell.typeImage.image = UIImage(named: place.imageType)
            cell.typeLabel.text = place.type
            
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 195, height: 250)
        } else {
            return CGSize(width: 200, height: 175)
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text!.isEmpty {
            popular = popular.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
            collectionView.reloadData()
        } else {
            setPopular()
        }
    }
}
