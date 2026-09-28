import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainMenuScreen(),
  ));
}

enum LetterState { idle, active, correct, wrong, passed }

class WordData {
  final String letter;
  final String levelGroup;
  final String answer;
  final String clueEn;
  final String clueTr;

  WordData({
    required this.letter,
    required this.levelGroup,
    required this.answer,
    required this.clueEn,
    required this.clueTr,
  });
}

class ActiveQuestion {
  final String letter;
  final String clue;
  final String answer;
  LetterState state;

  ActiveQuestion({
    required this.letter,
    required this.clue,
    required this.answer,
    this.state = LetterState.idle,
  });
}

final List<WordData> wordDatabase = [
  // A1 - A2 (Temel)
  WordData(letter: 'A', levelGroup: 'A1-A2', answer: 'APPLE', clueEn: 'A sweet red or green fruit that keeps the doctor away.', clueTr: 'Kırmızı veya yeşil renkli, tatlı ve sulu bir meyve.'),
  WordData(letter: 'B', levelGroup: 'A1-A2', answer: 'BICYCLE', clueEn: 'A vehicle with two wheels that you pedal.', clueTr: 'Pedalları ayakla çevrilerek sürülen iki tekerlekli taşıt, bisiklet.'),
  WordData(letter: 'C', levelGroup: 'A1-A2', answer: 'CAMERA', clueEn: 'A device used for taking photographs or recording videos.', clueTr: 'Fotoğraf veya video çekmek için kullanılan cihaz, kamera.'),
  WordData(letter: 'D', levelGroup: 'A1-A2', answer: 'DANGER', clueEn: 'The possibility of suffering harm, damage, or injury.', clueTr: 'Zarar görme veya yaralanma olasılığı durumu, tehlike.'),
  WordData(letter: 'E', levelGroup: 'A1-A2', answer: 'ELEPHANT', clueEn: 'The largest land animal, recognizable by its long trunk.', clueTr: 'Uzun hortumu ve büyük kulaklarıyla bilinen en iri kara hayvanı, fil.'),
  WordData(letter: 'F', levelGroup: 'A1-A2', answer: 'FARMER', clueEn: 'A person who owns or manages a farm and grows food.', clueTr: 'Tarım ve hayvancılıkla uğraşan, tarlayı işleyen kimse, çiftçi.'),
  WordData(letter: 'G', levelGroup: 'A1-A2', answer: 'GARDEN', clueEn: 'A piece of ground next to a house used for growing flowers.', clueTr: 'Çiçeklerin, ağaçların veya sebzelerin yetiştirildiği alan, bahçe.'),
  WordData(letter: 'H', levelGroup: 'A1-A2', answer: 'HOSPITAL', clueEn: 'A place where sick or injured people are treated by doctors.', clueTr: 'Hasta ve yaralıların tedavi edildiği sağlık kuruluşu, hastane.'),
  WordData(letter: 'I', levelGroup: 'A1-A2', answer: 'ISLAND', clueEn: 'A piece of land completely surrounded by water.', clueTr: 'Her yanı suyla çevrilmiş kara parçası, ada.'),
  WordData(letter: 'J', levelGroup: 'A1-A2', answer: 'JACKET', clueEn: 'A short coat that you wear over clothes to keep warm.', clueTr: 'Kıyafetlerin üstüne giyilen kollu ve önü açılır üst giysisi, ceket.'),
  WordData(letter: 'K', levelGroup: 'A1-A2', answer: 'KITCHEN', clueEn: 'A room used for cooking and preparing food.', clueTr: 'Yemek pişirilen ve yiyecek hazırlanan oda, mutfak.'),
  WordData(letter: 'L', levelGroup: 'A1-A2', answer: 'LIBRARY', clueEn: 'A building or room containing collections of books to read.', clueTr: 'Kitapların korunduğu, ödünç verildiği veya okunduğu yer, kütüphane.'),
  WordData(letter: 'M', levelGroup: 'A1-A2', answer: 'MONKEY', clueEn: 'A playful mammal that climbs trees and loves bananas.', clueTr: 'Ağaçlara tırmanmasıyla ve muz sevmesiyle bilinen çevik primat, maymun.'),
  WordData(letter: 'N', levelGroup: 'A1-A2', answer: 'NEIGHBOR', clueEn: 'A person living next door or near to you.', clueTr: 'Evi veya dairesi sizinkine çok yakın olan kimse, komşu.'),
  WordData(letter: 'O', levelGroup: 'A1-A2', answer: 'OCTOPUS', clueEn: 'A sea creature with a soft body and eight long arms.', clueTr: 'Denizlerde yaşayan, sekiz kollu yumuşakça, ahtapot.'),
  WordData(letter: 'P', levelGroup: 'A1-A2', answer: 'PASSPORT', clueEn: 'An official document certifying identity for foreign travel.', clueTr: 'Yurt dışına çıkarken kimliği belgeleyen resmi evrak, pasaport.'),
  WordData(letter: 'Q', levelGroup: 'A1-A2', answer: 'QUEEN', clueEn: 'The female ruler of an independent royal nation.', clueTr: 'Bir krallığı yöneten veya kralın eşi olan kadın hükümdar, kraliçe.'),
  WordData(letter: 'R', levelGroup: 'A1-A2', answer: 'RIVER', clueEn: 'A large natural stream of water flowing in a channel to the sea.', clueTr: 'Denize veya göle doğru sürekli akan büyük doğal su yatağı, nehir.'),
  WordData(letter: 'S', levelGroup: 'A1-A2', answer: 'SUMMER', clueEn: 'The warmest season of the year, between spring and autumn.', clueTr: 'Yılın en sıcak mevsimi, ilkbahar ile sonbahar arası; yaz.'),
  WordData(letter: 'T', levelGroup: 'A1-A2', answer: 'TEACHER', clueEn: 'A person who educates students in a school.', clueTr: 'Bir okulda öğrencilere bilgi ve beceri öğreten meslek sahibi, öğretmen.'),
  WordData(letter: 'U', levelGroup: 'A1-A2', answer: 'UMBRELLA', clueEn: 'A folding circular canopy protecting against wet rain.', clueTr: 'Yağmurdan veya güneşten korunmak için açılan katlanır siperlik, şemsiye.'),
  WordData(letter: 'V', levelGroup: 'A1-A2', answer: 'VILLAGE', clueEn: 'A small group of houses in a rural countryside area.', clueTr: 'Kırsal kesimde yer alan, kasaba veya şehirden küçük yerleşim, köy.'),
  WordData(letter: 'W', levelGroup: 'A1-A2', answer: 'WINDOW', clueEn: 'An opening in a wall fitted with glass to admit light.', clueTr: 'Duvarlara açılan, odaya ışık girmesini sağlayan camlı çerçeve, pencere.'),
  WordData(letter: 'X', levelGroup: 'A1-A2', answer: 'XYLOPHONE', clueEn: 'A musical instrument played by striking wooden bars with sticks.', clueTr: 'Tahta çubuklara tokmakla vurularak çalınan vurmalı müzik aleti, ksilofon.'),
  WordData(letter: 'Y', levelGroup: 'A1-A2', answer: 'YESTERDAY', clueEn: 'On the day before today.', clueTr: 'Bugünden hemen bir önceki gün, dün.'),
  WordData(letter: 'Z', levelGroup: 'A1-A2', answer: 'ZEBRA', clueEn: 'An African wild horse with black and white stripes.', clueTr: 'Afrika savanlarında yaşayan, siyah-beyaz çizgili yaban atı, zebra.'),

  // B1 - B2 (Orta - İleri)
  WordData(letter: 'A', levelGroup: 'B1-B2', answer: 'AMBITION', clueEn: 'A strong desire to achieve success, power, or fame.', clueTr: 'Bir hedefe veya başarıya ulaşma konusundaki güçlü istek, hırs/tutku.'),
  WordData(letter: 'B', levelGroup: 'B1-B2', answer: 'BEHAVIOR', clueEn: 'The way in which one acts or conducts oneself.', clueTr: 'Bir kimsenin sergilediği tutum ve hareket tarzı, davranış.'),
  WordData(letter: 'C', levelGroup: 'B1-B2', answer: 'CONFIDENCE', clueEn: 'A feeling of self-assurance in one\'s abilities or qualities.', clueTr: 'Kendi yeteneklerine ve gücüne güvenme duygusu, özgüven.'),
  WordData(letter: 'D', levelGroup: 'B1-B2', answer: 'DECISION', clueEn: 'A conclusion or resolution reached after consideration.', clueTr: 'Düşünüp tarttıktan sonra varılan kesin sonuç veya yargı, karar.'),
  WordData(letter: 'E', levelGroup: 'B1-B2', answer: 'ENVIRONMENT', clueEn: 'The natural world and ecosystem surrounding living things.', clueTr: 'Tüm canlıların içinde barındığı doğal ortam ve eko-düzen, çevre.'),
  WordData(letter: 'F', levelGroup: 'B1-B2', answer: 'FREEDOM', clueEn: 'The power or right to act, speak, or think without restraint.', clueTr: 'Kişinin hiçbir dış baskı altında kalmadan hareket edebilmesi, özgürlük.'),
  WordData(letter: 'G', levelGroup: 'B1-B2', answer: 'GENEROUS', clueEn: 'Showing a readiness to give more of something than is strictly necessary.', clueTr: 'Elindekileri, parasını ve imkanlarını seve seve paylaşan kimse, cömert.'),
  WordData(letter: 'H', levelGroup: 'B1-B2', answer: 'HERITAGE', clueEn: 'Property, customs, or culture inherited from past generations.', clueTr: 'Geçmiş nesillerden devralınan tarihi veya kültürel değerler bütünü, miras.'),
  WordData(letter: 'I', levelGroup: 'B1-B2', answer: 'INFLUENCE', clueEn: 'The capacity to have an effect on the character or behavior of someone.', clueTr: 'Başkalarının düşüncelerini ve eylemlerini yönlendirebilme gücü, etki/nüfuz.'),
  WordData(letter: 'J', levelGroup: 'B1-B2', answer: 'JUSTICE', clueEn: 'Just behavior or treatment; fair administration of law.', clueTr: 'Hak ve hukuka uygunluk, herkese hakkını verme ilkesi, adalet.'),
  WordData(letter: 'K', levelGroup: 'B1-B2', answer: 'KNOWLEDGE', clueEn: 'Facts, information, and skills acquired through experience or education.', clueTr: 'Öğrenme, araştırma veya gözlem yoluyla elde edilen müktesebat, bilgi.'),
  WordData(letter: 'L', levelGroup: 'B1-B2', answer: 'LEADERSHIP', clueEn: 'The action or ability of directing a group of people.', clueTr: 'Bir grubu veya topluluğu yönetme ve peşinden sürükleme kabiliyeti, liderlik.'),
  WordData(letter: 'M', levelGroup: 'B1-B2', answer: 'MOTIVATION', clueEn: 'The general desire or willingness of someone to do something.', clueTr: 'Birisini bir amaç uğruna harekete geçiren istek ve şevk kaynağı, motivasyon.'),
  WordData(letter: 'N', levelGroup: 'B1-B2', answer: 'NECESSARY', clueEn: 'Required to be done, achieved, or present; essential.', clueTr: 'Olmazsa olmaz, mutlaka yapılması veya bulunması icap eden, gerekli/zorunlu.'),
  WordData(letter: 'O', levelGroup: 'B1-B2', answer: 'OPINION', clueEn: 'A view or judgment formed about something, not necessarily based on fact.', clueTr: 'Bir konu üzerinde zihinde oluşan kişisel düşünce, görüş/fikir.'),
  WordData(letter: 'P', levelGroup: 'B1-B2', answer: 'PATIENCE', clueEn: 'The capacity to accept delay or suffering without getting angry.', clueTr: 'Zorluklara ve gecikmelere karşı öfkelenmeden metanetle bekleme gücü, sabır.'),
  WordData(letter: 'Q', levelGroup: 'B1-B2', answer: 'QUALIFIED', clueEn: 'Officially recognized as being trained to perform a particular job.', clueTr: 'Gerekli eğitim, sertifika ve yeterliliğe sahip olan, nitelikli/vasıflı.'),
  WordData(letter: 'R', levelGroup: 'B1-B2', answer: 'RESPONSIBLE', clueEn: 'Having an obligation to do something as part of a job or role.', clueTr: 'Görevini yerine getirmekle yükümlü olan kimse, sorumlu.'),
  WordData(letter: 'S', levelGroup: 'B1-B2', answer: 'STRATEGY', clueEn: 'A plan of action designed to achieve a long-term overall aim.', clueTr: 'Belirlenen hedeflere varmak için çizilen kapsamlı eylem planı, strateji.'),
  WordData(letter: 'T', levelGroup: 'B1-B2', answer: 'TALENTED', clueEn: 'Having a natural aptitude or skill for something creative.', clueTr: 'Doğuştan gelen üstün beceri ve yatkınlığı olan kimse, yetenekli.'),
  WordData(letter: 'U', levelGroup: 'B1-B2', answer: 'URGENT', clueEn: 'Requiring immediate action or attention.', clueTr: 'Gecikmeye tahammülü olmayan, ivedilikle halledilmesi gereken, acil.'),
  WordData(letter: 'V', levelGroup: 'B1-B2', answer: 'VOLUNTEER', clueEn: 'A person who freely offers to take part in an enterprise or service.', clueTr: 'Hiçbir maddi karşılık beklemeden kendi isteğiyle çalışan kimse, gönüllü.'),
  WordData(letter: 'W', levelGroup: 'B1-B2', answer: 'WARNING', clueEn: 'A statement or event that indicates a possible or impending danger.', clueTr: 'Olası bir tehlike veya hataya karşı yapılan ikaz, uyarı.'),
  WordData(letter: 'X', levelGroup: 'B1-B2', answer: 'XENOPHOBIA', clueEn: 'Dislike of or prejudice against people from other countries.', clueTr: 'Yabancılardan veya yabancı kültürlerden yersiz korkma, yabancı düşmanlığı.'),
  WordData(letter: 'Y', levelGroup: 'B1-B2', answer: 'YIELD', clueEn: 'To produce or provide a natural, agricultural, or financial product.', clueTr: 'Ürün vermek, mahsul veya kazanç getirmek; hasılat/getiri.'),
  WordData(letter: 'Z', levelGroup: 'B1-B2', answer: 'JEALOUS', clueEn: 'Envious of someone else\'s achievements (Sound of Z).', clueTr: 'Kıskanç veya çekemez kimse.'),

  // C1 - C2 (Akademik & Uzman)
  WordData(letter: 'A', levelGroup: 'C1-C2', answer: 'AUTHENTIC', clueEn: 'Of undisputed origin and not a copy; genuinely real.', clueTr: 'Orijinal, taklit olmayan, hakiki, özgün.'),
  WordData(letter: 'B', levelGroup: 'C1-C2', answer: 'BENEVOLENT', clueEn: 'Well meaning, kindly, and dedicated to charitable acts.', clueTr: 'Yardımsever, cömert, hayırsever ve iyilik dolu.'),
  WordData(letter: 'C', levelGroup: 'C1-C2', answer: 'CONSCIENTIOUS', clueEn: 'Wishing to do one\'s work thoroughly and with deep moral duty.', clueTr: 'Görevine ve vicdanına bağlı, işini titizlikle yapan.'),
  WordData(letter: 'D', levelGroup: 'C1-C2', answer: 'DILIGENT', clueEn: 'Showing persistent care and conscientious effort in duties.', clueTr: 'İşinde sebatkar, özenli ve gayretli çalışan.'),
  WordData(letter: 'E', levelGroup: 'C1-C2', answer: 'ELOQUENT', clueEn: 'Fluent and persuasive in speaking or expressive rhetoric.', clueTr: 'Sözleri güzel, etkili ve akıcı olan; beliğ.'),
  WordData(letter: 'F', levelGroup: 'C1-C2', answer: 'FASTIDIOUS', clueEn: 'Very attentive to detail, cleanliness, and accuracy; hard to please.', clueTr: 'Aşırı titiz, zor beğenen ve her ayrıntıya takılan kılı kırk yaran kimse.'),
  WordData(letter: 'G', levelGroup: 'C1-C2', answer: 'GREGARIOUS', clueEn: 'Fond of social company and living in community groups.', clueTr: 'Sosyalleşmeye düşkün, topluluk içinde yaşamayı seven.'),
  WordData(letter: 'H', levelGroup: 'C1-C2', answer: 'HYPOCRISY', clueEn: 'The practice of claiming to have moral standards one does not possess.', clueTr: 'Olduğundan farklı görünme hali, iki yüzlülük/riyakarlık.'),
  WordData(letter: 'I', levelGroup: 'C1-C2', answer: 'IMPECCABLE', clueEn: 'In accordance with the highest standards; faultless and flawless.', clueTr: 'Hatasız, kusursuz ve eksiksiz nitelikte olan.'),
  WordData(letter: 'J', levelGroup: 'C1-C2', answer: 'JUXTAPOSE', clueEn: 'To place different things together to create a contrasting effect.', clueTr: 'İki farklı nesne veya kavramı karşılaştırmak için yan yana getirmek.'),
  WordData(letter: 'K', levelGroup: 'C1-C2', answer: 'KINETIC', clueEn: 'Relating to or resulting from mechanical motion.', clueTr: 'Hareketle ilgili olan veya hareketten kaynaklanan enerji, kinetik.'),
  WordData(letter: 'L', levelGroup: 'C1-C2', answer: 'LUCID', clueEn: 'Expressed clearly; easy to understand and mentally sound.', clueTr: 'Anlaşılması son derece kolay, açık, berrak ve mantıklı.'),
  WordData(letter: 'M', levelGroup: 'C1-C2', answer: 'METICULOUS', clueEn: 'Showing great attention to detail; very careful and precise.', clueTr: 'Detaylara olağanüstü özen gösteren, aşırı dikkatli kimse.'),
  WordData(letter: 'N', levelGroup: 'C1-C2', answer: 'NEBULOUS', clueEn: 'In the form of a cloud or haze; unclear, vague, or ill-defined.', clueTr: 'Bulut gibi belirsiz, sınırları net çizilmemiş, muğlak.'),
  WordData(letter: 'O', levelGroup: 'C1-C2', answer: 'OBSOLETE', clueEn: 'No longer produced or used; out of date.', clueTr: 'Kullanımdan kalkmış, eskimiş, çağı geçmiş; köhne.'),
  WordData(letter: 'P', levelGroup: 'C1-C2', answer: 'PRAGMATIC', clueEn: 'Dealing with things sensibly based on practical considerations.', clueTr: 'Teoriden çok uygulanabilirliğe ve faydaya dayanan, faydacı.'),
  WordData(letter: 'Q', levelGroup: 'C1-C2', answer: 'QUINTESSENCE', clueEn: 'The most perfect or typical example of a quality or class.', clueTr: 'Bir niteliğin veya durumun en mükemmel timsali, özü.'),
  WordData(letter: 'R', levelGroup: 'C1-C2', answer: 'RESILIENT', clueEn: 'Able to withstand or recover quickly from difficult conditions.', clueTr: 'Zorluklara karşı esnek, çabuk toparlanan; mukavim.'),
  WordData(letter: 'S', levelGroup: 'C1-C2', answer: 'SCRUPULOUS', clueEn: 'Diligent, thorough, and extremely attentive to moral standards.', clueTr: 'Ahlaki kurallara ve dürüstlüğe aşırı derecede özen gösteren.'),
  WordData(letter: 'T', levelGroup: 'C1-C2', answer: 'TRANSIENT', clueEn: 'Lasting only for a short time; impermanent and fleeting.', clueTr: 'Kalıcı olmayan, gelip geçici, kısa süren; fani.'),
  WordData(letter: 'U', levelGroup: 'C1-C2', answer: 'UBIQUITOUS', clueEn: 'Present, appearing, or found everywhere at the same time.', clueTr: 'Her yerde aynı anda hazır bulunan, her tarafta rastlanan.'),
  WordData(letter: 'V', levelGroup: 'C1-C2', answer: 'VULNERABLE', clueEn: 'Exposed to the possibility of being attacked or harmed.', clueTr: 'Zarar görmeye veya darbeye açık, savunmasız/kırılgan.'),
  WordData(letter: 'W', levelGroup: 'C1-C2', answer: 'WARY', clueEn: 'Feeling or showing caution about possible dangers or problems.', clueTr: 'Olası tehlikelere karşı tedbirli, tetikte davranan.'),
  WordData(letter: 'X', levelGroup: 'C1-C2', answer: 'XENIAL', clueEn: 'Hospitable, especially to visiting foreigners or guests.', clueTr: 'Misafirlere ve yabancılara karşı konuksever olan.'),
  WordData(letter: 'Y', levelGroup: 'C1-C2', answer: 'YEARN', clueEn: 'To have an intense, deep feeling of longing for something lost.', clueTr: 'Derin bir hasret veya özlem duymak, yanıp tutuşmak.'),
  WordData(letter: 'Z', levelGroup: 'C1-C2', answer: 'ZEALOUS', clueEn: 'Having great energy and passion in pursuit of a cause.', clueTr: 'Bir amaç uğruna büyük gayret ve coşku gösteren; şevkli/hararetli.'),
];

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String selectedLevel = 'A1-A2';
  String selectedLanguage = 'TR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF3B82F6)]),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF38BDF8).withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 4),
                    ],
                  ),
                  child: const Center(
                    child: Text('P', style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'PASSAPAROLA',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
                const SizedBox(height: 4),
                const Text(
                  'English Vocabulary Game',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
                const SizedBox(height: 32),

                _buildSectionTitle('SEVİYE SEÇİN'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildOptionButton(title: 'A1 - A2', subtitle: 'Temel', value: 'A1-A2', currentGroupValue: selectedLevel, onSelect: (v) => setState(() => selectedLevel = v)),
                    const SizedBox(width: 8),
                    _buildOptionButton(title: 'B1 - B2', subtitle: 'Orta', value: 'B1-B2', currentGroupValue: selectedLevel, onSelect: (v) => setState(() => selectedLevel = v)),
                    const SizedBox(width: 8),
                    _buildOptionButton(title: 'C1 - C2', subtitle: 'Uzman', value: 'C1-C2', currentGroupValue: selectedLevel, onSelect: (v) => setState(() => selectedLevel = v)),
                  ],
                ),
                const SizedBox(height: 26),

                _buildSectionTitle('SORU İPUCU DİLİ'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildLanguageButton(label: '🇹🇷 Türkçe Soru', value: 'TR', currentGroupValue: selectedLanguage, onSelect: (v) => setState(() => selectedLanguage = v)),
                    const SizedBox(width: 10),
                    _buildLanguageButton(label: '🇬🇧 English Clue', value: 'EN', currentGroupValue: selectedLanguage, onSelect: (v) => setState(() => selectedLanguage = v)),
                  ],
                ),
                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PassaparolaGame(
                            levelGroup: selectedLevel,
                            language: selectedLanguage,
                          ),
                        ),
                      );
                    },
                    child: const Text('OYUNU BAŞLAT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildOptionButton({
    required String title,
    required String subtitle,
    required String value,
    required String currentGroupValue,
    required ValueChanged<String> onSelect,
  }) {
    final bool isSelected = value == currentGroupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? Colors.white : Colors.white12, width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              Text(title, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 2),
              Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.black87 : const Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required String label,
    required String value,
    required String currentGroupValue,
    required ValueChanged<String> onSelect,
  }) {
    final bool isSelected = value == currentGroupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? Colors.white : Colors.white12, width: isSelected ? 2 : 1),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
    );
  }
}

