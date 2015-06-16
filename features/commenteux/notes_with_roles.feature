# language: fr
@javascript
Fonctionnalité: En tant qu'utilisateur,
  Je veux saisir des commentaires pour une entité utilisant act_as_commentable

  Scénario: Affichage de la page de liste de commentaire
    Étant donné j'ai une entité 'DummyModel' avec rôle dans la base de donnée avec le id 1
    Quand J'accède la page 'index' du gem avec des rôles
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée

  Scénario: Affichage de la page de création d'un commentaire
    Étant donné j'ai une entité 'DummyModel' avec rôle dans la base de donnée avec le id 1
    Et J'accède la page 'index' du gem avec des rôles
    Et la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et le lien "Nouveau" s'affiche
    Quand je clique sur le lien "new_notes_link"
    Alors l'écran de saisi d'un nouveau commentaire s'affiche

  Scénario: Affichage de la page de création d'un commentaire et l'annuler par la suite
    Étant donné j'ai une entité 'DummyModel' avec rôle dans la base de donnée avec le id 1
    Et J'accède la page 'new' du gem avec des rôles
    Quand je clique sur le lien "new_notes_cancelled"
    Et la page d'affichage de la liste des commentaires pour DummyModel est affichée

  Scénario: Saisi et sauvegarde d'un nouveau commentaire
    Étant donné j'ai une entité 'DummyModel' avec rôle dans la base de donnée avec le id 1
    Et J'accède la page 'new' du gem avec des rôles
    Et je saisi le commentaire "Ceci est un commentaire"
    Et je saisi le champ radio "comments_role_delivery_man"
    Quand je sauvegarde
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et le nouveau commentaire saisi "Ceci est un commentaire" s'y trouve
    Et le nouveau commentaire est bien saisi dans le base de données