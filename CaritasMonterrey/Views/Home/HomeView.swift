//
//  HomeView.swift
//  CaritasMonterrey
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var navPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Banner CTA
                    BannerCard(
                        title: vm.banner.title,
                        assetName: vm.banner.assetName,
                        systemFallback: vm.banner.systemFallback
                    ) {
                        navPath.append(vm.banner.route)
                    }

                    // Sección: Acciones rápidas
                    Text("Acciones rápidas")
                        .font(.title3).bold()
                        .padding(.top, 8)

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 14),
                                  GridItem(.flexible(), spacing: 14)],
                        spacing: 14
                    ) {
                        ForEach(vm.secondaryCards) { card in
                            ActionCard(
                                title: card.title,
                                assetName: card.assetName,
                                systemFallback: card.systemFallback
                            ) {
                                navPath.append(card.route)
                            }
                        }
                    }

                    // Sección: Tus estadísticas
                    Text("Tus estadísticas")
                        .font(.title3).bold()
                        .padding(.top, 8)

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 14),
                                  GridItem(.flexible(), spacing: 14)],
                        spacing: 14
                    ) {
                        StatCard(title: "Donaciones", value: vm.totalText, systemIcon: "chart.bar.fill")
                        StatCard(title: "En proceso", value: vm.inProgressText, systemIcon: "clock.badge.checkmark")
                        StatCard(title: "Ultima donación", value: vm.lastDonationText, systemIcon: "calendar")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle(vm.screenTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotificationsView()) {
                        Image(systemName: "bell.fill").font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.fill").font(.title2)
                    }
                }
            }
            .onAppear { vm.onAppear() }
            .navigationDestination(for: HomeViewModel.Route.self) { route in
                switch route {
                case .donate:    DonationsView()
                case .map:       mapaView()
                case .donations: DonationsView()
                }
            }
        }
    }
}

#Preview { HomeView() }

