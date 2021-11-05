//
//  FeesView.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/11/21.
//

import SwiftUI

struct FeesView: View {
    @Binding var currentData: CurrentData
    @Binding var actionSheet: MainActionSheet?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
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
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    CardValueSmallView(viewModel: CardValueViewModel(value: currentData.fastest, color: .pink, title: Resources.Strings.Common.Speed.fastest.uppercased(), subtitle: ""))
                    CardValueSmallView(viewModel: CardValueViewModel(value: currentData.fast, color: .blue, title: Resources.Strings.Common.Speed.fast.uppercased(), subtitle: ""))
                    CardValueSmallView(viewModel: CardValueViewModel(value: currentData.average, color: .green, title: Resources.Strings.Common.Speed.standard.uppercased(), subtitle: ""))
                }
                .padding(10)
                VStack {
                    VStack {
                        ItemFeeView(title: "ETH Transfer", gasLimit: 21000, fastest: currentData.fastest, fast: currentData.fast, average: currentData.average, ethusd: currentData.ethusd)
                        Spacer()
                            .frame(height: 20)
                        ItemFeeView(title: "ERC20 Transfer", gasLimit: 65000, fastest: currentData.fastest, fast: currentData.fast, average: currentData.average, ethusd: currentData.ethusd)
                        Spacer()
                            .frame(height: 20)
                        ItemFeeView(title: "Uniswap Swap", gasLimit: 200000, fastest: currentData.fastest, fast: currentData.fast, average: currentData.average, ethusd: currentData.ethusd)
                        Spacer()
                            .frame(height: 20)
                        ItemFeeView(title: "Uniswap Add/Remove LP", gasLimit: 175000, fastest: currentData.fastest, fast: currentData.fast, average: currentData.average, ethusd: currentData.ethusd)
                    }
                    Spacer()
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
}

struct FeesView_Previews: PreviewProvider {
    static var previews: some View {
        FeesView(currentData: .constant(CurrentData.dummyData), actionSheet: .constant(.fees))
    }
}
