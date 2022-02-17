import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_wave/audio_wave.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel/splash_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';


final AudioCache cache = AudioCache(prefix: 'assets/audio/');

void main() async {
  runApp(const CarouselApp());
}

class CarouselApp extends StatelessWidget {
  const CarouselApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'carousel',
      theme: ThemeData.dark().copyWith(
        canvasColor: Colors.black
      ),
      home: const Scaffold(
        body: SplashScreen(
          firstChild: InfoPage(),
          secondChild: CarouselPage(),
          duration: Duration(seconds: 3),
          switchDuration: Duration(seconds: 3),
        ),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {

  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcOver),
              image: const AssetImage('assets/splash.jpg'),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              '@north32\nsnippet carousel',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
        ),
      ]
    );
  }

}

class CarouselPage extends StatefulWidget {

  const CarouselPage({Key? key}) : super(key: key);

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {

  final List<String> titles = [
    'title1',
    'title2',
    'title3',
    'title4',
    'title5',
    'title6',
    'title7',
    'title8',
    'title9',
    'title10',
    'title11',
    'title12',
    'title13',
    'title14',
    'title15',
    'title16',
    'title17',
    'title18',
    'title19',
    'title20',
    'title21'
  ];

  late AudioPlayer player;

  late Wheel _wheel;

  int selectedItem = 0;

  @override
  void initState() {
    super.initState();
    _wheel = Wheel(
      builder: (BuildContext context, int index) {
        return Tile(text: titles[index]);
      },
      count: titles.length,
      extent: 80.0,
      onItemChanged: updateSelected,
    );
    playAudio(selectedItem);
  }

  void updateSelected(int index) {
    stopAudio();
    setState(() {
      selectedItem = index;
    });
    playAudio(index);
  }

  void playAudio(int index) {
    cache.play((index + 1).toString().padLeft(5, '0') + '.wav')
        .then((value) {
          player = value;
          player.onPlayerCompletion.listen((event) {
            _wheel.next();
          });
    });
  }

  void stopAudio() {
    player.stop();
  }

  void shareSoundLink() {
    HapticFeedback.mediumImpact();
    Share.share('https://carousel.app/fake-link-to-something-i-like');
  }

  void showBookmarks() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const SizedBox(
            height: 480.0,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: BookmarksPage()
            ),
          ),
        );
      },
      context: context,
    );
  }

  void showComments() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: const [
                Text(
                  'Comments',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                )
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: UniqueKey(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.srcOver),
                      image: AssetImage('assets/cover/$selectedItem.png')
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: SafeArea(
                  key: UniqueKey(),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GestureDetector(
                        onTap: () {
                          stopAudio();
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return CreateContentPage();
                          }));
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.width - 50,
                            width: MediaQuery.of(context).size.width - 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/cover/$selectedItem.png')
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0
                  ),
                  child: SizedBox(
                    child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
                            stops: [0.0, 0.3, 0.8, 1.0],
                          ).createShader(bounds);
                        },
                        child: _wheel,
                    ),
                    height: 350,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0,
                      bottom: 60.0
                  ),
                  child: Container(
                    height: 260.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.heart_circle,
                          size: 32.0,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: showComments,
                          child: const Icon(
                            CupertinoIcons.bubble_right_fill,
                            size: 32.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: showBookmarks,
                          child: const Icon(
                            CupertinoIcons.bookmark,
                            size: 32.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: shareSoundLink,
                          child: const Icon(
                            CupertinoIcons.paperplane,
                            size: 32.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            stopAudio();
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return FandomPage(
                                index: selectedItem,
                              );
                            }));
                          },
                          child: const Icon(
                            CupertinoIcons.profile_circled,
                            size: 32.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]
          );
  }
}

typedef WheelItemBuilder = Widget? Function(BuildContext, int);

class Wheel extends StatefulWidget {

  int get selectedItem => controller.selectedItem;

  final FixedExtentScrollController controller = FixedExtentScrollController();

  final WheelItemBuilder builder;
  final int count;
  final double extent;
  final Function(int) onItemChanged;

  Wheel({
    required this.builder,
    required this.count,
    required this.extent,
    required this.onItemChanged,
    Key? key
  }) : super(key: key);

  void next() {
    int nextItem = selectedItem + 1;
    if (nextItem != count) {
      controller.animateToItem(
          nextItem,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease
      );
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _WheelState();
  }

}

class _WheelState extends State<Wheel> with AutomaticKeepAliveClientMixin {

  bool isScrolling = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
      super.build(context);
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            isScrolling = true;
          } else if (scrollNotification is ScrollEndNotification) {
            isScrolling = false;
            widget.onItemChanged(widget.selectedItem);
          }
          return true;
        },
        child: ListWheelScrollView.useDelegate(
          controller: widget.controller,
          itemExtent: widget.extent,
          diameterRatio: 1.2,
          onSelectedItemChanged: (item) => HapticFeedback.selectionClick(),
          physics: const FixedExtentScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          childDelegate: ListWheelChildBuilderDelegate(
            builder: widget.builder,
            childCount: widget.count
          ),
        ),
      );
  }

}

