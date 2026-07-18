//
//  DraftStore.swift
//  AfterTaste
//
//  Created by Raghad Aljuid on 03/02/1448 AH.
//
import Foundation
import Combine

struct PurchaseDraft: Identifiable {
    let id: UUID

    var itemName: String
    var price: String

    var purchaseType: PurchaseType
    var paymentType: PaymentType
    var purchasePriority: PurchasePriority

    var urgency: Double
    var reason: String

    var lifeExpectancy: String
    var lifeExpectancyUnit: String
}

@MainActor
final class DraftStore: ObservableObject {
    @Published var drafts: [PurchaseDraft] = []

    func saveDraft(from viewModel: PurchaseViewModel) {
        guard viewModel.hasDraftContent else {
            return
        }

        let draft = PurchaseDraft(
            id: UUID(),
            itemName: viewModel.itemName,
            price: viewModel.price,
            purchaseType: viewModel.purchaseType,
            paymentType: viewModel.paymentType,
            purchasePriority: viewModel.purchasePriority,
            urgency: viewModel.urgency,
            reason: viewModel.reason,
            lifeExpectancy: viewModel.lifeExpectancy,
            lifeExpectancyUnit: viewModel.lifeExpectancyUnit
        )

        drafts.append(draft)
    }

    func removeDraft(_ draft: PurchaseDraft) {
        drafts.removeAll {
            $0.id == draft.id
        }
    }
}
