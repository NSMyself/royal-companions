//
//  FeedFlowController.swift
//  Babylon iOS Interview Demo
//
//  Created by João Pereira on 23/01/2019.
//  Copyright © 2019 NSMyself. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol FeedChildBuilders {
    func makeDetailedPost(
        modal: Flow,
        navigation: Flow
    ) -> UIViewController
}

class FeedFlowController {
    
    private let modalFlow: Flow
    private let navigationFlow: Flow
    private let builder: FeedBuilder
    
    init(modal: Flow, navigation: Flow, builder: FeedBuilder) {
        self.modalFlow = modal
        self.navigationFlow = navigation
        self.builder = builder
    }
    
    func observe(_ output: Signal<FeedViewModel.Route, NoError>) {
        
    }
}

extension FeedFlowController {
    func handle(_ route: FeedViewModel.Route) {
        switch route {
        case let .showAlert(error):
            print("SHOW ERROR: \(error)")
        case let .showFeed(feed, error):
            print("SHOW FEED WITH ERROR \(error)")
        case .showLoading():
            print("SHOW LOADING")
        case let .showPost(post):
            print("SHOW POST")
        }
    }
}
