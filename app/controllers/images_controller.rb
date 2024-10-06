class ImagesController < ApplicationController
    def default
      # smiley-cyrus.jpeg をデフォルト画像として返す
    send_file Rails.root.join('app', 'assets', 'images', 'profiles', 'smiley-cyrus.jpeg'), type: 'image/jpeg', disposition: 'inline'
    end
end