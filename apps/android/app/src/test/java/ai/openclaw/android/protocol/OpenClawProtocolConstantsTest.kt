package ai.openhand.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class OpenHandProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", OpenHandCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", OpenHandCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", OpenHandCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", OpenHandCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", OpenHandCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", OpenHandCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", OpenHandCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", OpenHandCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", OpenHandCapability.Canvas.rawValue)
    assertEquals("camera", OpenHandCapability.Camera.rawValue)
    assertEquals("screen", OpenHandCapability.Screen.rawValue)
    assertEquals("voiceWake", OpenHandCapability.VoiceWake.rawValue)
    assertEquals("location", OpenHandCapability.Location.rawValue)
    assertEquals("sms", OpenHandCapability.Sms.rawValue)
    assertEquals("device", OpenHandCapability.Device.rawValue)
    assertEquals("notifications", OpenHandCapability.Notifications.rawValue)
    assertEquals("system", OpenHandCapability.System.rawValue)
    assertEquals("appUpdate", OpenHandCapability.AppUpdate.rawValue)
    assertEquals("photos", OpenHandCapability.Photos.rawValue)
    assertEquals("contacts", OpenHandCapability.Contacts.rawValue)
    assertEquals("calendar", OpenHandCapability.Calendar.rawValue)
    assertEquals("motion", OpenHandCapability.Motion.rawValue)
  }

  @Test
  fun cameraCommandsUseStableStrings() {
    assertEquals("camera.list", OpenHandCameraCommand.List.rawValue)
    assertEquals("camera.snap", OpenHandCameraCommand.Snap.rawValue)
    assertEquals("camera.clip", OpenHandCameraCommand.Clip.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", OpenHandScreenCommand.Record.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", OpenHandNotificationsCommand.List.rawValue)
    assertEquals("notifications.actions", OpenHandNotificationsCommand.Actions.rawValue)
  }

  @Test
  fun deviceCommandsUseStableStrings() {
    assertEquals("device.status", OpenHandDeviceCommand.Status.rawValue)
    assertEquals("device.info", OpenHandDeviceCommand.Info.rawValue)
    assertEquals("device.permissions", OpenHandDeviceCommand.Permissions.rawValue)
    assertEquals("device.health", OpenHandDeviceCommand.Health.rawValue)
  }

  @Test
  fun systemCommandsUseStableStrings() {
    assertEquals("system.notify", OpenHandSystemCommand.Notify.rawValue)
  }

  @Test
  fun photosCommandsUseStableStrings() {
    assertEquals("photos.latest", OpenHandPhotosCommand.Latest.rawValue)
  }

  @Test
  fun contactsCommandsUseStableStrings() {
    assertEquals("contacts.search", OpenHandContactsCommand.Search.rawValue)
    assertEquals("contacts.add", OpenHandContactsCommand.Add.rawValue)
  }

  @Test
  fun calendarCommandsUseStableStrings() {
    assertEquals("calendar.events", OpenHandCalendarCommand.Events.rawValue)
    assertEquals("calendar.add", OpenHandCalendarCommand.Add.rawValue)
  }

  @Test
  fun motionCommandsUseStableStrings() {
    assertEquals("motion.activity", OpenHandMotionCommand.Activity.rawValue)
    assertEquals("motion.pedometer", OpenHandMotionCommand.Pedometer.rawValue)
  }
}
