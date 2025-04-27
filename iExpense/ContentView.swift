//
//  ContentView.swift
//  iExpense
//
//  Created by evesquare on 2025/04/27.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decordedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decordedItems
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpenses = false
    
    var body: some View {
        NavigationStack {

            
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.type == "Personal" }, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Buisness") {
                    ForEach(expenses.items.filter { $0.type == "Business" }, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            
            }
            .navigationTitle("iExpenses")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpenses = true
                }
            }
            .sheet(isPresented: $showingAddExpenses) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
 