class Tile extends StatelessWidget {

  final String text;

  const Tile({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: Text(
              text,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 8.0,
                    color: Colors.grey,
                  ),
                ],
              )
            ),
          )
      );
  }
}

class BookmarksPage extends StatelessWidget {

  const BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Playlists',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30.0,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const BookmarkCardImage(
            height: 100,
            width: 300,
            image: 'assets/image.jpg',
            opacity: 0.7,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'studying',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15.0
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    bottom: 20.0
                  ),
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0
                        ),
                        child: BookmarkCardImage(
                          height: 90.0,
                          width: 200.0,
                          image: 'assets/image2.jpg',
                          opacity: 0.8,
                        ),
                      ),

                      BookmarkCardColor(
                        height: 80.0,
                        width: 200.0,
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '2022\njam',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
              const Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 5.0,
                      right: 10.0,
                      bottom: 20.0
                  ),
                  child: BookmarkCardImage(
                    height: 180.0,
                    width: 200.0,
                    image: 'assets/image3.jpg',
                    opacity: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const Icon(
            CupertinoIcons.plus,
            size: 64.0,
            color: Colors.black,
          )
        ],
      ),
    );
  }

}

class BookmarkCardColor extends StatelessWidget {

  final double height;
  final double width;
  final Color color;
  final Widget? child;

  const BookmarkCardColor({
    Key? key,
    required this.height,
    required this.width,
    required this.color,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}

class BookmarkCardImage extends StatelessWidget {

  final double height;
  final double width;
  final String image;
  final double opacity;
  final Widget? child;

  const BookmarkCardImage({
    Key? key,
    required this.height,
    required this.width,
    required this.image,
    required this.opacity,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(opacity), BlendMode.dstIn),
            image: AssetImage(image)
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
      ),
      child: child,
    );
  }
}

class CreateContentPage extends StatefulWidget {

  const CreateContentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateContentPage();
  }

}

class _CreateContentPage extends State<CreateContentPage> {

  final Duration playWindow = const Duration(seconds: 15);

  final AudioPlayer _player = AudioPlayer();

  final Random _random = Random();

  File? pickedImage;
  bool pickedAudio = false;

  Duration? audioDuration;
  late int windowLeftSideMillis = 0;
  late int windowRightSideMillis = playWindow.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _player.onDurationChanged.listen((Duration duration) {
      audioDuration = duration;
    });
    _player.onAudioPositionChanged.listen((duration) {
      if (duration.inMilliseconds < windowLeftSideMillis
            || duration.inMilliseconds >= windowRightSideMillis) {
        _player.seek(Duration(milliseconds: windowLeftSideMillis));
      }
    });
  }


  void _pickImage() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery)
        .then((value) {
          if (value != null) {
            setState(() {
              pickedImage = File(value.path);
            });
          }
        });
  }

  void _pickAudio() {
    FilePicker.platform.pickFiles(
      type: FileType.audio
    ).then((value) {
      if (value != null) {
        _player.play(
          value.files.single.path!,
          isLocal: true,
        );
        setState(() {
          pickedAudio = true;
        });
      }
    });
  }

  void _updateAudioWindow(double currentExtent, double maxExtent) {
    if (audioDuration != null) {
      int maxWindowPositionMillis =
          audioDuration!.inMilliseconds - playWindow.inMilliseconds
              - const Duration(seconds: 1).inMilliseconds;

      windowLeftSideMillis =
          (maxWindowPositionMillis * (currentExtent / maxExtent)).round();
      windowRightSideMillis = windowLeftSideMillis + playWindow.inMilliseconds;
    }
  }

  void _pauseAudio() {
    _player.pause();
  }

  void _resumeAudio() {
    _player.resume();
  }

  void _stopAudio() {
    _player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: UniqueKey(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.srcOver),
                      image: pickedImage !=  null
                          ? FileImage(pickedImage!)
                          : const AssetImage('assets/image5.png') as ImageProvider
                  ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: SafeArea(
                key: UniqueKey(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                          height: MediaQuery.of(context).size.width - 50,
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: pickedImage !=  null
                                      ? FileImage(pickedImage!)
                                      : const AssetImage('assets/image5.png') as ImageProvider
                              )
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            pickedAudio
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 50.0,
                          left: 20.0,
                          right: 20.0
                        ),
                        child: SizedBox(
                          height: 300.0,
                          child: Column(
                            children: [
                              NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  if (scrollNotification is ScrollStartNotification) {
                                    _pauseAudio();
                                  }
                                  if (scrollNotification is ScrollEndNotification) {
                                    _updateAudioWindow(
                                        scrollNotification.metrics.pixels,
                                        scrollNotification.metrics.maxScrollExtent
                                    );
                                    _resumeAudio();
                                  }
                                  return false;
                                },
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: AudioWave(
                                    height: 150.0,
                                    width: 1000.0,
                                    animation: false,
                                    bars: List<AudioWaveBar>.generate(60, (i) =>
                                        AudioWaveBar(
                                            height: _random.nextInt(50) + 20,
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 70.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                    _stopAudio();
                                    Navigator.pop(context);
                                },
                                child: const Icon(
                                  CupertinoIcons.paperplane_fill,
                                  size: 80.0,
                                ),
                              )
                            ]
                          ),
                        )
                    )
                )
                :  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 100.0,
                      ),
                        child: GestureDetector(
                          onTap: _pickAudio,
                          child: const Icon(
                            CupertinoIcons.plus_circled,
                            size: 100.0,
                          ),
                        )
                    )
                  )
          ]
      ),
    );
  }
}

