class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.all
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  def findactivity
    @user = nil
    User.all.each do |usu|
      if usu.token == params[:token]
        @user = usu
      end
    end
    if @user != nil
      @cadena = params[:cadena]
      if @cadena.blank?  # blank? covers both nil and empty string
        @activities = Activity.where("sampling_type_id = ?", params[:sampling_type_id])
      else
        @activitiesAux = Activity.where("lower(nombre) like ?", "%#{@cadena.downcase}%")
        @activities = []
        @activitiesAux.each do |act|
          if act.sampling_type_id == params[:sampling_type_id]
            @activities.push(act)
          end
        end
      end
    else
      respond_to do |format|
        @activities = Activity.new()
        format.html { render :show }
        format.json { render json: @activities.errors, status: :unprocessable_entity }
      end
    end
  end

  def getactivities
    @objs = params[:registers]
    ids = []
    @objs.each do |obj|
        ids.push(obj[:activity_id])
      end
    @activities = Activity.where(:id => ids)
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:nombre)
    end
end
