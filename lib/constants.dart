import 'package:flutter/material.dart';

const String k = 'NeverKnowThisString1234567890123';

const String dateFormat = 'dd/MM/yyyy HH:mm:ss';
const String tableDateFormat = 'yyyy/MM/dd HH:mm:ss';

const double appBarHeight = 0.13;

const Map<String, LinearGradient> cardGradientsMap = {
  "Appreciation & Insecurity": cardGradient1,
  "Affection & Rituals": cardGradient2,
  "Big Questions & Beliefs": cardGradient3,
  "Boundaries & Trust": cardGradient4,
  "Conflict & Communication": cardGradient5,
  "Daily Life Together": cardGradient6,
  "History & Past Loves": cardGradient7,
  "Living Together": cardGradient8,
  "Love Languages & Expression": cardGradient9,
  "Must-Have Questions Before Starting a Relationship": cardGradient10,
  "Romantic Fantasies": cardGradient11,
  "Secrets & Openness": cardGradient12,
  "Unasked Questions": cardGradient13,
  "Visions of the Future": cardGradient14,
  "What-Ifs & Imagination": cardGradient15,
  "After Dark Fights": cardGradient16,
  "Bedroom Habits": cardGradient17,
  "Dirty Would You Rather": cardGradient18,
  "Fantasy Confessions": cardGradient19,
  "Fetishes You Don’t Talk About": cardGradient20,
  "First Time Stories": cardGradient21,
  "Forbidden Thoughts": cardGradient22,
  "I’d Try It If You Would": cardGradient23,
  "Kinks & Curiosities": cardGradient24,
  "Secret Crushes": cardGradient25,
  "Sex vs. Intimacy": cardGradient26,
  "Spicy Truth or Dare": cardGradient27,
  "The Morning After": cardGradient28,
  "The Taboo Zone": cardGradient29,
  "Turn Ons - Turn Offs": cardGradient30,
  "Alternate Universes": cardGradient31,
  "Cringe Archive": cardGradient32,
  "Dark Thoughts & Weird Vibes": cardGradient33,
  "Do You Even Know Me": cardGradient34,
  "Favorite Glitches in the Friendship Matrix": cardGradient35,
  "Forgive & Forget (or Not)": cardGradient36,
  "If We Were…": cardGradient37,
  "Lowkey Roasts": cardGradient38,
  "Our Origin Story": cardGradient39,
  "Shared Chaos": cardGradient40,
  "Turning Points": cardGradient41,
  "Unfiltered Games": cardGradient42,
  "Unrealistic Life Plans": cardGradient43,
  "What You Dont Know About Me": cardGradient44,
  "Would You Still Be Friends If…": cardGradient45,
};
const Map<String, String> cardDescriptionMap = {
  "Appreciation & Insecurity": 'What makes you feel seen — or unseen',
  "Affection & Rituals": 'The little things that make love feel real',
  "Big Questions & Beliefs": 'What do you truly believe — and why',
  "Boundaries & Trust": 'Where is the line, and how do we protect it?',
  "Conflict & Communication": 'How we fight — and how we heal',
  "Daily Life Together": 'The rhythm and rituals of living side by side',
  "History & Past Loves": 'Who came before — and what stayed with you',
  "Living Together": 'Sharing space, habits, and the occasional chaos',
  "Love Languages & Expression": 'How do you show — and feel — love?',
  "Must-Have Questions Before Starting a Relationship": 'What matters before love begins?',
  "Romantic Fantasies":'The dreamiest moments you wish were real',
  "Secrets & Openness": 'What you keep in — and what you share',
  "Unasked Questions": 'The things you’ve always wondered — but never said',
  "Visions of the Future": 'What do you see when you dream together?',
  "What-Ifs & Imagination": 'Explore possibilities, fantasies, and parallel lives',
  "After Dark Fights": 'Arguments that heat up after midnight',
  "Bedroom Habits": 'What happens behind closed doors',
  "Dirty Would You Rather": 'Bold choices, spicy dilemmas',
  "Fantasy Confessions": 'Dive into your wildest, unspoken desires',
  "Fetishes You Don’t Talk About": 'The secrets you’ve never dared to share',
  "First Time Stories": 'Awkward, funny, unforgettable',
  "Forbidden Thoughts": 'Taboo ideas that live rent-free in your mind',
  "I’d Try It If You Would": 'Experiments that only need a “yes” from both sides',
  "Kinks & Curiosities": 'What excites you? Let’s explore without judgment',
  "Secret Crushes": 'Hidden feelings you’ve never admitted',
  "Sex vs. Intimacy": 'Discover what truly connects — or divides ',
  "Spicy Truth or Dare": 'Daring truths, risky dares — no backing out',
  "The Morning After": 'What happens after the heat? Let’s talk about it',
  "The Taboo Zone": 'Enter a space where nothing is off-limits',
  "Turn Ons - Turn Offs": 'What sparks your fire — and what shuts it down',
  "Alternate Universes": 'Who would we be in a totally different world?',
  "Cringe Archive": 'Relive the most awkward, hilarious moments ever',
  "Dark Thoughts & Weird Vibes": 'Strange ideas, odd energy — and we love it',
  "Do You Even Know Me": 'Prove how well (or badly) you really know each other',
  "Favorite Glitches in the Friendship Matrix": 'All the absurd, surreal moments we can’t explain',
  "Forgive & Forget (or Not)": 'Let’s talk about petty grudges and real growth',
  "If We Were…": 'Swap roles, lives, worlds — go full imagination mode',
  "Lowkey Roasts": 'Friendly fire only — let’s roast with love',
  "Our Origin Story": 'How it all started — or how you remember it',
  "Shared Chaos": 'The wild, messy stuff you only survive together',
  "Turning Points": 'The moments that changed everything between you',
  "Unfiltered Games": 'No rules, no filter, just brutal honesty and fun',
  "Unrealistic Life Plans": 'Surprise! There’s more to me than you think',
  "What You Dont Know About Me": 'Bold dreams, big lies, and zero budgets',
  "Would You Still Be Friends If…": 'Extreme scenarios that will test your loyalty',
};


