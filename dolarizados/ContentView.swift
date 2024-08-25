//
//  ContentView.swift
//  dolarizados
//
//  Created by Leandro Bordon on 25/08/2024.
//

import SwiftUI

var apiUrl: String = "https://dolarapi.com/v1/dolares";

struct ContentView: View {
    @State private var dolarData: [DolarInfo] = []
    @State private var refreshCounter = 0 // Variable para controlar la actualización

    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green, Color.accentColor, Color.green, Color.accentColor], startPoint: .top, endPoint: .bottomLeading)
                .ignoresSafeArea()
            VStack(alignment: .center){
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 30,height: 30)
                    Text("Dolarizados")
                        .font(.largeTitle)
                        .fontWeight(.light)
                    Button {
                        print("Refresh data")
                        refreshCounter += 1
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    
                }
                
                
                
                ForEach(dolarData.filter { info in
                    info.nombre.lowercased() == "blue"
                }, id: \.casa) { info in
                    LastUpdate(fechaActualizacion: dolarData[0].fechaActualizacion)}
                Spacer()
                VStack{
                    ForEach(dolarData.filter { info in
                        info.nombre.lowercased() == "cripto" || info.nombre.lowercased() == "blue"
                    }, id: \.casa) { info in
                        HeadCardView(Title: info.nombre, BuyPrice: String(info.compra), SellPrice: String(info.venta))
                    }
                }
            
                Spacer()

                ScrollView {
                    VStack{
                        Text("Diferentes cotizaciones 👇")
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(Color.white)
                    }
                           LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                               ForEach(dolarData, id: \.casa) { info in
                                   DolarCardView(title: info.nombre, BuyPrice: "$\(info.compra)", SellPrice: "$\(info.venta)")
                               }
                           }
                         
                }
                Spacer()
                Button(action: {
                    print("Convertidor")
                }, label: {
                    VStack(alignment: .center) {
                        HStack(alignment: .center) {
                            Text("Convertidor")
                                .font(.title)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            
                            Image(systemName: "repeat" )
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color.black)
                        }
                        .padding(.top)
                        VStack(alignment: .center){
                            Text("Convierte cualquier valor a pesos")
                                .fontWeight(.ultraLight)
                                .foregroundColor(Color.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                  
                    .background()
                 
                   
                    
                      
                        
                })
                  
               
            }


        }
        .refreshable {
            fetchData()
        }
        .onAppear {
                   fetchData()
               }
    }
    
    private func fetchData() {
           guard let url = URL(string: "https://dolarapi.com/v1/dolares") else { return }

           URLSession.shared.dataTask(with: url) { data, _, error in
               if let error = error {
                   print("Error fetching data: \(error)")
                   return
               }

               if let data = data {
                   do {
                       let decoder = JSONDecoder()
                       let dolarInfo = try decoder.decode([DolarInfo].self, from: data)
                       DispatchQueue.main.async {
                           self.dolarData = dolarInfo
                           print(dolarInfo);
                       }
                   } catch {
                       print("Error decoding data: \(error)")
                   }
               }
           }.resume()
       }
}



struct LastUpdate: View {
    var fechaActualizacion: String;
    var body: some View {
        VStack{
            Text("Última actualizacion")
                .font(.subheadline)
                .fontWeight(.ultraLight)
            Text(fechaActualizacion)
                .font(.subheadline)
                .fontWeight(.ultraLight)
        }
    }
}


struct DolarInfo: Codable {
    let moneda: String
    let casa: String
    let nombre: String
    let compra: Double
    let venta: Double
    let fechaActualizacion: String
}


struct DolarCardView: View {
    var title: String;
    var BuyPrice: String;
    var SellPrice: String;
    
    var body: some View{
        VStack(alignment: .center){
            HStack(alignment: .center) {
                HStack(alignment: .center) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.light)
                    .foregroundColor(Color.white)
                }
            }
            HStack(alignment: .center) {
               
                VStack(alignment: .leading) {
                    Text("Compra")
                        .font(.headline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .opacity(0.7)
                    Text(BuyPrice)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                }
      
                VStack(alignment: .leading) {
                    Text("Venta")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black)
                        .opacity(0.7)
                    Text(SellPrice)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                }
          
            }
        }
        
        
       
    }
}

struct HeadCardView: View {
    var Title: String;
    var BuyPrice: String;
    var SellPrice: String;
    var body: some View {
        HStack(alignment: .top){
            VStack(alignment: .leading) {
                Text(Title)
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
            }
            .padding(.trailing)
            VStack(alignment: .leading){
                
                HStack(alignment: .center) {
                   
                    VStack(alignment: .leading) {
                        Text("Compra")
                            .font(.headline)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                            .opacity(0.7)
                        Text("$\(BuyPrice)")
                            .font(.title2)
                            .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    }
          
                    VStack(alignment: .leading) {
                        Text("Venta")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                            .opacity(0.7)
                        Text("$\(SellPrice)")
                            .font(.title2)
                            .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    }
              
                }
                    .font(.title)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
               
                
            }
            
            
        }

        .padding()
    }
}


#Preview {
    ContentView()
}
