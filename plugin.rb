# frozen_string_literal: true

# name: discourse-inline-likes
# about: Restores the original inline "who liked" display below posts instead of the dropdown menu
# version: 0.1
# author: Martin
# url: https://github.com/discourse/discourse

enabled_site_setting :discourse_inline_likes_enabled

register_asset "stylesheets/discourse-inline-likes.scss"
