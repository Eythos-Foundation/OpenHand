package ai.openhand.android.node

import ai.openhand.android.protocol.OpenHandCalendarCommand
import ai.openhand.android.protocol.OpenHandCanvasA2UICommand
import ai.openhand.android.protocol.OpenHandCanvasCommand
import ai.openhand.android.protocol.OpenHandCameraCommand
import ai.openhand.android.protocol.OpenHandCapability
import ai.openhand.android.protocol.OpenHandContactsCommand
import ai.openhand.android.protocol.OpenHandDeviceCommand
import ai.openhand.android.protocol.OpenHandLocationCommand
import ai.openhand.android.protocol.OpenHandMotionCommand
import ai.openhand.android.protocol.OpenHandNotificationsCommand
import ai.openhand.android.protocol.OpenHandPhotosCommand
import ai.openhand.android.protocol.OpenHandScreenCommand
import ai.openhand.android.protocol.OpenHandSmsCommand
import ai.openhand.android.protocol.OpenHandSystemCommand

data class NodeRuntimeFlags(
  val cameraEnabled: Boolean,
  val locationEnabled: Boolean,
  val smsAvailable: Boolean,
  val voiceWakeEnabled: Boolean,
  val motionActivityAvailable: Boolean,
  val motionPedometerAvailable: Boolean,
  val debugBuild: Boolean,
)

enum class InvokeCommandAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  MotionActivityAvailable,
  MotionPedometerAvailable,
  DebugBuild,
}

enum class NodeCapabilityAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  VoiceWakeEnabled,
  MotionAvailable,
}

data class NodeCapabilitySpec(
  val name: String,
  val availability: NodeCapabilityAvailability = NodeCapabilityAvailability.Always,
)

data class InvokeCommandSpec(
  val name: String,
  val requiresForeground: Boolean = false,
  val availability: InvokeCommandAvailability = InvokeCommandAvailability.Always,
)

object InvokeCommandRegistry {
  val capabilityManifest: List<NodeCapabilitySpec> =
    listOf(
      NodeCapabilitySpec(name = OpenHandCapability.Canvas.rawValue),
      NodeCapabilitySpec(name = OpenHandCapability.Screen.rawValue),
      NodeCapabilitySpec(name = OpenHandCapability.Device.rawValue),
      NodeCapabilitySpec(name = OpenHandCapability.Notifications.rawValue),
      NodeCapabilitySpec(name = OpenHandCapability.System.rawValue),
      NodeCapabilitySpec(name = OpenHandCapability.AppUpdate.rawValue),
      NodeCapabilitySpec(
        name = OpenHandCapability.Camera.rawValue,
        availability = NodeCapabilityAvailability.CameraEnabled,
      ),
      NodeCapabilitySpec(
        name = OpenHandCapability.Sms.rawValue,
        availability = NodeCapabilityAvailability.SmsAvailable,
      ),
      NodeCapabilitySpec(
        name = OpenHandCapability.VoiceWake.rawValue,
        availability = NodeCapabilityAvailability.VoiceWakeEnabled,
      ),
      NodeCapabilitySpec(
        name = OpenHandCapability.Location.rawValue,
        availability = NodeCapabilityAvailability.LocationEnabled,
      ),
      NodeCapabilitySpec(name = OpenHandCapability.Photos.rawValue),
      NodeCapabilitySpec(name = OpenHandCapability.Contacts.rawValue),
      NodeCapabilitySpec(name = OpenHandCapability.Calendar.rawValue),
      NodeCapabilitySpec(
        name = OpenHandCapability.Motion.rawValue,
        availability = NodeCapabilityAvailability.MotionAvailable,
      ),
    )

  val all: List<InvokeCommandSpec> =
    listOf(
      InvokeCommandSpec(
        name = OpenHandCanvasCommand.Present.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandCanvasCommand.Hide.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandCanvasCommand.Navigate.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandCanvasCommand.Eval.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandCanvasCommand.Snapshot.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandCanvasA2UICommand.Push.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandCanvasA2UICommand.PushJSONL.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandCanvasA2UICommand.Reset.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandScreenCommand.Record.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = OpenHandSystemCommand.Notify.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandCameraCommand.List.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = OpenHandCameraCommand.Snap.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = OpenHandCameraCommand.Clip.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = OpenHandLocationCommand.Get.rawValue,
        availability = InvokeCommandAvailability.LocationEnabled,
      ),
      InvokeCommandSpec(
        name = OpenHandDeviceCommand.Status.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandDeviceCommand.Info.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandDeviceCommand.Permissions.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandDeviceCommand.Health.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandNotificationsCommand.List.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandNotificationsCommand.Actions.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandPhotosCommand.Latest.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandContactsCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandContactsCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandCalendarCommand.Events.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandCalendarCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = OpenHandMotionCommand.Activity.rawValue,
        availability = InvokeCommandAvailability.MotionActivityAvailable,
      ),
      InvokeCommandSpec(
        name = OpenHandMotionCommand.Pedometer.rawValue,
        availability = InvokeCommandAvailability.MotionPedometerAvailable,
      ),
      InvokeCommandSpec(
        name = OpenHandSmsCommand.Send.rawValue,
        availability = InvokeCommandAvailability.SmsAvailable,
      ),
      InvokeCommandSpec(
        name = "debug.logs",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(
        name = "debug.ed25519",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(name = "app.update"),
    )

  private val byNameInternal: Map<String, InvokeCommandSpec> = all.associateBy { it.name }

  fun find(command: String): InvokeCommandSpec? = byNameInternal[command]

  fun advertisedCapabilities(flags: NodeRuntimeFlags): List<String> {
    return capabilityManifest
      .filter { spec ->
        when (spec.availability) {
          NodeCapabilityAvailability.Always -> true
          NodeCapabilityAvailability.CameraEnabled -> flags.cameraEnabled
          NodeCapabilityAvailability.LocationEnabled -> flags.locationEnabled
          NodeCapabilityAvailability.SmsAvailable -> flags.smsAvailable
          NodeCapabilityAvailability.VoiceWakeEnabled -> flags.voiceWakeEnabled
          NodeCapabilityAvailability.MotionAvailable -> flags.motionActivityAvailable || flags.motionPedometerAvailable
        }
      }
      .map { it.name }
  }

  fun advertisedCommands(flags: NodeRuntimeFlags): List<String> {
    return all
      .filter { spec ->
        when (spec.availability) {
          InvokeCommandAvailability.Always -> true
          InvokeCommandAvailability.CameraEnabled -> flags.cameraEnabled
          InvokeCommandAvailability.LocationEnabled -> flags.locationEnabled
          InvokeCommandAvailability.SmsAvailable -> flags.smsAvailable
          InvokeCommandAvailability.MotionActivityAvailable -> flags.motionActivityAvailable
          InvokeCommandAvailability.MotionPedometerAvailable -> flags.motionPedometerAvailable
          InvokeCommandAvailability.DebugBuild -> flags.debugBuild
        }
      }
      .map { it.name }
  }
}
