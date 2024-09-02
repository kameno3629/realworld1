class SessionsController < Devise::SessionsController

  # GET /login
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?

    # signin.html.erb を明示的にレンダリング
    respond_to do |format|
      format.html { render 'signin/signin' }
      format.json { render json: { error: 'Not acceptable' }, status: :not_acceptable }
    end
  end

  # POST /login
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
    # Deviseの標準的なログイン処理に変更
  end
end
