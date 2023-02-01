//
//  ViewController.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-16.
//

import UIKit

class EarthquakeListCollectionViewController: UICollectionViewController {
    var dataSource: DataSource!
    var quakes: [Quake] = []
    
    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: config)
        
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .systemFill
        collectionView.collectionViewLayout = listLayout()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Quake.ID) in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        collectionView.dataSource = dataSource
        initialQuakes()
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        showDetail(for: quakes[indexPath.item])
        return false
    }
    
    // MARK: Private functions
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.showsSeparators = false
        config.backgroundColor = .clear
        config.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            let index = self?.quakes.indexOfQuake(for: id)
            self?.quakes.remove(at: index!)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func showDetail(for quake: Quake) {
        let viewController = EarthquakeViewController(quake: quake)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func initialQuakes() {
#if !targetEnvironment(simulator)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let decoded = try! decoder.decode(GeoJSON.self, from: testQuakesData)
        quakes = decoded.quakes
#else
        let client = QuakeClient()
        print(Thread.current)
        Task {
            quakes = try await client.quakes
            updateSnapshot()
        }
#endif
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct EarthquakeListCollectionViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]
    
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                EarthquakeListCollectionViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

