import 'package:flutter/material.dart';

import 'package:kirare_app/bloc/scale_bloc.dart';

import 'package:kirare_app/widgets/custom_circle_painter.dart';
import 'package:kirare_app/widgets/custom_spacing.dart';
import 'package:kirare_app/widgets/custom_text_description.dart';
import 'package:kirare_app/widgets/scale_name_widget.dart';

import 'package:kirare_app/models/defined_models.dart';
import 'package:kirare_app/models/scale_models.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ResultScreen extends StatefulWidget {
  final Scale result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    final ScaleModels scaleModel = _determineScaleModel();
    final videoID = YoutubePlayer.convertUrlToId(scaleModel.youtubeLink);
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScaleModels scaleModel = _determineScaleModel();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.grey[500],
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ScaleNameWidget(
                scaleName: scaleModel.name,
                scaleImageUrl: scaleModel.imageUrl,
              ),
              const CustomSpacing(),
              CustomTextDescription(description: scaleModel.description),
              const CustomSpacing(),
              const Text(
                "Bracelet Diagram",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
              const CustomSpacing(),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: CustomCirclePainter(
                      scaleKeys: scaleModel.braceletKeys,
                    ),
                  ),
                ),
              ),
              const CustomSpacing(),
              CustomTextDescription(
                description: scaleModel.braceletDiagramDescription,
              ),
              SizedBox(
                width: 350,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: YoutubePlayer(
                    controller: _youtubePlayerController,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ),
              const CustomSpacing()
            ],
          ),
        ));
  }

  ScaleModels _determineScaleModel() {
    ScaleModels scaleModel;
    switch (widget.result) {
      case Scale.tizita:
        scaleModel = definedModels[0];
        break;
      case Scale.ambassel:
        scaleModel = definedModels[1];
        break;
      case Scale.bati:
        scaleModel = definedModels[2];
        break;
      case Scale.anchihoye:
        scaleModel = definedModels[3];
        break;
      default:
        scaleModel = definedModels[0];
    }

    return scaleModel;
  }
}
