
Repo initial : https://github.com/Ab2nour/projet-compilation
Ici, on ne bidouille que les tests et la Calculette

A sort of devlog des 4 derniers jours avant le rendu du projet, une initiative pertinente à n'en pas douter. 
[edit: Un devlog implique des versions, et des dates, c'est plus une todo list, avec une done list pour se remonter le moral, et un endroit pour râler, je sais pas comment on appelle ça dans le jargon.]


## kessessé les soucis majeurs : 
- comparaison : on ne peut comparer que des expressions booléennes ou que des expressions arithmétiques ensemble 
Erreur que j'obtiens quand il y a comparaison dans bexpr: 
```The following sets of rules are mutually left-recursive [expr, comparaison, nexpr]```
`true or 42==42` ça marche po par exemple
- types : on ne peut plus initialiser des trucs comme "int x = true" mais on peut toujours faire des opérations arithmétiques sur les booléens :rolling-eyes:

## TODO list :
- distinction des types dans les opérations 
- fix comparaison
- do while
- pow
 

## DONE list: 
- expressions arithmétiques
- expressions booléennes
- comparaison (+/-)
- afficher
- déclaration de variables
- assignation/utilisation de var
- if, if else
- distinction des types à la déclaration
- read