class FandomPage extends StatelessWidget {

  final int index;

  const FandomPage({
    Key? key,
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Fandom',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        LyricCard(
                          lyrics: const [''],
                          image: 'assets/cover/' + index.toString() + '.png',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AudioCard(
                          image: 'assets/imag6.jpg',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const TweetCard(
                          avatar: 'assets/imag7.jpg',
                          name: 'name',
                          tag: 'tag',
                          date: 'day ago',
                          post: Text(
                            'text',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                          comments: '629',
                          likes: '2K',
                          retweets: '37K',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TweetCard(
                          avatar: 'assets/imag8.jpg',
                          name: 'name',
                          tag: 'tag',
                          date: 'day ago',
                          post: Container(
                              width: 250.0,
                              height: 250.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/imag9.png')
                                ),
                              )
                          ),
                          comments: '281',
                          likes: '63',
                          retweets: '1K',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AudioCard(
                          image: 'assets/imag10.jpg',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AudioCard(
                          image: 'assets/splash.jpg',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
                PlayerWidget(
                    image: 'assets/cover/' + index.toString() + '.png'
                )
              ]
            )
        ),
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {

  final Random _random = Random();

  final String image;

  PlayerWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20.0)
        ),
        image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcOver),
            image: AssetImage(image)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                CupertinoIcons.pause_solid,
                size: 48.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            AudioWave(
              width: 270.0,
              animation: false,
              bars: List<AudioWaveBar>.generate(20, (i) =>
                  AudioWaveBar(
                    height: _random.nextInt(50) + 10,
                    color: Colors.white
                  )
              )
            )
          ],
        ),
      )
    );
  }
}

class LyricCard extends StatelessWidget {

  final List<String> lyrics;
  final String image;

  const LyricCard({
    Key? key,
    required this.lyrics,
    required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcOver),
            image: AssetImage(image)
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lyrics.map((lyric) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 3.0,
                    bottom: 3.0,
                    left: 10.0
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        lyric,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50.0,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.0)
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Expand lyrics',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}

class AudioCard extends StatelessWidget {

  final Random _random = Random();

  final String image;

  AudioCard({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.srcOver),
            image: AssetImage(image)
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.play_arrow_solid,
                size: 48.0,
              ),
              const SizedBox(
                width: 10.0,
              ),
              AudioWave(
                  width: 250.0,
                  animation: false,
                  bars: List<AudioWaveBar>.generate(20, (i) =>
                      AudioWaveBar(
                          height: _random.nextInt(50) + 10,
                          color: Colors.white
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TweetCard extends StatelessWidget {

  final String avatar;
  final String name;
  final String tag;
  final String date;
  final Widget post;
  final String comments;
  final String retweets;
  final String likes;

  const TweetCard({
    Key? key,
    required this.avatar,
    required this.name,
    required this.tag,
    required this.date,
    required this.post,
    required this.comments,
    required this.retweets,
    required this.likes

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.blueGrey,
          width: 0.5
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(avatar),
              radius: 25.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    const Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      color: Colors.lightBlueAccent,
                      size: 18.0,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    const CircleAvatar(
                      radius: 1.0,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    const Icon(
                      CupertinoIcons.ellipsis,
                      color: Colors.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                post,
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    TwitterIconText(
                      icon: CupertinoIcons.conversation_bubble,
                      text: comments,
                    ),
                    const SizedBox(
                      width: 24.0,
                    ),
                    TwitterIconText(
                      icon: CupertinoIcons.arrow_2_squarepath,
                      text: retweets,
                    ),
                    const SizedBox(
                      width: 24.0,
                    ),
                    TwitterIconText(
                      icon: CupertinoIcons.heart,
                      text: likes,
                    ),
                    const SizedBox(
                      width: 24.0,
                    ),
                    const Icon(
                      CupertinoIcons.share,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TwitterIconText extends StatelessWidget {

  final IconData icon;
  final String text;

  const TwitterIconText({
    Key? key,
    required this.icon,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 16.0,
        ),
        const SizedBox(
          width: 2.0,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0
          ),
        )
      ],
    );
  }
}
