//
//  AppleITunesResult.swift
//  Cupcake Corner
//
//  Created by Takasur Azeem on 20/04/2022.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct AppleITunesResult: View {
    
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=sami+yusuf&entity=song") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            } else {
                print("Decoding failed")
            }
            
        } catch {
            print("invalid data")
        }
    }
}

struct AppleITunesResult_Previews: PreviewProvider {
    static var previews: some View {
        AppleITunesResult()
    }
}
