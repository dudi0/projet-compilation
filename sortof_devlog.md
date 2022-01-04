
Repo initial : https://github.com/Ab2nour/projet-compilation
Ici, on ne bidouille que les tests et la Calculette

A sort of devlog des 4 derniers jours avant le rendu du projet, une initiative pertinente à n'en pas douter. 
[edit: Un devlog implique des versions, et des dates, c'est plus une todo list, avec une done list pour se remonter le moral, et un endroit pour râler, je sais pas comment on appelle ça dans le jargon.]


## kessessé les soucis majeurs : 
- types : on ne peut plus initialiser des trucs comme "int x = true" mais on peut toujours faire des opérations arithmétiques sur les booléens :rolling-eyes:
- bloc : quand il y a plusieurs instructions dans le bloc, on a ces erreurs autant de fois qu'il y a d'instructions - 1
```
line 8:0 token recognition error at: 'n'
line 8:1 token recognition error at: 'u'
line 8:2 token recognition error at: 'l'
line 8:3 token recognition error at: 'l'
```
On lit un caractère null 
C'est à cause de ça j'pense : `{$code += $instruction.code;}` le += ajoute un caractère null à un moment 
C'est surement le NEWLINE de mort à la ligne d'après jpp pourquoi je commence par un NEWLINE ? 

## TODO list :
- distinction des types dans les opérations 
- do while
- float
- pow
 

## DONE list: 
- expressions arithmétiques
- expressions booléennes
- comparaison 
- afficher
- déclaration de variables
- assignation/utilisation de var
- if, if else
- distinction des types à la déclaration
- read

