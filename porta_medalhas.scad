// ==========================================
// PORTA MEDALHAS COLMEIA - VERSAO LIMPA 2026
// Conforme especificacoes do painel original
// ==========================================

$fn = 50; // Qualidade dos circulos

// Dimensoes maximas da placa externa
largura_total = 250;
altura_total = 230;
espessura_total = 6;
profundidade_rebaixo = 3;

// Dimensoes geometricas do hexagono (colmeia)
raio_externo = 23.5; 
espessura_parede = 3.5;
raio_interno = raio_externo - espessura_parede;

// Fatores de deslocamento matematico para encaixe perfeito da colmeia
passo_x = raio_externo * 1.5;
passo_y = raio_externo * sqrt(3);

difference() {
    // 1. GERACAO DA MALHA DE COLMEIAS UNIDAS
    union() {
        for (x = [-largura_total/2 : passo_x : largura_total/2]) {
            for (y = [-altura_total/2 : passo_y : altura_total/2]) {
                
                // Colunas normais
                translate([x, y, 0])
                    cylinder(h=espessura_total, r=raio_externo, $fn=6, center=true);
                
                // Colunas intercaladas
                translate([x + passo_x/2, y + passo_y/2, 0])
                    cylinder(h=espessura_total, r=raio_externo, $fn=6, center=true);
            }
        }
    }

    // 2. APLICACAO DOS REBAIXOS E ENCAIXES EM CADA CELULA
    for (x = [-largura_total/2 : passo_x : largura_total/2]) {
        for (y = [-altura_total/2 : passo_y : altura_total/2]) {
            
            // Furos nas celulas normais
            translate([x, y, 0])
                desenhar_detalhes_celula();
            
            // Furos nas celulas intercaladas
            translate([x + passo_x/2, y + passo_y/2, 0])
                desenhar_detalhes_celula();
        }
    }

    // 3. CORTE DELIMITADOR DAS BORDAS (Garante o tamanho maximo na mesa)
    difference() {
        cube([largura_total + 100, altura_total + 100, espessura_total + 5], center=true);
        cube([largura_total, altura_total, espessura_total + 10], center=true);
    }
}

// MACRO PARA DESENHAR CADA ELEMENTO DA MEDALHA SEM REPETICOES INUTEIS
module desenhar_detalhes_celula() {
    // A. Rebaixo Sextavado Principal (Onde a medalha assenta)
    translate([0, 0, espessura_total/2 - profundidade_rebaixo/2 + 0.05])
        cylinder(h=profundidade_rebaixo + 0.1, r=raio_interno, $fn=6, center=true);
    
    // B. Furo Central Limpo (Para o eixo da trava baioneta)
    cylinder(h=espessura_total + 2, r=4.5, center=true);
    
    // C. Suporte Superior (Orelha de cima)
    translate([0, raio_interno - 4, 0])
        cube([12, 5, espessura_total + 2], center=true);
        
    // D. Suporte Inferior (Orelha de baixo)
    translate([0, -(raio_interno - 4), 0])
        cube([12, 5, espessura_total + 2], center=true);
}
