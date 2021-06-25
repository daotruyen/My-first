//
//  Timecell.swift
//  Weather
//
//  Created by Tuyen on 24/06/2021.
//

import UIKit

class Timecell: UICollectionViewCell{
    static var reuseIdentifier: String = "Timecell"
    
    private let timeLabel:UILabel = {
        let label = UILabel()
        label.text = "05:00"
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let imageSymbol: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "05:00"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        addSubview(timeLabel)
        addSubview(imageSymbol)
        addSubview(tempLabel)
        
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        imageSymbol.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 6).isActive = true
        imageSymbol.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageSymbol.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageSymbol.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        tempLabel.topAnchor.constraint(equalTo: imageSymbol.bottomAnchor).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with item: WeatherInfo) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        if let date = dateFormatterGet.date(from: item.time) {
            timeLabel.text = dateFormatter.string(from: date)
        }
        
        imageSymbol.loadImage(url: "http://openweathermap.org/img/wn/\(item.icon)@2x.png")
        tempLabel.text = String(item.temp.kelvin()) + " °C"
    }
}
