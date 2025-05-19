//
//  Helper.swift
//  TestApp
//
//  Created by Kirill Sysoev on 19.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

let db = Database.database().reference()

let storyboard = UIStoryboard(name: "Main", bundle: nil)

let startVC = storyboard.instantiateViewController(withIdentifier: "startVC")

let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController


enum PlaceType: String, Codable {
    case locations = "Locations", hotels = "Hotels", food = "Food", adventure = "Adventure"
}

enum Facility: String, Codable {
    case wifi = "Wi-Fi", pool = "Pool", restaurant = "Restaurant", sauna = "Sauna"
}

struct Place: Codable, Equatable {
    let name: String
    let description: String
    let image: String
    var rating: Double
    var myRate: Int
    var visitors: Int
    let recommendedTime: String
    let address: String
    let phone: String
    let facilities: [Facility]
    let placeType: PlaceType
    let budget: Int
    let openTime: String
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name
    }
    
    init(name: String, description: String, image: String, rating: Double, myRate: Int, visitors: Int, recommendedTime: String, address: String, phone: String, facilities: [Facility], placeType: PlaceType, budget: Int, openTime: String) {
        self.name = name.localized()
        self.description = description.localized()
        self.image = image
        self.rating = rating
        self.myRate = myRate
        self.visitors = visitors
        self.recommendedTime = recommendedTime.localized()
        self.address = address.localized()
        self.phone = phone
        self.facilities = facilities
        self.placeType = placeType
        self.budget = budget
        self.openTime = openTime
    }
}

struct Places: Codable {
    static var locations: [Place] = [
        Place(
            name: "Troitskoe suburb",
            description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.",
            image: "троицкое",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "1-2 hours",
            address: "Lenina Street 20",
            phone: "+375-17-3970163",
            facilities: [],
            placeType: .locations,
            budget: 0,
            openTime: ""),
        Place(name: "National library",
              description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.",
              image: "библиотека",
              rating: 0,
              myRate: 0,
              visitors: 0,
              recommendedTime: "1-2 hours",
              address: "Lenina Street 20",
              phone: "+375-17-3970163",
              facilities: [],
              placeType: .locations,
              budget: 0,
              openTime: ""),
        Place(
            name: "Museum of the Great Patriotic War History",
            description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.",
            image: "музей ВОВ",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "1-2 hours",
            address: "Lenina Street 20",
            phone: "+375-17-3970163",
            facilities: [],
            placeType: .locations,
            budget: 0,
            openTime: ""),
        Place(
            name: "Bolshoy Theater of Belarus",
            description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.",
            image: "большой театр",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "1-2 hours",
            address: "Lenina Street 20",
            phone: "+375-17-3970163",
            facilities: [],
            placeType: .locations,
            budget: 0,
            openTime: ""),
        Place(
            name: "National Art Museum",
            description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.",
            image: "музей искусства",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "1-2 hours",
            address: "Lenina Street 20",
            phone: "+375-17-3970163",
            facilities: [],
            placeType: .locations,
            budget: 0,
            openTime: ""),
        Place(
            name: "Komarovsky market",
            description: "The National Art Museum of the Republic of Belarus is the largest fund and exposition repository of art objects in the country.",
            image: "комаровка",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "1-2 hours",
            address: "Lenina Street 20",
            phone: "+375-17-3970163",
            facilities: [],
            placeType: .locations,
            budget: 0,
            openTime: "")
    ]
    
    static var hotels: [Place] = [
        Place(
            name: "Marriott",
            description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.",
            image: "мариотт",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "",
            phone: "",
            facilities: [.wifi, .restaurant, .sauna, .pool],
            placeType: .hotels,
            budget: 0,
            openTime: ""),
        Place(
            name: "DoubleTree by Hilton Hotel",
            description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.",
            image: "хилтон",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "",
            phone: "",
            facilities: [.wifi, .restaurant, .sauna, .pool],
            placeType: .hotels,
            budget: 0,
            openTime: ""),
        Place(
            name: "Minsk Hotel",
            description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.",
            image: "минск",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "",
            phone: "",
            facilities: [.wifi, .restaurant, .sauna, .pool],
            placeType: .hotels,
            budget: 0,
            openTime: ""),
        Place(
            name: "President Hotel",
            description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.",
            image: "президент",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "",
            phone: "",
            facilities: [.wifi, .restaurant, .sauna, .pool],
            placeType: .hotels,
            budget: 0,
            openTime: ""),
        Place(
            name: "Hotel Victoria Minsk",
            description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.",
            image: "виктория",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "",
            phone: "",
            facilities: [.wifi, .restaurant, .sauna, .pool],
            placeType: .hotels,
            budget: 0,
            openTime: ""),
        Place(
            name: "Beijing Hotel Minsk",
            description: "The hotel provides complete amenities and friendly service. Guests appreciate the clean, spacious rooms and convenient location near the city center and public transport.",
            image: "пекин",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "",
            phone: "",
            facilities: [.wifi, .restaurant, .sauna, .pool],
            placeType: .hotels,
            budget: 0,
            openTime: "")
    ]
    
