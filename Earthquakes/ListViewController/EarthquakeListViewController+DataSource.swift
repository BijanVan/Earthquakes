//
//  EarthquakeListViewController+DataSource.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-18.
//

import UIKit

extension EarthquakeListCollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Quake.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Quake.ID>
    
    func updateSnapshot(reloading idsThatChanged: [Quake.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(quakes.map { $0.id })
        if !idsThatChanged.isEmpty {
            snapshot.reloadItems(idsThatChanged)
        }
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Quake.ID) {
        let quake = quakes[indexPath.item]
        var contentConfiguration = cell.defaultContentConfiguration()
        
        var attributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1), .foregroundColor: quake.color, .backgroundColor: UIColor.label]
        let magnitude = NSMutableAttributedString(string: quake.magnitude.formatted(.number.precision(.fractionLength(1))), attributes: attributes)
        attributes = [.font: UIFont.preferredFont(forTextStyle: .title3)]
        let place = NSAttributedString(string: "  " + quake.place, attributes: attributes)
        magnitude.append(place)
        
        contentConfiguration.attributedText = magnitude

        contentConfiguration.secondaryText = quake.time.formatted(.relative(presentation: .named))
        cell.contentConfiguration = contentConfiguration
        
        cell.accessories = [.disclosureIndicator(displayed: .always)]
    }
}
