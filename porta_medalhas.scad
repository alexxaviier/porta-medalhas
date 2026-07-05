// =========================================================
// PORTA MEDALHAS PLACA HEXAGONAL - REPLICANTE MANDALA REAL
// Ajustado especificamente para as 4 medalhas com encaixe quebra-cabeça
// =========================================================

$fn = 100; // Resolução máxima para curvas e encaixes perfeitos

// Dimensões do Painel Geral (Baseado no infográfico)
LARGURA = 250;
ALTURA = 230;
ESPESSURA = 7; // Ligeiramente mais espessa para acomodar o peso do metal

// Dimensões do Alojamento da Mandala de Medalhas
DIAMETRO_MANDALA = 155; // Diâmetro total das 4 medalhas unidas com folga de tolerância
REBAIXO_MEDALHA = 3.5;  // Profundidade para as medalhas assentarem firmes

difference() {
    // -------------------------------------------------------
    // 1. CORPO CENTRAL MACIÇO (HEXÁGONO COM CANTOS SUAVES)
    // -------------------------------------------------------
    minkowski() {
        cylinder(h=ESPESSURA - 1, r=LARGURA/2 - 5, $fn=6, center=true);
        cylinder(h=1, r=5, center=true); // Suaviza as quinas externas
    }

    // -------------------------------------------------------
    // 2. BERÇO DE ASSENTAMENTO DA MANDALA (REBAIXO CIRCULAR)
    // -------------------------------------------------------
    // Cria o rebaixo liso onde o corpo das 4 medalhas unidas vai descansar
    translate([0, 0, ESPESSURA/2 - REBAIXO_MEDALHA/2 + 0.1])
        cylinder(h=REBAIXO_MEDALHA + 0.2, r=DIAMETRO_MANDALA/2, center=true);

    // -------------------------------------------------------
    // 3. ABERTURA EM CRUZ VAZADA (PARA AS FITAS E PASSADORES)
    // -------------------------------------------------------
    // Rasgos que atravessam a peça por completo (vazados) permitindo que
    // as alças e fitas de cada uma das 4 medalhas passem para a parte de trás da placa
    
    // Canal Vertical Vazado (Eixo Y)
    cube([42, ALTURA - 30, ESPESSURA + 4], center=true);
    
    // Canal Horizontal Vazado (Eixo X)
    cube([LARGURA - 30, 42, ESPESSURA + 4], center=true);

    // 4. DETALHES DE ALÍVIO SIMÉTRICOS NA BORDA INFERIOR
    translate([-35, -ALTURA/2 + 15, ESPESSURA/2 - 1])
        cube([16, 20, 4], center=true);
    translate([35, -ALTURA/2 + 15, ESPESSURA/2 - 1])
        cube([16, 20, 4], center=true);

    // -------------------------------------------------------
    // 5. OS 5 PARAFUSOS DE FIXAÇÃO (FUROS ESCAREADOS)
    // -------------------------------------------------------
    // Topo Esquerda e Direita
    translate([-45, ALTURA/2 - 20, 0]) usinar_furo_parede();
    translate([45, ALTURA/2 - 20, 0]) usinar_furo_parede();
    
    // Laterais Centro Esquerda e Direita
    translate([-LARGURA/2 + 22, 18, 0]) usinar_furo_parede();
    translate([LARGURA/2 - 22, 18, 0]) usinar_furo_parede();
    
    // Base Central
    translate([0, -ALTURA/2 + 20, 0]) usinar_furo_parede();
}

// -------------------------------------------------------
// 6. PAREDES DE RETENÇÃO DA TRAVA CENTRAL (BAIONETA)
// -------------------------------------------------------
// Como o centro foi vazado para as fitas, recriamos o pino da baioneta central 
// fixado por pequenas pontes estruturais ocultas abaixo do nível da medalha
difference() {
    union() {
        // Bloco central suspenso
        cylinder(h=ESPESSURA - REBAIXO_MEDALHA, r=16, center=true);
        // Pontes de fixação em X que se fundem na parede interna do rebaixo
        rotate([0, 0, 45]) cube([DIAMETRO_MANDALA - 2, 8, ESPESSURA - REBAIXO_MEDALHA], center=true);
    }
    
    // Furo central e as ranhuras da trava giratória (Abaixa 20 graus)
    cylinder(h=ESPESSURA + 4, r=6, center=true);
    for(angulo = [0 : 90 : 270]) {
        rotate([0, 0, angulo])
            translate([6, 0, 0])
                cube([4, 4, ESPESSURA + 4], center=true);
    }
}

// -----------------------------------------------------------
// SUB-ROTINA: CRIAÇÃO DO FURO TÉCNICO ESCAREADO
// -----------------------------------------------------------
module usinar_furo_parede() {
    cylinder(h=ESPESSURA + 4, r=2.5, center=true); // Furo do parafuso M4/M5
    translate([0, 0, ESPESSURA/2 - 1.5])
        cylinder(h=4, r=5.5, center=true); // Rebaixo para embutir a cabeça do parafuso
}
