// =========================================================
// PORTA MEDALHAS COLMEIA - MANDALA CENTRAL "VEM PRA RUA"
// Réplica exata: Moldura hexagonal com fundo mini-colmeia
// =========================================================

$fn = 60; // Alta resolução para os círculos e encaixes

// Dimensões da Peça Final
LARGURA = 250;
ALTURA = 230;
ESPESSURA_MOLDURA = 8;
ESPESSURA_GRADE = 3.5; // Fundo mais fino para destacar as medalhas

// Diâmetro da Mandala Central (União das 4 medalhas + folga)
DIAMETRO_MANDALA = 145; 
RAIO_MANDALA = DIAMETRO_MANDALA / 2;

// Parâmetros da Grade Interna (Mini-colmeias)
RAIO_MINI_HEX = 8;
PAREDE_MINI_HEX = 1.8;
PASSO_X = RAIO_MINI_HEX * 1.73205;
PASSO_Y = RAIO_MINI_HEX * 1.5;

difference() {
    // -------------------------------------------------------
    // 1. CORPO PRINCIPAL (MOLDURA + GRADE DE FUNDO)
    // -------------------------------------------------------
    union() {
        // Moldura Hexagonal Externa Sólida
        cylinder(h=ESPESSURA_MOLDURA, r=LARGURA/2, $fn=6, center=true);
    }

    // -------------------------------------------------------
    // 2. CORTE DO REBAIXO PARA GERAR A MOLDURA GROSSA EXTERNA
    // -------------------------------------------------------
    translate([0, 0, ESPESSURA_GRADE/2 + 0.1])
        cylinder(h=ESPESSURA_MOLDURA, r=LARGURA/2 - 12, $fn=6, center=true);

    // -------------------------------------------------------
    // 3. PERFURAÇÃO DA GRADE ESTILO COLMEIA DE FUNDO
    // -------------------------------------------------------
    // Cria os furos sextavados apenas na área interna da grade
    for (x = [-LARGURA/2 : PASSO_X : LARGURA/2]) {
        for (y = [-ALTURA/2 : PASSO_Y : ALTURA/2]) {
            
            // Coluna Normal
            translate([x, y, 0])
                cylinder(h=ESPESSURA_MOLDURA + 2, r=RAIO_MINI_HEX - PAREDE_MINI_HEX, $fn=6, center=true);
            
            // Coluna Intercalada
            translate([x + PASSO_X/2, y + PASSO_Y/2, 0])
                cylinder(h=ESPESSURA_MOLDURA + 2, r=RAIO_MINI_HEX - PAREDE_MINI_HEX, $fn=6, center=true);
        }
    }
}

// -----------------------------------------------------------
// 4. ADIÇÃO DOS ENCAIXES E APONTAMENTOS CENTRALIZADOS
// -----------------------------------------------------------
// Adiciona os blocos sólidos centrais onde as medalhas e fitas apoiam
difference() {
    union() {
        // Anel central de suporte para o assentamento das medalhas
        difference() {
            cylinder(h=ESPESSURA_MOLDURA, r=RAIO_MANDALA + 3, center=true);
            cylinder(h=ESPESSURA_MOLDURA + 2, r=RAIO_MANDALA - 4, center=true);
        }
        
        // Eixo Sólido Central para o mecanismo da Baioneta
        cylinder(h=ESPESSURA_MOLDURA, r=16, center=true);
        
        // Guias verticais para passagem das fitas superiores e inferiores
        translate([0, 0, 0]) cube([35, ALTURA - 20, ESPESSURA_MOLDURA], center=true);
        
        // Abas de fixação para parafusos nas pontas laterais da moldura
        translate([-LARGURA/2 + 15, 0, 0]) cylinder(h=ESPESSURA_MOLDURA, r=12, center=true);
        translate([LARGURA/2 - 15, 0, 0]) cylinder(h=ESPESSURA_MOLDURA, r=12, center=true);
        translate([0, -ALTURA/2 + 12, 0]) cylinder(h=ESPESSURA_MOLDURA, r=12, center=true);
    }

    // Usinagem do Furo Central da Trava Baioneta (Com as rampas internas)
    cylinder(h=ESPESSURA_MOLDURA + 2, r=6.5, center=true);
    for(a = [0 : 90 : 270]) {
        rotate([0, 0, a])
            translate([6.5, 0, 0])
                cube([4, 5, ESPESSURA_MOLDURA + 2], center=true);
    }
    
    // Furos escareados de fixação na parede (2 nas laterais, 1 embaixo)
    translate([-LARGURA/2 + 15, 0, 0]) cylinder(h=ESPESSURA_MOLDURA + 2, r=2.5, center=true);
    translate([LARGURA/2 - 15, 0, 0]) cylinder(h=ESPESSURA_MOLDURA + 2, r=2.5, center=true);
    translate([0, -ALTURA/2 + 12, 0]) cylinder(h=ESPESSURA_MOLDURA + 2, r=2.5, center=true);
    
    // Recorte vazado interno para passagem das fitas de cetim
    translate([-16, 0, 0]) cube([6, ALTURA - 40, ESPESSURA_MOLDURA + 2], center=true);
    translate([16, 0, 0]) cube([6, ALTURA - 40, ESPESSURA_MOLDURA + 2], center=true);
    
    // Ajuste de Limite das Bordas Externas
    difference() {
        cube([LARGURA + 100, ALTURA + 100, ESPESSURA_MOLDURA + 5], center=true);
        cylinder(h=ESPESSURA_MOLDURA + 10, r=LARGURA/2, $fn=6, center=true);
    }
}
