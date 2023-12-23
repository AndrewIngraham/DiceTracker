//
//  ContentView.swift
//  DiceTracker
//
//  Created by Andrew Ingraham on 11/16/23.
//

// Main content view, default (Menu Screen)

import SwiftUI

struct MenuView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)])
    private var items: FetchedResults<Item>
    
    @State private var errorWrapper: ErrorWrapper?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
            NavigationStack {
                VStack{
                    Text("Dice Tracker")
                        .font(.title)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    NavigationLink {
                        GameSettingsView()
                            .toolbar(.hidden)
                    } label: {
                        Text("New Game")
                    }
                    .buttonStyle(regButton(color: Color("Accent3")))
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding(.bottom, 5)
                    List {
                        ForEach(items) {item in
                            NavigationLink(destination: GameView(item: item)
                                .toolbar(.hidden)) {
                                    VStack{
                                        Text(item.name!)
                                            .fontWeight(.bold)
                                        Text("\(item.date!.formatted(date: .numeric, time: .shortened))")
                                            .fontWeight(.thin)
                                    } // VStack item name + date created
                            } // NavigationLink
                        } // ForEach
                        .onDelete(perform: deleteItem)
                    } // List
                    .cornerRadius(30)
                    
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .frame(maxWidth: 150, maxHeight: 40)
                        .padding(.bottom, 0)
            } // VStack
                .padding()
                .background(Color("Accent1"))
                
        } // NavigationStack
            .sheet(item: $errorWrapper) {
                        } content: { wrapper in
                            ErrorView(errorWrapper: wrapper)
                        }
    } // View
    
    
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
                print("Game data saved")
            } catch {
                errorWrapper = ErrorWrapper(error: error, guidance: "The item data could not be deleted.")
            }
        }
    } // deleteItem used with onDelete 
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
        MenuView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
