//
//  GameView.swift
//  DiceTracker
//
//  Created by Andrew Ingraham on 11/21/23.
//

import SwiftUI
import Charts

struct GameView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var editMode = false
    
    @ObservedObject var item: FetchedResults<Item>.Element
    
    @State private var errorWrapper: ErrorWrapper?
    
    @State private var name = ""
    @State private var data: [Int] = Array(repeating: 0, count: 12)
    
    @State private var currentRolls: [Int] = Array(repeating: 6, count: 2)
    
    var body: some View {
            VStack(alignment: .center){
                ZStack {
                    Button {
                        saveItemData()
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color("Black")
                                .opacity(0.5))
                            .padding([.top, .bottom], 5.0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 25, alignment: .leading)
                    if editMode {
                        TextField("\(item.name!)", text: $name, onCommit: { editItem(item: item, name: name)
                        })
                        .background(Color.gray
                            .opacity(0.2))
                        .cornerRadius(30)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 5.0)
                        .padding([.leading, .trailing], 25)
                    } else {
                        Text(item.name ?? "No Item Found")
                            .frame(alignment: .center)
                            .lineLimit(1)
                            .padding(.top, 5)
                            .padding(.bottom, 6.0)
                            .padding([.leading, .trailing], 20)
                    } // If Else (TextField when editMode)
                    Button {
                        editMode.toggle()
                    } label: {
                        if editMode { Image(systemName: "checkmark") }
                        else { Image(systemName: "pencil") }
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 2)
                    .foregroundColor(Color("Black"))
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    // Editbutton (Pencil/CheckMark shape)
                } // HStack for name and edit symbol depends on edit state
                    ZStack{
                        Image(systemName: "squareshape.fill")
                            .resizable()
                            .foregroundColor(Color("Accent2"))
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 5)
                        if (item.gameType == "2Dice") {
                        Chart(Array((item.graphData ?? data).enumerated()), id: \.0) { index, magnitude in
                            if index > 0 && index < 12 {
                                BarMark (
                                    x: .value("Number", String(index + 1)),
                                    y: .value("Magnitude", magnitude))
                                .foregroundStyle(Color("Accent1"))
                            }
                        }// Chart
                        .padding()
                        .chartYAxis(.hidden)
                    } else if (item.gameType == "1Dice") {
                        Image(systemName: "squareshape.fill")
                            .resizable()
                            .foregroundColor(Color("Accent2"))
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 5)
                        Chart(Array((item.graphData ?? data).enumerated()), id: \.0) { index, magnitude in
                            if (index < 6 && index > -1) {
                                BarMark (
                                    x: .value("Number", String(index + 1)),
                                    y: .value("Magnitude", magnitude))
                                .foregroundStyle(Color("Accent1"))
                            }
                        }// Chart
                        .padding()
                        .chartYAxis(.hidden)
                    } // else if 2Dice : 1Dice
                } // ZStack for Graph Background
                HStack {
                    Spacer()
                    if (item.gameType == "2Dice") {
                        ForEach(1..<12) { value in
                            Spacer()
                            Text("\(item.graphData?[value] ?? 0)")
                                .fontWidth(.condensed)
                            Spacer()
                        }
                    } // if 2Dice
                    else {
                        ForEach(0..<6) { value in
                            Spacer()
                            Text("\(item.graphData?[value] ?? 0)")
                                .fontWidth(.condensed)
                            Spacer()
                        }
                    }
                    Spacer()
                } // HStack for bar annotations
                VStack {
                    ZStack {
                        VStack{
                            if (!editMode) {
                                Text("Recently Rolled:")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 2)
                                HStack{
                                    ForEach (0..<5) { value in
                                        if ((item.data!.count) > value) {
                                            Text("\(item.data![item.data!.count - 1 - value])")
                                                .padding(.leading, 1.0)
                                        }
                                    }
                                } // HStack for recent rolls
                                if (item.data!.count == 0) {
                                    Text("No Data")
                                } // if no values
                            }
                            else {
                                if (item.diceType == "physical") {
                                    Button {
                                        item.diceType = "digital"
                                    } label: {
                                        Text("Button Mode")
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                    .frame(maxWidth: 180)
                                }
                                else {
                                    Button {
                                        item.diceType = "physical"
                                    } label: {
                                        Text("Dice Mode")
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                    .frame(maxWidth: 180)
                                }
                            }
                        } // VStack for recent rolls + title
                        .frame(maxHeight: 50)
                        NavigationLink {
                            InfoView(item: item)
                                .toolbar(.hidden)
                        } label: {
                            if !editMode { Image(systemName: "info.circle") }
                        } // Infobutton (info.circle shape)
                        .padding(.bottom, 3.0)
                        .foregroundColor(Color("Black"))
                        .opacity(0.5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    } // ZStack for recent rolls + info button
                    if (item.diceType == "digital") {
                        ZStack{
                            Image(systemName: "squareshape.fill")
                                .resizable()
                                .foregroundColor(Color("Accent1"))
                                .cornerRadius(20)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                            HStack{
                                if (item.gameType == "2Dice") {
                                    Button {
                                        currentRolls = rollDice(item: item, diceCount: 2, minRoll: 1, maxRoll: 6)
                                    } label: {
                                        Image("Dice\(currentRolls[0])")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(13)
                                            .transaction { transaction in
                                                transaction.animation = nil
                                            }
                                    }
                                    .padding([.top, .leading, .bottom], 10)
                                    Button {
                                        currentRolls = rollDice(item: item, diceCount: 2, minRoll: 1, maxRoll: 6)
                                    } label: {
                                        Image("Dice\(currentRolls[1])")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(13)
                                            .transaction { transaction in
                                                transaction.animation = nil
                                            }
                                    }
                                    .padding([.top, .bottom, .trailing], 10)
                                }
                                else if (item.gameType == "1Dice") {
                                    Button {
                                    currentRolls = rollDice(item: item, diceCount: 1, minRoll: 1, maxRoll: 6)
                                    } label: {
                                        Image("Dice\(currentRolls[0])")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(19)
                                            .transaction { transaction in
                                                transaction.animation = nil
                                            }
                                    }
                                    .padding([.top, .bottom], 10)
                                }
                            } // HStack lays dice next to each other
                        } // ZStack lays the dice overtop of the border
                    } // if "digital" dice
                    if (item.diceType == "physical") {
                        if (item.gameType == "2Dice") {
                            HStack {
                                ForEach (2..<6) { value in
                                    Button("\(value)") {
                                        rollAdd(item: item, num: value)
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                }
                            } // HStack Buttons 2-5
                            HStack {
                                ForEach (6..<10) { value in
                                    Button("\(value)") {
                                        rollAdd(item: item, num: value)
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                }
                            } // HStack Buttons 6-9
                            HStack {
                                Button("-") {
                                    if (item.data!.count > 0) {
                                        undo(item: item)
                                    }
                                }
                                .buttonStyle(regButton(color: Color("Accent1")))
                                
                                ForEach (10..<13) { value in
                                    Button("\(value)") {
                                        rollAdd(item: item, num: value)
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                } // ForEach
                            } // HStack Buttons 10-12 + undo
                        } // If 2Dice
                        else if (item.gameType == "1Dice") {
                            HStack {
                                ForEach (1..<3) { value in
                                    Button("\(value)") {
                                        rollAdd(item: item, num: value)
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                }
                            } // HStack Buttons 1-2
                            HStack {
                                ForEach (3..<5) { value in
                                    Button("\(value)") {
                                        rollAdd(item: item, num: value)
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                }
                            } // HStack Buttons 3-4
                            HStack {
                                ForEach (5..<7) { value in
                                    Button("\(value)") {
                                        rollAdd(item: item, num: value)
                                    }
                                    .buttonStyle(regButton(color: Color("Accent1")))
                                } // ForEach
                            } // HStack Buttons 5-6
                            Button("-") {
                                if (item.data!.count > 0) {
                                    undo(item: item)
                                }
                            } // undo
                            .buttonStyle(regButton(color: Color("Accent1")))
                        } // if 1Dice
                    } // if "physical" dice
                } // Buttons VStack
            } // VStack
            .padding(.top, 3.0)
            .padding([.leading, .bottom, .trailing])
            .background(Color("Accent3"))
            .sheet(item: $errorWrapper) {
                        } content: { wrapper in
                            ErrorView(errorWrapper: wrapper)
                        }
        }
    
    func editItem(item: Item, name: String) {
        item.name = name
        saveItemData()
    }
    
    func rollAdd(item: Item, num: Int) {
        item.graphData![num - 1] += 1
        item.data!.append(num)
        saveItemData()
    }

    func undo(item: Item) {
        item.graphData![item.data!.removeLast() - 1] -= 1
        saveItemData()
    }
    
    func rollDice(item: Item, diceCount: Int, minRoll: Int, maxRoll: Int) -> [Int] {
        var roll = 0
        var currentRoll = [Int](repeating: 1, count: diceCount)
        for value in 0..<diceCount {
            currentRoll[value] = Int.random(in: minRoll..<(maxRoll+1))
            roll += currentRoll[value]
        }
        rollAdd(item: item, num: roll)
        saveItemData()
        
        return currentRoll
    }
    
    func saveItemData() {
        do {
            try viewContext.save()
        } catch {
            errorWrapper = ErrorWrapper(error: error, guidance: "The game data could not be saved.")
        }
    }
}

struct selectButton: ButtonStyle
{
    var color: Color
    var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(systemName: "squareshape.fill")
                .resizable()
                .foregroundColor(color.opacity(isPressed ? 1 : 0.5))
                .cornerRadius(20)
            
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black,lineWidth: isPressed ? 4 : 2)
            configuration.label
        }
    }
}
struct regButton: ButtonStyle
{
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Image(systemName: "squareshape.fill")
                .resizable()
                .foregroundColor(color)
                .cornerRadius(20)
                
            RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
            configuration.label
        }
    }
}

struct textField: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(5)
        .background(Color.gray
            .opacity(0.2))
        .cornerRadius(30)
        .multilineTextAlignment(.center)
    }
}

struct GameView_Previews: PreviewProvider {
    static let item = DataController.previewItem
    static let item2 = DataController.previewItem2
    static var previews: some View {
        GameView(item: item).environment(\.managedObjectContext, DataController.preview.container.viewContext)
        GameView(item: item2).environment(\.managedObjectContext, DataController.preview.container.viewContext)
        GameView(item: item).environment(\.managedObjectContext, DataController.preview.container.viewContext)
            .preferredColorScheme(.dark)
        GameView(item: item2).environment(\.managedObjectContext, DataController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
