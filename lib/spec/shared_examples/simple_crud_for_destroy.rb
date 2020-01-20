shared_examples 'simple crud for destroy' do
  describe 'DELETE #destroy' do
    context 'without authenticated user' do
      subject!(:req) { delete :destroy, params: { id: 1 } }

      include_examples 'unauthorized when not logged in' if check_authenticate(:destroy)
    end

    if check_authorize(:destroy)
      context 'when not authorized' do
        subject!(:req) { delete :destroy, params: { id: model.id } }

        it 'fails with forbidden' do
          make_policies_fail(:index)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when ID is valid' do
      include_context 'with authenticated user' if check_authenticate(:destroy)

      before do
        model
        make_policies_succeed(:destroy) if check_authenticate(:destroy)
        delete :destroy, params: { id: model.id }
      end

      it 'response with 200 status code' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when ID is invalid' do
      include_context 'with authenticated user' if check_authenticate(:destroy)

      before do
        model
        make_policies_succeed(:destroy) if check_authenticate(:destroy)
        delete :destroy, params: { id: model.id + 13 }
      end

      it 'response with 200 status code' do
        expect(response).to have_http_status(:created)
      end
    end

    if check_authorize(:destroy)
      context 'when ID is valid but user isn\'t authorized' do
        include_context 'with authenticated user' if check_authenticate(:destroy)

        before do
          model
          make_policies_fail(:destroy)
          delete :destroy, params: { id: model.id }
        end

        it 'response with 200 status code' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
