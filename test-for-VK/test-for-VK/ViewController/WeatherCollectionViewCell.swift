//
//  WeatherCollectionViewCell.swift
//  test-for-VK
//
//  Created by Dmitrii Imaev on 17.07.2024.
//

import UIKit

final class WeatherCollectionViewCell: UICollectionViewCell {
    
    private let label = UILabel()
    private let weatherImageView = UIImageView()
    
    private let sunnyImage = UIImage(systemName: "sun.max.fill")
    private let rainyImage = UIImage(systemName: "cloud.rain.fill")
    private let cloudyImage = UIImage(systemName: "cloud.fill")
    private let stormyImage = UIImage(systemName: "cloud.bolt.rain.fill")
    private let snowyImage = UIImage(systemName: "cloud.snow.fill")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner]
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.25
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = UIColor.clear
        contentView.layer.insertSublayer(makeGradientLayer(), at: 0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .white
        contentView.addSubview(label)
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.contentMode = .scaleAspectFit
        contentView.addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 75),
            label.heightAnchor.constraint(equalToConstant: 27),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            weatherImageView.widthAnchor.constraint(equalToConstant: 50),
            weatherImageView.heightAnchor.constraint(equalToConstant: 50),
            weatherImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 13),
            weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 20
        gradientLayer.colors = [
            UIColor(white: 1.0, alpha: 0.26).cgColor,
            UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 0.26).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }
    
    func configure(with weather: Weather) {
        label.text = weather.localizedName
        
        switch weather {
        case .sunny:
            weatherImageView.image = sunnyImage
            weatherImageView.tintColor = .sunnyColor
        case .rainy:
            weatherImageView.image = rainyImage
            weatherImageView.tintColor = UIColor.lightGray
        case .cloudy:
            weatherImageView.image = cloudyImage
            weatherImageView.tintColor = UIColor.white
        case .stormy:
            weatherImageView.image = stormyImage
            weatherImageView.tintColor = UIColor.darkGray
        case .snowy:
            weatherImageView.image = snowyImage
            weatherImageView.tintColor = UIColor.white
        }
    }
}