const LinearGradient appBackgroundGradient = LinearGradient(
  colors: [
    Color(0xFF3B002A), // насичений темний бордовий
    Color(0xFF5B0A4C), // бордово-фіолетовий
    Color(0xFF9E2B6A), // м’який рожево-малиновий відтінок
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient purpleGradient = LinearGradient(
  colors: [
    Color(0xFFB0246B), // глибокий малиново-фіолетовий
    Color(0xFF71004E), // насичений бордо
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient pinkPurpleGradient = LinearGradient(
  colors: [
    Color(0xFFFF4F9D), // яскравий рожевий
    Color(0xFF9E1B5F), // бордовий із фіолетовим підтоном
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);


const Color pinkMain = Color(0xFFFF4F9D);
const Color purpleLight = Color(0xFF8E2B6A);
const Color tabBarColor = Color(0xFF3B002A);


// 🂠 Верх картки — глибокий бордо з м’яким переходом у рожево-малиновий
const LinearGradient cardTopGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF6C0F45), // насичений бордо
    Color(0xFFB0246B), // малиново-фіолетовий
  ],
  stops: [0.1, 0.95],
  transform: GradientRotation(161.21 * (3.14159265359 / 180)),
);

// 🃏 Основний фон картки — плавний перехід бордо → фіолетовий
const LinearGradient cardMainGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF3B002A), // темний бордо
    Color(0xFF8E2B6A), // фіолетово-бордовий
  ],
  stops: [0.45, 1.0],
);

// 🌄 Фон онбордингу — градієнт бордо-рожевий із глибини в світло-малиновий
const LinearGradient onboardingBackgroundGradient = LinearGradient(
  begin: AlignmentDirectional(-0.1, -1.0),
  end: AlignmentDirectional(0.1, 1.0),
  colors: [
    Color(0xFF3B002A), // глибокий бордо
    Color(0xFF6C0F45), // теплий винний
    Color(0xFFB83B82), // світлий малиново-рожевий
  ],
  stops: [0.0, 0.5, 1.0],
);

