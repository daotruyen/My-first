//
//  CollectionViewController.swift
//  Weather
//
//  Created by Tuyen on 22/06/2021.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let networkWeather = WeatherNetwork()
    var collectionViews : UICollectionView!
    var forecastData: [numberTemperature] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Forecast"
        
        collectionViews = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionViews.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        collectionViews.translatesAutoresizingMaskIntoConstraints = false
        collectionViews.backgroundColor = .systemBackground
        collectionViews.delegate = self
        collectionViews.dataSource = self
        
        
        view.addSubview(collectionViews)
        collectionViews.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        collectionViews.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionViews.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionViews.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        networkWeather.fetchFiveDay(city: city) { (forecast) in
            self.forecastData = forecast
            print("Total Count:", forecast.count)
            DispatchQueue.main.async {
                self.collectionViews.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
       layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

       let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
       let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
      // layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
       return layoutSection
}
    //collectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
        cell.configure(with: forecastData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    

    

}
