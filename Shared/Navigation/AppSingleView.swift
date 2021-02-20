//
//  AppSingolView.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/15.
//

import SwiftUI

var SCREENWIDTH = UIScreen.main.bounds.width
var SCREENHEIGHT = UIScreen.main.bounds.height

struct AppSingleView: View {
    @State private var isShowPetRegisterView = false
    @State private var isShowSettingView = false
    @State private var isShowWakanda = false
    @State private var status: String = "😀"
    @State private var lastGeo: Geo = Geo()
    
    @EnvironmentObject private var model: TelepoleModel
    
    var petInfo: some View {
        Button(action: {
        }) {
            HStack(spacing: 0){
                Text("🐶")
                    .frame(width: 30, height: 30, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                    .clipShape(Circle())
                    .frame(width: 44, height: 44, alignment: .center)
                
                VStack(alignment: .leading){
                    Text(model.selectedPet.petname)
                        .bold()
                    Text(String(format: "%0.1f", model.selectedPet.coins) + " 币")
                }
                .font(.footnote)
                .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                .padding(.trailing)
            }
            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
            .cornerRadius(44)
            .frame(height: 44)
        }
    }
    
    var userStatus: some View {
        Button(action: {
            isShowSettingView = true
        }) {
            Text(status)
                .frame(width: 44, height: 44, alignment: .center)
                .font(.title)
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .clipShape(Circle())
        }
    }
    
    var petGeoInfo: some View {
        VStack(alignment: .leading, spacing: 4){
            Button {
                Geo().getLastGeo(petID: model.selectedPet.id) { geo in
                    lastGeo = geo
                }
            } label: {
                Text("获取宠物最新位置")
                    .font(.footnote)
            }
            
            Text("\(lastGeo.latitude), \(lastGeo.longitude)")
                .font(.callout)
                
        }
    }
    
    var buttonRegisterPet: some View {
        Button {
            isShowPetRegisterView = true
        } label: {
            Image(systemName: "plus.circle")
                .font(.title3)
                .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
                .clipShape(Circle())
        }
    }
    
    var callMeButton: some View {
        Button {
            guard let number = URL(string: "tel://" + model.selectedPet.phone) else { return }
            UIApplication.shared.open(number)
        } label: {
            Image(systemName: "phone.circle.fill")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
        }
        .foregroundColor(Color(model.selectedPet.id == "" ? #colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1) : #colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
        .disabled(model.selectedPet.id == "" ? true : false)
    }
    
    var wakandaSlogan: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Telepole")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button {
                    isShowWakanda.toggle()
                } label: {
                    Text("@Wakanda")
                        .font(.caption)
                        .padding(.leading, 4)
                        .foregroundColor(Color(#colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)))
                }
            }
           
            Text("Go wild, go beyond!")
                .font(.title)
                .fontWeight(.light)
        }
        .padding(.vertical)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    MapView()
                        .padding(.top, 80)
                    
                    wakandaSlogan
                    
                    petGeoInfo
                }
                .animation(Animation.openMap)
            }
            
            VStack(alignment: .leading){
                HStack {
                    // 宠物图标
                    petInfo
                    
                    #if !APPCLIP
                    buttonRegisterPet
                        .sheet(isPresented: $isShowPetRegisterView) {
                            PetRegisterView(isShow: $isShowPetRegisterView)
                                .environmentObject(model)
                        }
                    #endif
                    Spacer()
                    // 个人图标
                    #if !APPCLIP
                    userStatus
                        .sheet(isPresented: $isShowSettingView) {
                            SettingView(isShow: $isShowSettingView)
                                .environmentObject(model)
                        }
                    #endif
                }
                .padding(.vertical)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    callMeButton
                    
                       
                }
            }
        }
        .padding(.horizontal)
    }
}

struct AppSingleView_Previews: PreviewProvider {
    static var previews: some View {
        AppSingleView()
    }
}
