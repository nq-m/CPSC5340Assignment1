import SwiftUI

struct GardenItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let icon: String
}

struct ItemRowView: View {
    let item: GardenItem
    @Binding var quantity: Int
    
    var body: some View {
        HStack {
            Image(systemName: item.icon)
                .foregroundColor(.green)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(String(format: "$%.2f", item.price))
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Stepper("\(quantity)", value: $quantity, in: 0...20)
                .frame(width: 110)
        }
        .padding(.vertical, 4)
    }
}

struct ContentView: View {
    @State private var hydrangeaQty = 0
    @State private var hostasQty = 0
    @State private var coneflowersQty = 0
    @State private var catmintQty = 0
    @State private var creepingPhloxQty = 0
    @State private var dayliliesQty = 0
    @State private var pineBarkQty = 0
    @State private var brownMulchQty = 0
    @State private var stirrupHoeQty = 0

    @State private var requiresDelivery = false
    @State private var showConfirmation = false
    
    let hydrangea = GardenItem(name: "Hydrangea (1 Gal)", price: 18.50, icon: "leaf")
    let hostas = GardenItem(name: "Hostas (1 Gal)", price: 12.00, icon: "leaf.circle")
    let coneflowers = GardenItem(name: "Coneflowers (1 Gal)", price: 14.50, icon: "sun.max")
    let catmint = GardenItem(name: "Catmint (1 Gal)", price: 10.00, icon: "leaf")
    let creepingPhlox = GardenItem(name: "Creeping Phlox", price: 8.50, icon: "drop.fill")
    let daylilies = GardenItem(name: "'Stella de Oro' Daylilies", price: 11.00, icon: "sun.min")
    let pineBark = GardenItem(name: "Timberline Pine Bark", price: 4.50, icon: "tree")
    let brownMulch = GardenItem(name: "Earthgro Brown Mulch", price: 3.00, icon: "leaf.fill")
    let stirrupHoe = GardenItem(name: "Stirrup Hoe", price: 24.00, icon: "wrench.and.screwdriver")
    
    var orderTotal: Double {
        let itemsTotal = (Double(hydrangeaQty) * hydrangea.price) +
            (Double(pineBarkQty) * pineBark.price) +
            (Double(brownMulchQty) * brownMulch.price) +
            (Double(stirrupHoeQty) * stirrupHoe.price) +
            (Double(hostasQty) * hostas.price) +
            (Double(coneflowersQty) * coneflowers.price) +
            (Double(catmintQty) * catmint.price) +
            (Double(creepingPhloxQty) * creepingPhlox.price) +
            (Double(dayliliesQty) * daylilies.price)
            
        let deliveryFee = requiresDelivery ? 15.00 : 0.00
        return itemsTotal > 0 ? (itemsTotal + deliveryFee) : 0.00
        }
        
        var totalItems: Int {
            hydrangeaQty + pineBarkQty + brownMulchQty + stirrupHoeQty + hostasQty + coneflowersQty + catmintQty + creepingPhloxQty + dayliliesQty
        }
        
        var isOrderValid: Bool {
            if orderTotal == 0 { return false }
            if requiresDelivery && totalItems < 5 { return false }
            return true
        }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: "leaf.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)
                            .padding()
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("Nursery & Supplies")) {
                    ItemRowView(item: hydrangea, quantity: $hydrangeaQty)
                    ItemRowView(item: pineBark, quantity: $pineBarkQty)
                    ItemRowView(item: brownMulch, quantity: $brownMulchQty)
                    ItemRowView(item: stirrupHoe, quantity: $stirrupHoeQty)
                    ItemRowView(item: hostas, quantity: $hostasQty)
                    ItemRowView(item: coneflowers, quantity: $coneflowersQty)
                    ItemRowView(item: catmint, quantity: $catmintQty)
                    ItemRowView(item: creepingPhlox, quantity: $creepingPhloxQty)
                    ItemRowView(item: daylilies, quantity: $dayliliesQty)
                }
                
                Section(header: Text("Fulfillment")) {
                    Toggle("Require Home Delivery (+$15.00)", isOn: $requiresDelivery)
                        .tint(.green)
                    
                    if requiresDelivery {
                        Text("Delivery requires a 5-bag/item minimum and will be scheduled within 2 business days.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                Section {
                        HStack {
                            Text("Total Amount")
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text(String(format: "$%.2f", orderTotal))
                                            .font(.title3)
                                            .bold()
                                    }
                    
                    Button(action: {
                        showConfirmation = true
                    }) {
                        Text(requiresDelivery && totalItems < 5 && orderTotal > 0 ? "Add \(5 - totalItems) more for delivery" : "Submit Order")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(isOrderValid ? Color.green : Color.gray.opacity(0.3))
                                        .foregroundColor(isOrderValid ? .white : .gray)
                                        .cornerRadius(10)
                    }
                    .disabled(!isOrderValid)
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("MyGardenShop")
            .sheet(isPresented: $showConfirmation) {
                OrderConfirmationView(total: orderTotal)
            }
        }
    }
}

struct OrderConfirmationView: View {
    let total: Double
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Order Confirmed!")
                .font(.largeTitle)
                .bold()
            
            Text(String(format: "Your card will be charged $%.2f.", total))
                .font(.title3)
                .foregroundColor(.secondary)
            
            Button("Return to Shop") {
                dismiss()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding()
    }
}
