When(/^j'ai une entité 'DummyModel' avec rôle dans la base de donnée avec le id (\d+)$/) do |id|
  user = Fabricate(:user_info)
  comment1 = Fabricate(:comment, {:comment => 'note 1 administrateur', :commentable_type => 'DummyModel', :role => 'comments', user_id: user.id})
  comment2 = Fabricate(:comment, {:comment => 'note 2 livreur', :commentable_type => 'DummyModel', :role => 'delivery_man', user_id: user.id})
  @dummy_model = Fabricate(:dummy_model, {:id => id, comments_comments: [comment1], delivery_man_comments: [comment2]})
end

When(/^j'ai une entité 'DummyNoRoleModel' dans la base de donnée avec le id (\d+)$/) do |id|
  user = Fabricate(:user_info)
  comment = Fabricate(:comment, {:comment => 'note 3 administrateur', :commentable_type => 'DummyNonRoleModel', :role => 'comments', user_id: user.id})
  @dummy_no_role_model = Fabricate(:dummy_no_role_model, {:id => id, comments: [comment]})
end

And(/^J'accède la page 'index' du modèle "(.*?)" du gem avec les paramètres "(.*?)"$/) do |model, params|
  visit "/commenteux/#{model}/1#{params}"
end

And(/^J'accède la page 'new' du modèle "(.*?)" du gem avec les paramètres "(.*?)"$/) do |model, params|
  visit "/commenteux/#{model}/1/new#{params}"
end

And(/^J'accède la page 'edit' du modèle "(.*?)" du gem avec les paramètres "(.*?)"$/) do |model, params|
  visit "/commenteux/#{model}/1/1/edit#{params}"
end

Then(/^la page d'affichage de la liste des commentaires pour DummyModel est affichée$/) do
  page.should have_content('Commentaire')
  page.should have_content('Fait par')
  page.should have_content('Date')
  page.should have_content('Rôle')
  #page.should have_content('note 1 administrateur')
  #page.should have_content('note 2 livreur')
  page.has_xpath?('//table')
  page.should have_link('Nouveau')
end

Then(/^la page d'affichage pour DummyModel est affichée sans la liste des commentaires$/) do
  page.should_not have_content('Commentaire')
  page.should_not have_content('Fait par')
  page.should_not have_content('Date')
  page.should_not have_content('Rôle')
  page.should_not have_content('note 1 administrateur')
  page.should_not have_content('note 2 livreur')
  page.has_xpath?('//table')
  page.should have_link('Nouveau')
end

Then(/^la page d'affichage de la liste des commentaires pour DummyNoRoleModel est affichée$/) do
  page.should have_content('Commentaire')
  page.should have_content('Fait par')
  page.should have_content('Date')
  page.should_not have_content('Rôle')
  page.should have_content('note 3 administrateur')
  page.has_xpath?('//table')
  page.should have_link('Nouveau')
end

Then(/^la page d'affichage pour DummyNoRoleModel est affichée sans la liste des commentaires$/) do
  page.should_not have_content('Commentaire')
  page.should_not have_content('Fait par')
  page.should_not have_content('Date')
  page.should_not have_content('Rôle')
  page.should_not have_content('note 3 administrateur')
  page.has_xpath?('//table')
  page.should have_link('Nouveau')
end

And(/^je clique sur le lien "(.*?)"$/) do |link_name|
  click_link(link_name)
end

Then(/^l'écran de saisi d'un nouveau commentaire s'affiche$/) do
  page.should have_content('Commentaire')
  page.has_xpath?('//textarea')
end

And(/^je saisi le commentaire "(.*?)"$/) do |commentaire|
  fill_in('Commentaire', :with => commentaire)
end

And(/^je sauvegarde$/) do
  click_button('Enregistrer')
end

And(/^le nouveau commentaire saisi "(.*?)" s'y trouve$/) do |arg1|
  page.should have_content(arg1)
end

And(/^le nouveau commentaire saisi "(.*?)" ne s'y trouve pas$/) do |comment|
  page.should_not have_content(comment)
end

And(/^le nouveau commentaire "(.*?)" et son rôle "(.*?)" du modèle "(.*?)" ont été bien saisi dans le base de données$/) do |valeur_commentaire, valeur_role, modele|
  comment = Comment.find_by_comment(valeur_commentaire)
  comment.should_not be_nil
  comment.comment.should eq valeur_commentaire
  comment.commentable_type.should eq modele
  comment.role.should eq valeur_role
end

And(/^je saisi le champ radio "(.*?)"$/) do |nom_champ|
  choose("#{nom_champ}")
end

And(/^je ne vois pas le champ radio "(.*?)"$/) do |nom_champ|
  expect(page).to_not have_css("input[id='#{nom_champ}']", "input[type='radio']")
end

And(/^j'attend "(.*?)" secondes$/) do |arg1|
  sleep arg1.to_i
end

And(/^je vois le bouton radio "(.*?)" à l'écran$/) do |arg1|
  page.should have_xpath("//label[contains(@class, 'radio') and contains(text(), '#{ arg1 }')]")
end

And(/^je vois que le bouton annuler contient la variable cachée qui indique de ne pas afficher la liste des commentaires/) do
  page.should have_xpath("//a[@id='new_notes_cancelled' and @data-display-list-notes='false']")
end

And(/^je vois le bouton supprimer du commentaire "(.*?)"/) do |comment_id|
  page.should have_xpath("//a[@class='remove_comment' and @data-id='#{comment_id}']")
end

And(/^je ne vois pas le bouton supprimer du commentaire "(.*?)"/) do |comment_id|
  page.should_not have_xpath("//a[@class='remove_comment' and @data-id='#{comment_id}']")
end

And(/^je supprime le commentaire "(.*?)"/) do |comment_id|
  find("a[data-id='#{comment_id}'][class='remove_comment']").trigger('click')
end

And(/^je veux modifier le commentaire "(.*?)"/) do |comment_id|
  find("a[data-id='#{comment_id}'][class='edit_comment']").trigger('click')
end

And(/^je ne vois pas le contenu "(.*?)"/) do |comment_text|
  page.should_not have_content(comment_text)
end

And(/^je vois le contenu "(.*?)"/) do |comment_text|
  page.should have_content(comment_text)
end

And(/^je clique sur le bouton "(.*?)"/) do |button_name|
  click_button(button_name)
end

And(/^je réponds 'OK' au popup de confirmation/) do
  page.driver.browser.accept_js_confirms
end

And(/^je ne vois pas le lien "(.*?)"$/) do |link_name|
  page.should_not have_link(link_name)
end

And(/^je vois le lien "(.*?)"$/) do |link_name|
  page.should have_link(link_name)
end

And(/^le champ "(.*?)" contient "(.*?)"$/) do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end
