class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.includes(:tables).order(:time)
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservations::Creator.new(
      time: DateTime.parse(reservation_params[:time]),
      people_amount: reservation_params[:people_amount].to_i,
      name: reservation_params[:name]
    ).call

    if @reservation.errors.any?
      respond_to do |format|
        format.html do
          flash.now[:alert] = 'There was an error creating the reservation.'
          render :index, status: :unprocessable_entity
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('form', partial: 'reservations/form', locals: { reservation: @reservation })
          ]
        end
      end
    else
      flash.now[:notice] = 'Reservation created successfully!'
      respond_to do |format|
        format.html { redirect_to reservations_path, notice: 'Reservation created successfully!' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('reservations', partial: 'reservations/reservation', locals: { reservation: @reservation }),
            turbo_stream.replace('form', partial: 'reservations/form', locals: { reservation: Reservation.new })
          ]
        end
      end
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:time, :people_amount, :name)
  end
end
