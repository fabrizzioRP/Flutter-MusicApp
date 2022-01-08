import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
import 'package:music_app/src/helpers/helpers.dart';
import 'package:music_app/src/providers/audio_player_mode.dart';
import 'package:music_app/src/widgets/custom_appBar.dart';

class MusicMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              CustomAppBar(),
              ImageDiscoDuracion(),
              TituloMusic(),
              Expanded(child: LyricsMusic()),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: sizeScreen.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ],
        ),
      ),
    );
  }
}

class ImageDiscoDuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 120),
      child: Row(
        children: [ImagenDisco(), SizedBox(width: 38), BarraProgreso()],
      ),
    );
  }
}

class ImagenDisco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final consumeProvider = Provider.of<AudioPlayerMode>(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: Duration(seconds: 10),
              infinite: true,
              animate: false,
              manualTrigger: true,
              controller: (animationController) =>
                  consumeProvider.controller = animationController,
              child: Image(image: AssetImage('assets/aurora.jpg')),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Colors.black38,
              ),
            ),
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Color(0xff1E1C24),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerProvider = Provider.of<AudioPlayerMode>(context);
    final procentaje = audioPlayerProvider.porcentaje;
    return Container(
      child: Column(
        children: [
          Text('${audioPlayerProvider.songTotalDuration}', style: estilo),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: 3,
                height: 220,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 230 * procentaje,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('${audioPlayerProvider.currentSecond}', style: estilo),
        ],
      ),
    );
  }
}

class TituloMusic extends StatefulWidget {
  @override
  _TituloMusicState createState() => _TituloMusicState();
}

class _TituloMusicState extends State<TituloMusic>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController controllerPlay;

  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    controllerPlay =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    this.controllerPlay.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayer = Provider.of<AudioPlayerMode>(context, listen: false);

    assetAudioPlayer.open(
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      autoStart: true,
      showNotification: true,
    );

    // ACA DEFINIMOS CUANTO DURA LA CANCION :
    assetAudioPlayer.current.listen((duration) {
      audioPlayer.songDuration = duration!.audio.duration;
    });

    // ACA DEFINIMOS LOS SEGUNDOS DE LA CANCION :
    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayer.current = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.all(35),
      child: Row(
        children: [
          Column(
            children: [
              Text('Far Away',
                  style: TextStyle(color: Colors.white70, fontSize: 28)),
              SizedBox(height: 5),
              Text('-Breaking Benjamin-',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  )),
            ],
          ),
          Spacer(),
          FloatingActionButton(
            tooltip: 'Play',
            elevation: 0,
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: controllerPlay,
            ),
            onPressed: () {
              final consumeProvider =
                  Provider.of<AudioPlayerMode>(context, listen: false);
              if (this.isPlaying) {
                controllerPlay.reverse();
                isPlaying = false;
                consumeProvider.controller.stop();
                consumeProvider.isPlaying = false;
              } else {
                controllerPlay.forward();
                isPlaying = true;
                consumeProvider.controller.repeat();
                consumeProvider.isPlaying = true;
              }

              if (this.firstTime) {
                this.open();
                this.firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
          ),
        ],
      ),
    );
  }
}

class LyricsMusic extends StatefulWidget {
  @override
  _LyricsMusicState createState() => _LyricsMusicState();
}

class _LyricsMusicState extends State<LyricsMusic> {
  late ScrollController scrollController;
  final lyrics = getLyrics();

  void listener() {
    final isPlay =
        Provider.of<AudioPlayerMode>(context, listen: false).isPlaying;
    if (isPlay) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    } else {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListWheelScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 1.8,
        children: lyrics
            .map((e) => Text(e,
                style: TextStyle(
                    fontSize: 20, color: Colors.white.withOpacity(0.6))))
            .toList(),
      ),
    );
  }
}
