# language: fr
@javascript
Fonctionnalité: En tant qu'utilisateur administrateur,
  Je veux saisir des commentaires pour une entité utilisant act_as_commentable

  Contexte:
    Étant donné je prétends être connecté comme utilisateur admin
    Et j'ai une entité 'DummyModel' avec rôle dans la base de donnée avec le id 1

  Scénario: Affichage de la page de liste de commentaire
    Quand J'accède la page 'index' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man"
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et je vois le contenu "note 1 administrateur fungo@fungo.com"
    Et je vois le contenu "note 2 livreur fungo@fungo.com"
    Et je vois le bouton supprimer du commentaire "1"
    Et je vois le bouton supprimer du commentaire "2"

  Scénario: Affichage de la page de liste de commentaire dont le rôle est delivery_man
    Quand J'accède la page 'index' du modèle "dummy_model" du gem avec les paramètres "?roles=delivery_man"
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et je ne vois pas le contenu "note 1 administrateur"
    Et je vois le contenu "note 2 livreur fungo@fungo.com"
    Et je ne vois pas le bouton supprimer du commentaire "1"
    Et je vois le bouton supprimer du commentaire "2"

  Scénario: Affichage de la page de liste de commentaire et n'affiche pas la liste de commentaire, seulement le bouton Nouveau
    Quand J'accède la page 'index' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man&display_list_notes=false"
    Alors la page d'affichage pour DummyModel est affichée sans la liste des commentaires

  Scénario: Affichage de la page de création d'un commentaire
    Quand J'accède la page 'index' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man"
    Quand je clique sur le lien "new_notes_link"
    Alors l'écran de saisi d'un nouveau commentaire s'affiche

  Scénario: Affichage de la page de création d'un commentaire où la liste de commentaire n'était pas affiché dans l'index
    Quand J'accède la page 'index' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man&display_list_notes=false"
    Et la page d'affichage pour DummyModel est affichée sans la liste des commentaires
    Quand je clique sur le lien "new_notes_link"
    Alors l'écran de saisi d'un nouveau commentaire s'affiche
    Et je vois que le bouton annuler contient la variable cachée qui indique de ne pas afficher la liste des commentaires

  Scénario: Affichage de la page de création d'un commentaire et l'annuler par la suite
    Quand J'accède la page 'new' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man"
    Et je clique sur le lien "new_notes_cancelled"
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et je vois le contenu "note 1 administrateur fungo@fungo.com"
    Et je vois le contenu "note 2 livreur fungo@fungo.com"

  Scénario: Affichage de la page de création d'un commentaire où la liste de commentaire n'était pas affiché dans l'index
  et l'annuler par la suite
    Quand J'accède la page 'new' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man&display_list_notes=false"
    Et je clique sur le lien "new_notes_cancelled"
    Alors la page d'affichage pour DummyModel est affichée sans la liste des commentaires

  Scénario: Saisi et sauvegarde d'un nouveau commentaire
    Quand J'accède la page 'new' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man"
    Et je vois le bouton radio "Livreur" à l'écran
    Et je vois le bouton radio "Administrateur" à l'écran
    Et je saisi le commentaire "Ceci est un commentaire"
    Et je saisi le champ radio "comments_role_delivery_man"
    Quand je sauvegarde
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et je vois le contenu "note 1 administrateur fungo@fungo.com"
    Et je vois le contenu "note 2 livreur fungo@fungo.com"
    Et le nouveau commentaire saisi "Ceci est un commentaire" s'y trouve
    Et le nouveau commentaire "Ceci est un commentaire" et son rôle "delivery_man" du modèle "DummyModel" ont été bien saisi dans le base de données

  Scénario: Saisi et sauvegarde d'un nouveau commentaire où la liste de commentaire n'était pas affiché dans l'index
    Quand J'accède la page 'new' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man&display_list_notes=false"
    Et je vois le bouton radio "Livreur" à l'écran
    Et je vois le bouton radio "Administrateur" à l'écran
    Et je saisi le commentaire "Ceci est un commentaire"
    Et je saisi le champ radio "comments_role_delivery_man"
    Quand je sauvegarde
    Alors la page d'affichage pour DummyModel est affichée sans la liste des commentaires
    Et le nouveau commentaire saisi "Ceci est un commentaire" ne s'y trouve pas
    Et le nouveau commentaire "Ceci est un commentaire" et son rôle "delivery_man" du modèle "DummyModel" ont été bien saisi dans le base de données

  Scénario: Supprime un des commentaires de la liste
    Quand J'accède la page 'index' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man"
    Et je supprime le commentaire "1"
    Et je réponds 'OK' au popup de confirmation
    Alors je ne vois pas le contenu "note 1 administrateur"
    Et je vois le contenu "note 2 livreur fungo@fungo.com"

  Scénario: Affichage de la page de modification d'un commentaire
    Quand J'accède la page 'index' du modèle "dummy_model" du gem avec les paramètres "?roles=comments,delivery_man"
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Alors je veux modifier le commentaire "1"
    Et le champ "comments_comment" contient "note 1 administrateur"
    Et je saisi le commentaire "note 1 administrateur test"
    Et je saisi le champ radio "comments_role_comments"
    Quand je sauvegarde
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et je vois le contenu "note 2 livreur fungo@fungo.com"
    Et le nouveau commentaire saisi "note 1 administrateur test" s'y trouve
    Et le nouveau commentaire "note 1 administrateur test" et son rôle "comments" du modèle "DummyModel" ont été bien saisi dans le base de données

  Scénario:Affichage de la page de modification d'un commentaire et l'annuler par la suite
    Quand J'accède la page 'edit' du modèle "dummy_model" du gem avec les paramètres "?comment_role=comments&roles=comments,delivery_man"
    Et je clique sur le lien "new_notes_cancelled"
    Alors la page d'affichage de la liste des commentaires pour DummyModel est affichée
    Et je vois le contenu "note 1 administrateur fungo@fungo.com"
    Et je vois le contenu "note 2 livreur fungo@fungo.com"