module UsersHelper

  # setting the default size to 50 - hmm 50 what actually - what is the default unit?
  def gravatar_for(user, options = {:size=> 50})
    # downcasing the email as gravatar is case-sensitive
      gravatar_image_tag(user.email.downcase, :alt => user.name, :class => 'gravatar', :options => options)
  end
end
