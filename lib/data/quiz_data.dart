class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

const List<QuizQuestion> simplePresentQuestions = [
  QuizQuestion(
    question: "She ___ to school every day.",
    options: ["go", "goes", "going", "went"],
    correctAnswer: "goes",
  ),
  QuizQuestion(
    question: "They ___ football on Sundays.",
    options: ["play", "plays", "playing", "played"],
    correctAnswer: "play",
  ),
  QuizQuestion(
    question: "He ___ a doctor.",
    options: ["is", "am", "are", "be"],
    correctAnswer: "is",
  ),
  QuizQuestion(
    question: "We ___ in a big city.",
    options: ["live", "lives", "living", "lived"],
    correctAnswer: "live",
  ),
  QuizQuestion(
    question: "The sun ___ in the east.",
    options: ["rise", "rises", "rising", "rose"],
    correctAnswer: "rises",
  ),
  QuizQuestion(
    question: "Birds ___ every morning.",
    options: ["sing", "sings", "singing", "sang"],
    correctAnswer: "sing",
  ),
  QuizQuestion(
    question: "I ___ coffee for breakfast.",
    options: ["drink", "drinks", "drinking", "drank"],
    correctAnswer: "drink",
  ),
  QuizQuestion(
    question: "My cat ___ a lot.",
    options: ["sleep", "sleeps", "sleeping", "slept"],
    correctAnswer: "sleeps",
  ),
  QuizQuestion(
    question: "They ___ their homework after dinner.",
    options: ["do", "does", "doing", "did"],
    correctAnswer: "do",
  ),
  QuizQuestion(
    question: "She ___ to music before bed.",
    options: ["listen", "listens", "listening", "listened"],
    correctAnswer: "listens",
  ),
];

const List<QuizQuestion> pastSimpleQuestions = [
  QuizQuestion(
    question: "She ___ to school yesterday.",
    options: ["go", "goes", "went", "gone"],
    correctAnswer: "went",
  ),
  QuizQuestion(
    question: "They ___ football last Sunday.",
    options: ["play", "plays", "played", "playing"],
    correctAnswer: "played",
  ),
  QuizQuestion(
    question: "He ___ a doctor two years ago.",
    options: ["is", "was", "were", "be"],
    correctAnswer: "was",
  ),
  QuizQuestion(
    question: "We ___ in a small town in 2000.",
    options: ["live", "lives", "lived", "living"],
    correctAnswer: "lived",
  ),
  QuizQuestion(
    question: "The sun ___ at 6 a.m. yesterday.",
    options: ["rise", "rises", "rose", "rising"],
    correctAnswer: "rose",
  ),
  QuizQuestion(
    question: "Birds ___ early this morning.",
    options: ["sing", "sings", "sang", "singing"],
    correctAnswer: "sang",
  ),
  QuizQuestion(
    question: "I ___ tea for breakfast yesterday.",
    options: ["drink", "drinks", "drank", "drinking"],
    correctAnswer: "drank",
  ),
  QuizQuestion(
    question: "My cat ___ a lot last night.",
    options: ["sleep", "sleeps", "slept", "sleeping"],
    correctAnswer: "slept",
  ),
  QuizQuestion(
    question: "They ___ their homework after dinner yesterday.",
    options: ["do", "does", "did", "doing"],
    correctAnswer: "did",
  ),
  QuizQuestion(
    question: "She ___ to music before bed last night.",
    options: ["listen", "listens", "listened", "listening"],
    correctAnswer: "listened",
  ),
];

