class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy, :inbox, :outbox]
  before_action :validate_search_key, only: [:search]

  def index
    @search = Job.ransack(params[:q])
    @jobs = @search.result.published

    if params[:workplace].blank?
      @jobs = Job.published.recent.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 15)
    else
      @workplace_id = Workplace.find_by(name: params[:workplace]).id
      @jobs = Job.where(:workplace_id => @workplace_id).order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 15)
    end

  end

  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      redirect_to root_path
    end
  end

  def search
    if @query_string.present?
      search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.paginate(:page => params[:page], :per_page => 5)
    end
  end


  def inbox
   @job = Job.find(params[:id])

    if !current_user.is_member_of?(@job)
      current_user.inbox!(@job)
      flash[:notice] = "收藏成功！"
    else
      flash[:warning] = "你已经收藏过了！"
    end

    redirect_to job_path(@job)
  end

  def outbox
    @job = Job.find(params[:id])

    if current_user.is_member_of?(@job)
      current_user.outbox!(@job)
      flash[:alert] = "已取消收藏！"
    else
      flash[:warning] = "本来就没有收藏哦！"
    end

    redirect_to job_path(@job)
  end

  def ilike
    @job = Job.find(params[:id])
    @likes = @job.likes
    current_user.likes.is_liked = false    
    @job.likes.is_liked = false
    @job.save
    redirect_to :back
  end

  def unlike
    @job = Job.find(params[:id])
    @likes = @job.likes
    current_user.likes.is_liked = true
    @job.save
    redirect_to :back
  end



  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end

  def search_criteria(query_string)
    { :title_cont => query_string }
  end

  private

end
