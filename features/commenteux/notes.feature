# language: fr

Fonctionnalité: En tant qu'utilisateur,
  Je veux saisir des commentaires pour une entité utilisant act_as_commentable

  Scénario: : Affichage de la page de liste de commentaire
    Quand j'ai une entité 'DummyModel' dans la base de donnée avec le id 1
    Et J'accède la page 'index' du gem
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée

  Scénario: : Affichage de la page de création d'un commentaire
    Quand j'ai une entité 'DummyModel' dans la base de donnée avec le id 1
    Et J'accède la page 'index' du gem
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et le lien "Nouveau" s'affiche
    Et je clique sur le lien "Nouveau"
    Alors l'écran de saisi d'un nouveau commentaire s'affiche

  Scénario: : Saisi et sauvegarde d'un nouveau commentaire
    Quand j'ai une entité 'DummyModel' dans la base de donnée avec le id 1
    Et J'accède la page 'new' du gem
    Et je saisi le commentaire "Ceci est un commentaire"
    Et je sauvegarde
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et le nouveau commentaire saisi "Ceci est un commentaire" s'y trouve
    Et le nouveau commentaire est bien saisi dans le base de données