const List<QuizQuestion> presentContinuousQuestions = [
  QuizQuestion(
    question: "She ___ to school now.",
    options: ["goes", "is going", "went", "going"],
    correctAnswer: "is going",
  ),
  QuizQuestion(
    question: "They ___ football at the moment.",
    options: ["play", "are playing", "played", "playing"],
    correctAnswer: "are playing",
  ),
  QuizQuestion(
    question: "He ___ a book right now.",
    options: ["reads", "is reading", "read", "reading"],
    correctAnswer: "is reading",
  ),
  QuizQuestion(
    question: "We ___ in the park.",
    options: ["are walking", "walk", "walked", "walking"],
    correctAnswer: "are walking",
  ),
  QuizQuestion(
    question: "The sun ___ at the moment.",
    options: ["shines", "is shining", "shone", "shining"],
    correctAnswer: "is shining",
  ),
  QuizQuestion(
    question: "Birds ___ now.",
    options: ["sing", "are singing", "sang", "singing"],
    correctAnswer: "are singing",
  ),
  QuizQuestion(
    question: "I ___ coffee right now.",
    options: ["drink", "am drinking", "drank", "drinking"],
    correctAnswer: "am drinking",
  ),
  QuizQuestion(
    question: "My cat ___ a lot these days.",
    options: ["sleeps", "is sleeping", "slept", "sleeping"],
    correctAnswer: "is sleeping",
  ),
  QuizQuestion(
    question: "They ___ their homework at the moment.",
    options: ["do", "are doing", "did", "doing"],
    correctAnswer: "are doing",
  ),
  QuizQuestion(
    question: "She ___ to music now.",
    options: ["listens", "is listening", "listened", "listening"],
    correctAnswer: "is listening",
  ),
];

const List<QuizQuestion> presentPerfectQuestions = [
  QuizQuestion(
    question: "She ___ to school already.",
    options: ["has gone", "have gone", "went", "goes"],
    correctAnswer: "has gone",
  ),
  QuizQuestion(
    question: "They ___ football many times.",
    options: ["have played", "has played", "played", "play"],
    correctAnswer: "have played",
  ),
  QuizQuestion(
    question: "He ___ a doctor for 5 years.",
    options: ["has been", "have been", "was", "is"],
    correctAnswer: "has been",
  ),
  QuizQuestion(
    question: "We ___ in this city since 2000.",
    options: ["have lived", "has lived", "lived", "live"],
    correctAnswer: "have lived",
  ),
  QuizQuestion(
    question: "The sun ___ already.",
    options: ["has risen", "have risen", "rose", "rises"],
    correctAnswer: "has risen",
  ),
  QuizQuestion(
    question: "Birds ___ yet?",
    options: ["have sung", "has sung", "sang", "sing"],
    correctAnswer: "have sung",
  ),
  QuizQuestion(
    question: "I ___ coffee this morning.",
    options: ["have drunk", "has drunk", "drank", "drink"],
    correctAnswer: "have drunk",
  ),
  QuizQuestion(
    question: "My cat ___ a lot lately.",
    options: ["has slept", "have slept", "slept", "sleep"],
    correctAnswer: "has slept",
  ),
  QuizQuestion(
    question: "They ___ their homework.",
    options: ["have done", "has done", "did", "do"],
    correctAnswer: "have done",
  ),
  QuizQuestion(
    question: "She ___ to music all day.",
    options: ["has listened", "have listened", "listened", "listens"],
    correctAnswer: "has listened",
  ),
];

const List<QuizQuestion> presentPerfectContinuousQuestions = [
  QuizQuestion(
    question: "She ___ to school for 10 minutes.",
    options: ["has been going", "have been going", "went", "goes"],
    correctAnswer: "has been going",
  ),
  QuizQuestion(
    question: "They ___ football for an hour.",
    options: ["have been playing", "has been playing", "played", "play"],
    correctAnswer: "have been playing",
  ),
  QuizQuestion(
    question: "He ___ a book since morning.",
    options: ["has been reading", "have been reading", "read", "reads"],
    correctAnswer: "has been reading",
  ),
  QuizQuestion(
    question: "We ___ in the park since 7 a.m.",
    options: ["have been walking", "has been walking", "walked", "walk"],
    correctAnswer: "have been walking",
  ),
  QuizQuestion(
    question: "The sun ___ since dawn.",
    options: ["has been shining", "have been shining", "shone", "shines"],
    correctAnswer: "has been shining",
  ),
  QuizQuestion(
    question: "Birds ___ since early morning.",
    options: ["have been singing", "has been singing", "sang", "sing"],
    correctAnswer: "have been singing",
  ),
  QuizQuestion(
    question: "I ___ coffee for 30 minutes.",
    options: ["have been drinking", "has been drinking", "drank", "drink"],
    correctAnswer: "have been drinking",
  ),
  QuizQuestion(
    question: "My cat ___ a lot lately.",
    options: ["has been sleeping", "have been sleeping", "slept", "sleep"],
    correctAnswer: "has been sleeping",
  ),
  QuizQuestion(
    question: "They ___ their homework for two hours.",
    options: ["have been doing", "has been doing", "did", "do"],
    correctAnswer: "have been doing",
  ),
  QuizQuestion(
    question: "She ___ to music for an hour.",
    options: [
      "has been listening",
      "have been listening",
      "listened",
      "listens"
    ],
    correctAnswer: "has been listening",
  ),
];

