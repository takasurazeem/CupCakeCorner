//
//  CustomDecoderEncoder.swift
//  Cupcake Corner
//
//  Created by Takasur Azeem on 26/03/2022.
//

import Foundation

class User: ObservableObject, Codable {
    @Published var name = "Takasur Azeem"
 
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
    enum CodingKeys: CodingKey {
        case name
    }
}
