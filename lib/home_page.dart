import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'stats_page.dart';
import 'utils/graph.dart';
import 'utils/heart_clip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool toggled = false;
  List<SensorValue> data = <SensorValue>[];
  late CameraController? controller;
  late AnimationController animationController;
  double alpha = 0.3;
  double iconScale = 1;
  int bpm = 0;
  int fs = 60;
  int windowLength = 180;
  CameraImage? image;
  late double averageIntensity;
  late DateTime now;
  late Timer timer;
  late Timer countdown;
  static const int timerSecondsComplete = 30;
  int timerSeconds = timerSecondsComplete;
  late List cameras;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animationController.addListener(() {
      setState(() {
        iconScale = 1.0 + animationController.value * 0.4;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    toggled = false;
    disposeController();
    Wakelock.disable();
    animationController.stop();
    animationController.dispose();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Estimated BPM',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (bpm > 15 && !timer.isActive) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StatPage(result: bpm)));
                            }
                          },
                          child: Hero(
                            tag: 'BPM_RESULT',
                            child: Material(
                              type: MaterialType.transparency,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    (bpm > 15 ? bpm.toString() : '--'),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        backgroundColor: Colors.white,
                        semanticsValue: 'timer',
                        strokeWidth: 10,
                        value:
                            ((timerSecondsComplete - timerSeconds).toDouble() /
                                timerSecondsComplete.toDouble()),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.all(45),
                    child: Center(
                      child: !toggled
                          ? InkWell(
                              onTap: () {
                                toggle();
                              },
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 0.9,
                                  child: Transform.scale(
                                    scale: !toggled ? iconScale : 0,
                                    child: ClipPath(
                                      clipper: HeartClipper(),
                                      child: Container(
                                        color: Colors.red,
                                        child: const Center(
                                          child: Text(
                                            'START',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: 0.9,
                              child: Transform.scale(
                                scale: toggled ? iconScale : 0,
                                child: ClipPath(
                                  clipper: HeartClipper(),
                                  child: CameraPreview(controller!),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    toggled
                        ? "Cover both the camera and the flash with your finger"
                        : "Click on START to determine your heart rate",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  if (toggled)
                    const Text(
                      "Hold for 30 Seconds",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.black,
                ),
                child: Graph(data: data),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearData() {
    bpm = 0;
    data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < windowLength; i++) {
      data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ fs), 128));
    }
  }

  Future<void> initController() async {
    try {
      List cameras = await availableCameras();
      controller = CameraController(cameras.first, ResolutionPreset.ultraHigh);
      await controller!.initialize();
      Future.delayed(const Duration(milliseconds: 100)).then((onValue) {
        controller!.setFlashMode(FlashMode.torch);
      });
      controller!.startImageStream((CameraImage img) {
        image = img;
      });
    } catch (e) {
      //
    }
  }

  void disposeController() {
    controller?.dispose();
    controller = null;
  }

  void initTimer() {
    timer = Timer.periodic(Duration(milliseconds: 1000 ~/ fs), (timer) {
      if (toggled) {
        if (image != null) scanImage(image!);
      } else {
        timer.cancel();
      }
    });
  }

  void startTimer() {
    timerSeconds = timerSecondsComplete;
    const second = Duration(seconds: 1);
    countdown = Timer.periodic(second, (timer) {
      if (!toggled) {
        setState(() {
          timer.cancel();
        });
      } else if (timerSeconds == 0) {
        setState(() {
          untoggle();
          timer.cancel();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StatPage(
                    result: bpm,
                  )));
        });
      } else {
        setState(() {
          timerSeconds--;
        });
      }
    });
  }

  void scanImage(CameraImage image) {
    now = DateTime.now();
    averageIntensity =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (data.length >= windowLength) {
      data.removeAt(0);
    }
    setState(() {
      data.add(SensorValue(now, 255 - averageIntensity));
    });

    int sampleCount = fs ~/ 2;
    if (data.length > sampleCount) {
      var slope =
          (averageIntensity - data.elementAt(data.length - sampleCount).value) /
              sampleCount;
      if (slope > 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Finger moved away from the camera!')));
        untoggle();
      }
    }
  }

  void calculateBPM() async {
    List<SensorValue> values;
    double avg;
    int n;
    double max;
    double threshold;
    double bpm;
    int counter;
    int previous;
    while (toggled) {
      values = List.from(data);
      n = values.length;
      max = 0;
      avg = 0;
      for (var value in values) {
        avg += value.value / n;
        if (value.value > max) {
          max = value.value;
        }
      }
      threshold = (max + avg) / 2;
      bpm = 0;
      counter = 0;
      previous = 0;
      for (int i = 1; i < n; i++) {
        if (values[i - 1].value < threshold && values[i].value > threshold) {
          if (previous != 0) {
            counter++;
            bpm += (60 *
                1000 /
                (values[i].time.millisecondsSinceEpoch - previous));
          }
          previous = values[i].time.millisecondsSinceEpoch;
        }
      }
      if (counter > 0) {
        bpm = (bpm / counter);
        setState(() {
          this.bpm = ((1 - alpha) * this.bpm + alpha * bpm).toInt();
        });
      }
      await Future.delayed(Duration(milliseconds: 1000 * windowLength ~/ fs));
    }
  }

  void toggle() {
    clearData();
    initController().then((onValue) {
      Wakelock.enable();
      animationController.repeat(reverse: true);
      setState(() {
        toggled = true;
      });
      initTimer();
      calculateBPM();
      startTimer();
    });
  }

  void untoggle() {
    disposeController();
    Wakelock.disable();
    animationController.stop();
    animationController.value = 0;
    setState(() {
      toggled = false;
    });
  }
}
