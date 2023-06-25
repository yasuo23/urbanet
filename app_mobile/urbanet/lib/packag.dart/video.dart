import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerButton extends StatefulWidget {
  @override
  _VideoPickerButtonState createState() => _VideoPickerButtonState();
}

class _VideoPickerButtonState extends State<VideoPickerButton> {
  VideoPlayerController _controller = VideoPlayerController.network('');
  bool _showVideo = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _showVideo = true;
        _controller = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            _controller.play();
            _startTimer();
          });
      });
    }
  }

  void _startTimer() {
    Future.delayed(Duration(minutes: 1), () {
      if (_showVideo) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    _controller.pause();
    print('Video duration limit reached');
  }

  void _deleteVideo() {
    setState(() {
      _showVideo = false;
      _controller.pause();
      _controller = VideoPlayerController.network('');
    });
  }

  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 150),
          primary: Color.fromARGB(255, 65, 41, 151),
        ),
        onPressed: _pickVideo,
        child: InkWell(
          child: Image.asset(
            'images/video-player.png',
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      child: _showVideo
          ? _buildVideoPlayer()
          : Container(
              width: 150.0,
              height: 150.0,
              child: _buildButton(),
            ),
    );
  }
}
