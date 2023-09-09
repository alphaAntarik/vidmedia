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
        setState(() {});
        //_controller!.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    final dayk =
        (DateTime.now().difference(DateTime.parse(widget.day)).inMinutes);
    return _controller!.value.isInitialized
        ? InkWell(
            onTap: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
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
                            dayk / 60 < 1
                                ? '${(dayk)} minutes ago'
                                : dayk / 3600 < 1
                                    ? '${(dayk / 60).toString().split('.')[0]} hours ago'
                                    : '${(dayk / 3600).toString().split('.')[0]} days ago',
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
