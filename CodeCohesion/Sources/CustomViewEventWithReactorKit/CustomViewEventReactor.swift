//
//  CustomViewEventReactor.swift
//  CodeCohesion
//
//  Created by jc.kim on 8/1/22.
//

import ReactorKit

final class CustomViewEventReactor: Reactor {
    
    enum Action {
        case send(String)
    }
    
    enum Mutaion {
        case addMessage(String)
    }
    
    struct State {
        var chats: [String] = []
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case let .send(text):
            return Observable.just(text)
                .map { text in Mutaion.addMessage(text) }
        }
    }
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var state = state
        switch mutation {
        case let .addMessage(text):
            state.chats.append(text)
            return state
        }
    }
    
    
    
}
