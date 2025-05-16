//
//  ContentView.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
