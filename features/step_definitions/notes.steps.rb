Quand(/^j'ai une entité 'DummyModel' dans la base de donnée avec le id (\d+)$/) do |arg1|
  @dummy_model = Fabricate(:dummy_model, {:id => 1})
end

Quand(/^J'accède la page 'index' du gem$/) do
  visit '/commenteux/dummy_model/1'
end

Et(/^J'accède la page 'new' du gem$/) do
  visit '/commenteux/dummy_model/1/new'
end

Alors(/^la page d'affichage de la liste des commentaires pour DummyModel est affichée$/) do
  page.should have_content('Commentaire')
  page.should have_content('Fait par')
  page.should have_content('Date')
  page.has_xpath?('//table')
end

Et(/^le lien "(.*?)" s'affiche$/) do |link_name|
  find_link(link_name).visible?
end

Et(/^je clique sur le lien "(.*?)"$/) do |link_name|
  click_link(link_name)
end

Alors(/^l'écran de saisi d'un nouveau commentaire s'affiche$/) do
  page.should have_content('Commentaire')
  page.has_xpath?('//textarea')
end

Et(/^je saisi le commentaire "(.*?)"$/) do |commentaire|
  fill_in('Commentaire', :with => commentaire)
end

Et(/^je sauvegarde$/) do
  click_button('Enregistrer')
end

Et(/^le nouveau commentaire saisi "(.*?)" s'y trouve$/) do |arg1|
  page.should have_content(arg1)
end

Et(/^le nouveau commentaire est bien saisi dans le base de données$/) do
  comment = Comment.find_by_commentable_id(1)
  comment.should_not be_nil
  comment.comment.should eq 'Ceci est un commentaire'
  comment.commentable_type.should eq 'DummyModel'
end