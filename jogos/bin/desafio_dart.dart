import 'dart:io' as io;
import 'dart:math';

// Jogo 
// Desafio 5 -> Uso de enum
enum Jogada { pedra, papel, tesoura }

void main() {
  bool rodandoJogo= true;

  while (rodandoJogo) {
    print('\n=========================================');
    print('                BORA JOGAR!!!           ');
    print('\n      ==============================     ');
    print('         ESCOLHA UM JOGO PARA COMEÇAR:         ');
    print('============================================');
    print('1. Adivinhe o Número');
    print('2. Jokenpô!!!');
    print('0. Sair');
    io.stdout.write('Escolha uma opção: ');
    
    String? opcao = io.stdin.readLineSync();

    switch (opcao) {
      case '1':
        jogarAdivinhacao();
        break;
      case '2':
        jogarJokenpo();
        break;
      case '0':
        rodandoJogo = false;
        print('Saindo... Até mais!');
        break;
      default:
        print('Opção inválida! Tente novamente.');
    }
  }
}

// Jogo 1: Adivinhe o número
// Desafio 3 -> Função separada para obter palpite válido
int palpiteValido() {
  while (true) {
    io.stdout.write('Digite um número entre 1 e 50: ');
    String? entrada = io.stdin.readLineSync();
    int? numero = int.tryParse(entrada ?? '');

    // Desafio 1 -> Impedir números fora do intervalo (1 a 100)
    if (numero != null && numero >= 1 && numero <= 50) {
      return numero;
    }
    print('⚠️ Valor inválido! Digite apenas números inteiros entre 1 e 50.');
  }
}

void jogarAdivinhacao() {
  print('\n--- ADIVINHE O NÚMERO ---');
  int numeroOculto = Random().nextInt(50) + 1;
  int tentativasRestantes = 4; // Desafio 2 -> Limite de 4 tentativas
  bool acertou = false;

  print('O computador escolheu um número entre 1 e 50.');
  print('Você tem $tentativasRestantes tentativas!');

  while (tentativasRestantes > 0) {
    print('\nTentaivas restantes: $tentativasRestantes');
    int palpite = palpiteValido();

    if (palpite == numeroOculto) {
      print('🎉 Parabéns! Você acertou o número secreto ($numeroOculto)!');
      acertou = true;
      break;
    } else if (palpite < numeroOculto) {
      print('📈 O número secreto é MAIOR que $palpite.');
    } else {
      print('📉 O número secreto é MENOR que $palpite.');
    }

    tentativasRestantes--;
  }

  // Desafio 2 -> Fim de jogo e revelação se esgotar as tentativas
  if (!acertou) {
    print('\n❌ Fim de Jogo! Suas tentativas acabaram.');
    print('O número correto era: $numeroOculto');
  }
}

// Jogo 2 - Jokenpô
void jogarJokenpo() {
  print('\n--- JOKENPÔ!!! (MELHOR DE TRÊS) ---');
  
  // Desafio 4 -> Variáveis de pontuação acumulativa
  int vitoriasJogador = 0;
  int vitoriasComputador = 0;

  // Desafio 6 -> Laço roda até alguém alcançar 3 vitórias
  while (vitoriasJogador < 3 && vitoriasComputador < 3) {
    print('\n--- Placar Atual ---');
    print('Você: $vitoriasJogador | Computador: $vitoriasComputador');
    
    print('Escolha sua jogada:');
    print('0 - Pedra');
    print('1 - Papel');
    print('2 - Tesoura');
    io.stdout.write('Digite o número da sua escolha: ');

    String? entrada = io.stdin.readLineSync();
    int? escolhaInt = int.tryParse(entrada ?? '');

    if (escolhaInt == null || escolhaInt < 0 || escolhaInt > 2) {
      print('⚠️ Escolha inválida! Digite 0, 1 ou 2.');
      continue;
    }

    // Desafio 5 -> Uso do Enum Jogada
    Jogada jogadaJogador = Jogada.values[escolhaInt];
    Jogada jogadaComputador = Jogada.values[Random().nextInt(3)];

    print('Você jogou: ${jogadaJogador.name}');
    print('O computador jogou: ${jogadaComputador.name}');

    // Lógica do jogo
    if (jogadaJogador == jogadaComputador) {
      print('🤝 Empate nesta rodada!');
    } else if (
      (jogadaJogador == Jogada.pedra && jogadaComputador == Jogada.tesoura) ||
      (jogadaJogador == Jogada.papel && jogadaComputador == Jogada.pedra) ||
      (jogadaJogador == Jogada.tesoura && jogadaComputador == Jogada.papel)
    ) {
      print('✨ Você venceu esta rodada!');
      vitoriasJogador++;
    } else {
      print('💻 O computador venceu esta rodada!');
      vitoriasComputador++;
    }
  }

  // Resultado final do Melhor de Três
  print('\n==============================');
  print('       FIM DO JOGO         ');
  print('Placar Final -> Você: $vitoriasJogador | Computador: $vitoriasComputador');
  if (vitoriasJogador == 3) {
    print('🏆 Parabéns! Você ganhou!');
  } else {
    print('😢 O computador venceu!');
  }
  print('==============================');
}