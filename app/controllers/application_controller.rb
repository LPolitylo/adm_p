class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource_or_scope)
		session[:allowed_actions] ||= current_user.roles.map(&:acls).flatten.map { |acl| "#{acl.class_name}::#{acl.method_name}" }
		super
	end
end
