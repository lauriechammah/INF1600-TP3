/*
    Vous pouvez modifier le liens des images. SVP mettre leur source si pris en ligne.

    Commandes:

	make : compile le projet en générant l’exécutable principal.
	make run : compile le projet (si nécessaire) puis exécute l’application.
	make test : lance la suite de tests prévue pour vérifier le bon fonctionnement des fonctions et filtres implémentés.
	make remise : crée un fichier zip contenant l’ensemble des fichiers nécessaires pour la remise du projet, prêt à être soumis.

*/

.data 

inputCrt: 
    .asciz "images/johnpork.png"

outputCrt:
    .asciz "crt.png"

outputSierpinski:
    .asciz "sierpinski.png"

.align 4
color:
    .byte 227, 171, 59, 255

.text 
.globl main                      

main:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    subl $24, %esp              # alloué de l'espace pour deux images dès le début (2 x 12 octets)
                                # Image CRT : -12(%ebp)
                                # Image Triangle : -24(%ebp)
    #################### Filtre CRT #######################

    # TODO: Charger l'image inputCrt en appelant loadImage()
    # subl $12, %esp              # Allocation : struct Image = 3 ints = 12 octets

    leal -12(%ebp), %eax        # eax = &imageCRT
    pushl %eax                  # 2e argument : pointeur vers img
    pushl $inputCrt             # 1er argument : filename
    call loadImage
    addl $8, %esp

    # TODO: Appliquer le filtre crtFilter() sur cette image
    pushl $3                    # 2e argument : scanlineSpacing = 3
    leal -12(%ebp), %eax        # eax = &imageCRT
    pushl %eax                  # 1er argument : img
    call crtFilter
    addl $8, %esp

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()
    leal -12(%ebp), %eax        # eax = &imageCRT
    pushl %eax                  # 2e argument : pointeur vers img
    pushl $outputCrt            # 1er argument : filename
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal -12(%ebp), %eax
    pushl %eax                  # 1er argument : img
    call freeImage
    addl $4, %esp


    #################### Triangle de Sierpinski #######################


    # TODO: Créer une image vide de taille d'une puissance de 2 en appelant createImage()
    # Puisque createImage() retourne une struct Image, il faut d’abord allouer de l’espace sur la pile pour l’image, puit push l’adresse de cet espace comme 3e paramètre avant de call la fonction.
    
    # subl $12, %esp              # Allocation : struct Image = 3 ints = 12 octets
    # movl %esp, %eax              # Adresse de l'espace alloué : eax = &imageCRT

    leal -24(%ebp), %eax
    pushl %eax                  # 3e paramètre : adresse de l'image
    pushl $1024                 # 2e paramètre : hauteur
    pushl $1024                 # 1e paramètre : largeur
    
    call createImage
    addl $12, %esp              # 3 param. x 4 octets = 12

    # TODO: Dessiner le triangle de Sierpinski avec la fonction récursive sierpinskiImage()
    leal -24(%ebp), %eax        # eax = &imageCRT
    pushl color
    pushl %eax                  # adresse de l'image
    pushl $1024                 # size (taille de l'image)
    pushl $0                    # y = 0
    pushl $0                    # x = 0
    call sierpinskiImage
    addl $20, %esp              # 5 paramètres x 4 bytes = 20
    
    # TODO: Sauvegarder cette image dans le fichier outputSierpinski avec saveImage()
    leal -24(%ebp), %eax        # eax = &imageCRT
    pushl %eax                  # 2e argument : pointeur vers img
    pushl $outputSierpinski     # 1er argument : filename
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal -24(%ebp), %eax
    pushl %eax                  # 1er argument : img
    call freeImage
    addl $4, %esp



    movl    $0, %eax
    # epilogue
    leave 
    ret 
