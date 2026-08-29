import 'dart:io';
import 'dart:math';

void main() {
  // Dicionário com chave sequencial (1 e 2) para armazenar os jogadores
  final Map<int, Map<String, dynamic>> jogadores = {};
  
  // Lista para armazenar o histórico de todas as batalhas
  final List<String> historicoBatalhas = [];

  print("=== THE BATTLE FRIENDS ===");
  print("=== REGISTRE OS SEUS LUTADORES ===");

  for (int i = 1; i <= 2; i++) {
    print("\n--- Jogador $i ---");
    
    stdout.write("Digite seu número da sorte: ");
    String id = stdin.readLineSync() ?? "";
    
    stdout.write("Digite o nome do seu lutador: ");
    String nome = stdin.readLineSync() ?? "";
    
    int forca = 0;
    int vida = 0;
    bool dadosValidos = false;

    while (!dadosValidos) {
      stdout.write("Digite a Força de seu lutador (mínimo 10 e máxima 50): ");
      forca = int.tryParse(stdin.readLineSync() ?? "") ?? 0;

      stdout.write("Digite a vida de seu lutador (mínimo 10 e máxima 50): ");
      vida = int.tryParse(stdin.readLineSync() ?? "") ?? 0;

      // TODO: Implementar as validações aqui (Mínimo de 10 cada e soma máxima de 100)
      int soma = forca + vida;

      if (forca >= 10 &&
          vida >= 10 &&
          forca <= 50 &&
          vida <= 50 &&
          soma <= 100) {
        print("Registro aceito, bom jogo!");
        dadosValidos = true;
      }
      else {
        print("Registo recusado, força e vida no minimo 10 e máxima 50");
      }

      // Se válido, definir dadosValidos = true; caso contrário, exibir mensagem de erro.
    }

    // TODO: Armazenar os dados do jogador atual no Map 'jogadores' usando a chave 'i'
    jogadores[i] = {
      "id": id,
      "nome": nome,
      "forca": forca,
      "vida": vida,
    };
  }

  print("\n=== QUE COMECE A BATALHA!!! ===");
  int turno = 1;
  final random = Random();

  // Variável para guardar o vencedor
  int? vencedor;

  // Loop principal do jogo
  while (true) {
    // TODO: Verificar se algum jogador perdeu (vida <= 0 ou forca <= 0). Se sim, quebrar o loop.
    bool jogador1Perdeu =
        jogadores[1]!["vida"] <= 0 || jogadores[1]!["forca"] <= 0;

    bool jogador2Perdeu =
        jogadores[2]!["vida"] <= 0 || jogadores[2]!["forca"] <= 0;

    if (jogador1Perdeu || jogador2Perdeu) {
      break;
    }

    // TODO: Sortear quem ataca (1 ou 2) e definir quem defende
    int atacante = random.nextInt(2) + 1;
    int defensor = atacante == 1 ? 2 : 1;

    // TODO: Sortear o valor da batalha (entre 5 e 20)
    int valorBatalha = random.nextInt(16) + 5;

    // TODO: Subtrair o valor da força do atacante e da vida do defensor
    jogadores[atacante]!["forca"] =
        (jogadores[atacante]!["forca"] - valorBatalha).clamp(0, 100);

    jogadores[defensor]!["vida"] =
        (jogadores[defensor]!["vida"] - valorBatalha).clamp(0, 100);

    // TODO: Montar uma String com o resumo do turno e adicionar na lista 'historicoBatalhas'
    String resumo =
        "Turno $turno: ${jogadores[atacante]!["nome"]} "
        "ataca ${jogadores[defensor]!["nome"]} "
        "causando $valorBatalha de dano. \n"
        "\nForça de ${jogadores[atacante]!["nome"]}: ${jogadores[atacante]!["forca"]}. "
        "\nVida de ${jogadores[defensor]!["nome"]}: ${jogadores[defensor]!["vida"]}.";

    print(resumo);

    // Adiciona ao histórico
    historicoBatalhas.add(resumo);

    // Verifica se o defensor perdeu
    bool defensorPerdeu =
        jogadores[defensor]!["vida"] <= 0 ||
        jogadores[defensor]!["forca"] <= 0;

    // Verifica se o atacante perdeu
    bool atacantePerdeu =
        jogadores[atacante]!["vida"] <= 0 ||
        jogadores[atacante]!["forca"] <= 0;

    // Se os dois perderam no mesmo turno, o defensor perde
    if (defensorPerdeu && atacantePerdeu) {
      vencedor = atacante;
      break;
    }

    // Se somente o defensor perdeu, o atacante vence
    if (defensorPerdeu) {
      vencedor = atacante;
      break;
    }

    // Se somente o atacante perdeu, o defensor vence
    if (atacantePerdeu) {
      vencedor = defensor;
      break;
    }

    turno++;
  }

  print("\n=== FIM DE JOGO ===");

  // TODO: Anunciar o vencedor 
  if (vencedor != null) {
    print("Vencedor: ${jogadores[vencedor]!["nome"]}");
  } else {
    print("Empate! Os dois jogadores perderam.");
  }

  print("\n=== RELATÓRIO FINAL DE BATALHAS ===");

  // TODO: Percorrer e imprimir a lista de históricos
  for (String batalha in historicoBatalhas) {
    print(batalha);
  }
}