const List<QuizQuestion> pastContinuousQuestions = [
  QuizQuestion(
    question: "She ___ to school when it started to rain.",
    options: ["was going", "went", "is going", "goes"],
    correctAnswer: "was going",
  ),
  QuizQuestion(
    question: "They ___ football at 5 p.m. yesterday.",
    options: ["were playing", "played", "are playing", "play"],
    correctAnswer: "were playing",
  ),
  QuizQuestion(
    question: "He ___ a book when I called.",
    options: ["was reading", "read", "is reading", "reads"],
    correctAnswer: "was reading",
  ),
  QuizQuestion(
    question: "We ___ in the park at that time.",
    options: ["were walking", "walked", "are walking", "walk"],
    correctAnswer: "were walking",
  ),
  QuizQuestion(
    question: "The sun ___ when I woke up.",
    options: ["was shining", "shone", "is shining", "shines"],
    correctAnswer: "was shining",
  ),
  QuizQuestion(
    question: "Birds ___ when I arrived.",
    options: ["were singing", "sang", "are singing", "sing"],
    correctAnswer: "were singing",
  ),
  QuizQuestion(
    question: "I ___ coffee when the phone rang.",
    options: ["was drinking", "drank", "am drinking", "drink"],
    correctAnswer: "was drinking",
  ),
  QuizQuestion(
    question: "My cat ___ a lot last night.",
    options: ["was sleeping", "slept", "is sleeping", "sleeps"],
    correctAnswer: "was sleeping",
  ),
  QuizQuestion(
    question: "They ___ their homework at 8 p.m. yesterday.",
    options: ["were doing", "did", "are doing", "do"],
    correctAnswer: "were doing",
  ),
  QuizQuestion(
    question: "She ___ to music when I came in.",
    options: ["was listening", "listened", "is listening", "listens"],
    correctAnswer: "was listening",
  ),
];

const List<QuizQuestion> pastPerfectQuestions = [
  QuizQuestion(
    question: "She ___ to school before it rained.",
    options: ["had gone", "went", "has gone", "goes"],
    correctAnswer: "had gone",
  ),
  QuizQuestion(
    question: "They ___ football before dinner.",
    options: ["had played", "played", "have played", "play"],
    correctAnswer: "had played",
  ),
  QuizQuestion(
    question: "He ___ a doctor before he moved.",
    options: ["had been", "was", "has been", "is"],
    correctAnswer: "had been",
  ),
  QuizQuestion(
    question: "We ___ in that city before 2010.",
    options: ["had lived", "lived", "have lived", "live"],
    correctAnswer: "had lived",
  ),
  QuizQuestion(
    question: "The sun ___ before we woke up.",
    options: ["had risen", "rose", "has risen", "rises"],
    correctAnswer: "had risen",
  ),
  QuizQuestion(
    question: "Birds ___ before the storm started.",
    options: ["had sung", "sang", "have sung", "sing"],
    correctAnswer: "had sung",
  ),
  QuizQuestion(
    question: "I ___ coffee before leaving home.",
    options: ["had drunk", "drank", "have drunk", "drink"],
    correctAnswer: "had drunk",
  ),
  QuizQuestion(
    question: "My cat ___ a lot before the trip.",
    options: ["had slept", "slept", "has slept", "sleep"],
    correctAnswer: "had slept",
  ),
  QuizQuestion(
    question: "They ___ their homework before class.",
    options: ["had done", "did", "have done", "do"],
    correctAnswer: "had done",
  ),
  QuizQuestion(
    question: "She ___ to music before going to bed.",
    options: ["had listened", "listened", "has listened", "listens"],
    correctAnswer: "had listened",
  ),
];

