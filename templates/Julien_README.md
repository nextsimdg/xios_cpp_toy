Bonjour Laurent,

Tu trouveras en PJ un exemple de code en C++ qui appelle l'interface C. 
Il s'agit de la traduction de la 1ère partie du TP de prise en main de 
la décomposition de domaine fait lors de la dernière formation :

    https://forge.ipsl.jussieu.fr/ioserver/browser/XIOS/xios_training/hands-on-3/answer/test_tp3.f90_1
    https://forge.ipsl.jussieu.fr/ioserver/browser/XIOS/xios_training/hands-on-3/TP_src/iodef.xml

Le code C++ est commenté pour décrire la démarche qui permet d'aller 
chercher les interfaces C ad hoc. N'hésite pas si tu as des questions.

Un élément qui manque dans XIOS au regard de votre utilisation est le 
header qui contient les interfaces C (pas utilisé jusqu'ici si ce n'est 
au travers du binding Fortran).
Il est nécessaire de le créer à la main (pour le cas présent le fichier 
my_xios.hpp est également en PJ).

Pour la compilation, il est nécessaire (de mon coté) d'intégrer la 
bibliothèque Fortran qui a permis de compiler XIOS à l'édition de liens :

    # ../ = XIOS_ROOR_DIR
    $ mpicxx -w -std=c++11 -c test_tp3.cpp -I./ -I../inc
    -I../extern/boost/include -I../extern/blitz
    -I../extern/rapidxml/include/
    $ mpicxx -o test_cpp test_tp3.o  -L../lib -lxios
    -L${HOME}/Applications/netcdf-c-4.7.4/lib -lnetcdf -lgfortran

Quelques remarques :

  * Pour la gestion d'attributs de type chaîne de caractères, il est
    préférable de travailler dans le XML directement.
    L'interfaçage fortran/C est basé sur des char* (et pas sur des
    string) avec une partie du travail qui est fait au niveau Fortran,
    ce qui pose quelques difficultés dans ce contexte pur C.
  * Il faudra prêter une attention particulière à l'organisation en
    mémoire des champs (column/raw major), j'avoue ne pas y avoir fait
    particulièrement attention ici (dans ce test le champs est constant
    pour chaque rang MPI)

Julien
