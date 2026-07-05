// Dimensões baseadas na imagem
largura = 250;
altura = 230;
espessura = 6;
raio_hex = 15; 

difference() {
    // Bloco principal do porta medalhas
    cube([largura, altura, espessura], center = true);
    
    // Furos estilo colmeia
    for (x = [-largura/2 + 20 : raio_hex * 1.75 : largura/2 - 20]) {
        for (y = [-altura/2 + 20 : raio_hex * 3 : altura/2 - 20]) {
            translate([x, y, 0])
                cylinder(h = espessura + 2, r = raio_hex, $fn = 6, center = true);
            
            translate([x + (raio_hex * 1.75)/2, y + (raio_hex * 3)/2, 0])
                cylinder(h = espessura + 2, r = raio_hex, $fn = 6, center = true);
        }
    }
}
