//
//  MainViewController.swift
//  TestApp
//
//  Created by Kirill Sysoev on 19.05.2025.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recommendedView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var seeAllButton: UIButton!
    
    var sortedPlaces: [Place] = Places.locations
    
    var popular: [Place] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Find things to do"
        searchController.searchResultsUpdater = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        recommendedView.delegate = self
        recommendedView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sortPopular(count: 4)
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
            sortedPlaces = Places.locations
        }
        
        collectionView.setContentOffset(.zero, animated: true)
        
        collectionView.reloadData()
        sortPopular(count: 4)
    }

    
    func sortPopular(count: Int) {
        popular = sortedPlaces.sorted{
            $0.visitors > $1.visitors
        }
        .prefix(count)
        .map{$0}
    }
}


extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            print("\(popular[indexPath.row].name) нажат")
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popular.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlaceCollectionViewCell
            
            let place = popular[indexPath.row]
            
            cell.name.layer.cornerRadius = 38/2
            cell.rating.layer.cornerRadius = 35 / 2
            cell.name.clipsToBounds = true
            cell.rating.clipsToBounds = true
            
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
            
            cell.layer.cornerRadius = 20
            
            
            cell.name.text = place.name
            cell.image.image = UIImage(named: place.image)
            countRating(place: place, showReviews: false, completion: { rating in
                cell.rating.text = rating
                
            })
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecommendedCollectionViewCell
            cell.layer.cornerRadius = 20
            
            let place = recommendedPlaces[indexPath.row]
            
            cell.image.image = UIImage(named: place.image)
            cell.name.text = place.name
            cell.typeLabel.text = place.type
            cell.typeImage.image = UIImage(named: place.imageType)
            
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
            popular = popular.filter{ $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        } else {
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
                sortedPlaces = Places.locations
            }
            sortPopular(count: 4)
        }
        collectionView.reloadData()
    }
}
