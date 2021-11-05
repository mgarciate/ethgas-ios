//
//  ChartsView.swift
//  ethgas-ios
//
//  Created by mgarciate on 06/02/2021.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @Binding var actionSheet: MainActionSheet?
    
    private let firebaseService: FirebaseService = FirebaseServiceImpl()
    @State private var dailyEntries = [GraphEntry]()
    @State private var weeklyEntries = [GraphEntry]()
    
    var body: some View {
        VStack {
            HStack {
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text(Resources.Strings.Common.appName)
                    .font(Font.title3.bold())
                Spacer()
                Button(action: {
                    actionSheet = nil
                }) {
                    Image(systemName: "multiply")
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                        .foregroundColor(Color("White"))
                        .background(Color("Black"))
                        .cornerRadius(15)
                    
                }
                .frame(height: 30)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            VStack {
                if dailyEntries.count > 0 {
                    LineView(entries: dailyEntries, graphType: .daily, description: Resources.Strings.Charts._24h)
                        .frame(minHeight: 0, maxHeight: .infinity)
                }
                if weeklyEntries.count > 0 {
                    LineView(entries: weeklyEntries, graphType: .weekly, description: Resources.Strings.Charts._7d)
                        .frame(minHeight: 0, maxHeight: .infinity)
                }
                Spacer()
            }
            .padding([.horizontal, .bottom])
        }
        .onAppear() {
            firebaseService.graphs { result in
                switch result {
                case.success(let graphs):
                    dailyEntries = graphs.daily
                    weeklyEntries = graphs.weekly
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(actionSheet: .constant(.graphs))
    }
}
