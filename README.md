How to build a Pinterest Clone in Rails 5
By Bala Paranj
May 20, 2016
Libraries Used
Devise for Authentication
Paperclip for File Uploading
Masonry Rails for Transition Effects
Twitter Bootstrap 4 for CSS Framework
Acts as Votable for Voting
Starter Rails 5 App
Create a new Rails 5 project and pin resource.

rails g scaffold pin title description:text
Migrate the database.

rails db:migrate
Start the server.

rails s
Create some records using the UI.

Authenticate using Devise
Add:

gem 'devise', github: 'plataformatec/devise'
Run bundle. Generate the devise related files.

rails generate devise:install
Define the home page in routes.rb.

root to: "pins#index"
Create the user model.

rails generate devise user
Add the user_id foreign_key to pins table.

rails g migration add_user_id_to_pins user_id:integer
Migrate the database.

rails db:migrate
Add the navigation links:

<% if user_signed_in? %>
  <li><%= link_to "New Pin", new_pin_path %></li>
    <li><%= link_to "Account", edit_user_registration_path %></li>
  <li><%= link_to "Sign Out", destroy_user_session_path, method: :delete %></li>
<% else %>
  <li><%= link_to "Sign Up", new_user_registration_path %></li>
    <li><%= link_to "Sign In", new_user_session_path %></li>
<% end %>     
to layout. You will now be able to signup, signin and logout.

File Uploading using Paperclip
gem "paperclip", "~> 5.0.0.beta1"
Run bundle. Add:

has_attached_file :image, :styles => { :medium => "300x300>" }
validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
to pin.rb. Generate the fields required to upload image by running the paperclip generator.

rails g paperclip pin image
Modify the pins table by running the migration.

rails db:migrate
Add:

html: { multipart: true }
to pin form partial. Add file upload field to pin form partial.

<div class='field'>
  <%= f.label :image %>
  <%= f.file_field :image %>
</div>
You will get the error:

User must exist
if you try to create a pin without a user associated. Change the pins controller new action:

def new
  @pin = current_user.pins.build
end
Image will not be uploaded. To fix the problem, add image field to the permitted fields in pin_params pins controller method:

def pin_params
  params.require(:pin).permit(:title, :description, :image)
end
You can now upload and view the image.

Transition Effects using Masonry Rails Gem
Add masonry-rails gem to Gemfile.

gem 'masonry-rails'
Run bundle. In application.scss:

*= require 'masonry/transitions'
It will look like this:

*= require 'masonry/transitions'
*= require_tree .
*= require_self
*/
Style the pin index page to enable transition effect provided by masonry-rails gem.

<div class="transitions-enabled" id="pins">
  <% @pins.each do |pin| %>
    <div class="box panel panel-default">
      <%= link_to (image_tag pin.image.url), pin %>
      <h2>
        <%= link_to pin.title, pin %>
      </h2>
      <p class="user">
        Submitted by
        <%= pin.user.email %>
      </p>
    </div>  
  <% end %>
</div>  
<%= link_to 'New Pin', new_pin_path %>
Add CSS to application.scss:

 body {
    background: #E9E9E9;
 }

 h1, h2, h3, h4, h5, h6 {
    font-weight: 100;
 }

 nav {
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
    .navbar-brand {
        a {
            color: #BD1E23;
            font-weight: bold;
            &:hover {
                text-decoration: none;
            }
        }
    }
 }

 #pins {
   margin: 0 auto;
   width: 100%;
   .box {
      margin: 10px;
      width: 350px;
      box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
      border-radius: 7px;
      text-align: center;
      img {
        max-width: 100%;
        height: auto;
      }
      h2 {
        font-size: 22px;
        margin: 0;
        padding: 25px 10px;
        a {
                color: #474747;
        }
      }
      .user {
        font-size: 12px;
        border-top: 1px solid #EAEAEA;
            padding: 15px;
            margin: 0;
      }
    }
 }

 #edit_page {
    .current_image {
        img {
            display: block;
            margin: 20px 0;
        }
    }
 }

 #pin_show {
    .panel-heading {
        padding: 0;
    }
    .pin_image {
        img {
            max-width: 100%;
            width: 100%;
            display: block;
            margin: 0 auto;
        }
    }
    .panel-body {
        padding: 35px;
        h1 {
            margin: 0 0 10px 0;
        }
        .description {
            color: #868686;
            line-height: 1.75;
            margin: 0;
        }
    }
    .panel-footer {
        padding: 20px 35px;
        p {
            margin: 0;
        }
        .user {
            padding-top: 8px;
        }
    }
 }

 textarea {
    min-height: 250px;
 }
Reload the page. You will now see styled grids for the pins.

Integrate Twitter Bootstrap 4
Add bootstrap gem to Gemfile.

gem 'bootstrap', '~> 4.0.0.alpha3'
Run bundle. Require bootstrap in application.scss:

/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or any plugin's vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any other CSS/SCSS
 * files in this directory. Styles in this file should be added after the last require_* statement.
 * It is generally better to create a new file per style scope.
 *
 *= require 'masonry/transitions'
 */

@import "bootstrap";
Require bootstrap in application.js:

//= require bootstrap
It will now look like this:

//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require_tree .
Add signup, register, logout, account and new pin links in layouts/_header.html.erb:

<nav class="navbar navbar-dark bg-inverse navbar-fixed-top">
  <%= link_to "Puppy Reviews", root_path, class: "navbar-brand" %>
  <ul class="nav navbar-nav">
    <% if user_signed_in? %>
      <li class="nav-item">
        <%= link_to "New Pin", new_pin_path, class: 'nav-link' %>
      </li>
      <li class="nav-item">
        <%= link_to "Account", edit_user_registration_path, class: 'nav-link' %>
      </li>
      <li class="nav-item">
        <%= link_to "Sign Out", destroy_user_session_path, method: :delete, class: 'nav-link' %>
      </li>   
    <% else %>
        <li class="nav-item">
            <%= link_to "Sign Up", new_user_registration_path, class: 'nav-link' %>
        </li>
        <li class="nav-item">
            <%= link_to "Sign In", new_user_session_path, class: 'nav-link' %>
        </li>
    <% end %>
  </ul>
</nav>
Add:

<%= render 'layouts/header' %>
to layout file. In application.js:

//= require masonry/jquery.masonry
It will look like this:

//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require masonry/jquery.masonry
//= require turbolinks
//= require_tree .
In pins.coffee:

 $ ->
   $('#pins').imagesLoaded ->
     $('#pins').masonry
       itemSelector: '.box'
       isFitWidth: true
Now you will see the transition effect when the browser window is resized.

Vote on a Pin
Add acts_as_votable gem to Gemfile.

gem 'acts_as_votable', '~> 0.10.0'
Run bundle. Generate and create the tables required for voting functionality.

rails generate acts_as_votable:migration
rails db:migrate
Add:

acts_as_votable
in pin model. Define the route to vote in routes.rb.

resources :pins do
  put 'like', to: 'pins#upvote'
end
If you do rails routes, you can see the route to vote:

pin_like PUT    /pins/:pin_id/like(.:format)   pins#upvote
In pin show page, display the like icon and the number of votes:

<%= link_to like_pin_path(@pin), method: :put, class: "btn btn-secondary" do %>
  <span class="glyphicon glyphicon-heart"></span>
  <%= @pin.get_upvotes.size %>
<% end %>
Display the like button only if a user is signed in.

<% if user_signed_in? %>
  <%= link_to like_pin_path(@pin), method: :put, class: "btn btn-secondary" do %>
     <span class="glyphicon glyphicon-heart"></span>
     <%= @pin.get_upvotes.size %>
  <% end %>

   <%= link_to "Edit", edit_pin_path, class: "btn btn-default" %>
   <%= link_to "Delete", pin_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-secondary" %>
<% end %>
If you go to the show pin page, you will get the error:

undefined method `like_pin_path'
The output of rails routes shows:

pin_like PUT    /pins/:pin_id/like(.:format)   pins#upvote
Link the like icon to this path in the pin show page.

 <%= link_to pin_like_path(@pin), method: :put, class: "btn btn-secondary" do %>
 ...
Bootstrap 4 does not come with glyphicons support anymore. Let's use fontawesome instead. Add font-awesome-rails gem to Gemfile.

gem "font-awesome-rails"
Run bundle. Require it in application.scss:

@import "font-awesome";
In the pin show view, display the heart icon for the like link:

<i class="fa fa-heart"></i>
Click on the vote. You will get:

undefined method `upvote_by' for nil:NilClass
Initialize the @pin variable by adding the upvote action to before_action in pins controller.

before_action :set_pin, only: [:show, :edit, :update, :destroy, :upvote]
You will now get the error:

Couldn't find Pin with 'id'=
Currently the route for like is:

rails routes | grep like
pin_like PUT    /pins/:pin_id/like(.:format)   pins#upvote
Let's enclose the like route within the member block.

resources :pins do
  member do
    put 'like', to: 'pins#upvote'
  end
end
You will now get the error:

undefined method `pin_like_path'
Let's look at the route for like link:

rails routes | grep like
The output shows:

like_pin PUT    /pins/:id/like(.:format)       pins#upvote            
Change the like link in pin show.

like_pin_path(@pin)
We need to protect all actions except index and show from users who are not logged in. Add the before_action in pins controller that uses devise method to protect those actions.

before_action :authenticate_user!, except: [:index, :show]
Now you must be logged in to like any puppy by clicking the heart icon. You can download the source code for this article from pini

Summary
In this article, you learned how to develop a Pinterest clone using masonry-rails, acts_as_votable, bootstrap 4, devise in Rails 5.

References
Twitter Bootstrap 3 in a Rails 4 Application
Rails 4: How to Include Bootstrap Glyphicons
FontAwesome Rails Gem
FontAwesome Cheatsheet
