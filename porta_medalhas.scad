// =========================================================
// PORTA MEDALHAS COLMEIA - PROJETO OFICIAL "VEM PRA RUA"
// Réplica exata baseada nas especificações técnicas da imagem
// =========================================================

$fn = 60; // Alta resolução para os encaixes de impressão 3D

// Dimensões Globais
LARGURA = 250;
ALTURA = 230;
ESPESSURA = 6;
REBAIXO_MEDALHA = 3;

// Dimensões do Módulo Hexagonal Principal
RAIO_HEX = 45; // Tamanho proporcional para abrigar as medalhas e somar 250mm
PAREDE = 4;
RAIO_INT = RAIO_HEX - PAREDE;

// Posições calculadas para o encaixe perfeito dos 4 hexágonos principais
DIST_X = RAIO_HEX * 1.5;
DIST_Y = RAIO_HEX * sqrt(3) / 2;

difference() {
    // -------------------------------------------------------
    // 1. CORPO SÓLIDO DO PORTA-MEDALHAS (Formato de Colmeia Fechada)
    // -------------------------------------------------------
    union() {
        // Hexágono Central Esquerdo
        translate([-DIST_X/2, 0, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true);
        // Hexágono Central Direito
        translate([DIST_X/2, 0, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true);
        // Hexágono Superior Centro
        translate([0, DIST_Y, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true);
        // Hexágono Inferior Centro
        translate([0, -DIST_Y, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true);
        
        // Módulos de Extensão Laterais (Suportes Verticais Logotipo Ipojuca)
        translate([-DIST_X - 10, 0, 0]) cube([25, 80, ESPESSURA], center=true);
        translate([DIST_X + 10, 0, 0]) cube([25, 80, ESPESSURA], center=true);
        
        // Abas Laterais de Conexão Mecânica (Travas Ocultas Macho)
        translate([-DIST_X - 22, 20, 0]) cube([8, 15, ESPESSURA], center=true);
        translate([-DIST_X - 22, -20, 0]) cube([8, 15, ESPESSURA], center=true);
    }

    // -------------------------------------------------------
    // 2. DETALHAMENTO DE CADA UM DOS 4 NICHOS DE MEDALHA
    // -------------------------------------------------------
    // Nicho Esquerdo
    translate([-DIST_X/2, 0, 0]) usinar_nicho_medalha();
    // Nicho Direito
    translate([DIST_X/2, 0, 0]) usinar_nicho_medalha();
    // Nicho Superior
    translate([0, DIST_Y, 0]) usinar_nicho_medalha();
    // Nicho Inferior
    translate([0, -DIST_Y, 0]) usinar_nicho_medalha();

    // -------------------------------------------------------
    // 3. ENCAIXES FÊMEA PARA TRAVAS LATERAIS (Conexão de outras placas)
    // -------------------------------------------------------
    translate([DIST_X + 22, 20, 0]) cube([8.4, 15.4, ESPESSURA + 2], center=true);
    translate([DIST_X + 22, -20, 0]) cube([8.4, 15.4, ESPESSURA + 2], center=true);

    // -------------------------------------------------------
    // 4. LIMITADOR DE ÁREA DE IMPRESSÃO (Força o limite técnico de 250x230mm)
    // -------------------------------------------------------
    difference() {
        cube([LARGURA + 100, ALTURA + 100, ESPESSURA + 5], center=true);
        cube([LARGURA, ALTURA, ESPESSURA + 10], center=true);
    }
}

// -----------------------------------------------------------
// MACRO TÉCNICA: DETALHES INTERNOS DE FIXAÇÃO E TRAVAMENTO
// -----------------------------------------------------------
module usinar_nicho_medalha() {
    // A. Rebaixo Sextavado da Medalha (Profundidade de 3mm)
    translate([0, 0, ESPESSURA/2 - REBAIXO_MEDALHA/2 + 0.05])
        cylinder(h=REBAIXO_MEDALHA + 0.1, r=RAIO_INT, $fn=6, center=true);
    
    // B. Trava Central Tipo Baioneta (Furo de 12mm com canais radiais para rotação de 20°)
    cylinder(h=ESPESSURA + 2, r=6, center=true);
    for(angulo = [0 : 90 : 270]) {
        rotate([0, 0, angulo])
            translate([6, 0, 0])
                cube([6, 5, ESPESSURA + 2], center=true);
    }
    
    // C. Suporte da Orelha Superior (Encaixe guia retangular)
    translate([0, RAIO_INT - 8, 0]) {
        cube([22, 6, ESPESSURA + 2], center=true); // Canal de entrada
        translate([0, -2, -ESPESSURA/4]) cube([26, 10, ESPESSURA/2], center=true); // Rampa interna de travamento
    }
        
    // D. Suporte da Orelha Inferior (Canal com folga flexível para travamento por clique)
    translate([0, -(RAIO_INT - 8), 0]) {
        cube([22, 6, ESPESSURA + 2], center=true);
        // Recorte lateral que cria o "efeito mola" da trava inferior flexível
        translate([-15, 2, 0]) cube([4, 10, ESPESSURA + 2], center=true);
        translate([15, 2, 0]) cube([4, 10, ESPESSURA + 2], center=true);
    }
}
