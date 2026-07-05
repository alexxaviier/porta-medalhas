// =========================================================
// PORTA MEDALHAS PLACA HEXAGONAL - VERSÃO DEFINITIVA REAL
// Réplica exata baseada na imagem: Painel maciço com canais
// =========================================================

$fn = 80; // Alta resolução para os cantos arredondados e círculos

// Dimensões Técnicas Principais
LARGURA = 250;
ALTURA = 230;
ESPESSURA = 6;

// Profundidade das trilhas e canais esculpidos
PROFUNDIDADE_CANAL = 2.5;

// Configuração dos Canais em Cruz
LARGURA_CANAL_VERT = 38;
LARGURA_CANAL_HORIZ = 30;

difference() {
    // -------------------------------------------------------
    // 1. CORPO HEXAGONAL MACIÇO PRINCIPAL (CANTOS SUAVES)
    // -------------------------------------------------------
    minkowski() {
        cylinder(h=ESPESSURA - 1, r=LARGURA/2 - 4, $fn=6, center=true);
        cylinder(h=1, r=4, center=true); // Arredonda as quinas externas do hexágono
    }

    // -------------------------------------------------------
    // 2. ESCULPINDO OS CANAIS E REBAIXOS GEOMÉTRICOS (SUBTRAÇÃO)
    // -------------------------------------------------------
    
    // A. Rebaixo Circular Central
    translate([0, 0, ESPESSURA/2 - PROFUNDIDADE_CANAL/2 + 0.1])
        cylinder(h=PROFUNDIDADE_CANAL, r=46, center=true);

    // B. Canal Retangular Vertical (Eixo Y)
    translate([0, 0, ESPESSURA/2 - PROFUNDIDADE_CANAL/2 + 0.1])
        cube([LARGURA_CANAL_VERT, ALTURA + 10, PROFUNDIDADE_CANAL], center=true);

    // C. Canal Retangular Horizontal (Eixo X)
    translate([0, 0, ESPESSURA/2 - PROFUNDIDADE_CANAL/2 + 0.1])
        cube([LARGURA + 10, LARGURA_CANAL_HORIZ, PROFUNDIDADE_CANAL], center=true);

    // D. Detalhes de Alívio/Rebaixo na Borda Inferior (Guias simétricas da base)
    translate([-32, -ALTURA/2 + 15, ESPESSURA/2 - PROFUNDIDADE_CANAL/2 + 0.1])
        cube([14, 20, PROFUNDIDADE_CANAL], center=true);
    translate([32, -ALTURA/2 + 15, ESPESSURA/2 - PROFUNDIDADE_CANAL/2 + 0.1])
        cube([14, 20, PROFUNDIDADE_CANAL], center=true);

    // -------------------------------------------------------
    // 3. FURAÇÃO TÉCNICA DE FIXAÇÃO (OS 5 OLHAIS INTERNOS)
    // -------------------------------------------------------
    // Furos do Topo (Esquerda e Direita)
    translate([-42, ALTURA/2 - 18, 0]) usinar_furo_fixacao();
    translate([42, ALTURA/2 - 18, 0]) usinar_furo_fixacao();
    
    // Furos do Meio (Esquerda e Direita nas quinas)
    translate([-LARGURA/2 + 20, 18, 0]) usinar_furo_fixacao();
    translate([LARGURA/2 - 20, 18, 0]) usinar_furo_fixacao();
    
    // Furo da Base Central
    translate([0, -ALTURA/2 + 18, 0]) usinar_furo_fixacao();
}

// -------------------------------------------------------
// 4. ADIÇÃO DO TEXTO EM ALTO-RELEVO CENTRALIZADO
// -------------------------------------------------------
// O texto nasce do fundo do rebaixo circular e sobe até a altura da superfície
translate([0, 8, -ESPESSURA/2 + (ESPESSURA - PROFUNDIDADE_CANAL)]) {
    linear_extrude(height = PROFUNDIDADE_CANAL + 0.8) {
        text("VEM", size = 15, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
}
translate([0, -10, -ESPESSURA/2 + (ESPESSURA - PROFUNDIDADE_CANAL)]) {
    linear_extrude(height = PROFUNDIDADE_CANAL + 0.8) {
        text("PRA", size = 15, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
}
translate([0, -28, -ESPESSURA/2 + (ESPESSURA - PROFUNDIDADE_CANAL)]) {
    linear_extrude(height = PROFUNDIDADE_CANAL + 0.8) {
        text("RUA", size = 15, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
}

// -----------------------------------------------------------
// SUB-ROTINA TÉCNICA: FURO ESCAREADO COM ANEL DE REFORÇO
// -----------------------------------------------------------
module usinar_furo_fixacao() {
    // Furo central para o parafuso (3mm)
    cylinder(h=ESPESSURA + 4, r=2.5, center=true);
    // Rebaixo superior para esconder a cabeça do parafuso/soquete
    translate([0, 0, ESPESSURA/2 - 1.5])
        cylinder(h=4, r=5.5, center=true);
}
