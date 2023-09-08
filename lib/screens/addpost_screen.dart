import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:vidmedia/auth%20services/authmethods.dart';
import 'package:vidmedia/screens/feed_screen.dart';
import 'package:vidmedia/screens/homepage.dart';

class AddPost extends StatefulWidget {
  final bool? isloggedinbyphone;
  const AddPost({required this.isloggedinbyphone});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _formKey = GlobalKey<FormState>();
  String? name;

  bool _isLoading = false;
  bool _isVideoLoaded = false;
  File? _userVideoFile;

  final titleController = TextEditingController();
  final genreController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
    genreController.dispose();
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.locality}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  VideoPlayerController? _controller;

  void _uploadVideo(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (_userVideoFile != null) {
      String result = await AuthMethods().update(
          _userVideoFile,
          name,
          titleController.text.trim(),
          genreController.text.trim(),
          DateTime.now().toString(),
          _currentAddress!);
      if (result != 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(
                  isloggedinviaphonenumber: widget.isloggedinbyphone,
                )));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _userVideoFile = File(pickedFile.path);
        name = pickedFile.name;
        _controller = VideoPlayerController.file(_userVideoFile!)
          ..initialize().then((_) {
            setState(() {
              _isVideoLoaded = true;
            });
          });
      } else {
        print('No Video selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => _pickVideo(),
                child: _userVideoFile == null
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                      )
                    : Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 250),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                    } else {
                                      _controller!.play();
                                    }
                                  });
                                },
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 100,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (_userVideoFile != null)
              textFeld(
                hintText: "video title",
                icon: Icons.edit,
                inputType: TextInputType.name,
                maxLines: 1,
                controller: titleController,
              ),
            if (_userVideoFile != null)
              textFeld(
                hintText: "category",
                icon: Icons.category,
                inputType: TextInputType.name,
                maxLines: 1,
                controller: genreController,
              ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (_userVideoFile != null)
              ElevatedButton(
                  onPressed: () async {
                    if (titleController.text == "" ||
                        genreController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Upload all the details.')));
                      return;
                    }

                    _getCurrentPosition();

                    _uploadVideo(context);
                  },
                  child: Text(_isLoading
                      ? "Got it, press to upload"
                      : "Access Location")),
            if (_userVideoFile == null)
              Center(
                child: Text("Upload a video"),
              ),
          ],
        ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }
}
