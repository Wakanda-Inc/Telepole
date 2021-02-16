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
    @State private var isFoldMap = false
    @State private var isShowWakanda = false
    @State private var status: String = "😀"
    @State private var pet: Pet = Pet()
    @State private var pickPetID: String = ""
    
    @ObservedObject var userSettings = UserSettings()
    
    fileprivate func getPetInfo() {
        PetApi().getPetByID(pickPetID) { (p) in
            pet = p
        }
    }
    
    var petname: String {
        if pet.name == "" {
            return "暂无宠物"
        }
        return pet.name
    }
    
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
                    Text(petname)
                        .bold()
                    Text(String(format: "%0.1f", pet.coins) + " 币")
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
    
    var showPetInfo: some View {
        VStack(alignment: .leading){
            Button {
                isFoldMap.toggle()
            } label: {
                Text((isFoldMap ? "折叠" : "展开" ) + "宠物信息")
                    .font(.footnote)
                    .foregroundColor(Color(isFoldMap ? #colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1) : #colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
            }
            Text(isFoldMap ? "" : "...")
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
            
        } label: {
            Image(systemName: "phone.circle.fill")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
        }
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
                        .cornerRadius(24)
                        .frame(height: isFoldMap ? SCREENWIDTH*0.618 : SCREENWIDTH*1.114)
                        .padding(.top, 80)
                    
                    wakandaSlogan
                    
                    showPetInfo
                }
                .animation(Animation.openMap)
            }
            
            VStack(alignment: .leading){
                HStack {
                    // 宠物图标
                    petInfo
                        .onAppear(perform: {
                            pickPetID = userSettings.selectedPetID
                            self.getPetInfo()
                        })
                        .onChange(of: pickPetID, perform: { value in
                            self.getPetInfo()
                        })
                    #if !APPCLIP
                    buttonRegisterPet
                        .sheet(isPresented: $isShowPetRegisterView) {
                            PetRegisterView(isShow: $isShowPetRegisterView, pickPetID: $pickPetID)
                        }
                    #endif
                    Spacer()
                    // 个人图标
                    #if !APPCLIP
                    userStatus
                        .sheet(isPresented: $isShowSettingView) {
                            SettingView(isShow: $isShowSettingView)
                        }
                    #endif
                }
                .padding(.vertical)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    callMeButton
                        .foregroundColor(Color(pickPetID == "" ? #colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1) : #colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)))
                        .disabled(pickPetID == "" ? true : false)
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
