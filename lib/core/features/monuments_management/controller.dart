import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/features/monuments_management/domain.dart';
import 'package:myguide/core/services/db_service.dart';
import 'package:myguide/core/utils/async.dart';

typedef MonumentState = AsyncValue<Iterable<Monument>>;

final monumentManagementProvider = StateNotifierProvider.autoDispose<
    MonumentManagementController, MonumentState>((ref) {
  final uid = ref.watch(uidProvider);
  return MonumentManagementController(
    uid: uid,
    collectionPath: 'Monuments',
    dbService: DBService(),
  );
});

class MonumentManagementController extends StateNotifier<MonumentState>
    with StateNotifierSubscriptionMixin {
  MonumentManagementController({
    required this.uid,
    required this.collectionPath,
    required this.dbService,
  }) : super(const MonumentState.loading()) {
    initialize();
  }

  final String uid;
  final String collectionPath;
  final DBService dbService;

  void initialize() async {
    state = MonumentState.data([
      Monument(
        id: 'colosseum',
        name: 'Colosseum',
        address: 'Piazza del Colosseo 1, 00184 Roma',
        description:
            '''The Colosseum is an oval amphitheatre in the centre of the city of Rome, Italy, just east of the Roman Forum. It is the largest ancient amphitheatre ever built, and is still the largest standing amphitheatre in the world today, despite its age. Construction began under the emperor Vespasian (r. 69–79 AD) in 72 and was completed in 80 AD under his successor and heir, Titus (r. 79–81). Further modifications were made during the reign of Domitian (r. 81–96). The three emperors that were patrons of the work are known as the Flavian dynasty, and the amphitheatre was named the Flavian Amphitheatre by later classicists and archaeologists for its association with their family name (Flavius).\n\nThe Colosseum is built of travertine limestone, tuff (volcanic rock), and brick-faced concrete. It could hold an estimated 50,000 to 80,000 spectators at various points in its history, having an average audience of some 65,000; it was used for gladiatorial contests and public spectacles including animal hunts, executions, re-enactments of famous battles, and dramas based on Roman mythology, and briefly mock sea battles. The building ceased to be used for entertainment in the early medieval era. It was later reused for such purposes as housing, workshops, quarters for a religious order, a fortress, a quarry, and a Christian shrine.
            ''',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/myguide-prod.appspot.com/o/content%2Fimages%2Fcolosseum.jpg?alt=media&token=31f8cc55-424e-47fe-9ae3-c37340f91059',
      ),
      Monument(
        id: 'sagrada',
        name: 'Sagrada Família',
        address: 'Carrer de Mallorca, 401, 08013 Barcelona, Spain',
        description:
            '''Il 19 marzo 1882 iniziò la costruzione della Sagrada Família sotto l'architetto Francisco de Paula del Villar . Nel 1883, quando Villar si dimise, Gaudí subentrò come capo architetto, trasformando il progetto con il suo stile architettonico e ingegneristico, combinando forme gotiche e curvilinee Art Nouveau . Gaudí ha dedicato il resto della sua vita al progetto ed è sepolto nella cripta della chiesa. Al momento della sua morte nel 1926, meno di un quarto del progetto era stato completato.\n\nLa costruzione della Sagrada Família procedette lentamente e fu interrotta dalla guerra civile spagnola . Nel luglio 1936, gli anarchici del FAI incendiarono la cripta e irruppero nel laboratorio, distruggendo parzialmente i piani, i disegni e i modelli in gesso originali di Gaudí.\n\nLo stile della Sagrada Família è variamente paragonato al tardo gotico spagnolo , al modernismo catalano o all'Art Nouveau . Sebbene la Sagrada Família rientri nel periodo Art Nouveau, Nikolaus Pevsner sottolinea che, insieme a Charles Rennie Mackintosh a Glasgow, Gaudí portò lo stile Art Nouveau ben oltre la sua consueta applicazione come decorazione di superficie.
            ''',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/myguide-prod.appspot.com/o/content%2Fimages%2Fsagrada.jpg?alt=media&token=fdcd03c7-ecbb-4248-8abc-c0b2963f69ec',
      ),
      Monument(
        id: 'torre',
        name: 'Torre Eiffel',
        address: '5 Avenue Anatole 75007 Paris, France',
        description:
            '''La Torre Eiffel (in francese tour Eiffel) è una torre metallica completata nel 1889 in occasione dell'esposizione universale e poi divenuta il monumento più famoso di Parigi, conosciuto in tutto il mondo come simbolo della città stessa e della Francia.\n\nLa Torre si trova in uno dei punti nevralgici della viabilità parigina, essendo a poca distanza da strade rotabili di primaria importanza come avenue Gustave Eiffel, avenue de la Bourdonnais, avenue de Suffren e infine la trafficata Quai Branly (che sfocia nel Pont d'Iéna, sulla Senna). Queste quattro direttrici, intersecandosi, descrivono un rettangolo all'interno del quale si inseriscono la Torre, circondata da un fitto boschetto e da alcuni laghetti: le strade di questo parco sono completamente chiuse al traffico motorizzato e sono aperte al solo transito pedonale.
            ''',
        imageURL:
            'https://firebasestorage.googleapis.com/v0/b/myguide-prod.appspot.com/o/content%2Fimages%2Fimage5.jpg?alt=media&token=064a0094-7c49-4f7a-920f-42d57e4ee1bf',
      ),
    ]);
  }

  Future<Monument?> getMonument({String? id}) async {
    if (id == null) return null;
    final monuments = await first;
    return monuments.firstWhereOrNull((monument) {
      return monument.id == id;
    });
  }
}
