package ai.openhand.android.ui

import androidx.compose.runtime.Composable
import ai.openhand.android.MainViewModel
import ai.openhand.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
