//
//  Router.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 16/05/25.
//


import Foundation
import SwiftUI

public final class Router<Routes: Routable>: RoutableObject, ObservableObject {
    public typealias Destination = Routes

    @Published public var stack: [Routes] = []

    public init() {}
}