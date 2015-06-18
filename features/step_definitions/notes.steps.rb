When(/^j'ai une entité 'DummyModel' avec rôle dans la base de donnée avec le id (\d+)$/) do |arg1|
  comment1 = Fabricate(:comment, {:comment => 'note 1 administrateur', :commentable_type => 'DummyModel', :role => 'comments'})
  comment2 = Fabricate(:comment, {:comment => 'note 2 livreur', :commentable_type => 'DummyModel', :role => 'delivery_man'})
  @dummy_model = Fabricate(:dummy_model, {:id => 1, comments_comments: [comment1], delivery_man_comments: [comment2]})
end

When(/^j'ai une entité 'DummyNoRoleModel' dans la base de donnée avec le id (\d+)$/) do |arg1|
  comment = Fabricate(:comment, {:comment => 'note 3 administrateur', :commentable_type => 'DummyNonRoleModel', :role => 'comments'})
  @dummy_no_role_model = Fabricate(:dummy_no_role_model, {:id => 1, comments: [comment]})
end

When(/^J'accède la page 'index' du gem avec des rôles$/) do
  visit '/commenteux/dummy_model/1?roles=comments,delivery_man'
end

When(/^J'accède la page 'index' du gem sans rôle$/) do
  visit '/commenteux/dummy_no_role_model/1'
end

And(/^J'accède la page 'new' du gem avec des rôles$/) do
  visit '/commenteux/dummy_model/1/new?roles=comments,delivery_man'
end

And(/^J'accède la page 'new' du gem sans rôle$/) do
  visit '/commenteux/dummy_no_role_model/1/new'
end

Then(/^la page d'affichage de la liste des commentaires pour DummyModel est affichée$/) do
  page.should have_content('Commentaire')
  page.should have_content('Fait par')
  page.should have_content('Date')
  page.should have_content('Rôle')
  page.should have_content('note 1 administrateur')
  page.should have_content('note 2 livreur')
  page.has_xpath?('//table')
end

Then(/^la page d'affichage de la liste des commentaires pour DummyNoRoleModel est affichée$/) do
  page.should have_content('Commentaire')
  page.should have_content('Fait par')
  page.should have_content('Date')
  page.should_not have_content('Rôle')
  page.should have_content('note 3 administrateur')
  page.has_xpath?('//table')
end

And(/^le lien "(.*?)" s'affiche$/) do |link_name|
  find_link(link_name).visible?
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

And(/^le nouveau commentaire "(.*?)" est bien saisi dans le base de données$/) do |valeur_commentaire|
  comment = Comment.find_by_comment(valeur_commentaire)
  comment.should_not be_nil
  comment.comment.should eq 'Ceci est un commentaire'
  comment.commentable_type.should eq 'DummyModel'
  comment.role.should eq 'delivery_man'
end

And(/^le nouveau commentaire sans rôle "(.*?)" est bien saisi dans le base de données$/) do |valeur_commentaire|
  comment = Comment.find_by_comment(valeur_commentaire)
  comment.should_not be_nil
  comment.comment.should eq 'Ceci est un commentaire'
  comment.commentable_type.should eq 'DummyNoRoleModel'
  comment.role.should eq 'comments'
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