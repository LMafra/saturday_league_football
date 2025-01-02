# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChampionshipsController, type: :controller do

  let(:championship_sample) { FactoryBot.create(:championship) }

  describe '#index' do
    it 'assigns @championships' do
      get :index
    end
  end

  describe '#create' do
    context 'with valid params' do
      it 'creates a new championship' do
        expect { post :create, params: { championship: championship_sample } }.to change(Championship, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not create a new championship' do
        expect { post :create, params: { championship: { name: '' } } }.not_to change(Championship, :count)
      end
    end
  end

  describe '#update' do

    it 'updates the championship' do
      patch :update, params: { id: championship_sample.id, championship: { name: 'Updated' } }
      expect(championship_sample.reload.name).to eq('Updated')
    end
  end

  describe '#destroy' do
    it 'destroys the requested championship' do
      championship = create(:championship)
      expect { delete :destroy, params: { id: championship.id } }.to change(Championship, :count).by(-1)
    end
  end
end
