//
//  MapViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine
import CoreLocation
import MapKit

class MapViewModel: NSObject, MapViewModelType {
    // MARK: - Variables
    private let cancelBag = CancelBag()
    private let coordinator: MapCoordinator
    private let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    private let locationService: LocationServiceType
    @Published private var isFollowModeOn: Bool = true

    // MARK: - Input

    // MARK: - Output
    @Published private(set) var tabTitle: String = L10n.Main.TabBar.Map.title
    @Published private(set) var isShowUserLocation: Bool = true
    @Published private(set) var region: MKCoordinateRegion?
    @Published private(set) var modeButtonCollor: UIColor = Asset.followModeColor.color

    init(coordinator: MapCoordinator,
         locationService: LocationServiceType = LocationService()) {
        self.coordinator = coordinator
        self.locationService = locationService
        super.init()

        transform()
    }

    private func transform() {
        locationService.isEnable
            .assign(to: \.isShowUserLocation, on: self)
            .store(in: cancelBag)

        $isFollowModeOn
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self = self else { return }

                self.region = MKCoordinateRegion(center: self.locationService.currentCoordinate,
                                                 span: self.coordinateSpan)
            }
            .store(in: cancelBag)

        locationService.location
            .sink { [weak self] location in
                guard let self = self,
                      self.isFollowModeOn else { return }

                self.region = MKCoordinateRegion(center: location.coordinate,
                                          span: self.coordinateSpan)
            }
            .store(in: cancelBag)
    }

    func switchFollowDiscoveryMode() {
        isFollowModeOn = !isFollowModeOn
        modeButtonCollor = isFollowModeOn ? Asset.followModeColor.color : Asset.discoverModeColor.color
    }
}
