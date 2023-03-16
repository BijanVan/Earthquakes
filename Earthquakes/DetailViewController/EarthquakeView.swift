//
//  EarthquakeView.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-28.
//

import UIKit
import MapKit

class EarthquakeView: UIView {
    let quake: Quake
    
    let stackView = UIStackView()
    let map = MKMapView()
    let place = UILabel()
    let time = UILabel()
    let latitude = UILabel()
    let longitude = UILabel()
    let magnitude = UILabel()
    
    init(quake: Quake) {
        self.quake = quake
        super.init(frame: .zero)
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    private func prepareSubviews() {
        stackView.addArrangedSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        map.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.7).isActive = true
        if let location = quake.location {
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            let region = MKCoordinateRegion(center: center, span: span)
            map.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            map.addAnnotation(annotation)
        }
        
        magnitude.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1), .foregroundColor: quake.color, .backgroundColor: UIColor.label]
        magnitude.attributedText = NSMutableAttributedString(string: quake.magnitude.formatted(.number.precision(.fractionLength(1))), attributes: attributes)
        stackView.addArrangedSubview(magnitude)
        
        stackView.addArrangedSubview(place)
        place.translatesAutoresizingMaskIntoConstraints = false
        place.font = UIFont.preferredFont(forTextStyle: .headline)
        place.text = quake.place
        
        stackView.addArrangedSubview(time)
        time.translatesAutoresizingMaskIntoConstraints = false
        time.textColor = .secondaryLabel
        time.text = quake.time.formatted()
        
        stackView.addArrangedSubview(latitude)
        latitude.translatesAutoresizingMaskIntoConstraints = false
        if let location = quake.location {
            latitude.text = "Latitude: \(location.latitude.formatted(.number.precision(.fractionLength(3))))"
        }
        
        stackView.addArrangedSubview(longitude)
        longitude.translatesAutoresizingMaskIntoConstraints = false
        if let location = quake.location {
            longitude.text = "Longitude: \(location.longitude.formatted(.number.precision(.fractionLength(3))))"
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
struct EarthquakeView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]
    
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let view = EarthquakeView(quake: quakeSample)
                return view
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
