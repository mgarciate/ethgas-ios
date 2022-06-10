//
//  CardValueView.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/08/2021.
//

import SwiftUI

struct CardValueView: View {
    @ObservedObject var viewModel: CardValueViewModel
    
    var body: some View {
        HStack {
            Text("\(viewModel.value)")
                .frame(minWidth: 70)
                .font(.title)
                .foregroundColor(viewModel.color)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 1)
            Spacer()
                .frame(width: 20)
            HStack {
                Text("\(viewModel.title)")
                Text("\(viewModel.subtitle)")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

struct CardValueView_Previews: PreviewProvider {
    static var previews: some View {
        CardValueView(viewModel: CardValueViewModel(value: 100, color: .blue, title: "FASTEST", subtitle: "< ASAP"))
            .previewLayout(.fixed(width: 350, height: 100))
    }
}
