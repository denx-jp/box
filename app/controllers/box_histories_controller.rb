class BoxHistoriesController < ApplicationController
  before_action :check

  def index
  end

  private
  def check
    @update_histories = UpdateHistory.all.order("created_at desc")
    unless can? :read, :update_histories
      redirect_to '/'
    end
  end
end
