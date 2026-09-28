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
  final String meaning;
  LetterState state;

  ActiveQuestion({
    required this.letter,
    required this.clue,
    required this.answer,
    required this.meaning,
    this.state = LetterState.idle,
  });
}

final List<WordData> wordDatabase = [
  // A1 - A2
  WordData(letter: 'A', levelGroup: 'A1-A2', answer: 'APPLE', clueEn: 'A sweet red or green fruit that keeps the doctor away.', clueTr: 'Kırmızı veya yeşil renkli, tatlı ve sulu bir meyve.'),
  WordData(letter: 'A', levelGroup: 'A1-A2', answer: 'AIRPORT', clueEn: 'A place where planes take off and land.', clueTr: 'Uçakların kalkıp indiği yolcu alanı, havaalanı.'),
  WordData(letter: 'B', levelGroup: 'A1-A2', answer: 'BICYCLE', clueEn: 'A vehicle with two wheels that you pedal.', clueTr: 'Pedalları çevrilerek sürülen iki tekerlekli taşıt, bisiklet.'),
  WordData(letter: 'B', levelGroup: 'A1-A2', answer: 'BANANA', clueEn: 'A long curved yellow fruit with soft sweet flesh.', clueTr: 'Sarı kabuklu, tatlı tropikal bir meyve, muz.'),
  WordData(letter: 'C', levelGroup: 'A1-A2', answer: 'CAMERA', clueEn: 'A device used for taking photographs or recording videos.', clueTr: 'Fotoğraf veya video çekmek için kullanılan cihaz, kamera.'),
  WordData(letter: 'C', levelGroup: 'A1-A2', answer: 'COFFEE', clueEn: 'A hot dark drink made from roasted beans.', clueTr: 'Kavrulmuş çekirdeklerden demlenen sıcak içecek, kahve.'),
  WordData(letter: 'D', levelGroup: 'A1-A2', answer: 'DANGER', clueEn: 'The possibility of suffering harm, damage, or injury.', clueTr: 'Zarar görme veya yaralanma olasılığı durumu, tehlike.'),
  WordData(letter: 'D', levelGroup: 'A1-A2', answer: 'DOCTOR', clueEn: 'A person qualified to treat people who are ill.', clueTr: 'Hastalıkları teşhis ve tedavi eden tıp uzmanı, doktor.'),
  WordData(letter: 'E', levelGroup: 'A1-A2', answer: 'ELEPHANT', clueEn: 'The largest land animal with a trunk and big tusks.', clueTr: 'Uzun hortumu ve dişleriyle bilinen iri kara memelisi, fil.'),
  WordData(letter: 'F', levelGroup: 'A1-A2', answer: 'FARMER', clueEn: 'A person who owns or manages a farm and grows food.', clueTr: 'Toprağı ekip biçen kimse, çiftçi.'),
  WordData(letter: 'G', levelGroup: 'A1-A2', answer: 'GARDEN', clueEn: 'A piece of ground used for growing flowers or plants.', clueTr: 'Çiçek veya sebze yetiştirilen bahçe.'),
  WordData(letter: 'H', levelGroup: 'A1-A2', answer: 'HOSPITAL', clueEn: 'A place where sick people receive medical treatment.', clueTr: 'Hastaların tedavi edildiği sağlık kurumu, hastane.'),
  WordData(letter: 'I', levelGroup: 'A1-A2', answer: 'ISLAND', clueEn: 'A piece of land completely surrounded by water.', clueTr: 'Dört tarafı sularla çevrili kara parçası, ada.'),
  WordData(letter: 'J', levelGroup: 'A1-A2', answer: 'JACKET', clueEn: 'A short coat with sleeves that opens at the front.', clueTr: 'Üst giysisi, ceket.'),
  WordData(letter: 'K', levelGroup: 'A1-A2', answer: 'KITCHEN', clueEn: 'A room where food is kept and cooked.', clueTr: 'Yemek pişirilen oda, mutfak.'),
  WordData(letter: 'L', levelGroup: 'A1-A2', answer: 'LIBRARY', clueEn: 'A building containing collections of books.', clueTr: 'Kitapların bulunduğu yer, kütüphane.'),
  WordData(letter: 'M', levelGroup: 'A1-A2', answer: 'MONKEY', clueEn: 'A mammal that climbs trees and has a tail.', clueTr: 'Ağaçlara tırmanan primat, maymun.'),
  WordData(letter: 'N', levelGroup: 'A1-A2', answer: 'NEIGHBOR', clueEn: 'A person who lives next door or close to you.', clueTr: 'Evi yakın olan kimse, komşu.'),
  WordData(letter: 'O', levelGroup: 'A1-A2', answer: 'OCTOPUS', clueEn: 'A soft-bodied marine creature with eight arms.', clueTr: 'Sekiz kollu deniz yumuşakçası, ahtapot.'),
  WordData(letter: 'P', levelGroup: 'A1-A2', answer: 'PASSPORT', clueEn: 'An official document certifying identity for travel.', clueTr: 'Yurt dışı seyahat belgesi, pasaport.'),
  WordData(letter: 'Q', levelGroup: 'A1-A2', answer: 'QUEEN', clueEn: 'The female ruler of an independent royal state.', clueTr: 'Kadın hükümdar, kraliçe.'),
  WordData(letter: 'R', levelGroup: 'A1-A2', answer: 'RIVER', clueEn: 'A large natural stream of water flowing to the sea.', clueTr: 'Büyük doğal akarsu, nehir.'),
  WordData(letter: 'S', levelGroup: 'A1-A2', answer: 'SUMMER', clueEn: 'The warmest season of the year.', clueTr: 'En sıcak mevsim, yaz.'),
  WordData(letter: 'T', levelGroup: 'A1-A2', answer: 'TEACHER', clueEn: 'A person who instructs others in a school.', clueTr: 'Öğretim görevlisi/öğretmen.'),
  WordData(letter: 'U', levelGroup: 'A1-A2', answer: 'UMBRELLA', clueEn: 'A folding circular canopy protecting against rain.', clueTr: 'Yağmur siperliği, şemsiye.'),
  WordData(letter: 'V', levelGroup: 'A1-A2', answer: 'VILLAGE', clueEn: 'A small group of houses in a rural area.', clueTr: 'Kırsal yerleşim yeri, köy.'),
  WordData(letter: 'W', levelGroup: 'A1-A2', answer: 'WINDOW', clueEn: 'An opening in a wall fitted with glass.', clueTr: 'Camlı çerçeve, pencere.'),
  WordData(letter: 'X', levelGroup: 'A1-A2', answer: 'XYLOPHONE', clueEn: 'A musical instrument played with sticks on wooden bars.', clueTr: 'Vurmalı müzik aleti, ksilofon.'),
  WordData(letter: 'Y', levelGroup: 'A1-A2', answer: 'YESTERDAY', clueEn: 'The day before today.', clueTr: 'Bugünden önceki gün, dün.'),
  WordData(letter: 'Z', levelGroup: 'A1-A2', answer: 'ZEBRA', clueEn: 'An African wild horse with stripes.', clueTr: 'Çizgili yabani at, zebra.'),

  // B1 - B2
  WordData(letter: 'A', levelGroup: 'B1-B2', answer: 'AMBITION', clueEn: 'A strong desire to achieve success or fame.', clueTr: 'Başarı ve hedeflere ulaşma isteği, hırs.'),
  WordData(letter: 'B', levelGroup: 'B1-B2', answer: 'BEHAVIOR', clueEn: 'The way someone acts toward others.', clueTr: 'Tutum ve hareket tarzı, davranış.'),
  WordData(letter: 'C', levelGroup: 'B1-B2', answer: 'CONFIDENCE', clueEn: 'A feeling of self-assurance in abilities.', clueTr: 'Kendi gücüne inanma, özgüven.'),
  WordData(letter: 'D', levelGroup: 'B1-B2', answer: 'DECISION', clueEn: 'A choice reached after consideration.', clueTr: 'Varılan kesin hüküm, karar.'),
  WordData(letter: 'E', levelGroup: 'B1-B2', answer: 'ENVIRONMENT', clueEn: 'The natural world surrounding living things.', clueTr: 'Doğal yaşam alanı, çevre.'),
  WordData(letter: 'F', levelGroup: 'B1-B2', answer: 'FREEDOM', clueEn: 'The power to act without restraint.', clueTr: 'Kendi iradesiyle hareket etme, özgürlük.'),
  WordData(letter: 'G', levelGroup: 'B1-B2', answer: 'GENEROUS', clueEn: 'Willing to give more help than usual.', clueTr: 'Paylaşmayı seven, cömert.'),
  WordData(letter: 'H', levelGroup: 'B1-B2', answer: 'HERITAGE', clueEn: 'Culture inherited from past generations.', clueTr: 'Geçmişten devralınan kültürel miras.'),
  WordData(letter: 'I', levelGroup: 'B1-B2', answer: 'INFLUENCE', clueEn: 'The capacity to affect someone\'s actions.', clueTr: 'Yönlendirme gücü, etki/nüfuz.'),
  WordData(letter: 'J', levelGroup: 'B1-B2', answer: 'JUSTICE', clueEn: 'Fair treatment and administration of law.', clueTr: 'Hak ve hukuka uygunluk, adalet.'),
  WordData(letter: 'K', levelGroup: 'B1-B2', answer: 'KNOWLEDGE', clueEn: 'Facts acquired through study or experience.', clueTr: 'Öğrenilen malumat, bilgi.'),
  WordData(letter: 'L', levelGroup: 'B1-B2', answer: 'LEADERSHIP', clueEn: 'The action of guiding a group.', clueTr: 'Yol gösterme ve sevk yeteneği, liderlik.'),
  WordData(letter: 'M', levelGroup: 'B1-B2', answer: 'MOTIVATION', clueEn: 'A reason for behaving in a particular way.', clueTr: 'Eyleme geçiren içsel istek, motivasyon.'),
  WordData(letter: 'N', levelGroup: 'B1-B2', answer: 'NECESSARY', clueEn: 'Required to be done; essential.', clueTr: 'Zorunlu, gerekli.'),
  WordData(letter: 'O', levelGroup: 'B1-B2', answer: 'OPINION', clueEn: 'A personal view formed about something.', clueTr: 'Kişisel görüş, fikir.'),
  WordData(letter: 'P', levelGroup: 'B1-B2', answer: 'PATIENCE', clueEn: 'The capacity to endure delay without anger.', clueTr: 'Metanetle bekleme, sabır.'),
  WordData(letter: 'Q', levelGroup: 'B1-B2', answer: 'QUALIFIED', clueEn: 'Officially trained to perform a job.', clueTr: 'Eğitimli, nitelikli.'),
  WordData(letter: 'R', levelGroup: 'B1-B2', answer: 'RESPONSIBLE', clueEn: 'Having an obligation to do something.', clueTr: 'Görev yükümlülüğü olan, sorumlu.'),
  WordData(letter: 'S', levelGroup: 'B1-B2', answer: 'STRATEGY', clueEn: 'A plan of action to achieve an aim.', clueTr: 'Uzun vadeli eylem planı, strateji.'),
  WordData(letter: 'T', levelGroup: 'B1-B2', answer: 'TALENTED', clueEn: 'Having natural skill for something.', clueTr: 'Yetenekli.'),
  WordData(letter: 'U', levelGroup: 'B1-B2', answer: 'URGENT', clueEn: 'Requiring immediate action.', clueTr: 'İvedilikle yapılması gereken, acil.'),
  WordData(letter: 'V', levelGroup: 'B1-B2', answer: 'VOLUNTEER', clueEn: 'A person who freely offers service.', clueTr: 'Karşılıksız çalışan, gönüllü.'),
  WordData(letter: 'W', levelGroup: 'B1-B2', answer: 'WARNING', clueEn: 'A statement indicating danger.', clueTr: 'İkaz, uyarı.'),
  WordData(letter: 'X', levelGroup: 'B1-B2', answer: 'XENOPHOBIA', clueEn: 'Prejudice against foreign people.', clueTr: 'Yabancı düşmanlığı.'),
  WordData(letter: 'Y', levelGroup: 'B1-B2', answer: 'YIELD', clueEn: 'To produce financial or natural profit.', clueTr: 'Getiri, kazanç/hasılat.'),
  WordData(letter: 'Z', levelGroup: 'B1-B2', answer: 'ZONE', clueEn: 'An area with a particular characteristic.', clueTr: 'Belirli bir alan, bölge.'),

  // C1 - C2
  WordData(letter: 'A', levelGroup: 'C1-C2', answer: 'AUTHENTIC', clueEn: 'Genuine and not a copy.', clueTr: 'Taklit olmayan, hakiki, özgün.'),
  WordData(letter: 'B', levelGroup: 'C1-C2', answer: 'BENEVOLENT', clueEn: 'Kind and charitable to others.', clueTr: 'İyiliksever, hayırsever.'),
  WordData(letter: 'C', levelGroup: 'C1-C2', answer: 'CONSCIENTIOUS', clueEn: 'Wishing to do work thoroughly.', clueTr: 'Vicdanlı, titiz çalışan.'),
  WordData(letter: 'D', levelGroup: 'C1-C2', answer: 'DILIGENT', clueEn: 'Showing persistent care in duties.', clueTr: 'Sebatkar, gayretli.'),
  WordData(letter: 'E', levelGroup: 'C1-C2', answer: 'ELOQUENT', clueEn: 'Fluent and persuasive in speech.', clueTr: 'Hitabeti güçlü, beliğ.'),
  WordData(letter: 'F', levelGroup: 'C1-C2', answer: 'FASTIDIOUS', clueEn: 'Very attentive to detail; hard to please.', clueTr: 'Aşırı titiz, zor beğenen.'),
  WordData(letter: 'G', levelGroup: 'C1-C2', answer: 'GREGARIOUS', clueEn: 'Fond of company; sociable.', clueTr: 'Sosyalleşmeyi seven.'),
  WordData(letter: 'H', levelGroup: 'C1-C2', answer: 'HYPOCRISY', clueEn: 'Claiming moral standards one lacks.', clueTr: 'İki yüzlülük, riyakarlık.'),
  WordData(letter: 'I', levelGroup: 'C1-C2', answer: 'IMPECCABLE', clueEn: 'Faultless and highest standard.', clueTr: 'Kusursuz, hatasız.'),
  WordData(letter: 'J', levelGroup: 'C1-C2', answer: 'JUXTAPOSE', clueEn: 'Place together to create contrast.', clueTr: 'Karşılaştırmak için yan yana koymak.'),
  WordData(letter: 'K', levelGroup: 'C1-C2', answer: 'KINETIC', clueEn: 'Relating to mechanical motion.', clueTr: 'Hareketle ilgili.'),
  WordData(letter: 'L', levelGroup: 'C1-C2', answer: 'LUCID', clueEn: 'Expressed clearly; easy to understand.', clueTr: 'Berrak, anlaşılır.'),
  WordData(letter: 'M', levelGroup: 'C1-C2', answer: 'METICULOUS', clueEn: 'Showing great attention to detail.', clueTr: 'Kılı kırk yaran, titiz.'),
  WordData(letter: 'N', levelGroup: 'C1-C2', answer: 'NEBULOUS', clueEn: 'Unclear, vague, or ill-defined.', clueTr: 'Muğlak, belirsiz.'),
  WordData(letter: 'O', levelGroup: 'C1-C2', answer: 'OBSOLETE', clueEn: 'No longer used; out of date.', clueTr: 'Kullanımdan kalkmış, köhne.'),
  WordData(letter: 'P', levelGroup: 'C1-C2', answer: 'PRAGMATIC', clueEn: 'Dealing with things based on practical reasons.', clueTr: 'Faydacı, pratik.'),
  WordData(letter: 'Q', levelGroup: 'C1-C2', answer: 'QUINTESSENCE', clueEn: 'The most perfect example of a quality.', clueTr: 'En saf timsali, özü.'),
  WordData(letter: 'R', levelGroup: 'C1-C2', answer: 'RESILIENT', clueEn: 'Able to recover quickly from hardship.', clueTr: 'Dayanıklı, çabuk toparlanan.'),
  WordData(letter: 'S', levelGroup: 'C1-C2', answer: 'SCRUPULOUS', clueEn: 'Attentive to moral details.', clueTr: 'Ahlaki titizlik gösteren.'),
  WordData(letter: 'T', levelGroup: 'C1-C2', answer: 'TRANSIENT', clueEn: 'Lasting only for a short time.', clueTr: 'Gelip geçici, fani.'),
  WordData(letter: 'U', levelGroup: 'C1-C2', answer: 'UBIQUITOUS', clueEn: 'Found everywhere at once.', clueTr: 'Her yerde var olan.'),
  WordData(letter: 'V', levelGroup: 'C1-C2', answer: 'VULNERABLE', clueEn: 'Exposed to attack or harm.', clueTr: 'Savunmasız, kırılgan.'),
  WordData(letter: 'W', levelGroup: 'C1-C2', answer: 'WARY', clueEn: 'Showing caution about danger.', clueTr: 'Tetikte olan, temkinli.'),
  WordData(letter: 'X', levelGroup: 'C1-C2', answer: 'XENIAL', clueEn: 'Hospitable to visiting guests.', clueTr: 'Konuksever.'),
  WordData(letter: 'Y', levelGroup: 'C1-C2', answer: 'YEARN', clueEn: 'Deep longing for something.', clueTr: 'Hasret çekmek.'),
  WordData(letter: 'Z', levelGroup: 'C1-C2', answer: 'ZEALOUS', clueEn: 'Showing great energy for a cause.', clueTr: 'Şevkli, hararetli.'),
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
                  'English Voice & Vocabulary Game',
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
  bool isEvaluating = false;

  final TextEditingController inputController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _voiceModeActive = false;
  Timer? _speechSilenceTimer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _prepareQuestions();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inputFocusNode.requestFocus();
    });
  }

  void _listenVoice() async {
    if (isGameOver || isEvaluating) return;

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
            if (_voiceModeActive && !isEvaluating && !isGameOver && mounted) {
              Future.delayed(const Duration(milliseconds: 250), () {
                if (_voiceModeActive && !isEvaluating && !isGameOver && mounted) {
                  _startListeningSession();
                }
              });
            }
          }
        },
        onError: (err) {
          setState(() => _isListening = false);
          if (_voiceModeActive && !isEvaluating && !isGameOver && mounted) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (_voiceModeActive && !isEvaluating && !isGameOver && mounted) {
                _startListeningSession();
              }
            });
          }
        },
      );

      if (available) {
        _voiceModeActive = true;
        _startListeningSession();
      }
    } else {
      _voiceModeActive = false;
      _speechSilenceTimer?.cancel();
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _startListeningSession() {
    if (isGameOver || isEvaluating || !_voiceModeActive) return;

    setState(() => _isListening = true);

    _speech.listen(
      localeId: 'en_US',
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 4),
      cancelOnError: false,
      partialResults: true,
      onResult: (result) {
        if (isEvaluating || isGameOver) return;

        final raw = result.recognizedWords.trim();
        setState(() {
          inputController.text = raw;
        });

        if (raw.isEmpty) return;

        final upper = raw.toUpperCase();
        final expected = questions[currentIndex].answer.toUpperCase();

        // 1. SESLE PAS DENDİĞİ AN ENTER BEKLEMEDEN DİREKT GEÇ
        if (upper.contains('PASS') || upper.contains('PAS') || upper.contains('NEXT')) {
          _speechSilenceTimer?.cancel();
          _speech.stop();
          setState(() => _isListening = false);
          passQuestion();
          return;
        }

        // 2. DOĞRU KELİME AĞIZDAN ÇIKTIĞI AN ENTER BEKLEMEDEN DİREKT ONAYLA
        if (upper == expected || upper.split(' ').contains(expected)) {
          _speechSilenceTimer?.cancel();
          _speech.stop();
          setState(() => _isListening = false);
          checkAnswer(expected);
          return;
        }

        // 3. EĞER BAŞKA BİR ŞEY SÖYLEDİYSE VE 1 SANİYE SUSTUYSA OTOMATİK KONTROL ET
        _speechSilenceTimer?.cancel();
        _speechSilenceTimer = Timer(const Duration(milliseconds: 900), () {
          if (!isEvaluating && !isGameOver && mounted && inputController.text.trim().isNotEmpty) {
            _speech.stop();
            setState(() => _isListening = false);
            checkAnswer(inputController.text.trim());
          }
        });
      },
    );
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
      final chosen = pool.first;

      questions.add(
        ActiveQuestion(
          letter: letter,
          clue: widget.language == 'TR' ? chosen.clueTr : chosen.clueEn,
          answer: chosen.answer,
          meaning: chosen.clueTr,
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

  void checkAnswer(String val) async {
    if (isGameOver || isEvaluating) return;
    _speechSilenceTimer?.cancel();

    final text = val.trim().toUpperCase();
    if (text.isEmpty) {
      inputFocusNode.requestFocus();
      return;
    }

    if (text.contains('PASS') || text.contains('PAS') || text.contains('NEXT')) {
      passQuestion();
      return;
    }

    setState(() {
      isEvaluating = true;
      final expected = questions[currentIndex].answer.toUpperCase();
      if (text == expected || text.split(' ').contains(expected)) {
        questions[currentIndex].state = LetterState.correct;
        score += 10;
      } else {
        questions[currentIndex].state = LetterState.wrong;
      }
    });

    // 0.8 saniye sonucu gör (yeşil/kırmızı)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted || isGameOver) return;

    setState(() {
      inputController.clear();
      isEvaluating = false;
      advanceLetter();
    });

    inputFocusNode.requestFocus();

    // Sesli moddaysa el değmeden yeni harfi dinlemeye başla
    if (_voiceModeActive) {
      _startListeningSession();
    }
  }

  void passQuestion() async {
    if (isGameOver || isEvaluating) return;
    _speechSilenceTimer?.cancel();

    setState(() {
      isEvaluating = true;
      questions[currentIndex].state = LetterState.passed;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted || isGameOver) return;

    setState(() {
      inputController.clear();
      isEvaluating = false;
      advanceLetter();
    });

    inputFocusNode.requestFocus();

    if (_voiceModeActive) {
      _startListeningSession();
    }
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
    _speechSilenceTimer?.cancel();
    if (_isListening) _speech.stop();
    _voiceModeActive = false;
    setState(() => isGameOver = true);
    _showGameOverDialog();
  }

  void _showGameOverDialog() {
    int correctCount = questions.where((q) => q.state == LetterState.correct).length;
    int wrongCount = questions.where((q) => q.state == LetterState.wrong).length;
    int passedCount = questions.where((q) => q.state == LetterState.passed || q.state == LetterState.idle).length;
    List<ActiveQuestion> missedWords = questions.where((q) => q.state != LetterState.correct).toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131D2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF38BDF8), width: 1.5)),
        title: const Center(
          child: Text('🏆 OYUN BİTTİ!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 14),
                _buildStatRow('✅ Doğru Cevap:', '$correctCount', const Color(0xFF10B981)),
                const SizedBox(height: 6),
                _buildStatRow('❌ Yanlış Cevap:', '$wrongCount', const Color(0xFFEF4444)),
                const SizedBox(height: 6),
                _buildStatRow('⏸ Pas / Boş:', '$passedCount', const Color(0xFFF59E0B)),
                const SizedBox(height: 16),
                if (missedWords.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('📖 ÖĞRENİLECEK KELİMELER', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white12)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: missedWords.length,
                      separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                      itemBuilder: (context, index) {
                        final item = missedWords[index];
                        final bool isWrong = item.state == LetterState.wrong;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: isWrong ? const Color(0xFFEF4444).withValues(alpha: 0.2) : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.center,
                                child: Text(item.letter, style: TextStyle(color: isWrong ? const Color(0xFFEF4444) : const Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.answer, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text(item.meaning, style: const TextStyle(color: Colors.white60, fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
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
    _speechSilenceTimer?.cancel();
    if (_isListening) _speech.stop();
    inputController.dispose();
    inputFocusNode.dispose();
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
                      decoration: const BoxDecoration(color: Color(0xFF131D2E), shape: BoxShape.circle),
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

              // Kontrol Çubuğu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _listenVoice,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isListening ? const Color(0xFFEF4444) : (_voiceModeActive ? const Color(0xFF38BDF8) : const Color(0xFF1E293B)),
                          shape: BoxShape.circle,
                          boxShadow: _isListening
                              ? [BoxShadow(color: const Color(0xFFEF4444).withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2)]
                              : [],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : (_voiceModeActive ? Icons.mic : Icons.mic_none),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller: inputController,
                        focusNode: inputFocusNode,
                        autofocus: true,
                        enabled: !isEvaluating,
                        onSubmitted: checkAnswer,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: isEvaluating
                              ? 'Cevap kontrol ediliyor...'
                              : (_isListening ? 'Konuşun (Enter gerekmez)...' : 'Yazın veya mikrofona basın...'),
                          hintStyle: TextStyle(
                            color: isEvaluating
                                ? const Color(0xFFF59E0B)
                                : (_isListening ? const Color(0xFF38BDF8) : Colors.white38),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: isEvaluating ? null : () => checkAnswer(inputController.text),
                      child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: isEvaluating ? null : passQuestion,
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