// 🪞 Контейнер онбордингу — елегантний фіолетово-бордовий градієнт
const LinearGradient onboardingContainerGradient = LinearGradient(
  colors: [
    Color(0xFF9E2B6A), // бордо-фуксія
    Color(0xFF3B002A), // темна основа
  ],
  stops: [0.0, 0.6],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// 💖 Кнопка онбордингу — яскравий рожево-бордовий градієнт для акценту
const LinearGradient onboardingButtonGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180),
  colors: [
    Color(0xFFFF4F9D), // яскравий рожевий
    Color(0xFF9E1B5F), // бордовий із фіолетовим підтоном
  ],
);

// CARD GRADIENTS

const LinearGradient cardGradient1 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFFB86BF8),
    Color(0xFF6BB5F8),
  ],
);

const LinearGradient cardGradient2 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF702626),
    Color(0xFFF05151),
  ],
);

const LinearGradient cardGradient3 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF3E7030),
    Color(0xFF85F067),
  ],
);

const LinearGradient cardGradient4 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF4B55DB),
    Color(0xFF34E0E0),
  ],
);

const LinearGradient cardGradient5 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF866AFC),
    Color(0xFF6BB9DB),
  ],
);

const LinearGradient cardGradient6 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF703C27),
    Color(0xFFF08054),
  ],
);

const LinearGradient cardGradient7 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFFB86BF8),
    Color(0xFF5031A0),
  ],
);

const LinearGradient cardGradient8 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFFF59419),
    Color(0xFFF9D83E),
  ],
);

const LinearGradient cardGradient9 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF112541),
    Color(0xFFBE354C),
  ],
);

const LinearGradient cardGradient10 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF353C70),
    Color(0xFF7280F0),
  ],
);

const LinearGradient cardGradient11 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF9C7CF4),
    Color(0xFFF49782),
  ],
);

const LinearGradient cardGradient12 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFF3F3470),
    Color(0xFF866EF0),
  ],
);

const LinearGradient cardGradient13 = cardGradient12;

const LinearGradient cardGradient14 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFFFC8E51),
    Color(0xFFD96245),
  ],
);

const LinearGradient cardGradient15 = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  transform: GradientRotation(180 * 3.1416 / 180),
  colors: [
    Color(0xFFFCCF58),
    Color(0xFFFA7E69),
  ],
);

const LinearGradient cardGradient16 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF4B6CB7), // #4B6CB7
    Color(0xFF182848), // #182848
  ],
);

const LinearGradient cardGradient17 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF5D4883), // #5D4883
    Color(0xFFD76D77), // #D76D77
  ],
);

const LinearGradient cardGradient18 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFFDD2476), // #DD2476
    Color(0xFF762247), // #762247
    Color(0xFF430101), // #430101
  ],
);

const LinearGradient cardGradient19 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFFEB9430), // #EB9430
    Color(0xFFE06363), // #E06363
  ],
);

const LinearGradient cardGradient20 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF0F2027), // #0F2027
    Color(0xFF3D6E83), // #3D6E83
  ],
);

const LinearGradient cardGradient21 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF43CEA2), // #43CEA2
    Color(0xFF185A9D), // #185A9D
  ],
);

const LinearGradient cardGradient22 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF8E0E00), // #8E0E00
    Color(0xFFFF3C3C), // #FF3C3C
  ],
);

const LinearGradient cardGradient23 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFFF7971E), // #F7971E
    Color(0xFFFFD200), // #FFD200
  ],
);

const LinearGradient cardGradient24 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFFEE8E16), // #EE8E16
    Color(0xFFF5263A), // #F5263A
  ],
);

const LinearGradient cardGradient25 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF2C3E50), // #2C3E50
    Color(0xFF904E95), // #904E95
  ],
);

const LinearGradient cardGradient26 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFFDD2476), // #DD2476
    Color(0xFF641035), // #641035
    Color(0xFF000000), // #000000
  ],
);

const LinearGradient cardGradient27 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFFFF512F), // #FF512F
    Color(0xFFDD2476), // #DD2476
  ],
);

const LinearGradient cardGradient28 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF3A1C71), // #3A1C71
    Color(0xFFD76D77), // #D76D77
  ],
);

const LinearGradient cardGradient29 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF000000), // #000000
    Color(0xFFBE354C), // #BE354C
  ],
);

const LinearGradient cardGradient30 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(161.21 * 3.1416 / 180), // 161.21° → радіани
  colors: [
    Color(0xFF43CEA2), // #43CEA2
    Color(0xFF185A9D), // #185A9D
  ],
);

