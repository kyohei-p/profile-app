class SkillsController < ApplicationController
  before_action :set_category_ids, only: [:edit, :new]

  def index
  end

  def create
    @category = Category.find(params[:category_id])
    @skill = @category.skills.build(skill_params)
    @skill.user = current_user

    if @skill.save
      @modal_message = "#{@category.name}に#{@skill.name}を習得レベル#{@skill.skill_level}で追加しました!"
      # redirect_to edit_category_skill_path(@category, @skill)
    else
      render :new
    end
  end

  def edit
    if user_signed_in?
      @category = Category.find(params[:category_id])
      @skill = Skill.with_deleted.find_by(id: params[:id])
      # @skill = Skill.find(params[:id])
      @categories = Category.all
      @skills = Skill.all

      render :edit
    else
      redirect_to new_user_session_path
    end
  end

  def new
    if user_signed_in?
      @category = Category.find(params[:category_id])
      @skill = @category.skills.build
    else
      redirect_to new_user_session_path
    end
  end

  def update
    puts params
    @category = Category.find(params[:category_id])
    @skill = Skill.find(params[:id])
    
    if @skill.update!(skill_params)
      skill_name = @skill.name
      skill_level = @skill.skill_level
      # @success_update_message = "#{@skill.name}の習得レベルを保存しました！"
      render json: { success: true, skill_name: skill_name, skill_level: skill_level }
    else
      @error_update_message = "保存に失敗しました。"
      render json: { success: false, message: @error_update_message, errors: @skill.errors.full_messages }
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @skill = Skill.find(params[:id])
    if @skill.user_id == current_user.id
      @skill.destroy
      @success_delete_message = "#{@skill.name}の項目を削除しました！"
      render json: { success: true, message: @success_delete_message, skill: @skill.attributes }
    else
      @error_delete_message = "削除に失敗しました。"
      render json: { success: false, message: @error_delete_message, errors: @skill.errors.full_messages }
    end
  end

  private

  def skill_params
    params.require(:skill).permit(:name, :skill_level)
  end

  def set_category_ids
    @category_ids = [1, 2, 3]
  end
end
