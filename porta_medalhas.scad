// =========================================================
// PORTA MEDALHAS COLMEIA - PROJETO FINAL OFICIAL "VEM PRA RUA"
// Proporções, Textos 3D e Estrutura de Colmeia Corrigidos
// =========================================================

$fn = 60;

// Dimensões Globais da Placa
LARGURA = 250;
ALTURA = 230;
ESPESSURA = 6;
REBAIXO_MEDALHA = 3;

// Configuração dos Módulos Hexagonais (Ajustados para diâmetro interno padrão de medalha)
RAIO_HEX = 42; 
PAREDE = 4;
RAIO_INT = RAIO_HEX - PAREDE;

// Distâncias matemáticas precisas para os hexágonos se conectarem mantendo as paredes vazadas
DIST_X = RAIO_HEX * 1.73205; 
DIST_Y = RAIO_HEX * 1.5;

difference() {
    // -------------------------------------------------------
    // 1. CORPO DA COLMEIA E ABAS LATERAIS
    // -------------------------------------------------------
    union() {
        // Os 4 Nichos Principais em formato de Colmeia/Losango
        translate([0, DIST_Y, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true); // Superior
        translate([0, -DIST_Y, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true); // Inferior
        translate([-DIST_X/2, 0, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true); // Esquerdo
        translate([DIST_X/2, 0, 0]) cylinder(h=ESPESSURA, r=RAIO_HEX, $fn=6, center=true); // Direito
        
        // Extensões para os Selos de Identificação (Ipojuca) nas extremidades
        translate([-DIST_X/2 - 32, 0, 0]) cube([16, 70, ESPESSURA], center=true);
        translate([DIST_X/2 + 32, 0, 0]) cube([16, 70, ESPESSURA], center=true);
        
        // Conexões extras / Abas de Encaixe Macho (Lado Esquerdo)
        translate([-DIST_X/2 - 38, 20, 0]) cube([6, 12, ESPESSURA], center=true);
        translate([-DIST_X/2 - 38, -20, 0]) cube([6, 12, ESPESSURA], center=true);
        
        // -------------------------------------------------------
        // ADIÇÃO DE TEXTOS EM ALTO-RELEVO (Projetados para fora da peça)
        // -------------------------------------------------------
        // Texto Superior Principal
        translate([0, DIST_Y + 16, ESPESSURA/2]) 
            linear_extrude(height = 1.5)
                text("VEM PRA RUA", size = 6, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        
        translate([0, DIST_Y + 6, ESPESSURA/2]) 
            linear_extrude(height = 1.5)
                text("2026", size = 5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");

        // Identificadores de Etapas em cada nicho
        translate([0, DIST_Y - 14, ESPESSURA/2 - REBAIXO_MEDALHA]) 
            linear_extrude(height = 1.0) text("ETAPA 3", size = 3.5, halign = "center");
            
        translate([0, -DIST_Y - 14, ESPESSURA/2 - REBAIXO_MEDALHA]) 
            linear_extrude(height = 1.0) text("ETAPA 2", size = 3.5, halign = "center");

        translate([-DIST_X/2, -14, ESPESSURA/2 - REBAIXO_MEDALHA]) 
            linear_extrude(height = 1.0) text("ETAPA 1", size = 3.5, halign = "center");

        translate([DIST_X/2, -14, ESPESSURA/2 - REBAIXO_MEDALHA]) 
            linear_extrude(height = 1.0) text("ETAPA 4", size = 3.5, halign = "center");
    }

    // -------------------------------------------------------
    // 2. USINAGEM DOS REBAIXOS E SISTEMAS DE TRAVA
    // -------------------------------------------------------
    translate([0, DIST_Y, 0]) usinar_nicho_completo();
    translate([0, -DIST_Y, 0]) usinar_nicho_completo();
    translate([-DIST_X/2, 0, 0]) usinar_nicho_completo();
    translate([DIST_X/2, 0, 0]) usinar_nicho_completo();

    // Cavidades Fêmea das Travas Laterais (Lado Direito)
    translate([DIST_X/2 + 38, 20, 0]) cube([6.4, 12.4, ESPESSURA + 2], center=true);
    translate([DIST_X/2 + 38, -20, 0]) cube([6.4, 12.4, ESPESSURA + 2], center=true);

    // 3. LIMITADOR DE ÁREA TÉCNICA (Corte do tamanho máximo permitido na mesa)
    difference() {
        cube([LARGURA + 100, ALTURA + 100, ESPESSURA + 5], center=true);
        cube([LARGURA, ALTURA, ESPESSURA + 10], center=true);
    }
}

// -----------------------------------------------------------
// SUB-ROTINA: CRIA O ALOJAMENTO DA MEDALHA, BAIONETA E ABAS
// -----------------------------------------------------------
module usinar_nicho_completo() {
    // Rebaixo Sextavado Interno da Medalha (Fundo Liso)
    translate([0, 0, ESPESSURA/2 - REBAIXO_MEDALHA/2 + 0.05])
        cylinder(h=REBAIXO_MEDALHA + 0.1, r=RAIO_INT, $fn=6, center=true);
    
    // Furo Central Baioneta (Eixo cilíndrico limpo com travas)
    cylinder(h=ESPESSURA + 2, r=5.5, center=true);
    for(a = [0 : 90 : 270]) {
        rotate([0, 0, a])
            translate([5.5, 0, 0])
                cube([4, 4, ESPESSURA + 2], center=true);
    }
    
    // Suporte Superior (Orelha de Cima)
    translate([0, RAIO_INT - 6, 0])
        cube([14, 5, ESPESSURA + 2], center=true);
        
    // Suporte Inferior Flexível (Orelha de Baixo)
    translate([0, -(RAIO_INT - 6), 0]) {
        cube([14, 5, ESPESSURA + 2], center=true);
        // Canal milimetrado periférico para criar o efeito mola/clique do PLA
        translate([-12, 3, 0]) cube([2, 8, ESPESSURA + 2], center=true);
        translate([12, 3, 0]) cube([2, 8, ESPESSURA + 2], center=true);
    }
}
