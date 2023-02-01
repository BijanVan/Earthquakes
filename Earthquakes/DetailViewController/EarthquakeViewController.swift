//
//  EarthquakeViewController.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-27.
//

import UIKit

class EarthquakeViewController: UIViewController {
    let quake: Quake
    let earthquakeView: EarthquakeView
    
    init(quake: Quake) {
        self.quake = quake
        self.earthquakeView = EarthquakeView(quake: quake)
        super.init(nibName: nil, bundle: nil)
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Private functions
    private func prepareSubviews() {
        view.addSubview(earthquakeView)
        earthquakeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            earthquakeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            earthquakeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

private let quakeSample = Quake(magnitude: 0.34,
                                place: "Shakey Acres",
                                time: Date(timeIntervalSinceNow: -1000),
                                code: "nc73649170",
                                detail: URL(string: "https://example.com")!,
                                location: QuakeLocation(latitude: 38.809_333_8, longitude: -122.796_836_9))

@available(iOS 13.0, *)
struct EarthquakeViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]
    
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                EarthquakeViewController(quake: quakeSample)
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
