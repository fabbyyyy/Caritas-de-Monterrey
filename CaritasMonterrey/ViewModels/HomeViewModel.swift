//
//  OnboardingViewModel.swift
//  CaritasMonterrey
//
//  Created by Alumno on 20/10/25.
//

// ViewModels/HomeViewModel.swift
import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    // Navegación
    enum Route: Hashable {
        case donate          // por ahora te lleva a DonationsView
        case map
        case donations       // usamos DonationsView existente
    }

    struct Promo: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let assetName: String?
        let systemFallback: String
        let route: Route
    }

    // UI copy
    @Published private(set) var screenTitle = "Inicio"
    @Published private(set) var headline = "Acciones rápidas"

    // Banner principal
    @Published private(set) var banner: Promo = .init(
        title: "Haz una donación ahora!",
        assetName: "home_heart",               // cambia si tu asset tiene otro nombre
        systemFallback: "heart.circle.fill",
        route: .donate
    )

    // Tarjetas de acción
    @Published private(set) var secondaryCards: [Promo] = [
        .init(title: "Ver bazares cercanos", assetName: nil, systemFallback: "mappin.and.ellipse", route: .map),
        .init(title: "Mis donaciones", assetName: nil, systemFallback: "gift.fill", route: .donations)
    ]

    // Resumen (para el Home)
    @Published private(set) var totalText = "0 donaciones"
    @Published private(set) var inProgressText = "0 en proceso"
    @Published private(set) var lastDonationText = "—"

    // Fuente temporal (mock). Luego la jalas de tu capa de datos.
    private var allDonations: [Donation] = Donation.sampleDonations

    func onAppear() {
        // Cálculos rápidos para el resumen
        let total = allDonations.count
        let inProcess = allDonations.filter { $0.status == .enProceso }.count

        totalText = "\(total) donaciones"
        inProgressText = "\(inProcess) en proceso"

        if let last = allDonations.sorted(by: { $0.date > $1.date }).first {
            lastDonationText = "" + format(date: last.date)
        } else {
            lastDonationText = "-"
        }
    }

    private func format(date: Date) -> String {
        let f = DateFormatter()
        f.locale = .current
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
