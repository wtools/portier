module Portier
  module Engines
    module Session
      protected

      def authenticate_from_session
        if session[:current_user_id]
          begin
            @current_user = self.class.user_model_for(:session).find session[:current_user_id]
          rescue ActiveRecord::RecordNotFound
            remove_user_from_session
          end
        end
      end

      def persist_user_into_session user
        @current_user = user
        session[:current_user_id] = user ? user.send(user.class.primary_key) : nil
      end

      def remove_user_from_session
        session.delete :current_user_id
      end
    end
  end
end
