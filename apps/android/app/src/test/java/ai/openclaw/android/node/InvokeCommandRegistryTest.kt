package ai.openhand.android.node

import ai.openhand.android.protocol.OpenHandCalendarCommand
import ai.openhand.android.protocol.OpenHandCameraCommand
import ai.openhand.android.protocol.OpenHandCapability
import ai.openhand.android.protocol.OpenHandContactsCommand
import ai.openhand.android.protocol.OpenHandDeviceCommand
import ai.openhand.android.protocol.OpenHandLocationCommand
import ai.openhand.android.protocol.OpenHandMotionCommand
import ai.openhand.android.protocol.OpenHandNotificationsCommand
import ai.openhand.android.protocol.OpenHandPhotosCommand
import ai.openhand.android.protocol.OpenHandSmsCommand
import ai.openhand.android.protocol.OpenHandSystemCommand
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InvokeCommandRegistryTest {
  private val coreCapabilities =
    setOf(
      OpenHandCapability.Canvas.rawValue,
      OpenHandCapability.Screen.rawValue,
      OpenHandCapability.Device.rawValue,
      OpenHandCapability.Notifications.rawValue,
      OpenHandCapability.System.rawValue,
      OpenHandCapability.AppUpdate.rawValue,
      OpenHandCapability.Photos.rawValue,
      OpenHandCapability.Contacts.rawValue,
      OpenHandCapability.Calendar.rawValue,
    )

  private val optionalCapabilities =
    setOf(
      OpenHandCapability.Camera.rawValue,
      OpenHandCapability.Location.rawValue,
      OpenHandCapability.Sms.rawValue,
      OpenHandCapability.VoiceWake.rawValue,
      OpenHandCapability.Motion.rawValue,
    )

  private val coreCommands =
    setOf(
      OpenHandDeviceCommand.Status.rawValue,
      OpenHandDeviceCommand.Info.rawValue,
      OpenHandDeviceCommand.Permissions.rawValue,
      OpenHandDeviceCommand.Health.rawValue,
      OpenHandNotificationsCommand.List.rawValue,
      OpenHandNotificationsCommand.Actions.rawValue,
      OpenHandSystemCommand.Notify.rawValue,
      OpenHandPhotosCommand.Latest.rawValue,
      OpenHandContactsCommand.Search.rawValue,
      OpenHandContactsCommand.Add.rawValue,
      OpenHandCalendarCommand.Events.rawValue,
      OpenHandCalendarCommand.Add.rawValue,
      "app.update",
    )

  private val optionalCommands =
    setOf(
      OpenHandCameraCommand.Snap.rawValue,
      OpenHandCameraCommand.Clip.rawValue,
      OpenHandCameraCommand.List.rawValue,
      OpenHandLocationCommand.Get.rawValue,
      OpenHandMotionCommand.Activity.rawValue,
      OpenHandMotionCommand.Pedometer.rawValue,
      OpenHandSmsCommand.Send.rawValue,
    )

  private val debugCommands = setOf("debug.logs", "debug.ed25519")

  @Test
  fun advertisedCapabilities_respectsFeatureAvailability() {
    val capabilities = InvokeCommandRegistry.advertisedCapabilities(defaultFlags())

    assertContainsAll(capabilities, coreCapabilities)
    assertMissingAll(capabilities, optionalCapabilities)
  }

  @Test
  fun advertisedCapabilities_includesFeatureCapabilitiesWhenEnabled() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          voiceWakeEnabled = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
        ),
      )

    assertContainsAll(capabilities, coreCapabilities + optionalCapabilities)
  }

  @Test
  fun advertisedCommands_respectsFeatureAvailability() {
    val commands = InvokeCommandRegistry.advertisedCommands(defaultFlags())

    assertContainsAll(commands, coreCommands)
    assertMissingAll(commands, optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_includesFeatureCommandsWhenEnabled() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = true,
        ),
      )

    assertContainsAll(commands, coreCommands + optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_onlyIncludesSupportedMotionCommands() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(commands.contains(OpenHandMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(OpenHandMotionCommand.Pedometer.rawValue))
  }

  private fun defaultFlags(
    cameraEnabled: Boolean = false,
    locationEnabled: Boolean = false,
    smsAvailable: Boolean = false,
    voiceWakeEnabled: Boolean = false,
    motionActivityAvailable: Boolean = false,
    motionPedometerAvailable: Boolean = false,
    debugBuild: Boolean = false,
  ): NodeRuntimeFlags =
    NodeRuntimeFlags(
      cameraEnabled = cameraEnabled,
      locationEnabled = locationEnabled,
      smsAvailable = smsAvailable,
      voiceWakeEnabled = voiceWakeEnabled,
      motionActivityAvailable = motionActivityAvailable,
      motionPedometerAvailable = motionPedometerAvailable,
      debugBuild = debugBuild,
    )

  private fun assertContainsAll(actual: List<String>, expected: Set<String>) {
    expected.forEach { value -> assertTrue(actual.contains(value)) }
  }

  private fun assertMissingAll(actual: List<String>, forbidden: Set<String>) {
    forbidden.forEach { value -> assertFalse(actual.contains(value)) }
  }
}
