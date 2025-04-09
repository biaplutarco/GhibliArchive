//
//  OnboardingView.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import SwiftUI

struct OnboardingView: View {
    var onContinue: () -> Void
    var viewModel: OnboardingViewModelProtocol

    var body: some View {
        VStack {
            Spacer()
            Image(.logoSvg)
                .resizable()
                .scaledToFit()
                .frame(height: 220)
                .padding(.horizontal, 32)
            VStack(spacing: 16) {
                Text(viewModel.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(viewModel.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
            Spacer()
            Button(action: onContinue) {
                Text(viewModel.buttonTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.ghibliBlue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(30)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 60)
        }
        .background(.ghibliBlue)
        .edgesIgnoringSafeArea(.all)
    }
}
