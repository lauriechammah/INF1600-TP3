/*
Signature : void crtFilter(Image& img, int scanlineSpacing)

Paramètres :
img : la référence vers l’image à modifier (sur place)
scanlineSpacing : espacement entre les lignes que l’on va dessiner sur l’image pour l’effet CRT


Description : Cette fonction applique un filtre global à une image afin de reproduire l’apparence d’un ancien écran CRT. Elle combine les deux fonctions précédentes.
Il faut parcourir TOUS les pixels et appliquer les traitements suivants:
1.	Appeler applyScanline() 
    	Si la ligne y est un multiple de scanlineSpacing on applique un assombrissement de 60 %.

2.	Appler applyPhosphor()
        Le paramètre subpixel est déterminé par la position horizontale du pixel : x % 3

*/
.data   

full_color:
    .int 100

less_color:
    .int 60

max_index:
    .int 3

.text 
.globl crtFilter                      

crtFilter:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO

    # Parametres
    # img = 8(%ebp)
    # scanlineSpacing = 12(%ebp)
    # sauver callee-saved
    pushl %ebx
    pushl %esi
    pushl %edi

    # img = 8(%ebp), scanlineSpacing = 12(%ebp)
    movl 8(%ebp), %esi        # esi = &img

    movl 0(%esi), %ecx        # ecx = largeur
    movl 4(%esi), %edx        # edx = hauteur
    movl 8(%esi), %esi        # esi = img.pixels (Pixel**)

    movl $0, %edi             # y = 0

    boucle_y:
        cmpl %edx, %edi           # y >= hauteur ?
        jge fin

        movl $0, %ebx             # x = 0

    boucle_x:
        cmpl %ecx, %ebx           # x >= largeur ?
        jge next_y

        # pixel* = img.pixels[y][x]
        movl (%esi, %edi, 4), %eax    # eax = img.pixels[y]
        lea  (%eax, %ebx, 4), %eax    # eax = &img.pixels[y][x]

        #### 1) applyScanline si y % scanlineSpacing == 0 ####
        # sauver contexte
        pushl %ecx                # largeur
        pushl %edx                # hauteur
        pushl %ebx                # x
        pushl %eax                # pixel*

        movl %edi, %eax           # eax = y
        xorl %edx, %edx           # edx = 0
        movl 12(%ebp), %ecx       # ecx = scanlineSpacing
        idivl %ecx                # edx = y % scanlineSpacing

        cmpl $0, %edx
        jne skip_scanline

        # pixel* est au sommet de la pile
        pushl $60
        pushl 4(%esp)             # Pousse pixel* (qui est maintenant à +4)
        call applyScanline
        addl $8, %esp

    skip_scanline:
        # restaurer contexte
        popl %eax                 # pixel*
        popl %ebx                 # x
        popl %edx                 # hauteur
        popl %ecx                 # largeur

        #### 2) applyPhosphor, subpixel = x % 3 ####
        pushl %ecx                # sauver largeur
        pushl %edx                # sauver hauteur

        movl %ebx, %eax           # eax = x
        xorl %edx, %edx
        movl $3, %ecx
        idivl %ecx                # edx = x % 3

        # recalculer pixel* (on a toujours esi, edi, ebx)
        movl (%esi, %edi, 4), %eax    # eax = img.pixels[y]
        lea  (%eax, %ebx, 4), %eax    # eax = &img.pixels[y][x]

        pushl %edx                # subpixel
        pushl %eax                # pixel*
        call applyPhosphor
        addl $8, %esp

        popl %edx                 # hauteur
        popl %ecx                 # largeur

        incl %ebx                 # x++
        jmp boucle_x

    next_y:
        incl %edi                 # y++
        jmp boucle_y

    fin:
        popl %edi
        popl %esi
        popl %ebx

        leave
        ret
