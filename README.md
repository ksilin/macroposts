# Ruby on Rails Tutorial: sample application
This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com/).

## 2012.11.29

pluralize is nice - use it in the rails console: "include ActionView::Helpers::TextHelper

but: pluralize(2, "goose") returns 2 gooses

Error display with a partial view, filtering passwords from params (they are already filtered from the log since RoR3)

## 2012.11.28

Added gravatar_img_tag, annotate, faker, will-paginate to Gemfile, using the gravatar tag and helper

## 2012.11.27

It's probably not worth is to stub. The tests run a bit slower,as htey have to make the complete roundtrip to the DB,
but on the upside they are simpler and one does no t have to use signal expectations which are supposed to be briitle.

Now using :symbols instead of strings for HTTP methods like (see users_controller_spec):
      `get :show, :id => @user`


## 2012.11.26

Used FactoryGirl for the first time - the description in the book was outdated - for some reason they have changed the syntax.
Factory is FactoryGirl now and the factory definition is slightly different. For reference, see users_controller_spec, spec/factories.rb  and
https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md to get started and
http://arjanvandergaag.nl/blog/factory_girl_tips.html for more advanced tricks
