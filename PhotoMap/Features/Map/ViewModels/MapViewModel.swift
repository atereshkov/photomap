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

class MapViewModel: MapViewModelType {
    // MARK: - Variables
    private let cancelBag = CancelBag()
    private let coordinator: MapCoordinator
    private let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    private let locationService: LocationServiceType
    private let diContainer: DIContainerType
    @Published private var isFollowModeOn: Bool = true

    // MARK: - Input
    var categoryButtonSubject = PassthroughSubject<Void, Never>()
    var enableDiscoveryModeSubject = PassthroughSubject<Void, Never>()
    var navigationButtonSubject = PassthroughSubject<Void, Never>()
    var photoButtonSubject = PassthroughSubject<Void, Never>()

    // MARK: - Output
    @Published private(set) var tabTitle: String = L10n.Main.TabBar.Map.title
    @Published private(set) var isShowUserLocation: Bool = true
    @Published private(set) var region: MKCoordinateRegion?
    @Published private(set) var modeButtonCollor: UIColor = Asset.followModeColor.color

    init(coordinator: MapCoordinator,
         diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.diContainer = diContainer
        self.locationService = diContainer.resolve()

        transform()
    }

    private func transform() {
        locationService.isEnable
            .assign(to: \.isShowUserLocation, on: self)
            .store(in: cancelBag)

        locationService.location
            .sink { [weak self] location in
                guard let self = self,
                      self.isFollowModeOn else { return }

                self.region = MKCoordinateRegion(center: location.coordinate,
                                          span: self.coordinateSpan)
            }
            .store(in: cancelBag)

        categoryButtonSubject
            .sink { [weak self] _ in
                print("Category Button Tapped!")
                self?.coordinator.showMapPopup()
            }
            .store(in: cancelBag)

        enableDiscoveryModeSubject
            .sink { [weak self] _ in
                self?.switchFollowDiscoveryMode(disableFolowMode: true)
            }
            .store(in: cancelBag)

        photoButtonSubject
            .sink { [weak self] _ in
                self?.switchFollowDiscoveryMode(disableFolowMode: true)
                self?.coordinator.showPhotoMenuAlert()
            }
            .store(in: cancelBag)

        navigationButtonSubject
            .sink { [weak self] _ in
                self?.switchFollowDiscoveryMode()
            }
            .store(in: cancelBag)
    }

    private func switchFollowDiscoveryMode(disableFolowMode: Bool = false) {
        isFollowModeOn = disableFolowMode ? !disableFolowMode : !isFollowModeOn
        modeButtonCollor = isFollowModeOn ? Asset.followModeColor.color : Asset.discoverModeColor.color
    }
}
