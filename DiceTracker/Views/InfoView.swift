//
//  InfoView.swift
//  DiceTracker
//
//  Created by Andrew Ingraham on 12/20/23.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var item: FetchedResults<Item>.Element
    
    var body: some View {
        ZStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("Black")
                        .opacity(0.5))
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            Text("Rolls")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    Text(arrayToString(array: item.data ?? Array(repeating: 0, count: 10)))
                }
                .padding(.top, 25)
                .padding(20)
                
                Text("Total Rolls: \(item.data!.count)")
                    .padding(.bottom, 8)
            }
        }
    }
}

func arrayToString(array: [Int]) -> String {
    var string = "    "
    for value in (0..<array.count) {
        string += " \(array[value])"
    }
    return string
}

struct InfoView_Previews: PreviewProvider {
    static let item = DataController.previewItem
    static let item2 = DataController.previewItem2
    static var previews: some View {
        InfoView(item: item).environment(\.managedObjectContext, DataController.preview.container.viewContext)
        InfoView(item: item2).environment(\.managedObjectContext, DataController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
