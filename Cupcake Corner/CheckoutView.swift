//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Paul Hudson on 18/11/2021.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order: Order
    
    var body: some View {
        Text("test")
    }
    
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
