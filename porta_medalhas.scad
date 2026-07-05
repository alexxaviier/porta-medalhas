// =========================================================
// PORTA MEDALHAS COLMEIA - PROJETO ENGENHARIA REVERSA "VEM PRA RUA"
// Código definitivo baseado em camadas lógicas puras
// =========================================================

$fn = 60; // Resolução para furos e círculos

// 1. VARIÁVEIS DO PROJETO (MEDIDAS EXATAS DA IMAGEM)
LARGURA = 250;
ALTURA = 230;
ESPESSURA_TOTAL = 6;
LARGURA_MOLDURA = 10;

// Configuração milimétrica da grade colmeia
RAIO_HEX = 7.5; 
PAREDE_HEX = 1.8;
PASSO_X = RAIO_HEX * 1.73205;
PASSO_Y = RAIO_HEX * 1.5;

// Diâmetro de assentamento da mandala central (4 medalhas)
RAIO_MANDALA = 142 / 2;

// -------------------------------------------------------
// CONSTRUÇÃO DO MODELO POR SOMA E SUBTRAÇÃO LÓGICA
// -------------------------------------------------------
difference() {
    
    // UNIÃO: Tudo o que é SÓLIDO na peça
    union() {
        // A. A grande moldura hexagonal externa
        difference() {
            cylinder(h=ESPESSURA_TOTAL, r=LARGURA/2, $fn=6, center=true);
            cylinder(h=ESPESSURA_TOTAL + 2, r=LARGURA/2 - LARGURA_MOLDURA, $fn=6, center=true);
        }
        
        // B. Os 3 Olhais maciços dos parafusos (Esquerda, Direita e Base)
        translate([-LARGURA/2 + 18, 0, 0]) cylinder(h=ESPESSURA_TOTAL, r=11, center=true);
        translate([LARGURA/2 - 18, 0, 0]) cylinder(h=ESPESSURA_TOTAL, r=11, center=true);
        translate([0, -ALTURA/2 + 14, 0]) cylinder(h=ESPESSURA_TOTAL, r=11, center=true);
        
        // C. O Anel Central flutuante que serve de batente para as medalhas
        difference() {
            cylinder(h=ESPESSURA_TOTAL, r=RAIO_MANDALA + 1, center=true);
            cylinder(h=ESPESSURA_TOTAL + 2, r=RAIO_MANDALA - 2, center=true);
        }
        
        // D. O Miolo central maciço onde prende a Baioneta
        cylinder(h=ESPESSURA_TOTAL, r=15, center=true);
        
        // E. A GRADE DE COLMEIA CONTÍNUA (Preenche todo o fundo)
        // Criada por interseção para ficar restrita apenas ao interior do hexágono
        intersection() {
            cylinder(h=ESPESSURA_TOTAL, r=LARGURA/2 - LARGURA_MOLDURA + 1, $fn=6, center=true);
            
            // Malha de mini-hexágonos sólidos interconectados
            union() {
                for (x = [-LARGURA/2 - 20 : PASSO_X : LARGURA/2 + 20]) {
                    for (y = [-ALTURA/2 - 20 : PASSO_Y : ALTURA/2 + 20]) {
                        // Linhas normais
                        translate([x, y, 0]) 
                            cylinder(h=ESPESSURA_TOTAL, r=RAIO_HEX, $fn=6, center=true);
                        // Linhas intercaladas (Desenho colmeia perfeito)
                        translate([x + PASSO_X/2, y + PASSO_Y/2, 0]) 
                            cylinder(h=ESPESSURA_TOTAL, r=RAIO_HEX, $fn=6, center=true);
                    }
                }
            }
        }
    }

    // SUBTRAÇÃO: Furos funcionais que cortam a peça de lado a lado
    union() {
        // 1. Os furos internos de cada mini-colmeia (Deixa apenas as paredes de 1.8mm)
        for (x = [-LARGURA/2 - 20 : PASSO_X : LARGURA/2 + 20]) {
            for (y = [-ALTURA/2 - 20 : PASSO_Y : ALTURA/2 + 20]) {
                translate([x, y, 0]) 
                    cylinder(h=ESPESSURA_TOTAL + 2, r=RAIO_HEX - PAREDE_HEX, $fn=6, center=true);
                translate([x + PASSO_X/2, y + PASSO_Y/2, 0]) 
                    cylinder(h=ESPESSURA_TOTAL + 2, r=RAIO_HEX - PAREDE_HEX, $fn=6, center=true);
            }
        }
        
        // 2. O Furo da Trava Baioneta Central (Com as 4 ranhuras guias)
        cylinder(h=ESPESSURA_TOTAL + 2, r=6, center=true);
        for(a = [0 : 90 : 270]) {
            rotate([0, 0, a])
                translate([6, 0, 0])
                    cube([4, 4, ESPESSURA_TOTAL + 2], center=true);
        }
        
        // 3. Os 3 furos de fixação na parede (Centralizados nos olhais)
        translate([-LARGURA/2 + 18, 0, 0]) cylinder(h=ESPESSURA_TOTAL + 2, r=2.5, center=true);
        translate([LARGURA/2 - 18, 0, 0]) cylinder(h=ESPESSURA_TOTAL + 2, r=2.5, center=true);
        translate([0, -ALTURA/2 + 14, 0]) cylinder(h=ESPESSURA_TOTAL + 2, r=2.5, center=true);
    }
}
