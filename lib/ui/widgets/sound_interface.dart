import 'package:audioplayers/audioplayers.dart';

class SoundInterface {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void play(Event event) async {
    await _audioPlayer.stop();
    switch (event) {
      case Event.notification:
        await _audioPlayer
            .play(AssetSource('sounds/income_notify_default.mp3'));
        break;
      case Event.error:
        await _audioPlayer.play(AssetSource('sounds/error_sound_default.mp3'));
        break;
      default:
    }
  }
}

enum Event {
  notification,
  error,
}