class PassaparolaGame extends StatefulWidget {
  final String levelGroup;
  final String language;

  const PassaparolaGame({
    super.key,
    required this.levelGroup,
    required this.language,
  });

  @override
  State<PassaparolaGame> createState() => _PassaparolaGameState();
}

class _PassaparolaGameState extends State<PassaparolaGame> {
  late List<ActiveQuestion> questions;
  int currentIndex = 0;
  int score = 0;
  int timerSeconds = 180;
  Timer? timer;
  bool isGameOver = false;

  // Ses Tanıma Alanı
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenWords = '';

  final TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _prepareQuestions();
    _startTimer();
  }

  void _prepareQuestions() {
    questions = [];
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = math.Random(DateTime.now().microsecondsSinceEpoch);

    for (int i = 0; i < alphabet.length; i++) {
      String letter = alphabet[i];
      List<WordData> pool = wordDatabase.where((w) => w.letter == letter && w.levelGroup == widget.levelGroup).toList();

      if (pool.isEmpty) {
        pool = wordDatabase.where((w) => w.letter == letter).toList();
      }

      pool.shuffle(random);
      final chosen = pool.isNotEmpty
          ? pool.first
          : WordData(
              letter: letter,
              levelGroup: widget.levelGroup,
              answer: '${letter}WORD',
              clueEn: 'A vocabulary word starting with $letter.',
              clueTr: '$letter harfi ile başlayan kelime.',
            );

      questions.add(
        ActiveQuestion(
          letter: letter,
          clue: widget.language == 'TR' ? chosen.clueTr : chosen.clueEn,
          answer: chosen.answer,
        ),
      );
    }

    questions[0].state = LetterState.active;
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timerSeconds > 0) {
        setState(() => timerSeconds--);
      } else {
        _endGame();
      }
    });
  }

  // Mikrofondan Konuşma Başlat / Durdur
  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => setState(() => _isListening = false),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'en_US', // İngilizce kelimeleri net anlaması için
          onResult: (val) {
            setState(() {
              _spokenWords = val.recognizedWords;
              inputController.text = _spokenWords;
            });
            // Konuşma netleştiğinde otomatik kontrol et
            if (val.hasConfidenceRating && val.confidence > 0.5) {
              checkAnswer(_spokenWords);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void checkAnswer(String val) {
    if (isGameOver) return;
    final text = val.trim().toUpperCase();
    if (text.isEmpty) return;

    if (text == 'PAS' || text == 'PASS') {
      passQuestion();
      return;
    }

    setState(() {
      if (text == questions[currentIndex].answer) {
        questions[currentIndex].state = LetterState.correct;
        score += 10;
      } else {
        questions[currentIndex].state = LetterState.wrong;
      }
      inputController.clear();
      advanceLetter();
    });
  }

  void passQuestion() {
    if (isGameOver) return;
    setState(() {
      questions[currentIndex].state = LetterState.passed;
      inputController.clear();
      advanceLetter();
    });
  }

  void advanceLetter() {
    int next = (currentIndex + 1) % questions.length;
    int inspected = 0;
    while (inspected < questions.length) {
      if (questions[next].state == LetterState.idle || questions[next].state == LetterState.passed) {
        currentIndex = next;
        questions[currentIndex].state = LetterState.active;
        return;
      }
      next = (next + 1) % questions.length;
      inspected++;
    }
    _endGame();
  }

  void _endGame() {
    timer?.cancel();
    if (_isListening) _speech.stop();
    setState(() => isGameOver = true);
    _showGameOverDialog();
  }

  void _showGameOverDialog() {
    int correctCount = questions.where((q) => q.state == LetterState.correct).length;
    int wrongCount = questions.where((q) => q.state == LetterState.wrong).length;
    int passedCount = questions.where((q) => q.state == LetterState.passed || q.state == LetterState.idle).length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131D2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF38BDF8), width: 1.5)),
        title: const Center(
          child: Text(
            '🏆 OYUN BİTTİ!',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Toplam Puan: ', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text('$score', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('✅ Doğru Cevap:', '$correctCount', const Color(0xFF10B981)),
            const SizedBox(height: 8),
            _buildStatRow('❌ Yanlış Cevap:', '$wrongCount', const Color(0xFFEF4444)),
            const SizedBox(height: 8),
            _buildStatRow('⏸ Pas / Boş:', '$passedCount', const Color(0xFFF59E0B)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('ANA MENÜYE DÖN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color getStatusColor(LetterState s) {
    switch (s) {
      case LetterState.correct:
        return const Color(0xFF10B981);
      case LetterState.wrong:
        return const Color(0xFFEF4444);
      case LetterState.passed:
        return const Color(0xFFF59E0B);
      case LetterState.active:
        return const Color(0xFF38BDF8);
      case LetterState.idle:
      default:
        return const Color(0xFF1E293B);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    if (_isListening) _speech.stop();
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double wheelSize = 340.0;
    const double radius = 135.0;
    final current = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.levelGroup} • ${widget.language == 'TR' ? 'Türkçe' : 'English'}',
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('⏱ $timerSeconds sn', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Skor: $score', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Harf Çarkı
              SizedBox(
                width: wheelSize,
                height: wheelSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: radius * 2,
                      height: radius * 2,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white12, width: 2)),
                    ),
                    for (int i = 0; i < questions.length; i++) ...[
                      Builder(builder: (context) {
                        final angle = (2 * math.pi / questions.length) * i - (math.pi / 2);
                        final x = (wheelSize / 2) + radius * math.cos(angle) - 15;
                        final y = (wheelSize / 2) + radius * math.sin(angle) - 15;

                        return Positioned(
                          left: x,
                          top: y,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: getStatusColor(questions[i].state),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: questions[i].state == LetterState.active ? Colors.white : Colors.white24,
                                width: questions[i].state == LetterState.active ? 2 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              questions[i].letter,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: questions[i].state == LetterState.active ? FontWeight.w900 : FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                    Container(
                      width: 170,
                      height: 170,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF131D2E),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(current.letter, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            current.clue,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Giriş / Mikrofon / Pas Butonları
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Mikrofon Butonu
                    IconButton(
                      iconSize: 32,
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? const Color(0xFFEF4444) : const Color(0xFF38BDF8),
                      ),
                      onPressed: _listen,
                    ),
                    const SizedBox(width: 4),

                    // Metin Alanı
                    Expanded(
                      child: TextField(
                        controller: inputController,
                        onSubmitted: checkAnswer,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: _isListening ? 'Dinleniyor...' : 'Yazın veya mikrofona basın...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Gönder
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: () => checkAnswer(inputController.text),
                      child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),

                    // Pas
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: passQuestion,
                      child: const Text('PAS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}