class Api::V1::PhotosController < ApplicationController

  def index
    @photos = Photo.all
    render json: {status: 'success', message: 'Loaded photos', data: @photos}
  end

  def show
    @photo = Photo.find(params[:id])
    remder json: {status: 'success', message: 'Loaded photo', data: @photo}
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      render json: {status: 'success', message: 'Created photo', data: @photo}
    else
      render json: {status: 'error', data: @photo.errors}
    end
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update(photo_params)
      render json: {status: 'success', message: 'Updated photo', data: @photo}
    else
      render json: {status: 'error', message: 'Not updated', data: @photo.errors}
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    render json: {status: 'success', message: 'Deleted photo', data: @photo}
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :description)
  end
end
