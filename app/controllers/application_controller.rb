class ApplicationController < ActionController::Base

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to main_app.my_sin_path, alert: exception.message
	end
end
