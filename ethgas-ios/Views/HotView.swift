//
//  HotView.swift
//  ethgas-ios
//
//  Created by mgarciate on 23/03/2021.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import Combine

class HotViewModel: ObservableObject {
    let ref = Database.database().reference()
    @Published var hotEntries = [IndexPath: HotEntry?]()
    @Published var typeSelected = 1
    
    private var weeklyEntries = [GraphEntry]()
    private var handler: UInt?
    
    init() {
        print("init")
        fetchData()
    }
    
    deinit {
        print("deinit \(handler)")
        guard let handler = handler else {
            return
        }
        print("Cancel \(handler)")
        ref.removeObserver(withHandle: handler)
    }
    
    func fetchData() {
        guard let _ = Auth.auth().currentUser else { return }
        handler = ref.child("gasprice/graph").observe(.value) { snapshot in
            print("*** fetchData \(self.handler)")
            var dailyEntries = [GraphEntry]()
            for child in snapshot.childSnapshot(forPath: "daily").children {
                guard let value = (child as? DataSnapshot)?.value as? NSDictionary,
                      let timestamp = value["timestamp"] as? Int,
                      let ethusd = value["ethusd"] as? Double,
                      let fastest = value["fastest"] as? Int,
                      let fast = value["fast"] as? Int,
                      let average = value["average"] as? Int else {
                    return
                }
                dailyEntries.append(GraphEntry(timestamp: timestamp, ethusd: ethusd, fastest: fastest, fast: fast, average: average))
            }
            self.weeklyEntries = snapshot.childSnapshot(forPath: "weekly").children.map { (child) -> GraphEntry in
                guard let value = (child as? DataSnapshot)?.value as? NSDictionary,
                      let timestamp = value["timestamp"] as? Int,
                      let ethusd = value["ethusd"] as? Double,
                      let fastest = value["fastest"] as? Int,
                      let fast = value["fast"] as? Int,
                      let average = value["average"] as? Int else {
                    return GraphEntry(timestamp: 0, ethusd: 0, fastest: 0, fast: 0, average: 0)
                }
                return GraphEntry(timestamp: timestamp, ethusd: ethusd, fastest: fastest, fast: fast, average: average)
            }
            self.formatWeeklyEntries()
        }
    }
    
    private func formatWeeklyEntries() {
        var aux = [IndexPath: HotEntry?]()
        let values: [Int] = weeklyEntries.map {
            switch typeSelected {
            case 0:
                return $0.fastest
            case 1:
                return $0.fast
            default:
                return $0.average
            }
        }
        let valueMin = values.min() ?? 0
        let valueMax = values.max() ?? Int.max
        weeklyEntries.forEach { entry in
            if let day = entry.dayDifference, day < 7, day >= 0, let hour = entry.hour, hour < 24, hour >= 0 {
                let value: Int
                switch typeSelected {
                case 0:
                    value = entry.fastest
                case 1:
                    value = entry.fast
                default:
                    value = entry.average
                }
                aux[IndexPath(row: hour, section: day)] = HotEntry(entry: entry, value: value, alpha: (Double(entry.fast - valueMin) / Double(valueMax - valueMin)))
            }
        }
        hotEntries = aux
        print("*** \(hotEntries.count)")
    }
    
    func valueSelected(_ value: Int) {
        formatWeeklyEntries()
    }
}

struct HotView: View {
    @Binding var actionSheet: MainActionSheet?
    @ObservedObject private var viewModel = HotViewModel()
    
    @State private var isPopupPresented = false
    @State private var selectedEntry: HotEntry?
    
    let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("ETHGas Alerts")
                        .font(Font.title3.bold())
                    Spacer()
                    Button(action: {
                        actionSheet = nil
                    }) {
                        Image(systemName: "multiply")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(15)
                    }
                    .frame(height: 30)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                Picker(selection: $viewModel.typeSelected.onChange(viewModel.valueSelected), label: Text("Gas type")) {
                    Text(AlertGasType.fastest.rawValue.uppercased()).tag(0)
                    Text(AlertGasType.fast.rawValue.uppercased()).tag(1)
                    Text(AlertGasType.standard.rawValue.uppercased()).tag(2)
                }
                .padding(.horizontal)
                .padding(.top, -5)
                .padding(.bottom, 0)
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                if !viewModel.hotEntries.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 1) {
                            HStack(spacing: 1) {
                                Text("")
                                    .frame(width: 60)
                                Text("\(startDate())")
                                Rectangle()
                                    .frame(height: 1)
                                    .padding(.horizontal, 5)
                                Text("Today")
                            }
                            ForEach(0..<24, id: \.self) { index in
                                HStack(spacing: 1) {
                                    Text("\(String(format: "%02d", index)):00")
                                        .frame(width: 60)
                                    ForEach((0..<7).reversed(), id: \.self) { j in
                                        Button(action: {
                                            if let value = viewModel.hotEntries[IndexPath(row: index, section: j)] {
                                                selectedEntry = value
                                                isPopupPresented = true
                                            }
                                        }) {
                                            ZStack {
                                                if let value = viewModel.hotEntries[IndexPath(row: index, section: j)], let hotEntry = value {
                                                    Color.red.opacity(hotEntry.alpha)
                                                    Text("\(hotEntry.value)")
                                                        .foregroundColor(Color("Black"))
                                                } else {
                                                    Color.clear
                                                    Text("")
                                                }
                                            }
                                            .cornerRadius(4.0)
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                                        }
                                    }
                                }
                            }
                            HStack(spacing: 1) {
                                Text("")
                                    .frame(width: 60)
                                Text("\(startDate())")
                                Rectangle()
                                    .frame(height: 1)
                                    .padding(.horizontal, 5)
                                Text("Today")
                            }
                        }
                        .padding([.horizontal, .bottom], 10)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
            if $isPopupPresented.wrappedValue {
                ZStack {
                    Color("White")
                    VStack {
                        HStack {
                            Text("\(selectedEntry?.entry.dateString ?? "")")
                            Spacer()
                        }
                        .foregroundColor(Color("Black"))
                        .padding(.bottom, 2)
                        HStack {
                            HStack {
                                Text("Gas price")
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.red.opacity(selectedEntry?.alpha ?? 0.0))
                            }
                            Spacer()
                            Text("Gwei")
                        }
                        .padding(.bottom, 2)
                        .foregroundColor(Color("Gray"))
                        HStack {
                            Text("Fastest")
                            Spacer()
                            if let value = selectedEntry?.entry.fastest {
                                Text("\(value)")
                            }
                        }
                        .foregroundColor(Color("Black"))
                        HStack {
                            Text("Fast")
                            Spacer()
                            if let value = selectedEntry?.entry.fast {
                                Text("\(value)")
                            }
                        }
                        .foregroundColor(Color("Black"))
                        HStack {
                            Text("Standard")
                            Spacer()
                            if let value = selectedEntry?.entry.average {
                                Text("\(value)")
                            }
                        }
                        .foregroundColor(Color("Black"))
                        Spacer()
                        VStack(alignment: .center) {
                            Button(action: {
                                isPopupPresented = false
                            }, label: {
                                Text("Close")
                            })
                        }
                    }.padding()
                }
                .frame(width: 300, height: 200)
                .cornerRadius(20).shadow(radius: 20)
            }
        }
        .onAppear() {
            print("*** onAppear")
        }
        .onDisappear() {
            print("*** onDisappear")
        }
    }
    
    private func startDate() -> String {
        guard let date = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM dd" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
}

struct HotView_Previews: PreviewProvider {
    static var previews: some View {
        HotView(actionSheet: .constant(.hot))
    }
}

fileprivate extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
