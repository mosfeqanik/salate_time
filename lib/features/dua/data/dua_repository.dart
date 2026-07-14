import 'models/dua.dart';

/// Static, in-memory source of duas for the Dua tab.
///
/// The list is curated and hardcoded for the first version. Each entry uses
/// widely-cited wording from Sahih al-Bukhari, Sahih Muslim, Sunan Abi Dawud,
/// and Riyad as-Salihin. Translations are short and indicative.
class DuaRepository {
  const DuaRepository();

  /// All duas in display order, grouped by [Dua.category].
  List<Dua> getAll() => _duas;

  /// Returns categories that actually have at least one dua, in first-seen
  /// order. Used to render section headers without showing empty groups.
  List<String> categories() {
    final seen = <String>{};
    final ordered = <String>[];
    for (final d in _duas) {
      if (seen.add(d.category)) ordered.add(d.category);
    }
    return ordered;
  }

  /// Filtered by category. Empty string returns everything.
  List<Dua> byCategory(String category) =>
      _duas.where((d) => d.category == category).toList(growable: false);

  static const _duas = <Dua>[
    // ---------------- Daily ----------------
    Dua(
      id: 'morning_1',
      title: 'Morning Remembrance',
      category: DuaCategory.daily,
      arabic:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      transliteration:
          "Asbahna wa asbahal-mulku lillahi, wal-hamdu lillahi, la ilaha illallahu wahdahu la sharika lah.",
      translation:
          'We have reached the morning and at this very time the kingdom belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah alone, with no partner.',
      reference: 'Sahih Muslim 2723',
    ),
    Dua(
      id: 'evening_1',
      title: 'Evening Remembrance',
      category: DuaCategory.daily,
      arabic:
          'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      transliteration:
          "Amsayna wa amsal-mulku lillahi, wal-hamdu lillahi, la ilaha illallahu wahdahu la sharika lah.",
      translation:
          'We have reached the evening and at this very time the kingdom belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah alone, with no partner.',
      reference: 'Sahih Muslim 2723',
    ),
    Dua(
      id: 'entering_home',
      title: 'Entering the Home',
      category: DuaCategory.daily,
      arabic: 'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
      transliteration:
          "Bismillahi walajna, wa bismillahi kharajna, wa 'alallahi rabbina tawakkalna.",
      translation:
          "In the name of Allah we enter, and in the name of Allah we leave, and upon Allah, our Lord, we place our trust.",
      reference: 'Sunan Abi Dawud 5095',
    ),
    Dua(
      id: 'leaving_home',
      title: 'Leaving the Home',
      category: DuaCategory.daily,
      arabic:
          'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      transliteration:
          "Bismillahi, tawakkaltu 'alallahi, wa la hawla wa la quwwata illa billah.",
      translation:
          'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
      reference: 'Sunan Abi Dawud 5095',
    ),

    // ---------------- Food ----------------
    Dua(
      id: 'before_eating',
      title: 'Before Eating',
      category: DuaCategory.food,
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillah.',
      translation: 'In the name of Allah.',
      reference: 'Sahih al-Bukhari 5374',
    ),
    Dua(
      id: 'after_eating',
      title: 'After Eating',
      category: DuaCategory.food,
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      transliteration:
          "Alhamdulillahil-ladhi at'ama wa saqana wa ja'alana muslimin.",
      translation:
          'All praise is for Allah who fed us and gave us drink, and made us Muslims.',
      reference: 'Sunan Abi Dawud 3850',
    ),

    // ---------------- Travel ----------------
    Dua(
      id: 'travel_1',
      title: 'Setting Out on a Journey',
      category: DuaCategory.travel,
      arabic:
          'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
      transliteration:
          "Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin.",
      translation:
          'Glory to Him who has subjected this to us, and we could never have it (by our efforts).',
      reference: 'Sahih Muslim 1342',
    ),
    Dua(
      id: 'travel_2',
      title: 'Returning from a Journey',
      category: DuaCategory.travel,
      arabic:
          'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
      transliteration:
          "A'ibuna ta'ibuna 'abiduna li-rabbina hamidun.",
      translation:
          'We are returning, repenting, worshipping, and praising our Lord.',
      reference: 'Sahih al-Bukhari 1797',
    ),

    // ---------------- Sleep ----------------
    Dua(
      id: 'before_sleep',
      title: 'Before Sleep',
      category: DuaCategory.sleep,
      arabic:
          'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: "Bismika Allahumma amutu wa ahya.",
      translation: 'In Your name, O Allah, I die and I live.',
      reference: 'Sahih al-Bukhari 6324',
    ),
    Dua(
      id: 'waking_up',
      title: 'Upon Waking',
      category: DuaCategory.sleep,
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      transliteration:
          "Alhamdulillahil-ladhi ahyana ba'da ma amatana wa ilayhin-nushur.",
      translation:
          'All praise is for Allah who gave us life after He caused us to die, and to Him is the return.',
      reference: 'Sahih al-Bukhari 6314',
    ),

    // ---------------- Prayer ----------------
    Dua(
      id: 'entering_prayer',
      title: 'Entering the Prayer (Takbir)',
      category: DuaCategory.prayer,
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar.',
      translation: 'Allah is the Greatest.',
      reference: 'Sahih al-Bukhari 304',
    ),
    Dua(
      id: 'between_sujood',
      title: 'Between the Two Prostrations',
      category: DuaCategory.prayer,
      arabic: 'رَبِّ اغْفِرْ لِي',
      transliteration: "Rabbigfir li.",
      translation: 'My Lord, forgive me.',
      reference: 'Sahih al-Bukhari 817',
    ),

    // ---------------- Hardship & Anxiety ----------------
    Dua(
      id: 'anxiety_1',
      title: 'In Times of Anxiety',
      category: DuaCategory.distress,
      arabic:
          'لَا إِلَٰهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَٰهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَٰهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ',
      transliteration:
          "La ilaha illallahul-'Azimul-Halim, la ilaha illallahu Rabbul-'Arshil-'Azim, la ilaha illallahu Rabbus-samawati wa Rabbul-ard.",
      translation:
          'None has the right to be worshipped except Allah, the Mighty, the Forbearing. None has the right to be worshipped except Allah, Lord of the Mighty Throne. None has the right to be worshipped except Allah, Lord of the heavens and Lord of the earth.',
      reference: 'Sahih al-Bukhari 6345',
    ),
    Dua(
      id: 'distress_1',
      title: 'In Times of Distress',
      category: DuaCategory.distress,
      arabic:
          'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      transliteration:
          "La ilaha illa anta subhanaka inni kuntu minaz-zalimin.",
      translation:
          'There is no deity except You; glory be to You. Indeed, I have been of the wrongdoers.',
      reference: 'Sunan Abi Dawud 5085 (Du\'a of Yunus)',
    ),

    // ---------------- Forgiveness ----------------
    Dua(
      id: 'forgiveness_seeker',
      title: "Sayyidul Istighfar",
      category: DuaCategory.forgiveness,
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَىٰ عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      transliteration:
          "Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu, a'udhu bika min sharri ma sana'tu, abu'u laka bi ni'matika 'alayya, wa abu'u bi dhanbi faghfir li, fa innahu la yaghfirudh-dhunuba illa anta.",
      translation:
          'O Allah, You are my Lord, none has the right to be worshipped except You. You created me and I am Your servant, and I am keeping my promise and covenant with You as much as I can. I seek refuge in You from the evil of what I have done. I acknowledge before You Your favor upon me, and I acknowledge my sin, so forgive me, for none forgives sins except You.',
      reference: 'Sahih al-Bukhari 6306',
    ),
    Dua(
      id: 'forgiveness_simple',
      title: 'A Short Forgiveness',
      category: DuaCategory.forgiveness,
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah.',
      translation: 'I seek the forgiveness of Allah.',
      reference: 'Sahih al-Bukhari 6307',
    ),
  ];
}
