//
//  WeatherViewController.swift
//  test-for-VK
//
//  Created by Dmitrii Imaev on 18.07.2024.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    private let cellId = String(describing: WeatherCollectionViewCell.self)
    private var animationView: UIView?
    
    private let dropImage = UIImage(systemName: "drop.fill")
    private let boltImage = UIImage(systemName: "bolt.fill")
    private let cloudImage = UIImage(systemName: "cloud.fill")
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 120)
        layout.minimumLineSpacing = 15
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.sunnyBackground
        
        setupCollectionView()
        layoutCollectionView()
        
        let randomWeather = Weather.allCases.randomElement()
        displayWeatherAnimation(for: randomWeather)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
    }
    
    private func layoutCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func displayWeatherAnimation(for weather: Weather?) {
        guard let weather = weather else { return }
        
        removeCurrentAnimation()
        
        let newAnimationView = UIView(frame: view.bounds)
        view.addSubview(newAnimationView)
        view.bringSubviewToFront(collectionView)
        animationView = newAnimationView
        
        let newBackgroundColor: UIColor
        
        switch weather {
        case .sunny:
            newBackgroundColor = UIColor.sunnyBackground
            animateSunny(in: newAnimationView)
        case .rainy:
            newBackgroundColor = UIColor.rainyBackground
            animateRainy(in: newAnimationView)
        case .cloudy:
            newBackgroundColor = UIColor.cloudyBackground
            animateCloudy(in: newAnimationView)
        case .stormy:
            newBackgroundColor = UIColor.stormyBackground
            animateStormy(in: newAnimationView)
        case .snowy:
            newBackgroundColor = UIColor.snowyBackground
            animateSnowy(in: newAnimationView)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.backgroundColor = newBackgroundColor
        }
    }
    
    private func removeCurrentAnimation() {
        if let currentView = animationView {
            UIView.animate(withDuration: 0.5, animations: {
                currentView.alpha = 0
            }, completion: { _ in
                currentView.removeFromSuperview()
            })
        }
    }
    
    private func animateSunny(in view: UIView) {
        let sunView = UIView(frame: CGRect(x: -225, y: view.bounds.height / 2 - 225, width: 450, height: 450))
        view.addSubview(sunView)
        
        let layers = [
            (width: 454.0, height: 454.0, opacity: 0.25),
            (width: 330.0, height: 330.0, opacity: 0.8),
            (width: 180.0, height: 180.0, opacity: 1.0)
        ]
        
        for layer in layers {
            let circleView = UIView()
            circleView.backgroundColor = UIColor.sunnyColor.withAlphaComponent(CGFloat(layer.opacity))
            circleView.frame = CGRect(
                x: (450.0 - layer.width) / 2,
                y: (450.0 - layer.height) / 2,
                width: layer.width,
                height: layer.height
            )
            circleView.layer.cornerRadius = layer.width / 2
            sunView.addSubview(circleView)
        }
        
        let arcPath = UIBezierPath()
        let startPoint = CGPoint(x: -225, y: view.bounds.height - 100)
        let endPoint = CGPoint(x: view.bounds.width + 225, y: view.bounds.height - 100)
        let controlPoint = CGPoint(x: view.bounds.width / 2, y: -450)
        
        arcPath.move(to: startPoint)
        arcPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = arcPath.cgPath
        animation.duration = 20.0
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        sunView.layer.add(animation, forKey: "moveInArcAnimation")
    }
    
    private func animateRainy(in view: UIView) {
        let cloudConfigurations = [
            (width: 100.0, height: 60.0, yOffset: 50.0, delay: 0.0),
            (width: 120.0, height: 72.0, yOffset: 30.0, delay: 5.0),
            (width: 140.0, height: 84.0, yOffset: 70.0, delay: 8.0)
        ]
        
        for (width, height, yOffset, delay) in cloudConfigurations {
            let smallCloud = createCloudImageView(size: CGSize(width: width, height: height), opacity: 1.0, color: .cloudFillColor)
            let mediumCloud = createCloudImageView(size: CGSize(width: width * 1.2, height: height * 1.2), opacity: 0.7, color: .cloudFillColor)
            let largeCloud = createCloudImageView(size: CGSize(width: width * 1.4, height: height * 1.4), opacity: 0.4, color: .cloudFillColor)
            
            let startX = -largeCloud.frame.width
            
            smallCloud.frame.origin = CGPoint(x: startX, y: yOffset)
            mediumCloud.frame.origin = CGPoint(x: startX - (mediumCloud.frame.width - smallCloud.frame.width) / 2, y: yOffset - (mediumCloud.frame.height - smallCloud.frame.height) / 2)
            largeCloud.frame.origin = CGPoint(x: startX - (largeCloud.frame.width - smallCloud.frame.width) / 2, y: yOffset - (largeCloud.frame.height - smallCloud.frame.height) / 2)
            
            view.addSubview(largeCloud)
            view.addSubview(mediumCloud)
            view.addSubview(smallCloud)
            
            animateCloud(cloud: smallCloud, delay: delay)
            animateCloud(cloud: mediumCloud, delay: delay)
            animateCloud(cloud: largeCloud, delay: delay)
        }
        
        for _ in 0..<80 {
            let drop = UIImageView(image: dropImage)
            drop.tintColor = .rainyColor
            let x = CGFloat(arc4random_uniform(UInt32(view.bounds.width)))
            drop.frame = CGRect(x: x, y: -20, width: 10, height: 20)
            view.addSubview(drop)
            
            animateRainDrop(drop)
        }
    }
    
    private func createCloudImageView(size: CGSize, opacity: CGFloat, color: UIColor) -> UIImageView {
        let cloudImageView = UIImageView(image: cloudImage)
        cloudImageView.frame.size = size
        cloudImageView.tintColor = color
        cloudImageView.alpha = opacity
        return cloudImageView
    }
    
    private func animateRainDrop(_ drop: UIImageView) {
        drop.alpha = 0.0
        let startDelay = TimeInterval(arc4random_uniform(3))
        UIView.animate(withDuration: TimeInterval(arc4random_uniform(5) + 5), delay: startDelay, options: [.repeat, .curveLinear], animations: {
            drop.alpha = 1.0
            drop.frame.origin.y = self.view.bounds.height
        }, completion: { _ in
            drop.frame.origin.y = -20
            drop.frame.origin.x = CGFloat(arc4random_uniform(UInt32(self.view.bounds.width)))
            self.animateRainDrop(drop)
        })
    }
    
    private func animateCloudy(in view: UIView) {
        let cloudConfigurations = [
            (width: 301.0, height: 173.98, yOffset: 331.0, delay: 0.0),
            (width: 295.0, height: 191.77, yOffset: 194.0, delay: 2.0),
            (width: 291.88, height: 183.0, yOffset: 534.0, delay: 3.0)
        ]
        
        for (width, height, yOffset, delay) in cloudConfigurations {
            let smallCloud = createCloudImageView(size: CGSize(width: width, height: height), opacity: 1.0, color: .white)
            let mediumCloud = createCloudImageView(size: CGSize(width: width * 1.2, height: height * 1.2), opacity: 0.7, color: .white)
            let largeCloud = createCloudImageView(size: CGSize(width: width * 1.4, height: height * 1.4), opacity: 0.4, color: .white)
            
            let startX = -largeCloud.frame.width
            
            smallCloud.frame.origin = CGPoint(x: startX, y: yOffset)
            mediumCloud.frame.origin = CGPoint(x: startX - (mediumCloud.frame.width - smallCloud.frame.width) / 2, y: yOffset - (mediumCloud.frame.height - smallCloud.frame.height) / 2)
            largeCloud.frame.origin = CGPoint(x: startX - (largeCloud.frame.width - smallCloud.frame.width) / 2, y: yOffset - (largeCloud.frame.height - smallCloud.frame.height) / 2)
            
            view.addSubview(largeCloud)
            view.addSubview(mediumCloud)
            view.addSubview(smallCloud)
            
            animateCloud(cloud: smallCloud, delay: delay)
            animateCloud(cloud: mediumCloud, delay: delay)
            animateCloud(cloud: largeCloud, delay: delay)
        }
    }
    
    private func animateCloud(cloud: UIImageView, delay: TimeInterval) {
        let moveRight = CABasicAnimation(keyPath: "position.x")
        moveRight.fromValue = cloud.frame.origin.x
        moveRight.toValue = view.bounds.width + cloud.frame.width
        moveRight.duration = 10.0
        moveRight.beginTime = CACurrentMediaTime() + delay
        moveRight.repeatCount = .infinity
        moveRight.timingFunction = CAMediaTimingFunction(name: .linear)
        
        cloud.layer.add(moveRight, forKey: "moveRightAnimation")
    }
    
    
    private func animateStormy(in view: UIView) {
        let rainContainer = UIView(frame: CGRect(x: 30, y: 170, width: 470, height: 127))
        rainContainer.backgroundColor = .clear
        rainContainer.transform = CGAffineTransform(rotationAngle: -.pi / 9)
        view.addSubview(rainContainer)
        
        for _ in 0..<160 {
            let drop = UIImageView(image: dropImage)
            drop.tintColor = .rainyColor
            let x = CGFloat(arc4random_uniform(UInt32(view.bounds.width)))
            drop.frame = CGRect(x: x, y: -20, width: 10, height: 20)
            view.addSubview(drop)
            
            animateRainDrop(drop)
        }
        
        let lightning1 = createLightningView(frame: CGRect(x: 49, y: 227.5, width: 115, height: 353.5))
        let lightning2 = createLightningView(frame: CGRect(x: 253, y: 491.5, width: 115, height: 353.5))
        
        view.addSubview(lightning1)
        view.addSubview(lightning2)
        
        startLightningAnimation(lightning1)
        startLightningAnimation(lightning2)
    }
    
    private func createLightningView(frame: CGRect) -> UIImageView {
        let lightning = UIImageView(image: boltImage)
        lightning.alpha = 0.0
        lightning.frame = frame
        lightning.tintColor = .lightningColor
        return lightning
    }
    
    private func startLightningAnimation(_ lightning: UIImageView) {
        let randomDelay = Double(arc4random_uniform(5) + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            self.animateLightning(lightning)
        }
    }
    
    private func animateLightning(_ lightning: UIImageView) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse], animations: {
            lightning.alpha = 1
        }, completion: { _ in
            lightning.alpha = 0
            let nextFlashDelay = Double(arc4random_uniform(5) + 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + nextFlashDelay) {
                self.animateLightning(lightning)
            }
        })
    }
    
    private func animateSnowy(in view: UIView) {
        for _ in 0..<50 {
            let snowflake = createSnowflake()
            view.addSubview(snowflake)
            animateSnowflake(snowflake)
        }
    }
    
    private func createSnowflake() -> UIView {
        let snowflake = UIView(frame: CGRect(x: CGFloat(arc4random_uniform(UInt32(view.bounds.width))), y: -25, width: 25, height: 25))
        snowflake.backgroundColor = .snowyColor
        snowflake.layer.cornerRadius = 12.5
        return snowflake
    }
    
    private func animateSnowflake(_ snowflake: UIView) {
        let endY = view.bounds.height + 25
        let startDelay = TimeInterval(arc4random_uniform(3))
        
        UIView.animate(withDuration: TimeInterval(arc4random_uniform(5) + 5), delay: startDelay, options: [.repeat, .curveLinear], animations: {
            snowflake.frame.origin.y = endY
        }, completion: { _ in
            snowflake.frame.origin.y = -25
            snowflake.frame.origin.x = CGFloat(arc4random_uniform(UInt32(self.view.bounds.width)))
            self.animateSnowflake(snowflake)
        })
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Weather.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? WeatherCollectionViewCell else { return UICollectionViewCell() }
        let weather = Weather.allCases[indexPath.item]
        cell.configure(with: weather)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWeather = Weather.allCases[indexPath.item]
        displayWeatherAnimation(for: selectedWeather)
    }
}