    static var food: [Place] = [
        Place(
            name: "Zolotoy Grebeshok",
            description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.",
            image: "гребешок",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Pobeditelei Ave., 9 | 7th Floor",
            phone: "+375-44-507-17-29",
            facilities: [],
            placeType: .food,
            budget: 29,
            openTime: ""),
        Place(
            name: "Ember",
            description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.",
            image: "эмбер",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Pobeditelei Ave., 9 | 7th Floor",
            phone: "+375-44-507-17-29",
            facilities: [],
            placeType: .food,
            budget: 29,
            openTime: ""),
        Place(
            name: "Grand Cafe",
            description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.",
            image: "гранд",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Pobeditelei Ave., 9 | 7th Floor",
            phone: "+375-44-507-17-29",
            facilities: [],
            placeType: .food,
            budget: 29,
            openTime: ""),
        Place(
            name: "Chaynyy P",
            description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.",
            image: "чайный",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Pobeditelei Ave., 9 | 7th Floor",
            phone: "+375-44-507-17-29",
            facilities: [],
            placeType: .food,
            budget: 29,
            openTime: ""),
        Place(
            name: "Pena Dney",
            description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.",
            image: "пена дней",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Pobeditelei Ave., 9 | 7th Floor",
            phone: "+375-44-507-17-29",
            facilities: [],
            placeType: .food,
            budget: 29,
            openTime: ""),
        Place(
            name: "Restoran Malevich",
            description: "The elegant Ember restaurant on the 7th floor of the DoubleTree by Hilton hotel offers dry-aged steaks, fresh fish and seafood dishes, and one of the richest wine bars in Minsk.",
            image: "малевич",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "1-2 hours",
            address: "Pobeditelei Ave., 9 | 7th Floor",
            phone: "+375-44-507-17-29",
            facilities: [],
            placeType: .food,
            budget: 29,
            openTime: "")
    ]
    
    static var adventure: [Place] = [
        Place(
            name: "Adventure Park",
            description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.",
            image: "парк развлечений",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Tashkentskaya St., 40",
            phone: "+375-17-345-32-65",
            facilities: [],
            placeType: .adventure,
            budget: 0,
            openTime: "10:00-20:00"),
        Place(
            name: "Minsk Zoo",
            description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.",
            image: "зоопарк",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Tashkentskaya St., 40",
            phone: "+375-17-345-32-65",
            facilities: [],
            placeType: .adventure,
            budget: 0,
            openTime: "10:00-20:00"),
        Place(
            name: "ZipLine",
            description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.",
            image: "зиплайн",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Tashkentskaya St., 40",
            phone: "+375-17-345-32-65",
            facilities: [],
            placeType: .adventure,
            budget: 0,
            openTime: "10:00-20:00"),
        Place(
            name: "Ninja Park",
            description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.",
            image: "ниндзя парк",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Tashkentskaya St., 40",
            phone: "+375-17-345-32-65",
            facilities: [],
            placeType: .adventure,
            budget: 0,
            openTime: "10:00-20:00"),
        Place(
            name: "AVRA VR",
            description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.",
            image: "авалон",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Tashkentskaya St., 40",
            phone: "+375-17-345-32-65",
            facilities: [],
            placeType: .adventure,
            budget: 0,
            openTime: "10:00-20:00"),
        Place(
            name: "Neurobox",
            description: "A unique museum of living nature. It was opened on August 9, 1984. The animal collection contains about 400 species of exotic animals.",
            image: "нейробокс",
            rating: 0,
            myRate: 0,
            visitors: 0,
            recommendedTime: "",
            address: "Tashkentskaya St., 40",
            phone: "+375-17-345-32-65",
            facilities: [],
            placeType: .adventure,
            budget: 0,
            openTime: "10:00-20:00")
    ]
}

struct Recommended: Codable {
    let name: String
    let image: String
    let type: String
    let imageType: String
}

var recommendedPlaces: [Recommended] = [
    Recommended(name: "Explore Minsk", image: "вокзал", type: "Hot Deal", imageType: "arrow"),
    Recommended(name: "Luxurious Minsk", image: "раубичи", type: "Hot Deal", imageType: "arrow"),
    Recommended(name: "Explore Minsk", image: "вокзал", type: "Hot Deal", imageType: "arrow"),
    Recommended(name: "Luxurious Minsk", image: "раубичи", type: "Hot Deal", imageType: "arrow"),
]

var favorites: [Place] = []

var rewards: [String] = []

func uploadFavorites() {
    if let encodedData = try? JSONEncoder().encode(favorites) {
        UserDefaults.standard.set(encodedData, forKey: "favorites-\(Auth.auth().currentUser!.uid)")
    }
}

func downloadFavorites() {
    if let data = UserDefaults.standard.data(forKey: "favorites-\(Auth.auth().currentUser!.uid)"), let decodedData = try? JSONDecoder().decode([Place].self, from: data) {
        favorites = decodedData
    }
}

func countRating(place: Place, showReviews: Bool, completion: @escaping (String) -> Void) {
    var kolvo = 0
    var summa = 0
    
    db.child("ratings").child(place.name).observeSingleEvent(of: .value, with: { snaphot in
        let group = DispatchGroup()
        kolvo = Int(snaphot.childrenCount)
        
        for child in snaphot.children {
            group.enter()
            
            guard let userSnaphot = child as? DataSnapshot else { continue }
            
            db.child("ratings").child(place.name).child(userSnaphot.key).observeSingleEvent(of: .value, with: { snaphot in
                defer { group.leave() }
                
                if let value = snaphot.value as? [String: Any], let myRate = value["myRate"] as? Int {
                    summa += myRate
                }
            })
        }
        
        group.notify(queue: .main) {
            let rating = Double(summa)/Double(kolvo)
            let roundedRating = Double(rating*100).rounded()/100
            if showReviews {
                completion("⭐️\(roundedRating) (\(kolvo)K Reviews")
            } else {
                completion("⭐️\(roundedRating)")
            }
        }
    })
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
