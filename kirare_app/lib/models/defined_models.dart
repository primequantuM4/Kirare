import 'package:kirare_app/models/scale_models.dart';

final List<ScaleModels> definedModels = [
  ScaleModels(
    description: _tizitaDescription,
    name: "Tizita",
    braceletKeys: [1, 3, 5, 8, 10],
    braceletDiagramDescription: _tizitaBraceletDiagramDescription,
    youtubeLink: "https://www.youtube.com/watch?v=OCfFdUavHNw",
    imageUrl: "images/tizita.png",
  ),
  ScaleModels(
    description: _ambasselDescription,
    name: "Ambassel",
    braceletKeys: [1, 2, 6, 8, 9],
    braceletDiagramDescription: _braceletDiagramDescription,
    youtubeLink: "https://www.youtube.com/watch?v=jwRP28_lgjY",
    imageUrl: "images/ambassel.png",
  ),
  ScaleModels(
    description: _batiDescription,
    name: "Batti",
    braceletKeys: [1, 5, 6, 8, 12],
    braceletDiagramDescription: _battiBraceletDiagramDescription,
    youtubeLink: "https://www.youtube.com/watch?v=jwRP28_lgjY",
    imageUrl: "images/batti.png",
  ),
  ScaleModels(
    description: _anchihoyeDescription,
    name: "Anchihoye",
    braceletKeys: [1, 2, 6, 7, 10],
    braceletDiagramDescription: _braceletDiagramDescription,
    youtubeLink: "https://www.youtube.com/watch?v=jwRP28_lgjY",
    imageUrl: "images/anchihoye.png",
  ),
];

const String _tizitaDescription =
    """Formerly Known as Wello Kinit because of its use by the Azmaris around this area.
The name is given because of the popular Amharic song sung in this Kinit. This pentatonic scale has two varieties Major and Minor (Traditionally known as Full Tizita and Half Tizita).
You can easily listen both in different traditional songs. Some examples are Mahamud Ahmed's Tizita song. Tizita Major or Minor pentatonic scale is common and widely used in traditional, pop, jazz and even classical music throughout the world.
""";

const String _batiDescription =
    """This kinit has the name Batti because of two reasons. One, because of the popular song called Batti and two, because of the kinit or scale widely used in Batti area or wello
This kinit has different types variations, which are used in the popular and traditional songs. Popular variations include, Batti Major, Batti Minor and Batti Lydian.
As an example of the Batti kinit would be the popular song of Kassa Tessema's Batti.
""";

const String _anchihoyeDescription =
    """The name is given from the popular tune 'Anchi hoye lene'. The kinit is widely used in festivals and weddings. It is considered by most music experts purely as an Ethiopian scale kinit.
But some musician and singers use Mixolydian pentatonic instead of Anchihoye. One interesting thing here is that some musicians used and considered Mixolydian pentatonic as Ambassel and others as Anchihoye even though, Mixolydian Pentatonic should be considered as a different entity of pentatonic scale since many songs were/are sung in this scale, and has its own characteristics.
""";

const String _ambasselDescription =
    """The name is given to this kinit type for two reasons. One, because of the popular song Ambassel and two, because the popularity of this kinit in Ambassel or Wello area.
Ambassel normally has a single type of variation, but recently because of different reasons, it has two types of variations. The first type of variation is accepted by modern and traditional musicians as Ambassel kinit.
But the second type of variation is more popular by another name, called Mixolydian pentatonic which is widely used in traitional and popular songs.
""";

const _braceletDiagramDescription =
    """The bracelet shows tones that are in this scale, starting from the top (12 o'clock), going clockwise in ascending semitones.
""";
const _tizitaBraceletDiagramDescription =
    """The bracelet shows tones that are in this scale, starting from the top (12 o'clock), going clockwise in ascending semitones. This specific type of bracelet diagram is an example of the Tizita Major scale. The variation of Tizita Minor is playing the 4th semi-tone instead of the 5th and the 9th instead of the 10th
""";
const _battiBraceletDiagramDescription =
    """The bracelet shows tones that are in this scale, starting from the top (12 o'clock), going clockwise in ascending semitones. This specific type of bracelet diagram is an example of the Batti Major scale. The variation of Batti Minor is playing the 4th semi-tone instead of the 5th and the 11th instead of the 12th, where as the variation of Batti Lydian can be achieved by playing the 7th instead of the 6th  
""";
