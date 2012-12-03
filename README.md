# microposts: a RoR sample app

### 2012.12.3

secure signin using cookies.permanent.signed. The signin is externalized in  the sessionshelper and included into the application
controller.

### 2012.12.1

Added the sesion controller to handle the login and logout. See the session routes for the sessions. The important difference between falsh and flash.now (p338).
A flash is prepared for a redirect and is empties after the first one. If we simply render a page, without redirecting,
the flash effectively stays for two pages - it's still waiting wor the redirect.

Rails Fixnum helpers are really nice - adding some cool methods to the Fixnum class, so you can write stuff like:

2.years.from_now, 10.weeks.ago, 5.megabytes

### 2012.11.29

pluralize is nice - use it in the rails console: "include ActionView::Helpers::TextHelper

but: pluralize(2, "goose") returns 2 gooses

Error display with a partial view, filtering passwords from params (they are already filtered from the log since RoR3)

### 2012.11.28

Added gravatar_img_tag, annotate, faker, will-paginate to Gemfile, using the gravatar tag and helper

### 2012.11.27

It's probably not worth is to stub. The tests run a bit slower,as htey have to make the complete roundtrip to the DB,
but on the upside they are simpler and one does no t have to use signal expectations which are supposed to be briitle.

Now using :symbols instead of strings for HTTP methods like (see users_controller_spec):
      `get :show, :id => @user`


### 2012.11.26

Used FactoryGirl for the first time - the description in the book was outdated - for some reason they have changed the syntax.
Factory is FactoryGirl now and the factory definition is slightly different. For reference, see users_controller_spec, spec/factories.rb  and
https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md to get started and
http://arjanvandergaag.nl/blog/factory_girl_tips.html for more advanced tricks