const List<QuizQuestion> pastPerfectContinuousQuestions = [
  QuizQuestion(
    question: "She ___ to school for 10 minutes before it rained.",
    options: ["had been going", "was going", "has been going", "went"],
    correctAnswer: "had been going",
  ),
  QuizQuestion(
    question: "They ___ football for an hour before dinner.",
    options: ["had been playing", "were playing", "has been playing", "played"],
    correctAnswer: "had been playing",
  ),
  QuizQuestion(
    question: "He ___ a book since morning before I met him.",
    options: ["had been reading", "was reading", "has been reading", "read"],
    correctAnswer: "had been reading",
  ),
  QuizQuestion(
    question: "We ___ in the park since 7 a.m. before it rained.",
    options: ["had been walking", "were walking", "has been walking", "walked"],
    correctAnswer: "had been walking",
  ),
  QuizQuestion(
    question: "The sun ___ since dawn before the clouds appeared.",
    options: ["had been shining", "was shining", "has been shining", "shone"],
    correctAnswer: "had been shining",
  ),
  QuizQuestion(
    question: "Birds ___ since early morning before the storm.",
    options: ["had been singing", "were singing", "has been singing", "sang"],
    correctAnswer: "had been singing",
  ),
  QuizQuestion(
    question: "I ___ coffee for 30 minutes before the call.",
    options: [
      "had been drinking",
      "was drinking",
      "has been drinking",
      "drank"
    ],
    correctAnswer: "had been drinking",
  ),
  QuizQuestion(
    question: "My cat ___ a lot lately before the vet visit.",
    options: [
      "had been sleeping",
      "was sleeping",
      "has been sleeping",
      "slept"
    ],
    correctAnswer: "had been sleeping",
  ),
  QuizQuestion(
    question: "They ___ their homework for two hours before class.",
    options: ["had been doing", "were doing", "has been doing", "did"],
    correctAnswer: "had been doing",
  ),
  QuizQuestion(
    question: "She ___ to music for an hour before dinner.",
    options: [
      "had been listening",
      "was listening",
      "has been listening",
      "listened"
    ],
    correctAnswer: "had been listening",
  ),
];

const List<QuizQuestion> futureSimpleQuestions = [
  QuizQuestion(
    question: "She ___ to school tomorrow.",
    options: ["will go", "goes", "went", "is going"],
    correctAnswer: "will go",
  ),
  QuizQuestion(
    question: "They ___ football next Sunday.",
    options: ["will play", "play", "played", "are playing"],
    correctAnswer: "will play",
  ),
  QuizQuestion(
    question: "He ___ a doctor in the future.",
    options: ["will be", "is", "was", "has been"],
    correctAnswer: "will be",
  ),
  QuizQuestion(
    question: "We ___ in a big city next year.",
    options: ["will live", "live", "lived", "are living"],
    correctAnswer: "will live",
  ),
  QuizQuestion(
    question: "The sun ___ at 6 a.m. tomorrow.",
    options: ["will rise", "rises", "rose", "is rising"],
    correctAnswer: "will rise",
  ),
  QuizQuestion(
    question: "Birds ___ in the morning.",
    options: ["will sing", "sing", "sang", "are singing"],
    correctAnswer: "will sing",
  ),
  QuizQuestion(
    question: "I ___ coffee for breakfast tomorrow.",
    options: ["will drink", "drink", "drank", "am drinking"],
    correctAnswer: "will drink",
  ),
  QuizQuestion(
    question: "My cat ___ a lot next week.",
    options: ["will sleep", "sleeps", "slept", "is sleeping"],
    correctAnswer: "will sleep",
  ),
  QuizQuestion(
    question: "They ___ their homework after dinner.",
    options: ["will do", "do", "did", "are doing"],
    correctAnswer: "will do",
  ),
  QuizQuestion(
    question: "She ___ to music before bed.",
    options: ["will listen", "listens", "listened", "is listening"],
    correctAnswer: "will listen",
  ),
];

