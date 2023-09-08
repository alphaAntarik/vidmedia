import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String userdp;
  final String location;
  final String genre;
  final String day;

  VideoPlayerScreen(
      {required this.videoUrl,
      required this.videoTitle,
      required this.userdp,
      required this.location,
      required this.genre,
      required this.day});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          // Ensure the first frame is shown
        });
        //_controller!.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller!.value.isInitialized
        ? InkWell(
            onTap: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown.
              setState(() {
                // If the video is playing, pause it.
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  // If the video is paused, play it.
                  _controller!.play();
                }
              });
            },
            child: Stack(
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.62,
                        left: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(widget.userdp),
                                radius: 20,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                widget.videoTitle.split(".")[0],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            widget.location,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            widget.genre,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${(DateTime.now().difference(DateTime.parse(widget.day))).toString().split(":")[0]} days ago',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 100,
                    color: Colors.white24,
                  ),
                ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
