import Foundation
import OpenHandDiscovery
import SwiftUI
import Testing
@testable import OpenHand

@Suite(.serialized)
@MainActor
struct OnboardingViewSmokeTests {
    @Test func onboardingViewBuildsBody() {
        let state = AppState(preview: true)
        let view = OnboardingView(
            state: state,
            permissionMonitor: PermissionMonitor.shared,
            discoveryModel: GatewayDiscoveryModel(localDisplayName: InstanceIdentity.displayName))
        _ = view.body
    }

    @Test func pageOrderOmitsWorkspaceAndIdentitySteps() {
        let order = OnboardingView.pageOrder(for: .local, showOnboardingChat: false)
        #expect(!order.contains(7))
        #expect(order.contains(3))
    }

    @Test func pageOrderOmitsOnboardingChatWhenIdentityKnown() {
        let order = OnboardingView.pageOrder(for: .local, showOnboardingChat: false)
        #expect(!order.contains(8))
    }

    @Test func selectRemoteGatewayClearsStaleSshTargetWhenEndpointUnresolved() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("openhand-config-\(UUID().uuidString)")
            .appendingPathComponent("openhand.json")
            .path

        await TestIsolation.withEnvValues(["OPENHAND_CONFIG_PATH": override]) {
            let state = AppState(preview: true)
            state.remoteTransport = .ssh
            state.remoteTarget = "user@old-host:2222"
            let view = OnboardingView(
                state: state,
                permissionMonitor: PermissionMonitor.shared,
                discoveryModel: GatewayDiscoveryModel(localDisplayName: InstanceIdentity.displayName))
            let gateway = GatewayDiscoveryModel.DiscoveredGateway(
                displayName: "Unresolved",
                serviceHost: nil,
                servicePort: nil,
                lanHost: "txt-host.local",
                tailnetDns: "txt-host.ts.net",
                sshPort: 22,
                gatewayPort: 18789,
                cliPath: "/tmp/openhand",
                stableID: UUID().uuidString,
                debugID: UUID().uuidString,
                isLocal: false)

            view.selectRemoteGateway(gateway)
            #expect(state.remoteTarget.isEmpty)
        }
    }
}