const List<QuizQuestion> futureContinuousQuestions = [
  QuizQuestion(
    question: "She ___ to school at 8 a.m. tomorrow.",
    options: ["will be going", "will go", "goes", "is going"],
    correctAnswer: "will be going",
  ),
  QuizQuestion(
    question: "They ___ football at 5 p.m. next Sunday.",
    options: ["will be playing", "will play", "play", "are playing"],
    correctAnswer: "will be playing",
  ),
  QuizQuestion(
    question: "He ___ a book at this time tomorrow.",
    options: ["will be reading", "will read", "reads", "is reading"],
    correctAnswer: "will be reading",
  ),
  QuizQuestion(
    question: "We ___ in the park at 7 a.m. tomorrow.",
    options: ["will be walking", "will walk", "walk", "are walking"],
    correctAnswer: "will be walking",
  ),
  QuizQuestion(
    question: "The sun ___ at 6 a.m. tomorrow.",
    options: ["will be shining", "will shine", "shines", "is shining"],
    correctAnswer: "will be shining",
  ),
  QuizQuestion(
    question: "Birds ___ at 5 a.m. tomorrow.",
    options: ["will be singing", "will sing", "sing", "are singing"],
    correctAnswer: "will be singing",
  ),
  QuizQuestion(
    question: "I ___ coffee at 7 a.m. tomorrow.",
    options: ["will be drinking", "will drink", "drink", "am drinking"],
    correctAnswer: "will be drinking",
  ),
  QuizQuestion(
    question: "My cat ___ at 10 p.m. tomorrow.",
    options: ["will be sleeping", "will sleep", "sleeps", "is sleeping"],
    correctAnswer: "will be sleeping",
  ),
  QuizQuestion(
    question: "They ___ their homework at 8 p.m. tomorrow.",
    options: ["will be doing", "will do", "do", "are doing"],
    correctAnswer: "will be doing",
  ),
  QuizQuestion(
    question: "She ___ to music at 9 p.m. tomorrow.",
    options: ["will be listening", "will listen", "listens", "is listening"],
    correctAnswer: "will be listening",
  ),
];

const List<QuizQuestion> futurePerfectQuestions = [
  QuizQuestion(
    question: "She ___ to school before 8 a.m. tomorrow.",
    options: ["will have gone", "will go", "goes", "is going"],
    correctAnswer: "will have gone",
  ),
  QuizQuestion(
    question: "They ___ football before 6 p.m. next Sunday.",
    options: ["will have played", "will play", "play", "are playing"],
    correctAnswer: "will have played",
  ),
  QuizQuestion(
    question: "He ___ a book before noon tomorrow.",
    options: ["will have read", "will read", "reads", "is reading"],
    correctAnswer: "will have read",
  ),
  QuizQuestion(
    question: "We ___ in the park before 8 a.m. tomorrow.",
    options: ["will have walked", "will walk", "walk", "are walking"],
    correctAnswer: "will have walked",
  ),
  QuizQuestion(
    question: "The sun ___ before 7 a.m. tomorrow.",
    options: ["will have risen", "will rise", "rises", "is rising"],
    correctAnswer: "will have risen",
  ),
  QuizQuestion(
    question: "Birds ___ before 6 a.m. tomorrow.",
    options: ["will have sung", "will sing", "sing", "are singing"],
    correctAnswer: "will have sung",
  ),
  QuizQuestion(
    question: "I ___ coffee before 8 a.m. tomorrow.",
    options: ["will have drunk", "will drink", "drink", "am drinking"],
    correctAnswer: "will have drunk",
  ),
  QuizQuestion(
    question: "My cat ___ before 11 p.m. tomorrow.",
    options: ["will have slept", "will sleep", "sleeps", "is sleeping"],
    correctAnswer: "will have slept",
  ),
  QuizQuestion(
    question: "They ___ their homework before 9 p.m. tomorrow.",
    options: ["will have done", "will do", "do", "are doing"],
    correctAnswer: "will have done",
  ),
  QuizQuestion(
    question: "She ___ to music before 10 p.m. tomorrow.",
    options: ["will have listened", "will listen", "listens", "is listening"],
    correctAnswer: "will have listened",
  ),
];

