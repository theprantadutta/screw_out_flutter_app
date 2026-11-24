// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Pausar';

  @override
  String get back => 'Voltar';

  @override
  String get settings => 'Configurações';

  @override
  String get tray => 'BANDEJA';

  @override
  String get trayFull => 'BANDEJA CHEIA';

  @override
  String get undo => 'DESFAZER';

  @override
  String hintCount(String count) {
    return 'DICA · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'Pausado';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · JOGADA $moves';
  }

  @override
  String get resume => 'Continuar';

  @override
  String get sound => 'SOM';

  @override
  String get haptics => 'VIBRAÇÃO';

  @override
  String get reducedMotion => 'MENOS MOVIMENTO';

  @override
  String get restart => 'REINICIAR';

  @override
  String get exitToSheets => 'SAIR PARA FOLHAS';

  @override
  String get restartConfirmTitle => 'Reiniciar esta folha?';

  @override
  String restartConfirmBody(int moves) {
    return 'Você vai perder $moves jogadas de progresso.';
  }

  @override
  String get cancel => 'CANCELAR';

  @override
  String get stuckTitle => 'Não há mais espaços livres.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parafusos',
      one: 'um parafuso',
    );
    return '$plate ainda prende $_temp0 no tabuleiro. Desfazer libera um espaço.';
  }

  @override
  String get stuckReasonGeneric =>
      'Todos os espaços estão ocupados e nenhuma placa pode cair. Desfazer libera um espaço.';

  @override
  String get undoLastMove => 'Desfazer última jogada';

  @override
  String rescueSlotCoins(int coins) {
    return 'ESPAÇO EXTRA · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'ESPAÇO EXTRA · VÍDEO';

  @override
  String get rescueSlotPro => 'ESPAÇO EXTRA · PRO';

  @override
  String get outOfHintsTitle => 'Quer mais uma dica?';

  @override
  String get hintsLeftZero => 'DICAS · 0 RESTANTES';

  @override
  String get outOfHintsBody =>
      'Uma dica circula um próximo parafuso útil. Ela nunca resolve a folha.';

  @override
  String get watchVideo => 'Assista a um vídeo curto';

  @override
  String get watchVideoMeta => 'OPCIONAL · ~30 S · +1 DICA';

  @override
  String useCoins(int coins) {
    return 'Usar $coins moedas';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'SALDO $balance ¢';
  }

  @override
  String get keepThinking => 'Continuar pensando';

  @override
  String get notEnoughCoins => 'Moedas insuficientes por enquanto.';

  @override
  String get adUnavailable => 'Nenhum vídeo disponível agora.';

  @override
  String cleared(String code) {
    return '$code · CONCLUÍDA';
  }

  @override
  String get disassembled => 'Desmontado.';

  @override
  String get approved => 'APROVADO';

  @override
  String get statMoves => 'JOGADAS';

  @override
  String get statTime => 'TEMPO';

  @override
  String get statMastery => 'MAESTRIA';

  @override
  String nextSheet(String code) {
    return 'Próxima · $code';
  }

  @override
  String get replay => 'REPETIR';

  @override
  String get sheets => 'FOLHAS';

  @override
  String get backHome => 'Voltar ao início';

  @override
  String chapterComplete(String chapter) {
    return 'CAPÍTULO $chapter · CONCLUÍDO';
  }

  @override
  String get themeUnlocked => 'TEMA DESBLOQUEADO';

  @override
  String nextChapter(String chapter) {
    return 'PRÓXIMO · CAPÍTULO $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'Começar capítulo $chapter';
  }

  @override
  String equipTheme(String name) {
    return 'USAR $name';
  }

  @override
  String get tutorialStep1 => 'PASSO 1 · TOQUE NO PARAFUSO';

  @override
  String get tutorialLands => '↓ ELE CAI NA BANDEJA';

  @override
  String get skipTutorial => 'PULAR TUTORIAL';

  @override
  String get splashTagline => 'UM QUEBRA-CABEÇA DE CAMADAS';

  @override
  String get splashFooter => 'REV 1.0 · FOLHA 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates PLACAS',
      one: '1 PLACA',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'PARAFUSOS',
      one: 'PARAFUSO',
    );
    return 'FIG. 1\nVISTA EXPLODIDA\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'CAPÍTULO $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PARAFUSOS',
      one: 'PARAFUSO',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'PRÓXIMA FOLHA';

  @override
  String chapterLabel(String chapter) {
    return 'CAPÍTULO $chapter';
  }

  @override
  String get campaign => 'CAMPANHA';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Continuar · $code';
  }

  @override
  String get daily => 'DIÁRIA';

  @override
  String get themes => 'TEMAS';

  @override
  String get allCleared => 'Todas as folhas concluídas';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total FOLHAS';
  }

  @override
  String get fiveChapters => 'Cinco capítulos';

  @override
  String get chaptersTitle => 'Capítulos';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'BLOQUEADO';

  @override
  String get downloadChapter => 'BAIXAR';

  @override
  String get downloading => 'BAIXANDO…';

  @override
  String get comingSoon => 'MAIS FOLHAS EM BREVE';

  @override
  String newMechanic(String mechanic) {
    return 'NOVO: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates placas',
      one: '1 placa',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers camadas',
      one: '1 camada',
    );
    return '$_temp0 · $_temp1 · bandeja $tray';
  }

  @override
  String get theCampaign => 'A CAMPANHA';

  @override
  String get campaignFooter =>
      'Os capítulos são desbloqueados ao terminar o anterior. As marcas de maestria são opcionais. As dicas nunca bloqueiam o progresso.';

  @override
  String get chapterBonus => 'BÔNUS DO CAPÍTULO';

  @override
  String get dailySheet => 'FOLHA DIÁRIA';

  @override
  String get dailyTitle => 'TÍTULO';

  @override
  String get dailyPlates => 'PLACAS';

  @override
  String get dailyReward => 'PRÊMIO';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: 'Sequência de $streak dias.',
      one: 'Sequência de 1 dia.',
      zero: 'Comece uma sequência.',
    );
    return 'A mesma folha para todos hoje. Sem cronômetro. $_temp0 Perder um dia não custa nada.';
  }

  @override
  String get startDaily => 'Começar a folha de hoje';

  @override
  String get dailyCompleted => 'Feito por hoje · volte amanhã';

  @override
  String get replayDaily => 'Repetir a folha de hoje';

  @override
  String get themesTitle => 'Temas';

  @override
  String get themesCaption => 'SÓ VISUAL · NUNCA MUDA AS REGRAS';

  @override
  String get equipped => 'EM USO';

  @override
  String get owned => 'ADQUIRIDO';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'PRÉVIA';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get feedbackSection => 'SOM E VIBRAÇÃO';

  @override
  String get soundEffects => 'Efeitos sonoros';

  @override
  String get music => 'Música';

  @override
  String get hapticsRow => 'Vibração';

  @override
  String get reducedMotionRow => 'Menos movimento';

  @override
  String get reducedMotionCaption => 'Esmaecer em vez de deslizar';

  @override
  String get generalSection => 'GERAL';

  @override
  String get highRefreshRate => 'Alta taxa de atualização';

  @override
  String highRefreshRateOn(int hz) {
    return 'Movimento mais suave · até $hz Hz · usa mais bateria';
  }

  @override
  String get highRefreshRateOff => 'Movimento mais suave · usa mais bateria';

  @override
  String get highRefreshRateUnsupported =>
      'Esta tela funciona em uma única taxa';

  @override
  String get highRefreshRateBattery =>
      'Limitada pela economia de bateria agora';

  @override
  String get highRefreshRateHeat =>
      'Limitada enquanto o celular estiver quente';

  @override
  String highRefreshRateNow(int hz) {
    return 'Agora $hz Hz';
  }

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Lembrete diário';

  @override
  String get notificationsCaption => 'Um aviso quando sair uma folha nova';

  @override
  String get accountSection => 'CONTA';

  @override
  String get signInGoogle => 'Fazer login com o Google';

  @override
  String get signInApple => 'Iniciar sessão com a Apple';

  @override
  String signedInAs(String name) {
    return 'Conectado · $name';
  }

  @override
  String get guestCaption =>
      'JOGANDO COMO CONVIDADO · ENTRE PARA SALVAR O PROGRESSO';

  @override
  String get signOut => 'SAIR';

  @override
  String get deleteAccount => 'EXCLUIR CONTA';

  @override
  String get purchasesSection => 'COMPRAS';

  @override
  String get removeAds => 'Remover anúncios';

  @override
  String get restore => 'RESTAURAR';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'SEM ANÚNCIOS · DICAS ILIMITADAS · TODOS OS TEMAS · RESGATES GRÁTIS · $coins ¢ POR MÊS';
  }

  @override
  String get proMonthly => 'MENSAL';

  @override
  String get proYearly => 'ANUAL';

  @override
  String proTrialDays(int days) {
    return '$days DIAS GRÁTIS';
  }

  @override
  String proThenPrice(String price) {
    return 'DEPOIS $price';
  }

  @override
  String get proTrialTerms =>
      'Renova automaticamente após o teste grátis, a menos que você cancele. As moedas mensais começam com o seu primeiro pagamento.';

  @override
  String get proActive => 'PRO · ATIVO';

  @override
  String get adsRemoved => 'SEM ANÚNCIOS';

  @override
  String get coinPacks => 'PACOTES DE MOEDAS';

  @override
  String get aboutSection => 'SOBRE';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get termsOfUse => 'Termos de uso';

  @override
  String get refundPolicy => 'Política de reembolso';

  @override
  String get privacyChoices => 'Opções de privacidade';

  @override
  String get licenses => 'Licenças e créditos';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · REV $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'Um lembrete para a folha diária?';

  @override
  String get notificationPrimerBody =>
      'Um lembrete discreto quando você não tiver jogado. Nunca mais de um por dia.';

  @override
  String get allow => 'PERMITIR';

  @override
  String get notNow => 'AGORA NÃO';

  @override
  String get somethingWentWrong => 'Algo deu errado.';

  @override
  String get purchaseThanks => 'Obrigado! Compra aplicada.';

  @override
  String get purchasePending =>
      'Compra pendente. Ela será aplicada quando for confirmada.';

  @override
  String get purchaseFailed => 'A compra não foi concluída.';

  @override
  String get restored => 'Compras restauradas.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Termine o capítulo $chapter primeiro.';
  }

  @override
  String get moreSheetsTitle => 'Mais folhas';

  @override
  String get moreSheetsCaption => 'Novos conjuntos de desenhos chegam aqui';

  @override
  String get equip => 'USAR';

  @override
  String buyFor(int coins) {
    return 'COMPRAR · $coins ¢';
  }

  @override
  String get close => 'FECHAR';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Licenças';

  @override
  String get licensesCaption => 'AVISOS DE CÓDIGO ABERTO';

  @override
  String playLevel(String code) {
    return 'Jogar $code';
  }

  @override
  String lockedLevel(int number) {
    return 'Folha $number, bloqueada';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Rankings';

  @override
  String get leaderboardCaption => 'JOGADORES CONECTADOS · AO VIVO';

  @override
  String get boardSheets => 'FOLHAS';

  @override
  String get boardDaily => 'DIÁRIA';

  @override
  String get boardStreak => 'SEQUÊNCIA';

  @override
  String get boardWeekly => 'SEMANA';

  @override
  String get boardWeeklyHint =>
      'FOLHAS CONCLUÍDAS NESTA SEMANA · REINICIA NA SEGUNDA';

  @override
  String get boardSheetsHint => 'MAIS FOLHAS CONCLUÍDAS';

  @override
  String get boardDailyHint =>
      'FOLHA DE HOJE · MENOS JOGADAS, DEPOIS MAIS RÁPIDO';

  @override
  String get boardStreakHint => 'DIAS SEGUIDOS NA FOLHA DIÁRIA';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'JOGADAS',
      one: 'JOGADA',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'DIAS',
      one: 'DIA',
    );
    return '$_temp0 · MELHOR $best';
  }

  @override
  String get boardYou => 'VOCÊ';

  @override
  String get boardYourRank => 'SUA POSIÇÃO';

  @override
  String get boardNotRanked => 'Ainda sem posição';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'DE $countString';
  }

  @override
  String get boardGuest =>
      'Entre para colocar seu nome no ranking. Seu progresso vai junto.';

  @override
  String get boardEmpty => 'Ninguém aqui ainda. Seja o primeiro.';

  @override
  String get boardOffline => 'Não foi possível carregar o ranking agora.';

  @override
  String get tryAgainCaps => 'RECARREGAR';

  @override
  String get todaysBoard => 'RANKING DE HOJE';

  @override
  String get signedOutToast =>
      'Você saiu · os dados deste dispositivo foram apagados. Entre de novo para recuperar seu progresso.';

  @override
  String get welcomeBack => 'Olá de novo';

  @override
  String welcomeBackName(String name) {
    return 'Olá de novo, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets folhas',
      one: '1 folha',
    );
    return '$who · $_temp0 e $coins moedas restauradas';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · você está conectado e seu progresso tem backup';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets folhas',
      one: '1 folha',
    );
    return '$who · o progresso deste dispositivo foi adicionado à sua conta: $_temp0, $coins moedas';
  }

  @override
  String syncSavedNew(String name) {
    return 'Conectado como $name · seu progresso agora fica salvo na sua conta';
  }

  @override
  String get syncSavedNewPlain =>
      'Conectado · seu progresso agora fica salvo na sua conta';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets folhas novas',
      one: '1 folha nova',
      zero: 'progresso atualizado',
    );
    return 'Sincronizado do seu outro dispositivo · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Ainda não foi possível carregar seu progresso salvo · ele vai sincronizar sozinho quando a conexão voltar';

  @override
  String get signedInOffline =>
      'Conectado · seu progresso vai sincronizar quando você estiver online';

  @override
  String get proActivated =>
      'O Pro está ativo · sem anúncios, todos os temas e dicas ilimitadas';

  @override
  String get accountDeletedToast =>
      'Sua conta e todos os dados dela foram excluídos.';

  @override
  String accountDeletedProToast(String store) {
    return 'Conta excluída. O Pro continua sendo cobrado até você cancelar na $store.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return 'SEQUÊNCIA DE $days DIAS · BÔNUS DE +$coins';
  }

  @override
  String get workshopRecord => 'Registro da oficina';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Registro da oficina · $earned/$total';
  }

  @override
  String get recordCaption => 'CONQUISTAS';

  @override
  String recordEarned(int earned, int total) {
    return '$earned DE $total CONQUISTADAS';
  }

  @override
  String get badgeEarnedLabel => 'OBTIDA';

  @override
  String badgeEarnedToast(String name) {
    return 'Insígnia conquistada · $name';
  }

  @override
  String get badgeFirstTurn => 'Primeira Volta';

  @override
  String get badgeApprentice => 'Aprendiz';

  @override
  String get badgeJourneyman => 'Oficial';

  @override
  String get badgeCraftsman => 'Artesão';

  @override
  String get badgeChiefEngineer => 'Engenheiro-Chefe';

  @override
  String get badgeCleanWork => 'Trabalho Limpo';

  @override
  String get badgePerfectionist => 'Perfeccionista';

  @override
  String get badgeRegular => 'Frequentador';

  @override
  String get badgeOnARoll => 'Embalado';

  @override
  String get badgeFullWeek => 'Semana Completa';

  @override
  String get badgeFortnight => 'Quinzena';

  @override
  String get badgeFirstDetail => 'Conclua sua primeira folha';

  @override
  String badgeClearDetail(int n) {
    return 'Conclua $n folhas';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'Termine o capítulo $n';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'Ganhe ◆ em $n folhas';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'Jogue $n folhas diárias';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'Alcance uma sequência de $n dias';
  }

  @override
  String get share => 'COMPARTILHAR';

  @override
  String get shareResult => 'Compartilhar resultado';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves jogadas',
      one: '1 jogada',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return 'Sequência de $days dias';
  }

  @override
  String get signOutSheetTitle => 'Sair?';

  @override
  String get signOutSheetBody =>
      'Ao sair, seu progresso é apagado deste dispositivo. Tudo o que já tem backup volta quando você entrar de novo, mas o que ainda não foi sincronizado (por exemplo, folhas jogadas offline) seria perdido.';

  @override
  String get staySignedIn => 'Continuar conectado';

  @override
  String get signOutConfirm => 'Sair';

  @override
  String get rateApp => 'Avaliar o Screw Out';

  @override
  String get sendFeedback => 'Enviar feedback';

  @override
  String get replayTutorial => 'Rever tutorial';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Nenhum app de e-mail encontrado. Escreva para $email';
  }

  @override
  String get updateChip => 'ATUALIZAR';

  @override
  String get updateReadyRestart =>
      'Atualização baixada. Reinicie para instalar.';

  @override
  String get deleteSheetTitle => 'Excluir sua conta?';

  @override
  String get deleteSheetBody =>
      'Isto exclui para sempre sua conta e tudo o que foi salvo nela: progresso em todas as folhas, moedas, temas, sua sequência diária e suas posições nos rankings. Não dá para desfazer.';

  @override
  String deleteSheetPro(String store) {
    return 'Você tem o Screw Out Pro. Excluir a conta não cancela a assinatura: cancele na $store ou você continuará sendo cobrado.';
  }

  @override
  String get manageSubscription => 'Gerenciar assinatura';

  @override
  String get deleteForever => 'Excluir minha conta';

  @override
  String get deleting => 'Excluindo…';

  @override
  String get keepAccount => 'Manter minha conta';

  @override
  String get deleteOffline =>
      'Você está offline. Conecte-se à internet para excluir sua conta.';

  @override
  String get deleteFailed =>
      'Não foi possível excluir sua conta. Tente de novo.';

  @override
  String get restoreNothing => 'Nada para restaurar nesta conta.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 dica';
  }

  @override
  String get hintEarnedToast => '+1 dica · obrigado por assistir';

  @override
  String get rescueToast => '+1 espaço na bandeja nesta folha';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 espaço na bandeja';
  }

  @override
  String get adNotCompleted =>
      'O vídeo não terminou, então desta vez não há recompensa.';

  @override
  String themeEquippedToast(String name) {
    return '$name em uso';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'O capítulo $chapter está pronto';
  }

  @override
  String get signInFailed => 'O login não foi concluído.';

  @override
  String get themePurchased => 'Tema desbloqueado.';

  @override
  String themeBuyStore(String price) {
    return 'OU COMPRE · $price';
  }

  @override
  String get themesBundleTitle => 'Todos os temas';

  @override
  String get themesBundleBody =>
      'Todos os temas pagos, seus para sempre. O Pro também inclui.';

  @override
  String themesBundleBuy(String price) {
    return 'COMPRAR · $price';
  }

  @override
  String get dailyWeekDone => 'Feito';

  @override
  String masteredCount(int count) {
    return '$count DOMINADAS';
  }

  @override
  String get reminderTitle => 'A folha de hoje está pronta';

  @override
  String get reminderBody =>
      'Um desenho novo, o mesmo para todos. Sem cronômetro.';

  @override
  String get comebackReminderTitle => 'Sua próxima folha está na bancada';

  @override
  String get comebackReminderBody =>
      'Alguns minutos tranquilos, alguns parafusos. Continue de onde parou.';

  @override
  String get signInEmail => 'Continuar com e-mail';

  @override
  String get emailSignInTitle => 'Entrar';

  @override
  String get emailCreateTitle => 'Criar conta';

  @override
  String get emailTabSignIn => 'ENTRAR';

  @override
  String get emailTabCreate => 'CRIAR CONTA';

  @override
  String get emailSheetBody => 'Seu progresso neste dispositivo vai junto.';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get passwordLabel => 'SENHA';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String passwordHint(int min) {
    return 'Pelo menos $min caracteres';
  }

  @override
  String get emailRequired => 'Digite seu e-mail.';

  @override
  String get emailInvalid => 'Esse endereço de e-mail não parece certo.';

  @override
  String get passwordRequired => 'Digite sua senha.';

  @override
  String passwordTooShort(int min) {
    return 'Use pelo menos $min caracteres.';
  }

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get forgotNeedsEmail =>
      'Digite seu e-mail acima e toque em Esqueceu a senha?';

  @override
  String resetSent(String email) {
    return 'Se $email tiver uma conta, um link de redefinição está a caminho.';
  }

  @override
  String get emailWorking => 'Um momento…';

  @override
  String get authErrWrongCredentials => 'E-mail ou senha incorretos.';

  @override
  String get authErrEmailInUse =>
      'Este e-mail já tem uma conta. Entre com ele.';

  @override
  String get authErrWeakPassword => 'Escolha uma senha mais forte.';

  @override
  String get authErrDisabled => 'Esta conta foi desativada.';

  @override
  String get authErrNotEnabled =>
      'O login por e-mail não está disponível agora.';

  @override
  String get authErrTooMany =>
      'Tentativas demais. Espere um pouco e tente de novo.';

  @override
  String get authErrNetwork =>
      'Sem conexão. Verifique sua internet e tente de novo.';

  @override
  String get authErrGeneric => 'Não foi possível entrar. Tente de novo.';

  @override
  String get deletePasswordBody =>
      'Digite sua senha para confirmar que é você.';

  @override
  String get deleteWrongPassword => 'Essa senha não corresponde a esta conta.';

  @override
  String get purchaseSaveTitle => 'Guarde sua compra';

  @override
  String get purchaseSaveBody =>
      'Opcional: entre para manter suas compras e seu progresso em todos os seus dispositivos. Sua compra já funciona neste.';

  @override
  String get purchaseNeedsConnection =>
      'Não foi possível falar com o servidor. Verifique sua conexão e tente de novo.';

  @override
  String get languageSystemDefault => 'Padrão do sistema';

  @override
  String get startupFailed =>
      'ALGO DEU ERRADO AO INICIAR.\nFECHE O APP E ABRA DE NOVO.';

  @override
  String get notificationChannelDescription =>
      'Lembretes da folha diária e avisos da conta';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Parafuso, placa $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Parafuso, placa $plate, bloqueado por $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled de $total';
  }

  @override
  String get chapterName1 => 'Básico da Oficina';

  @override
  String get chapterName2 => 'Camada por Camada';

  @override
  String get chapterName3 => 'Abra Espaço';

  @override
  String get chapterName4 => 'Encaixes';

  @override
  String get chapterName5 => 'Mestre Construtor';

  @override
  String get chapterGoal1 => 'Toque, remova, solte';

  @override
  String get chapterGoal2 => 'Sobreposição e ordem';

  @override
  String get chapterGoal3 => 'Planeje com bandeja curta';

  @override
  String get chapterGoal4 => 'Suportes compartilhados';

  @override
  String get chapterGoal5 => 'Tudo, de forma justa';

  @override
  String get chapterPitch1 =>
      'Toque num parafuso. Solte uma placa. A regra é só essa.';

  @override
  String get chapterPitch2 =>
      'Placas escondem placas. Trabalhe de cima para baixo.';

  @override
  String get chapterPitch3 =>
      'Bandejas menores. Planeje quais parafusos tirar primeiro.';

  @override
  String get chapterPitch4 => 'Uma placa prende várias. Encontre a peça-chave.';

  @override
  String get chapterPitch5 =>
      'Pilhas fundas, todas as ideias de uma vez. Sem pressa.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Conjunto de Desenhos $number';
  }

  @override
  String get chapterGoalDownloaded => 'Folhas de nível mestre';

  @override
  String get chapterPitchDownloaded => 'Mais folhas, as mesmas regras justas.';

  @override
  String get mechanicOverlap => 'SOBREPOSIÇÃO';

  @override
  String get mechanicTray => 'BANDEJA';

  @override
  String get mechanicLayers => 'CAMADAS';

  @override
  String get mechanicCircles => 'CÍRCULOS';

  @override
  String get mechanicTraps => 'ARMADILHAS';

  @override
  String get mechanicSupports => 'SUPORTES';

  @override
  String get sheetObjective004 =>
      'TIRE A PLACA DE CIMA PARA ALCANÇAR O PARAFUSO';

  @override
  String get sheetObjective006 =>
      'BANDEJA PARA 3. CADA PLACA SOLTA LIBERA ESPAÇOS';

  @override
  String get sheetObjective011 => 'TRÊS CAMADAS. TRABALHE DE CIMA PARA BAIXO';

  @override
  String get sheetObjective012 => 'TIRE PL-04 ANTES DAS PLACAS DE BAIXO';

  @override
  String get sheetObjective017 => 'UMA JOGADA TENTADORA ENCHE A BANDEJA';

  @override
  String get sheetObjective021 => 'PLACAS REDONDAS COBREM COMO QUALQUER OUTRA';

  @override
  String get sheetObjective024 => 'TIRE PL-04 PARA CHEGAR AO CANTO';

  @override
  String get sheetObjective041 =>
      'BANDEJA CURTA. SOLTE UMA PLACA ANTES QUE ENCHA';

  @override
  String get sheetObjective061 => 'UMA PLACA PODE PRENDER VÁRIAS OUTRAS';

  @override
  String get sheetObjective081 => 'TUDO O QUE VOCÊ APRENDEU. SEM PRESSA';

  @override
  String get themeNameBlueprint => 'Planta Limpa';

  @override
  String get themeNameWalnut => 'Oficina de Nogueira';

  @override
  String get themeNameOcean => 'Oceano Turquesa';

  @override
  String get themeNameCopper => 'Cobre Quente';

  @override
  String get themeNameMidnight => 'Oficina da Meia-Noite';

  @override
  String get themeNamePastel => 'Estúdio Pastel';

  @override
  String sheetTitleNumbered(int number) {
    return 'Folha $number';
  }

  @override
  String get sheetTitle001 => 'Primeira Volta';

  @override
  String get sheetTitle002 => 'Dois Pontos';

  @override
  String get sheetTitle003 => 'Lado a Lado';

  @override
  String get sheetTitle004 => 'Tampa';

  @override
  String get sheetTitle005 => 'Revelação';

  @override
  String get sheetTitle006 => 'Dia de Bandeja';

  @override
  String get sheetTitle007 => 'Plano Pequeno';

  @override
  String get sheetTitle008 => 'Encaixe Justo';

  @override
  String get sheetTitle009 => 'Barra Redonda';

  @override
  String get sheetTitle010 => 'Ponto de Controle';

  @override
  String get sheetTitle011 => 'Terceira Camada';

  @override
  String get sheetTitle012 => 'Travessa em X';

  @override
  String get sheetTitle013 => 'Libere um Espaço';

  @override
  String get sheetTitle014 => 'Dois à Frente';

  @override
  String get sheetTitle015 => 'Aço Pintado';

  @override
  String get sheetTitle016 => 'Bancada';

  @override
  String get sheetTitle017 => 'Tentação';

  @override
  String get sheetTitle018 => 'Cascata';

  @override
  String get sheetTitle019 => 'Mix da Oficina';

  @override
  String get sheetTitle020 => 'Montagem';

  @override
  String get sheetTitle021 => 'Pilha de Arruelas';

  @override
  String get sheetTitle022 => 'Junta';

  @override
  String get sheetTitle023 => 'Tampa de Lente';

  @override
  String get sheetTitle024 => 'Suporte Oculto';

  @override
  String get sheetTitle025 => 'Jogo de Calços';

  @override
  String get sheetTitle026 => 'Moldura';

  @override
  String get sheetTitle027 => 'Ilhós';

  @override
  String get sheetTitle028 => 'Respiro';

  @override
  String get sheetTitle029 => 'Anel de Flange';

  @override
  String get sheetTitle030 => 'Escotilha';

  @override
  String get sheetTitle031 => 'Espaçador';

  @override
  String get sheetTitle032 => 'Colar';

  @override
  String get sheetTitle033 => 'Tampa Final';

  @override
  String get sheetTitle034 => 'Turno Tranquilo';

  @override
  String get sheetTitle035 => 'Antepara';

  @override
  String get sheetTitle036 => 'Tampa de Inspeção';

  @override
  String get sheetTitle037 => 'Placa Frontal';

  @override
  String get sheetTitle038 => 'Serviço Leve';

  @override
  String get sheetTitle039 => 'Roseta';

  @override
  String get sheetTitle040 => 'Bolo de Camadas';

  @override
  String get sheetTitle041 => 'Abra Espaço';

  @override
  String get sheetTitle042 => 'Espaço na Caixa';

  @override
  String get sheetTitle043 => 'Transbordo';

  @override
  String get sheetTitle044 => 'Nicho';

  @override
  String get sheetTitle045 => 'Caixa de Peças';

  @override
  String get sheetTitle046 => 'Pouco Material';

  @override
  String get sheetTitle047 => 'Escaninho';

  @override
  String get sheetTitle048 => 'Saída Fácil';

  @override
  String get sheetTitle049 => 'Caça-Níquel';

  @override
  String get sheetTitle050 => 'Casa Cheia';

  @override
  String get sheetTitle051 => 'Pendências';

  @override
  String get sheetTitle052 => 'Espaço Reserva';

  @override
  String get sheetTitle053 => 'Folga';

  @override
  String get sheetTitle054 => 'Encaixe Solto';

  @override
  String get sheetTitle055 => 'Inventário';

  @override
  String get sheetTitle056 => 'Margem';

  @override
  String get sheetTitle057 => 'Tolerância';

  @override
  String get sheetTitle058 => 'Dia de Folga';

  @override
  String get sheetTitle059 => 'Altura Livre';

  @override
  String get sheetTitle060 => 'Depósito';

  @override
  String get sheetTitle061 => 'Intertravamento';

  @override
  String get sheetTitle062 => 'Chapa de Reforço';

  @override
  String get sheetTitle063 => 'Pedra Angular';

  @override
  String get sheetTitle064 => 'Junta Sobreposta';

  @override
  String get sheetTitle065 => 'Tala de Emenda';

  @override
  String get sheetTitle066 => 'Rabo de Andorinha';

  @override
  String get sheetTitle067 => 'Verga';

  @override
  String get sheetTitle068 => 'Retalho';

  @override
  String get sheetTitle069 => 'Escora';

  @override
  String get sheetTitle070 => 'Treliça';

  @override
  String get sheetTitle071 => 'Forquilha';

  @override
  String get sheetTitle072 => 'Canga';

  @override
  String get sheetTitle073 => 'Sela';

  @override
  String get sheetTitle074 => 'Sapata';

  @override
  String get sheetTitle075 => 'Par de Suportes';

  @override
  String get sheetTitle076 => 'Barra de Fixação';

  @override
  String get sheetTitle077 => 'Placa de Ligação';

  @override
  String get sheetTitle078 => 'Painel Liso';

  @override
  String get sheetTitle079 => 'Viga em Balanço';

  @override
  String get sheetTitle080 => 'Pórtico Rígido';

  @override
  String get sheetTitle081 => 'Plano Mestre';

  @override
  String get sheetTitle082 => 'Submontagem';

  @override
  String get sheetTitle083 => 'Vista Explodida';

  @override
  String get sheetTitle084 => 'Teste de Encaixe';

  @override
  String get sheetTitle085 => 'Torque Exato';

  @override
  String get sheetTitle086 => 'Gabarito';

  @override
  String get sheetTitle087 => 'Fixador';

  @override
  String get sheetTitle088 => 'Bancada Calma';

  @override
  String get sheetTitle089 => 'Caixa de Câmbio';

  @override
  String get sheetTitle090 => 'Carcaça';

  @override
  String get sheetTitle091 => 'Chassi';

  @override
  String get sheetTitle092 => 'Baia de Painéis';

  @override
  String get sheetTitle093 => 'Jogo de Tampas';

  @override
  String get sheetTitle094 => 'Torque Leve';

  @override
  String get sheetTitle095 => 'Coxim do Motor';

  @override
  String get sheetTitle096 => 'Quadro Elétrico';

  @override
  String get sheetTitle097 => 'Caixa de Comando';

  @override
  String get sheetTitle098 => 'Prancheta';

  @override
  String get sheetTitle099 => 'Inspeção Final';

  @override
  String get sheetTitle100 => 'Aprovação Final';
}
