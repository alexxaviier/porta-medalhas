// ==========================================
// PORTA MEDALHAS COLMEIA - VEM PRA RUA 2026
// Parametros baseados no desenho tecnico
// ==========================================

$fn = 60; // Qualidade das curvas

// Dimensoes da placa principal
largura_total = 250;
altura_total = 230;
espessura_modulo = 6;
profundidade_rebaixo = 3;

// Dimensoes das colmeias individuais (modulos hexagonais)
raio_modulo = 24; 
espessura_parede = 3.5;

// --- MODULO BASE HEXAGONAL ---
module modulo_hexagonal() {
    difference() {
        // Hexagono externo solido
        cylinder(h=espessura_modulo, r=raio_modulo, $fn=6, center=true);
        
        // Rebaixo da medalha (3mm de profundidade)
        translate([0, 0, espessura_modulo/2 - profundidade_rebaixo/2 + 0.1])
            cylinder(h=profundidade_rebaixo + 0.2, r=raio_modulo - espessura_parede, $fn=6, center=true);
    }
}

// --- DETALHE DO ENCAIXE / TRAVA DA ORELHA ---
module cavidade_trava_orelha() {
    // Canal guia para a orelha da medalha entrar e travar
    translate([0, raio_modulo - 6, 0]) {
        // Encaixe da orelha (Abertura retangular)
        cube([12, 6, espessura_modulo + 2], center=true);
        // Rebaixo interno para fixar a aba da orelha
        translate([0, -2, -espessura_modulo/4])
            cube([16, 8, espessura_modulo/2], center=true);
    }
}

// --- TRAVA CENTRAL (TIPO BAIONETA) ---
module furo_trava_baioneta() {
    // Furo central com folga de 0.3mm para a tampa giratoria de 20 graus
    cylinder(h=espessura_modulo + 2, r=6, center=true);
    // As 4 abas internas de travamento (sistema de rampa)
    for(a = [0 : 90 : 270]) {
        rotate([0, 0, a])
            translate([4, 0, 0])
                cube([4, 6, espessura_modulo + 2], center=true);
    }
}

// --- COMPOSICAO DO PAINEL COMPLETO ---
difference() {
    // Uniao e posicionamento dos modulos hexagonais interconectados
    union() {
        // Gera a malha geometrica aproximando as dimensoes da mesa de impressao
        for (x = [-largura_total/2 + 25 : raio_modulo * 1.5 : largura_total/2 - 25]) {
            for (y = [-altura_total/2 + 25 : raio_modulo * 1.732 : altura_total/2 - 25]) {
                
                // Coluna Par
                translate([x, y, 0])
                    modulo_hexagonal();
                
                // Coluna Impar (Deslocada para encaixe perfeito da colmeia)
                translate([x + (raio_modulo * 1.5)/2, y + (raio_modulo * 1.732)/2, 0])
                    modulo_hexagonal();
            }
        }
    }
    
    // Aplicacao dos furos funcionais (Trava central e Encaixes de orelha) em cada celula
    for (x = [-largura_total/2 + 25 : raio_modulo * 1.5 : largura_total/2 - 25]) {
        for (y = [-altura_total/2 + 25 : raio_modulo * 1.732 : altura_total/2 - 25]) {
            
            // Furos da Coluna Par
            translate([x, y, 0]) {
                furo_trava_baioneta();
                cavidade_trava_orelha(); // Suporte Superior
                rotate([0,0,180]) cavidade_trava_orelha(); // Suporte Inferior
            }
            
            // Furos da Coluna Impar
            translate([x + (raio_modulo * 1.5)/2, y + (raio_modulo * 1.732)/2, 0]) {
                furo_trava_baioneta();
                cavidade_trava_orelha();
                rotate([0,0,180]) cavidade_trava_orelha();
            }
        }
    }
    
    // Corte delimitador externo para garantir o tamanho exato de 250x230mm
    difference() {
        cube([largura_total + 100, altura_total + 100, espessura_modulo + 5], center=true);
        cube([largura_total, altura_total, espessura_modulo + 10], center=true);
    }
}
