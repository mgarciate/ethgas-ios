//
//  CardValueSmallView.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/11/21.
//

import SwiftUI

struct CardValueSmallView: View {
    @ObservedObject var viewModel: CardValueViewModel
    
    var body: some View {
        VStack {
            Text("\(viewModel.value)")
                .frame(minWidth: 70, maxHeight: 30)
                .font(.title)
                .foregroundColor(viewModel.color)
            Rectangle()
                .foregroundColor(.gray)
                .frame(height: 1)
                .padding(.top, -5)
            Spacer()
                .frame(height: 10)
            HStack {
                Text(viewModel.title)
                    .font(.caption)
            }
            .padding(.top, -5)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

struct CardValueSmallView_Previews: PreviewProvider {
    static var previews: some View {
        CardValueSmallView(viewModel: CardValueViewModel(value: 100, color: .blue, title: "FAST", subtitle: ""))
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
