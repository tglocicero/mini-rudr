class Api::V1::EventsController < ApplicationController

    # GET /events
    def index
        @events = Event.all
        render json: @events
    end

    # GET /event/:id
    def show
        @event = Event.find(params[:id])
        render json: @event
    end

    # POST /events
    def create
        @event = Event.new(event_params)
        if @event.save
            render json: @event
        else
            render error: { error: 'Could not create Event.' }, status: 400
        end
    end

    # PUT /events/:id
    def update
        @event = Event.find(params[:id])
        if @event
            @event.update(event_update_params)
            UpdateUserScoresJob.perform_later(@event) if @event.time == "past"
            render json: @event
        else
            render json: { error: "Could not update Event" }, status: 400
        end
    end

    # DELETE /events/:id
    def destroy
        @event = Event.find(params[:id])
        if @event
            @event.destroy
            render json: { message: 'Event destroyed' }, status: 200
        else
            render json: { error: 'Could not destroy Event' }, status: 400
        end
    end

    private

    def event_params
        params.require(:event).permit(:name)
    end

    def event_update_params
        params.require(:event).permit(:time)
    end

end
