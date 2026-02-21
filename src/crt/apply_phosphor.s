/*
Signature: void applyPhosphor(Pixel& p, int subpixel);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
subpixel : indice du pixel dominant

Description : Le paramètre subpixel détermine quelle composante reste dominante :
	si subpixel == 0 → le rouge est conservé, le vert et le bleu sont réduits à 70 % de leur valeur initiale.
	si subpixel == 1→ le vert est conservé, le rouge et le bleu sont réduits à 70 % de leur valeur initiale.
	sinon → le bleu est conservé, le rouge et le vert sont réduits à 70 % de leur valeur initiale.

Encore une fois, puisqu’on travaille avec des divisions entières, la réduction se fait avec la formule suivante : nouvelle_valeur = valeur_originale × 70 / 100


*/
.data 

offset:
    .int 3

factor:
    .int 70

percent_conversion: 
    .int 100
        
.text 
.globl applyPhosphor                      

applyPhosphor:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO
    # Arguments
    # p = 8(%ebp)    -> adresse du pixel (Pixel)
    # subpixel = 12(%ebp)

    movl 8(%ebp), %esi          # esi = &p
    movl 12(%ebp), %ecx         # ecx = subpixel

    cmpl $0, %ecx
    je rouge_dominant
    cmpl $1, %ecx
    je vert_dominant
    jmp bleu_dominant

    rouge_dominant:

        # Modifier vert
        movl factor, %ebx
        movzbl 1(%esi), %eax        # même logique que dans applyScanline
        imull %ebx, %eax            
        movl $0, %edx               
        movl percent_conversion, %ebx
        idivl %ebx                  
        movb %al, 1(%esi)   

        # Modifier bleu
        movl factor, %ebx
        movzbl 2(%esi), %eax        
        imull %ebx, %eax            
        movl $0, %edx               
        movl percent_conversion, %ebx
        idivl %ebx                  
        movb %al, 2(%esi)  

        jmp Fin

    vert_dominant:

        # Modifier rouge
        movl factor, %ebx
        movzbl (%esi), %eax        
        imull %ebx, %eax            
        movl $0, %edx               
        movl percent_conversion, %ebx
        idivl %ebx                  
        movb %al, (%esi)           

        # Modifier bleu
        movl factor, %ebx
        movzbl 2(%esi), %eax        
        imull %ebx, %eax            
        movl $0, %edx               
        movl percent_conversion, %ebx
        idivl %ebx                  
        movb %al, 2(%esi)  

        jmp Fin

    bleu_dominant:

        # Modifier rouge
        movl factor, %ebx
        movzbl (%esi), %eax        
        imull %ebx, %eax            
        movl $0, %edx               
        movl percent_conversion, %ebx
        idivl %ebx                  
        movb %al, (%esi)           

        # Modifier vert
        movl factor, %ebx
        movzbl 1(%esi), %eax        
        imull %ebx, %eax            
        movl $0, %edx               
        movl percent_conversion, %ebx
        idivl %ebx                  
        movb %al, 1(%esi)  

        jmp Fin



    # epilogue
    Fin:
        leave 
        ret   

