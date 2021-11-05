//
//  ItemFeeView.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/11/21.
//

import SwiftUI

struct ItemFeeView: View {
    let title: String
    let gasLimit: Int
    let fastest: Int
    let fast: Int
    let average: Int
    let ethusd: Double
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("\(title) -")
                Text("\(gasLimit)")
                    .foregroundColor(.gray)
            }
            LazyVGrid(columns: columns, spacing: 20) {
                VStack(spacing: 5) {
                    Text(Resources.Strings.Common.Speed.fastest.uppercased())
                    Text("$\(String(format: "%.2f", (Double(gasLimit * fastest) / 1000000000) * ethusd))")
                        .bold()
                }
                .foregroundColor(.pink)
                VStack(spacing: 5) {
                    Text(Resources.Strings.Common.Speed.fast.uppercased())
                    Text("$\(String(format: "%.2f", (Double(gasLimit * fast) / 1000000000) * ethusd))")
                        .bold()
                }
                .foregroundColor(.blue)
                VStack(spacing: 5) {
                    Text(Resources.Strings.Common.Speed.standard.uppercased())
                    Text("$\(String(format: "%.2f", (Double(gasLimit * average) / 1000000000) * ethusd))")
                        .bold()
                }
                .foregroundColor(.green)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
        }
    }
}

struct ItemFeeView_Previews: PreviewProvider {
    static var previews: some View {
        ItemFeeView(title: "ETH Transfer", gasLimit: 21000, fastest: 100, fast: 50, average: 25, ethusd: 4000)
            .previewLayout(.fixed(width: 340, height: 100))
    }
}