const List<QuizQuestion> futurePerfectContinuousQuestions = [
  QuizQuestion(
    question: "She ___ to school for 10 minutes before 8 a.m. tomorrow.",
    options: ["will have been going", "will be going", "will go", "is going"],
    correctAnswer: "will have been going",
  ),
  QuizQuestion(
    question: "They ___ football for an hour before 6 p.m. next Sunday.",
    options: [
      "will have been playing",
      "will be playing",
      "will play",
      "are playing"
    ],
    correctAnswer: "will have been playing",
  ),
  QuizQuestion(
    question: "He ___ a book since morning before noon tomorrow.",
    options: [
      "will have been reading",
      "will be reading",
      "will read",
      "is reading"
    ],
    correctAnswer: "will have been reading",
  ),
  QuizQuestion(
    question: "We ___ in the park since 7 a.m. before 8 a.m. tomorrow.",
    options: [
      "will have been walking",
      "will be walking",
      "will walk",
      "are walking"
    ],
    correctAnswer: "will have been walking",
  ),
  QuizQuestion(
    question: "The sun ___ since dawn before 7 a.m. tomorrow.",
    options: [
      "will have been shining",
      "will be shining",
      "will shine",
      "is shining"
    ],
    correctAnswer: "will have been shining",
  ),
  QuizQuestion(
    question: "Birds ___ since early morning before 6 a.m. tomorrow.",
    options: [
      "will have been singing",
      "will be singing",
      "will sing",
      "are singing"
    ],
    correctAnswer: "will have been singing",
  ),
  QuizQuestion(
    question: "I ___ coffee for 30 minutes before 8 a.m. tomorrow.",
    options: [
      "will have been drinking",
      "will be drinking",
      "will drink",
      "am drinking"
    ],
    correctAnswer: "will have been drinking",
  ),
  QuizQuestion(
    question: "My cat ___ a lot lately before 11 p.m. tomorrow.",
    options: [
      "will have been sleeping",
      "will be sleeping",
      "will sleep",
      "is sleeping"
    ],
    correctAnswer: "will have been sleeping",
  ),
  QuizQuestion(
    question: "They ___ their homework for two hours before 9 p.m. tomorrow.",
    options: ["will have been doing", "will be doing", "will do", "are doing"],
    correctAnswer: "will have been doing",
  ),
  QuizQuestion(
    question: "She ___ to music for an hour before 10 p.m. tomorrow.",
    options: [
      "will have been listening",
      "will be listening",
      "will listen",
      "is listening"
    ],
    correctAnswer: "will have been listening",
  ),
];

const List<QuizQuestion> nearFutureQuestions = [
  QuizQuestion(
    question: "Look at those clouds! It ___ soon.",
    options: ["is going to rain", "will rain", "rains", "is raining"],
    correctAnswer: "is going to rain",
  ),
  QuizQuestion(
    question: "She ___ to school in a few minutes.",
    options: ["is going to go", "will go", "goes", "is going"],
    correctAnswer: "is going to go",
  ),
  QuizQuestion(
    question: "They ___ football this afternoon.",
    options: ["are going to play", "will play", "play", "are playing"],
    correctAnswer: "are going to play",
  ),
  QuizQuestion(
    question: "He ___ a book tonight.",
    options: ["is going to read", "will read", "reads", "is reading"],
    correctAnswer: "is going to read",
  ),
  QuizQuestion(
    question: "We ___ in the park this evening.",
    options: ["are going to walk", "will walk", "walk", "are walking"],
    correctAnswer: "are going to walk",
  ),
  QuizQuestion(
    question: "The sun ___ at 6 a.m. tomorrow.",
    options: ["is going to rise", "will rise", "rises", "is rising"],
    correctAnswer: "is going to rise",
  ),
  QuizQuestion(
    question: "Birds ___ in the morning.",
    options: ["are going to sing", "will sing", "sing", "are singing"],
    correctAnswer: "are going to sing",
  ),
  QuizQuestion(
    question: "I ___ coffee for breakfast.",
    options: ["am going to drink", "will drink", "drink", "am drinking"],
    correctAnswer: "am going to drink",
  ),
  QuizQuestion(
    question: "My cat ___ a lot tonight.",
    options: ["is going to sleep", "will sleep", "sleeps", "is sleeping"],
    correctAnswer: "is going to sleep",
  ),
  QuizQuestion(
    question: "They ___ their homework after dinner.",
    options: ["are going to do", "will do", "do", "are doing"],
    correctAnswer: "are going to do",
  ),
];
