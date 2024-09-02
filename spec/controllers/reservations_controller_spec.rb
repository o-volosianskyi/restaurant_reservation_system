require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  render_views

  describe 'POST #create' do
    let(:time) { DateTime.parse("2025-05-01 17:00:00") }
    let(:people_amount) { 500 }
    let(:reservation) { create(:reservation) }
    let(:reservation_params) do
      {
        reservation: {
          time: time.to_s,
          people_amount: people_amount,
          name: "Test User"
        }
      }
    end

    context 'when there is no capacity' do
      let(:reservation_with_error) do
        res = Reservation.new
        res.errors.add(:base, "Some error")
        res
      end

      before do
        allow_any_instance_of(Reservations::Creator).to receive(:call).and_return(reservation_with_error)
      end

      it 'does not persist the reservation and returns an error message' do
        post :create, params: reservation_params

        reservation = assigns(:reservation)

        expect(reservation.persisted?).to be_falsey

        expect(reservation.errors[:base]).to include("Some error")

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with turbo_stream format' do
        post :create, params: reservation_params, format: :turbo_stream

        reservation = assigns(:reservation)

        expect(reservation.persisted?).to be_falsey

        expect(reservation.errors[:base]).to include("Some error")

        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("Some error")
      end
    end

    context 'when the reservation is successfully created' do
      before do
        allow_any_instance_of(Reservations::Creator).to receive(:call).and_return(reservation)
      end
  
      let(:people_amount) { 4 }

      it 'persists the reservation and redirects to the index page' do
        post :create, params: reservation_params

        reservation = assigns(:reservation)

        expect(response).to redirect_to(reservations_path)
        expect(flash[:notice]).to eq('Reservation created successfully!')
      end
    end
  end
end
