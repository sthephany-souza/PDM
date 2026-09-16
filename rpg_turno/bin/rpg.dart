import 'dart:math';

// Classe Base para qualquer Entidade do Jogo
class Personagem {
  String nome;

  int _vida; // Atributo privado (encapsulado)
  int forca;

  Personagem(this.nome, this._vida, this.forca);

  // Getter para ler a vida com segurança
  int get vida => _vida;

  // Setter para alterar a vida com segurança (usado na cura)
  set vida(int novaVida) {
    _vida = novaVida;
  }

  // Método de ação que altera o estado de outro objeto
  void atacar(Personagem oponente) {
    print("$nome ataca ${oponente.nome}!");

    oponente.receberDano(forca);
  }

  void receberDano(int quantidade) {
    _vida -= quantidade;

    if (_vida < 0) _vida = 0;
    print("$nome recebeu $quantidade de dano. Vida restante: $_vida");
  }

  bool estaVivo() => _vida > 0;
}

// 1. Sistema de Inventário
class Item {
  String nome;
  int bonusAtaque;

  Item(this.nome, this.bonusAtaque);
}

// 2. Sistema de Magias (Classes Abstratas e Polimorfismo)
abstract class Magia {
  String nome;

  Magia(this.nome);

  void conjurar(Personagem lancador, Personagem alvo);
}

class BolaDeFogo extends Magia {
  BolaDeFogo() : super("Bola de Fogo");

  @override
  void conjurar(Personagem lancador, Personagem alvo) {
    print("🔥 ${lancador.nome} conjura BolaDeFogo contra ${alvo.nome}!");

    alvo.receberDano(30);
  }
}

class LuzCurativa extends Magia {
  LuzCurativa() : super("Luz Curativa");

  @override
  void conjurar(Personagem lancador, Personagem alvo) {
    print("✨ ${lancador.nome} conjura LuzCurativa em si mesmo!");

    lancador.vida += 25;
    print("${lancador.nome} recuperou 25 de vida! Vida atual: ${lancador.vida}");
  }
}

// 3. Criar o Herói Avançado (Herança e Listas)
class HeroiAvancado extends Personagem {
  List<Item> inventario = [];

  Magia? magiaEquipada;
  int experiencia = 0;

  HeroiAvancado(String nome, int vida, int forca) : super(nome, vida, forca);

  void coletarItem(Item item) {
    inventario.add(item);

    print("🎒 ${nome} coletou o item: ${item.nome} (Bônus de Ataque: +${item.bonusAtaque})");
  }

  void equiparMagia(Magia novaMagia) {
    magiaEquipada = novaMagia;

    print("🔮 ${nome} equipou a magia: ${novaMagia.nome}");
  }

  void ganharExperiencia(int quantidade) {
    experiencia += quantidade;

    print("⭐ ${nome} ganhou $quantidade pontos de experiência (Total: $experiencia/50)");

    if (experiencia > 50) {
      print("🎉 LEVEL UP! ${nome} ficou mais forte!");

      forca += 10;
      experiencia = 0;
    }
  }

  @override
  void atacar(Personagem oponente) {
    int danoTotal = forca;

    if (inventario.isNotEmpty) {
      danoTotal += inventario.first.bonusAtaque;

      print("⚔️ ${nome} ataca ${oponente.nome} usando a arma ${inventario.first.nome}!");
    } else {
      print("⚔️ ${nome} ataca ${oponente.nome} com os punhos!");
    }

    oponente.receberDano(danoTotal);
  }
}

// 4. O Teste Final (Método main)
void main() {
  var heroi = HeroiAvancado("Ragnar", 80, 12);
  var orc = Personagem("Aron", 90, 9);

  print("⚔️ UMA CRUEL BATALHA SE INICIA! ⚔️\n");

  List<Item> itensPossiveis = [
    Item("Espada Longa", 8),
    Item("Machado de Batalha", 8),
    Item("Adaga Envenenada", 4)
  ];

  List<Magia> magiasPossiveis = [
    BolaDeFogo(),
    LuzCurativa()
  ];

  while (heroi.estaVivo() && orc.estaVivo()) {
    // Sorteia a ação: 0 = Coletar Item, 1 = Obter Magia, 2 = Desferir Ataque
    int acaoSorteada = Random().nextInt(3);

    if (acaoSorteada == 0) {
      var itemSorteado = itensPossiveis[Random().nextInt(itensPossiveis.length)];

      heroi.coletarItem(itemSorteado);
    } else if (acaoSorteada == 1) {
      var magiaSorteada = magiasPossiveis[Random().nextInt(magiasPossiveis.length)];

      heroi.equiparMagia(magiaSorteada);
    } else {
      if (heroi.magiaEquipada != null) {
        heroi.magiaEquipada!.conjurar(heroi, orc);
        heroi.magiaEquipada = null; // A magia é consumida após o uso
      } else {
        heroi.atacar(orc);
      }
    }

    if (!orc.estaVivo()) break;

    print("-" * 30);

    // O orc contra-ataca
    orc.atacar(heroi);
    
    // A cada turno o herói ganha 10 pontos de experiência
    heroi.ganharExperiencia(10);

    print("=" * 30);
  }

  // Verificação do estado final
  print("\n🏆 FIM DA BATALHA!");
  if (heroi.estaVivo()) {
    print("${heroi.nome} derrotou Aron! Saúdem o herói!");
  } else {
    print("Aron derrotou ${heroi.nome}! Mais sorte na póxima, herói!");
  }
}