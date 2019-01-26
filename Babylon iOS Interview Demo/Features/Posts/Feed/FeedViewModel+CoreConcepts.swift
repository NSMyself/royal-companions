//
//  FeedViewModel+StateMachine.swift
//  Babylon iOS Interview Demo
//
//  Created by João Pereira on 24/01/2019.
//  Copyright © 2019 NSMyself. All rights reserved.
//

import Foundation



extension FeedViewModel {
    
    enum State: Equatable {
        case loading
        case loaded(Feed, StoreError?)
        case loadingFailed(StoreError)
        case showing(postId: Int)
    }
    
    enum Event: Equatable {
        case didLoad(Feed)
        case didFail(StoreError)
        case ui(Action)
    }
    
    enum Action: Equatable {
        case retry
        case didSelect(postId: Int)
    }
    
    enum Route {
        case showLoading()
        case showFeed(feed: Feed)
        case showAlert(alert: StoreError)
        case showPost(_ post: Int)
    }
}