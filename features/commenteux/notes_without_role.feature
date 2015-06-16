# language: fr
@javascript
Fonctionnalité: En tant qu'utilisateur,
  Je veux saisir des commentaires pour une entité utilisant act_as_commentable

  Scénario: Affichage de la page de liste de commentaire
    Étant donné j'ai une entité 'DummyNoRoleModel' dans la base de donnée avec le id 1
    Quand J'accède la page 'index' du gem sans rôle
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée

  Scénario: Affichage de la page de création d'un commentaire
    Étant donné j'ai une entité 'DummyNoRoleModel' dans la base de donnée avec le id 1
    Et J'accède la page 'index' du gem sans rôle
    Et la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et le lien "Nouveau" s'affiche
    Quand je clique sur le lien "Nouveau"
    Alors l'écran de saisi d'un nouveau commentaire s'affiche

  Scénario: Saisi et sauvegarde d'un nouveau commentaire
    Étant donné j'ai une entité 'DummyNoRoleModel' dans la base de donnée avec le id 1
    Et J'accède la page 'new' du gem sans rôle
    Et je saisi le commentaire "Ceci est un commentaire"
    Et je ne vois pas le champ radio "comments_role"
    Quand je sauvegarde
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et le nouveau commentaire saisi "Ceci est un commentaire" s'y trouve
    Et le nouveau commentaire sans rôle est bien saisi dans le base de données