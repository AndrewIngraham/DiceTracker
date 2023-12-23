//
//  GameSettingsView.swift
//  DiceTracker
//
//  Created by Andrew Ingraham on 12/18/23.
//

import SwiftUI

struct GameSettingsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)])
    private var items: FetchedResults<Item>
    
    @State private var errorWrapper: ErrorWrapper?
    @State private var name = "New Game"
    @State private var gameType = "2Dice"
    @State private var diceType = "physical"
    
    var body: some View {
        NavigationStack{
            
            VStack{
                ZStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color("Black")
                                .opacity(0.5))
                            .padding(.bottom, 5.0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 25, alignment: .leading)
                    VStack {
                        Text("Settings")
                            .font(.title)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Name:")
                            .padding([.top], 2)
                        TextField("New Name", text: $name)
                            .textFieldStyle(textField())
                            .padding([.leading, .trailing], 40)
                    } // VStack
                } // ZStack <, name, settings
                Text("Dice Count:")
                    .padding(.top, 5)
                HStack{
                    VStack {
                        Button {
                            gameType = "2Dice"
                        } label: {
                            VStack{
                                Image("Dice1")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                                    .padding([.top, .leading, .trailing], 10)
                                Image("Dice2")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                                    .padding([.bottom, .leading, .trailing], 10)
                            }
                            .frame(minHeight: 75)
                        }
                        .buttonStyle(selectButton(color: Color("Accent1"), isPressed: (gameType == "2Dice")))

                        Text("Roll two dice")
                    }
                    VStack{
                        Button {
                            gameType = "1Dice"
                        } label: {
                            Image("Dice1")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(5)
                                .padding(40)
                        }
                        .frame(minHeight: 75)
                        .buttonStyle(selectButton(color: Color("Accent1"), isPressed: (gameType == "1Dice")))

                        Text("Roll one dice")
                    }
                } // HStack for Dice selection
                Text("Dice Type:")
                    .padding(.top, 10)
                HStack{
                    VStack{
                        Button {
                            diceType = "physical"
                        } label: {
                            Image("Buttons")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding(5)
                        }
                        .buttonStyle(selectButton(color: Color("Accent1"), isPressed: (diceType == "physical")))
                        Text("Physical Dice - Choose if you would like to input your rolls.")
                            .frame(height: 100, alignment: .top)
                            .padding([.top, .bottom], 5)
                    } // VStack for Physical Option
                    VStack{
                        Button {
                            diceType = "digital"
                        } label: {
                            Image("DiceButton")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding(5)
                        }
                        .buttonStyle(selectButton(color: Color("Accent1"), isPressed: (diceType == "digital")))
                        Text("Digital Dice - Choose if you would like to roll dice inside of the app.")
                            .frame(height: 100, alignment: .top)
                            .padding([.top, .bottom], 5)
                    } // VStack for Digital Option
                } // HStack for input type
                HStack{
                    Button("Return") {
                        dismiss()
                    }
                    .frame(width: 150, height: 50)
                    .buttonStyle(regButton(color: Color("Accent1")))
                    .padding(.trailing, 20)
                    
                    Button {
                        addItem()
                        dismiss()
                    } label: {
                        Text("Confirm")
                    }
                    .frame(width: 150, height: 50)
                    .buttonStyle(regButton(color: Color("Accent1")))
                } // HStack to return to menu
            } // VStack
            .padding()
        } // ZStack
        .sheet(item: $errorWrapper) {
                    } content: { wrapper in
                        ErrorView(errorWrapper: wrapper)
                    }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = name
            newItem.date = Date()
            newItem.data = [Int]()
            newItem.graphData = Array(repeating: 0, count: 12)
            newItem.gameType = gameType
            newItem.diceType = diceType
            
            do {
                try viewContext.save()
            } catch {
                errorWrapper = ErrorWrapper(error: error, guidance: "The game could not be created.")
            }
        }
    }
}

struct GameSettingsView_Previews: PreviewProvider {
    static let item = Item(context: DataController.preview.container.viewContext)
    static var previews: some View {
        GameSettingsView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
        GameSettingsView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
