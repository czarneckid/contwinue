class PreferencesController < ApplicationController
  before_filter :require_logged_in_user

  def show
  end

  def update
    case params[:continuation_style]
    when 'text'
      current_user.continuation_style = :text
    when 'numeric'
      current_user.continuation_style = :numeric
    else
      current_user.continuation_style = :text
    end

    case params[:continuation_placement]
    when 'beginning'
      current_user.continuation_placement = :beginning
    when 'end'
      current_user.continuation_placement = :end
    else
      current_user.continuation_placement = :end
    end

    current_user.save
    redirect_to action: :show
  end
end
