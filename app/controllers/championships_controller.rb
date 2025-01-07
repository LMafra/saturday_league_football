# frozen_string_literal: true

class ChampionshipsController < ApplicationController
  before_action :set_championship, only: %i[show update destroy]
  def index
    @championships = Championship.all.includes(:rounds)
    render json: @championships.as_json(include: :rounds, methods: :round_total)
  end

  def show
    render json: @championship.as_json(include: :rounds)
  end

  def create
    @championship = Championship.new(championship_params)
    if @championship.save
      render json: @championship, status: :created, location: @championship
    else
      render json: @championship.errors, status: :unprocessable_entity
    end
  end

  def update
    if @championship.update(championship_params)
      render json: @championship
    else
      render json: @championship.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @championship.destroy
  end

  private

  def set_championship
    @championship = Championship.find(params[:id])
  end

  def championship_params
    params.require(:championship).permit(:name)
  end
end
