/*
Signature: void applyPhosphor(applyScanline& p, int percent);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
percent : facteur d’assombrissement

Description : Cette fonction applique un facteur d’assombrissement à un pixel en multipliant chacune de ses composantes RGB par un pourcentage donné: nouvelle_valeur = valeur_orignale x percent / 100
*/    
.data 

percent_conversion: 
.int 100

.text 
.globl applyScanline                      

applyScanline:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp   

    # TODO

    # Arguments
    # p = 8(%ebp)    -> adresse du pixel (Pixel)
    # percent = 12(%ebp)

    movl 8(%ebp), %esi          # esi = &p
    movl 12(%ebp), %ecx         # ecx = percent

    ####### Traitement composante R #######
    movzbl (%esi), %eax         # on met un seul octet (R) étendu en 32 bits dans %eax (pour les prochaines opérations)
    imull %ecx, %eax            # eax = R * percent
    movl $0, %edx               # clean, éviter overflow
    movl percent_conversion, %ebx
    idivl %ebx                  # diviser eax par 100
    movb %al, (%esi)            # nouvelle valeur de R dans pixel

    ####### Traitement composante G #######
    movzbl 1(%esi), %eax        # même logique, mais octet suivant 
    imull %ecx, %eax            
    movl $0, %edx               
    movl percent_conversion, %ebx
    idivl %ebx                  
    movb %al, 1(%esi)        

    ####### Traitement composante B #######
    movzbl 2(%esi), %eax        # même logique, mais octet suivant 
    imull %ecx, %eax            
    movl $0, %edx               
    movl percent_conversion, %ebx
    idivl %ebx                  
    movb %al, 2(%esi)    

    ####### A est ignoré #######
    
    # epilogue
    leave 
    ret   

