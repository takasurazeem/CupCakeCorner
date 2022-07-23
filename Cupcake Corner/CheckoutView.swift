//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Paul Hudson on 18/11/2021.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var alertTitle = "Thank you!"
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityHidden(true)
                
                Text("Your total is \(order.data.cost, format: .currency(code: Locale.current.currencyCode ?? "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .alert(alertTitle, isPresented: $showingConfirmation) {
            Button("Ok") {}
        } message: {
            Text(confirmationMessage)
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order.data) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(OrderModel.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
        } catch let error {
            alertTitle = "Order Failed"
            confirmationMessage = error.localizedDescription
            print("Checkout failed.")
        }
        showingConfirmation = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