const LinearGradient cardGradient31 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(67.84 * 3.1416 / 180), // 67.84° → 1.184031 рад
  colors: [
    Color(0xFF682D8C), // #682D8C
    Color(0xFFEB1E79), // #EB1E79
  ],
);

const LinearGradient cardGradient32 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(270 * 3.1416 / 180), // 270° → 4.712389 рад
  colors: [
    Color(0xFFE39500), // #E39500
    Color(0xFFFAD546), // #FAD546
  ],
);

const LinearGradient cardGradient33 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(110.7 * 3.1416 / 180), // 110.7° → 1.932079 рад
  colors: [
    Color(0xFF49EBF5), // #49EBF5
    Color(0xFF04DB19), // rgba(4, 219, 25, 0.7)
  ],
);

const LinearGradient cardGradient34 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(108.2 * 3.1416 / 180), // 108.2° → 1.888446 рад
  colors: [
    Color(0xFFEF060F), // #EF060F
    Color(0xFFB60CF2), // #B60CF2
  ],
);

const LinearGradient cardGradient35 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(111.75 * 3.1416 / 180), // 111.75° → 1.950405 рад
  colors: [
    Color(0xFF0A15DB), // #0A15DB
    Color(0xFF02DADC), // #02DADC
  ],
);

const LinearGradient cardGradient36 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(180 * 3.1416 / 180), // 180° → 3.141593 рад
  colors: [
    Color(0xFF3F3470), // #3F3470
    Color(0xFF866EF0), // #866EF0
  ],
);

const LinearGradient cardGradient37 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(103.65 * 3.1416 / 180), // 103.65° → 1.809034 рад
  colors: [
    Color(0xFFDB1C1C), // #DB1C1C
    Color(0xFFFFC464), // #FFC464
  ],
);

const LinearGradient cardGradient38 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(180 * 3.1416 / 180), // 180° → 3.141593 рад
  colors: [
    Color(0xFF0BA360), // #0BA360
    Color(0xFF3CBA92), // #3CBA92
  ],
);


const LinearGradient cardGradient39 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(288.13 * 3.1416 / 180), // 288.13° → 5.028817 рад
  colors: [
    Color(0xFF480B4C), // #480B4C
    Color(0xFF760C63), // #760C63
  ],
);

const LinearGradient cardGradient40 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(270 * 3.1416 / 180), // 270° → 4.712389 рад
  colors: [
    Color(0xFF9468C9), // #9468C9
    Color(0xFFA1CAFE), // #A1CAFE
  ],
);

const LinearGradient cardGradient41 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(180 * 3.1416 / 180), // 180° → 3.141593 рад
  colors: [
    Color(0xFF2A5298), // #2A5298
    Color(0xFF1E3C72), // #1E3C72
  ],
);

const LinearGradient cardGradient42 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(270 * 3.1416 / 180), // 270° → 4.712389 рад
  colors: [
    Color(0xFFF55D52), // #F55D52
    Color(0xFFF80124), // #F80124
  ],
);

const LinearGradient cardGradient43 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(270 * 3.1416 / 180), // 270° → 4.712389 рад
  colors: [
    Color(0xFF0C5F55), // #0C5F55
    Color(0xFF17BFA8), // #17BFA8
  ],
);

const LinearGradient cardGradient44 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(108.13 * 3.1416 / 180), // 108.13° → 1.887225 рад
  colors: [
    Color(0xFF6A11CB), // #6A11CB
    Color(0xFF2575FC), // #2575FC
  ],
);

const LinearGradient cardGradient45 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  transform: GradientRotation(270 * 3.1416 / 180),
  colors: [
    Color(0xFFC6719B),
    Color(0xFFD492F4),
    Color(0xFF4D4A99),
  ],
);

const Color onboardingContainerBorderColor = Color(0xFF8E2B6A);

const Color purpleMain = Color(0xFFB0246B); // глибокий малиново-бордовий

const Color mainBackgroundColor = Color(0xFF3B002A); // темний бордо

const LinearGradient settingTitleGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF6C0F45),
    Color(0xFFB83B82),
  ],
  stops: [0.45, 1.0],
);
