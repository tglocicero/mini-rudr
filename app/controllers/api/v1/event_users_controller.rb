class Api::V1::EventUsersController < ApplicationController

    # GET /event_users
    def index
        @event_users = EventUser.all
        render json: @event_users
    end

    # GET /event_user/:id
    def show
        @event_user = EventUser.find(params[:id])
        render json: @event_user
    end

    # POST /event_users
    def create
        @event_user = EventUser.new(event_user_params)
        if @event_user.save
            render json: @event_user
        else
            render error: { error: 'Could not create EventUser.' }, status: 400
        end
    end

    # DELETE /event_users/:id
    def destroy
        @event_user = EventUser.find(params[:id])
        if @event_user
            @event_user.destroy
            render json: { message: 'EventUser destroyed' }, status: 200
        else
            render json: { error: 'Could not destroy EventUser' }, status: 400
        end
    end

    private

    def event_user_params
        params.require(:event_user).permit(:event_id, :user_id, :response, :present?)
    end
end
