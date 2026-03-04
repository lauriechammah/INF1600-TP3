/*
Implementation en C:
void sierpinskiImage(uint32_t x, uint32_t y, uint32_t size, Image& img, Pixel color) {
    // vérifier les bornes
    if (x >= img.largeur || y >= img.hauteur) return;

    // Cas de base: dessiner un seul pixel
    if (size == 1) {
        img.pixels[y][x] = color;
        return;
    }

    uint32_t half = size / 2;

    // Triangle en bas à gauche
    sierpinskiImage(x, y + half, half, img, color);
    // Triangle en bas à droite
    sierpinskiImage(x + half, y + half, half, img, color);
    // Triangle du haut
    sierpinskiImage(x + half / 2, y, half, img, color);
}

L’algorithme fonctionne mieux avec des tailles puissances de 2.
L’appel de la fonction dans le main sera ainsi : sierpinskiImage(0, 0, 1024, img, color);
*/

.data 

.text 
.globl sierpinskiImage                      

sierpinskiImage:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO
    # sauver callee-saved
    pushl %ebx
    pushl %esi
    pushl %edi
    
    # paramètres : x = 8(%ebp), y = 12(%ebp), size = 16(%ebp), img = 20(%ebp), color = 24(%ebp)
    movl 8(%ebp), %edi              # edi = x
    movl 12(%ebp), %ebx             # ebx = y
    movl 16(%ebp), %eax             # eax = size
    
    movl 20(%ebp), %esi             # esi = img (Image&)
    
    movl 0(%esi), %ecx              # ecx = largeur image
    movl 4(%esi), %edx              # edx = hauteur image
    movl 8(%esi), %esi              # esi = img.pixels (Pixel**)
    
    # vérifier les bornes
    cmp %ecx, %edi                  # x >= img.largeur ?
    jae fin
    cmp %edx, %ebx                  # y >= img.hauteur ?
    jae fin
    
    # cas de base
    cmp $1, %eax                    # si size == 1
    jne recursion
    
    # colorer pixel si size = 1
    # esi = img.pixels, y = ebx, x = edi
    movl 24(%ebp), %ecx         # ecx = Pixel (r, g, b, a) = color
    
    movl (%esi,%ebx,4), %esi    # esi = img.pixels[y]
    leal (%esi,%edi,4), %esi    # esi = &img.pixels[y][x] (donc l'adresse du pixel)
    
    movl %ecx, (%esi)           # &img.pixels[y][x] = color
    jmp fin

    recursion:
        # diviser size
        shrl $1, %eax           # eax / 2 (donc half = size / 2)
    
        # Triangle en bas à gauche
        movl %ebx, %ecx         # ecx = y
        addl %eax, %ecx         # y += half
        
        pushl 24(%ebp)          # color
        pushl 20(%ebp)          # img
        pushl %eax              # half
        pushl %ecx              # y + half
        pushl %edi              # x
        call sierpinskiImage
        addl $20, %esp          # 5 paramètres x 4 bytes = 20
        
        # Triangle en bas à droite
        movl %edi, %edx         # edx = x
        addl %eax, %edx         # x += half
        
        pushl 24(%ebp)          # color
        pushl 20(%ebp)          # img
        pushl %eax              # half
        pushl %ecx              # y + half
        pushl %edx              # x + half
        call sierpinskiImage
        addl $20, %esp
        
        # Triangle du haut
        movl %eax, %ecx         # ecx = half
        shrl $1, %ecx           # ecx = half / 2
        movl %edi, %edx         # edx = x
        addl %ecx, %edx         # x += half / 2
        
        pushl 24(%ebp)          # color
        pushl 20(%ebp)          # img
        pushl %eax              # half
        pushl %ebx              # y
        pushl %edx              # x + half/2
        call sierpinskiImage
        addl $20, %esp
        
    fin:
        # epilogue
        # registres callee-saved restorés :
        popl %edi
        popl %esi
        popl %ebx
        
        leave 
        ret
